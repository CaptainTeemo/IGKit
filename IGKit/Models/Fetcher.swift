//
//  Fetcher.swift
//  IGKit
//
//  Created by CaptainTeemo on 5/15/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

import Foundation

struct Fetcher {
    static func fetch(path: String, pagination: Pagination? = nil, method: Method = .GET, parameters: [String: AnyObject]? = nil) -> Promise<(JSON, Pagination?)> {
        var url = BaseUrl + path
        if let page = pagination {
            url = page.next_url
        }
        var param: [String: AnyObject] = ["access_token": UserDefaults.accessToken()]
        if let p = parameters {
            p.forEach { param[$0.0] = $0.1 }
        }
        
        return Request.request(method, urlString: url, parameters: param).then { (result) -> Promise<(JSON, Pagination?)> in
            let meta = result["meta"]
            let code = meta["code"].intValue
            return Promise<(JSON, Pagination?)> { (fulfill, reject) in
                if code == 200 {
                    let page = Pagination.generateModel(result["pagination"].dictionaryValue)
                    fulfill(result["data"], page.next_url.isEmpty ? nil : page)
                } else {
                    reject(NSError.error(code, description: meta["error_message"].stringValue))
                }
            }
        }
    }
}