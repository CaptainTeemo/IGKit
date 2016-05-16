//
//  Authentication.swift
//  IGKit
//
//  Created by CaptainTeemo on 5/13/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

import Foundation
import SafariServices

/**
 *  Authentication.
 */
public class Authentication: NSObject {
    
    private static let _auth = Authentication()
    private var loginClosure: ((NSError?) -> Void)?
    
    /**
     Call this function in `- application:openURL:options:` from AppDelegate to receive access token from SafariViewController.
     */
    public class func openURL(url: NSURL, options: [String: AnyObject]) {
        if let sourceApplication = options["UIApplicationOpenURLOptionsSourceApplicationKey"] where String(sourceApplication) == "com.apple.SafariViewService" {
            let param = Request.decodeParameters(url, query: false)
            if let token = param["access_token"] {
                UserDefaults.save([AccessTokenKey: token])
                _auth.loginClosure?(nil)
            } else {
                _auth.loginClosure?(NSError.error(-300, description: param["error"] ?? ""))
            }
        }
    }
    
    /**
     Login from a viewController.     
     */
    public class func login(scope: [Scope], viewController: UIViewController, done: ((NSError?) -> Void)) {
        let permissions = Scope.encode(scope)
        let authUrl = "https://api.instagram.com/oauth/authorize/?client_id=\(UserDefaults.clientId)&redirect_uri=\(UserDefaults.redirectURI)&response_type=token&scope=\(permissions)"
        let safari = SFSafariViewController(URL: NSURL(string: authUrl)!)
        safari.delegate = _auth
        _auth.loginClosure = done
        viewController.presentViewController(safari, animated: true, completion: nil)
    }
}

extension Authentication: SFSafariViewControllerDelegate {
    public func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}