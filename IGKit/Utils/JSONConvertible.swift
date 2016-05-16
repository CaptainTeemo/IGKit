//
//  JSONConvertible.swift
//  TMModel
//
//  Created by CaptainTeemo on 3/17/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

import Foundation

protocol JSONConvertible {
    static func generateModel(data: [String: AnyObject]) -> Self
    func convertToDictionary() -> [String: AnyObject]
}

extension JSONConvertible where Self: NSObject {
    
    init() {
        self.init()
    }
    
    /**
     Generate a model using a JSON dictionary.
     
     - parameter data: JSON dictionary.
     
     - returns: A model object with value assigned.
     */
    static func generateModel(data: [String: AnyObject]) -> Self {
        let model = Self()
        for (key, value) in data {
            guard model.respondsToSelector(Selector(key)) else { continue }
            if value is NSNull { continue }
            if value is NSDictionary || value is NSArray {
                model.setValue(value, forKey: key)
            } else {
                model.setValue("\(value)", forKey: key)
            }
        }

        return model
    }
    
    /**
     Convert given model to JSON dictionary.
     
     - parameter model: A model object.
     
     - returns: A JSON dictionary with properties' names as keys.
     */
    func convertToDictionary() -> [String: AnyObject] {
        var dic = [String: AnyObject]()
        var outCount: UInt32 = 0
        let properties = class_copyPropertyList(self.dynamicType, &outCount)
        for i in 0..<Int(outCount) {
            let property = properties[i]
            guard let key = String(CString: property_getName(property), encoding: NSUTF8StringEncoding) else { continue }
            let value = self.valueForKey(key)
            dic[key] = value
        }
        return dic
    }
}