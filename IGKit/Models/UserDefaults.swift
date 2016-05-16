//
//  UserDefaults.swift
//  IGKit
//
//  Created by CaptainTeemo on 5/13/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

import Foundation

struct UserDefaults {
    
    static var clientId = ""
    static var secret = ""
    static var redirectURI = ""
    
    private static let _defaults = NSUserDefaults.standardUserDefaults()
    
    static func save(keyValuePairs: [String: AnyObject]) {
        for (key, value) in keyValuePairs {
            _defaults.setObject(value, forKey: key)
        }
        _defaults.synchronize()
    }
    
    static func accessToken() -> String {
        return _defaults.objectForKey(AccessTokenKey) as? String ?? ""
    }
}