//
//  JSON.swift
//  IGKit
//
//  Created by CaptainTeemo on 5/13/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

import Foundation

public struct JSON {
    
    let object: AnyObject?
    
    init(_ object: AnyObject?) {
        self.object = object
    }
    
    init(_ data: NSData?) {
        self.init(JSON.objectWithData(data))
    }
    
    static func objectWithData(data: NSData?) -> AnyObject? {
        if let data = data {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: [])
            } catch {
                return nil
            }
        }
        return nil
    }
    
    subscript(key: String) -> JSON {
        guard let object = object else { return self }
        
        if let dictionary = object as? [String: AnyObject] {
            return JSON(dictionary[key])
        }
        
        return JSON(nil)
    }
}

// MARK: - String

extension JSON {
    var string: String? { return object as? String }
    var stringValue: String { return string ?? "" }
}

// MARK: - Integer

extension JSON {
    var int: Int? { return object as? Int }
    var intValue: Int { return int ?? 0 }
}


// MARK: - Bool

extension JSON {
    var bool: Bool? { return object as? Bool }
    var boolValue: Bool { return bool ?? false }
}


// MARK: - Dictionary

extension JSON {
    var dictionary: [String: AnyObject]? { return object as? [String: AnyObject] }
    var dictionaryValue: [String: AnyObject] { return dictionary ?? [:] }
    
    var jsonDictionary: [String: JSON]? { return dictionary?.reduceValues{ JSON($0) }}
    var jsonDictionaryValue: [String: JSON] { return jsonDictionary ?? [:] }
}

// MARK: - Array

extension JSON {
    var array: [AnyObject]? { return object as? [AnyObject] }
    var arrayValue: [AnyObject] { return array ?? [] }
    
    var jsonArray: [JSON]? { return array?.map { JSON($0) } }
    var jsonArrayValue: [JSON] { return jsonArray ?? [] }
}

internal extension Dictionary {
    func reduceValues <T: Any>(transform: (value: Value) -> T) -> [Key: T] {
        return reduce([Key: T]()) { (dictionary, kv) in
            var dictionary = dictionary
            dictionary[kv.0] = transform(value: kv.1)
            return dictionary
        }
    }
}