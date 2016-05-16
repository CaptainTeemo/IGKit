//
//  Request.swift
//  IGKit
//
//  Created by CaptainTeemo on 5/12/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

import Foundation

enum Method: String {
    case GET
    case POST
    case Delete
}

struct Request {
    
    /**
     Make a HTTP request.
     
     - parameter method:     HTTP method, currently GET, POST and Delete supported.
     - parameter urlString:  URL string.
     - parameter parameters: Parameters dictionary.
     
     - returns: `Promise` with JSON.
     */
    static func request(method: Method, urlString: String, parameters: [String: AnyObject]? = nil) -> Promise<JSON> {
        var encodedUrlString = urlString
        var bodyData: NSData?
        
        if let parameters = parameters {
            let encodedParam = encodeParameters(parameters)
            switch method {
            case .GET, .Delete:
                encodedUrlString += encodedParam
            case .POST:
                bodyData = encodedParam.dataUsingEncoding(NSUTF8StringEncoding)
            }
        }
        
        print(encodedUrlString)
        
        let request = NSMutableURLRequest(URL: NSURL(string: encodedUrlString)!)
        request.HTTPMethod = method.rawValue
        request.HTTPBody = bodyData
        
        return Promise<JSON> { (fulfill, reject) in
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                if let error = error {
                    reject(error)
                } else if let data = data {
                    let result = JSON(data)
                    guard result.object != nil else {
                        reject(NSError.error(-200, description: "Response data cannot be parsed to JSON."))
                        return
                    }
                    fulfill(result)
                } else {
                    reject(NSError.error(-100, description: "\(#function): Something goes wrong."))
                }
            }.resume()
        }
    }
    
    /**
     Decode url parameters to key value pairs.
     
     - parameter url:   Input url.
     - parameter query: Decode parameters from query or fragment.
     
     - returns: Decoded key value pairs.
     */
    static func decodeParameters(url: NSURL, query: Bool = true) -> [String: String] {
        var param = [String: String]()
        if let queryParams = (query ? url.query : url.fragment)?.componentsSeparatedByString("&") {
            for queryParam in queryParams {
                guard let equalRange = queryParam.rangeOfString("=") else { continue }
                let key = queryParam.substringToIndex(equalRange.endIndex.advancedBy(-1))
                let value = queryParam.substringFromIndex(equalRange.endIndex)
                param[key] = value
            }
        }
        return param
    }
    
    /**
     Encode key value pairs to parameters.
     
     - parameter param: Input parameters.
     
     - returns: Encoded parameters.
     */
    static func encodeParameters(param: [String: AnyObject]) -> String {
        let params = "?" + param.map { "\($0.0)=\($0.1)" }.joinWithSeparator("&")
        return params
    }
}