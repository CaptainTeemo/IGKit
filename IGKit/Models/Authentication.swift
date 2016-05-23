//
//  Authentication.swift
//  IGKit
//
//  Created by CaptainTeemo on 5/13/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

import Foundation
import WebKit

/**
 *  Authentication.
 */
public class Authentication: NSObject {
    
    private static let _auth = Authentication()
    private var _loginClosure: ((NSError?) -> Void)?
    private lazy var _indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.center = self._authViewController.view.center
        self._authViewController.view.addSubview(indicator)
        return indicator
    }()
    
    private lazy var _webView: WKWebView = {
        let webView = WKWebView(frame: CGRect(x: 0, y: 20, width: self._authViewController.view.frame.width, height: self._authViewController.view.frame.height - 20))
        webView.backgroundColor = .whiteColor()
        webView.navigationDelegate = _auth
        self._authViewController.view.addSubview(webView)
        return webView
    }()
    
    private lazy var _authViewController: UIViewController = {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .whiteColor()
        return viewController
    }()
    
    /**
     Login from a viewController.     
     */
    public class func login(scope: [Scope], viewController: UIViewController, done: ((NSError?) -> Void)) {
        let permissions = Scope.encode(scope)
        let authUrl = "https://api.instagram.com/oauth/authorize/?client_id=\(UserDefaults.clientId)&redirect_uri=\(UserDefaults.redirectURI)&response_type=token&scope=\(permissions)"
        
        let request = NSURLRequest(URL: NSURL(string: authUrl)!)
        _auth._webView.loadRequest(request)
        _auth._loginClosure = done
        viewController.presentViewController(_auth._authViewController, animated: true, completion: nil)
    }
}

extension Authentication: WKNavigationDelegate {
    
    public func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        _indicator.startAnimating()
        
        if let url = navigationAction.request.URL where url.absoluteString.rangeOfString("\(UserDefaults.redirectURI)", options: .CaseInsensitiveSearch)?.count > 0 {
            let param = Request.decodeParameters(url, query: false)
            if let token = param["access_token"] {
                UserDefaults.save([AccessTokenKey: token])
                _loginClosure?(nil)
            } else {
                _loginClosure?(NSError.error(-300, description: param["error"] ?? ""))
            }
            _authViewController.dismissViewControllerAnimated(true, completion: nil)
        }
        decisionHandler(.Allow)
    }
    
    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        _indicator.stopAnimating()
    }
    
    public func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        _indicator.stopAnimating()
        _loginClosure?(NSError.error(-300, description: "Failed loading auth url."))
        _authViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}