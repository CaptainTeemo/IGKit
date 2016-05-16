//
//  User.swift
//  IGKit
//
//  Created by CaptainTeemo on 5/13/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

import Foundation

/**
 Actions to handle user relationship.
 Basically user in `public class func modifyRelationship(userId: String, action: RelationshipAction) -> Promise<(String, String)>`.
 */
public enum RelationshipAction: String {
        /// Follow a user.
    case Follow = "follow"
        /// Unfollow a user.
    case Unfollow = "unfollow"
        /// Approve a follow request.
    case Approve = "approve"
        /// Ignore a follow request.
    case Ignore = "ignore"
}

/// User
public final class User: NSObject, JSONConvertible {
    public var id = ""
    public var username = ""
    public var full_name = ""
    public var profile_picture = ""
    public var bio = ""
    public var website = ""
    public var counts = [String: AnyObject]()
}

// MARK: - User information.
extension User {
    /**
     Get information about the owner of the access_token.
     
     - returns: `Promise` with User.
     */
    public class func fetchSelfInfo() -> Promise<User> {
        let path = "/users/self"
        return Fetcher.fetch(path).then { (result, pagination) -> User in
            let user = User.generateModel(result.dictionaryValue)
            return user
        }
    }
    
    /**
     Get information about a user. This endpoint requires the public_content scope if the user-id is not the owner of the access_token.
     
     - parameter userId: User id.
     
     - returns: `Promise` with User.
     */
    public class func fetchUserInfo(userId: String) -> Promise<User> {
        let path = "/users/\(userId)"
        return Fetcher.fetch(path).then { (result, pagination) -> User in
            let user = User.generateModel(result.dictionaryValue)
            return user
        }
    }
    
    /**
     Get the most recent media published by the owner of the access_token.
     
     - parameter pagination: Optional.
     
     - returns: `Promise` with ([Media], Pagination?).
     */
    public class func fetchSelfRecentMedia(pagination: Pagination? = nil) -> Promise<([Media], Pagination?)> {
        return Fetcher.fetch("/users/self/media/recent", pagination: pagination).then { (result, page) -> ([Media], Pagination?) in
            let media = result.jsonArrayValue.map { Media.generateModel($0.dictionaryValue) }
            return (media, page)
        }
    }
    
    /**
     Get the most recent media published by a user. This endpoint requires the public_content scope if the user-id is not the owner of the access_token.
     
     - parameter userId:     User id.
     - parameter pagination: Optional.
     
     - returns: `Promise` with ([Media], Pagination?).
     */
    public class func fetchUserRecentMedia(userId: String, pagination: Pagination? = nil) -> Promise<([Media], Pagination?)> {
        return Fetcher.fetch("/users/\(userId)/media/recent", pagination: pagination).then({ (result, page) -> ([Media], Pagination?) in
            let media = result.jsonArrayValue.map { Media.generateModel($0.dictionaryValue) }
            return (media, page)
        })
    }
    
    /**
     Fetch self feed.
     
     - parameter pagination: Optional.
     
     - returns: `Promise` with ([Media], Pagination?).
     */
    public class func fetchSelfFeed(pagination: Pagination? = nil) -> Promise<([Media], Pagination?)> {
        return Fetcher.fetch("/users/self/feed", pagination: pagination).then({ (result, page) -> ([Media], Pagination?) in
            let media = result.jsonArrayValue.map { Media.generateModel($0.dictionaryValue) }
            return (media, page)
        })
    }
    
    /**
     Get the list of recent media liked by the owner of the access_token.
     
     - parameter pagination: Optional.
     
     - returns: `Promise` with ([Media], Pagination?).
     */
    public class func fetchSelfLiked(pagination: Pagination? = nil) -> Promise<([Media], Pagination?)> {
        return Fetcher.fetch("/users/self/media/liked", pagination: pagination).then({ (result, page) -> ([Media], Pagination?) in
            let media = result.jsonArrayValue.map { Media.generateModel($0.dictionaryValue) }
            return (media, page)
        })
    }
    
    /**
     Get a list of users matching the query.
     
     - parameter query:      Key word of query.
     - parameter pagination: Optional.
     
     - returns: `Promise` with ([User], Pagination?).
     */
    public class func searchUser(query: String) -> Promise<[User]> {
        let param = ["q": query]
        return Fetcher.fetch("/users/search", parameters: param).then({ (result, page) -> [User] in
            let users = result.jsonArrayValue.map { User.generateModel($0.dictionaryValue) }
            return users
        })
    }
}

// MARK: - User relationships.
extension User {
    
    /**
     Get the list of users this user follows.
     Require scope: follower_list.
     
     - returns: `Promise` with [User].
     */
    public class func fetchSelfFollows() -> Promise<[User]> {
        return Fetcher.fetch("/users/self/follows").then({ (result, page) -> [User] in
            let users = result.jsonArrayValue.map { User.generateModel($0.dictionaryValue) }
            return users
        })
    }
    
    /**
     Get the list of users this user is followed by.
     Require scope: follower_list.
     
     - returns: `Promise` with [User].
     */
    public class func fetchSelfFollowers() -> Promise<[User]> {
        return Fetcher.fetch("/users/self/followed-by").then({ (result, page) -> [User] in
            let users = result.jsonArrayValue.map { User.generateModel($0.dictionaryValue) }
            return users
        })
    }
    
    /**
     List the users who have requested this user's permission to follow.
     Require scope: follower_list.
     
     - returns: `Promise` with [User].
     */
    public class func fetchSelfRequesters() -> Promise<[User]> {
        return Fetcher.fetch("/users/self/requested-by").then({ (result, page) -> [User] in
            let users = result.jsonArrayValue.map { User.generateModel($0.dictionaryValue) }
            return users
        })
    }
    
    /**
     Get information about a relationship to another user. Relationships are expressed using the following terms in the response:
     
     outgoing_status: Your relationship to the user. Can be 'follows', 'requested', 'none'.
     incoming_status: A user's relationship to you. Can be 'followed_by', 'requested_by', 'blocked_by_you', 'none'.
     
     Require scope: follower_list.
     
     - parameter userId: Target user id.
     
     - returns: `Promise` with (outgoing_status, incoming_status).
     */
    public class func getRelationship(userId: String) -> Promise<(String, String)> {
        return Fetcher.fetch("/users/\(userId)/relationship").then({ (result, page) -> (String, String) in
            let outgoingStatus = result["outgoing_status"].stringValue
            let incomingStatus = result["incoming_status"].stringValue
            return (outgoingStatus, incomingStatus)
        })
    }
    
    /**
     Modify the relationship between the current user and the target user. You need to include an action parameter to specify the relationship action you want to perform. Valid actions are: 'follow', 'unfollow' 'approve' or 'ignore'. Relationships are expressed using the following terms in the response:
     
     outgoing_status: Your relationship to the user. Can be 'follows', 'requested', 'none'.
     incoming_status: A user's relationship to you. Can be 'followed_by', 'requested_by', 'blocked_by_you', 'none'.
     
     Require scope: relationships.
     
     - parameter userId: Target user id.
     - parameter action: See `RelationshipAction`.
     
     - returns: `Promise` with (outgoing_status, incoming_status).
     */
    public class func modifyRelationship(userId: String, action: RelationshipAction) -> Promise<(String, String)> {
        return Fetcher.fetch("/users/\(userId)/relationship", method: .POST, parameters: ["action": action.rawValue]).then({ (result, page) -> (String, String) in
            let outgoingStatus = result["outgoing_status"].stringValue
            let incomingStatus = result["incoming_status"].stringValue
            return (outgoingStatus, incomingStatus)
        })
    }
}