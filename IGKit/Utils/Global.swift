//
//  Global.swift
//  IGKit
//
//  Created by CaptainTeemo on 5/13/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

/**
 Register with necessary information.
 
 - parameter clientId:    Instagram client id.
 - parameter secret:      Instagram client secret.
 - parameter redirectURI: Instagram redirect uri.
 */
public func register(clientId: String, secret: String, redirectURI: String) {
    UserDefaults.clientId = clientId
    UserDefaults.secret = secret
    UserDefaults.redirectURI = redirectURI
}

let AccessTokenKey = "access_token"

let ErrorDomain = "com.igkit.error"

let BaseUrl = "https://api.instagram.com/v1"
