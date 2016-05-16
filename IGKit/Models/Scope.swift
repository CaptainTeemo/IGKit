//
//  Scope.swift
//  IGKit
//
//  Created by CaptainTeemo on 5/15/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

import Foundation

/**
 Login permissions. See https://www.instagram.com/developer/authorization/
 */
public enum Scope: String {
    case Basic = "basic"
    case Public = "public_content"
    case Like = "likes"
    case Comment = "comments"
    case Relationship = "relationships"
    case Follower = "follower_list"
    case All
    
    static func encode(scopes: [Scope]) -> String {
        let all = scopes.filter { $0 == .All }
        if all.isEmpty {
            return scopes.map { $0.rawValue }.joinWithSeparator("+")
        }
        return "basic+public_content+likes+comments+relationships+follower_list"
    }
}