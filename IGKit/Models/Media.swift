//
//  Media.swift
//  IGKit
//
//  Created by CaptainTeemo on 5/13/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

import Foundation

/// Media
public final class Media: NSObject, JSONConvertible {
    public var type = ""
    public var videos = [String: AnyObject]()
    public var users_in_photo = [[String: AnyObject]]()
    public var filter = ""
    public var tags = [String]()
    public var comments = [String: AnyObject]()
    public var caption = [String: AnyObject]()
    public var likes = [String: AnyObject]()
    public var link = ""
    public var user = [String: AnyObject]()
    public var created_time = ""
    public var images = [String: AnyObject]()
    public var id = ""
    public var location = [String: AnyObject]()
    public var user_has_liked = ""
}

// MARK: - Media information.
extension Media {
    /**
     Get information about a media object. Use the type field to differentiate between image and video media in the response. You will also receive the user_has_liked field which tells you whether the owner of the access_token has liked this media.
     The public_content permission scope is required to get a media that does not belong to the owner of the access_token.
     
     - parameter mediaId:    Media id.
     
     - returns: `Promise` with Media.
     */
    public class func fetchMedia(mediaId: String) -> Promise<Media> {
        return Fetcher.fetch("/media/\(mediaId)").then({ (result, page) -> Media in
            let media = Media.generateModel(result.dictionaryValue)
            return media
        })
    }
    
    /**
     Fetch popular media.
     
     - returns: `Promise` with [Media].
     */
    public class func fetchPopularMedia() -> Promise<[Media]> {
        return Fetcher.fetch("/media/popular").then({ (result, page) -> [Media] in
            let media = result.jsonArrayValue.map { Media.generateModel($0.dictionaryValue) }
            return media
        })
    }
    
    /**
     This endpoint returns the same response as GET /media/media-id.
     A media object's shortcode can be found in its shortlink URL. An example shortlink is http://instagram.com/p/tsxp1hhQTG/. Its corresponding shortcode is tsxp1hhQTG.
     
     - parameter shortCode: Shortcode.
     
     - returns: `Promise` with Media.
     */
    public class func fetchMediaByShortCode(shortCode: String) -> Promise<Media> {
        return Fetcher.fetch("/media/shortcode/\(shortCode)").then({ (result, page) -> Media in
            let media = Media.generateModel(result.dictionaryValue)
            return media
        })
    }
    
    /**
     Search for recent media in a given area.
     
     - parameter lantitude: Latitude of the center search coordinate. If used, longitude is required.
     - parameter longitude: Longitude of the center search coordinate. If used, lantitude is required.
     - parameter distance:  Default is 1km (distance=1000), max distance is 5km.
     
     - returns: `Promise` with [Media].
     */
    public class func searchMedia(lantitude: Double, longitude: Double, distance: Double? = nil) -> Promise<[Media]> {
        let path = "/media/search"
        var param = ["lat": lantitude, "lng": longitude]
        if let dis = distance {
            param["distance"] = dis
        }
        return Fetcher.fetch(path).then({ (result, page) -> [Media] in
            let media = result.jsonArrayValue.map { Media.generateModel($0.dictionaryValue) }
            return media
        })
    }
}

// MARK: - Likes
extension Media {
    
    /**
     Get a list of users who have liked this media.
     Require scope: basic, public_content.
     
     - parameter mediaId: Media id.
     
     - returns: `Promise` with [User].
     */
    public class func fetchLikedUsers(mediaId: String) -> Promise<[User]> {
        return Fetcher.fetch("/media/\(mediaId)/likes").then({ (result, page) -> [User] in
            let users = result.jsonArrayValue.map { User.generateModel($0.dictionaryValue) }
            return users
        })
    }
    
    /**
     Set a like on this media by the currently authenticated user. The public_content permission scope is required to create likes on a media that does not belong to the owner of the access_token.
     
     Require scope: likes.
     
     - parameter mediaId: Media id.
     
     - returns: `Promise` with Void.
     */
    public class func likeMedia(mediaId: String) -> Promise<Void> {
        return Fetcher.fetch("/media/\(mediaId)/likes", method: .POST).then({ (result, page) -> Void in })
    }
    
    /**
     Remove a like on this media by the currently authenticated user. The public_content permission scope is required to delete likes on a media that does not belong to the owner of the access_token.
     
     Require scope: likes.

     - parameter mediaId: Media id.
     
     - returns: `Promise` with Void.
     */
    public class func unlikeMedia(mediaId: String) -> Promise<Void> {
        return Fetcher.fetch("/media/\(mediaId)/likes", method: .Delete).then({ (result, page) -> Void in })
    }
}

// MARK: - Comments
extension Media {
    /**
     Get a list of recent comments on a media object. The public_content permission scope is required to get comments for a media that does not belong to the owner of the access_token.
     
     Require scope: basic, public_content.
     
     - parameter mediaId:    Media id.
     
     - returns: `Promise` with [Comment].
     */
    
    public class func fetchComments(mediaId: String) -> Promise<[Comment]> {
        return Fetcher.fetch("/media/\(mediaId)/comments").then({ (result, page) -> [Comment] in
            let comments = result.jsonArrayValue.map { Comment.generateModel($0.dictionaryValue) }
            return comments
        })
    }
    
    /**
     Create a comment on a media object with the following rules:
     The total length of the comment cannot exceed 300 characters.
     The comment cannot contain more than 4 hashtags.
     The comment cannot contain more than 1 URL.
     The comment cannot consist of all capital letters.
     The public_content permission scope is required to create comments on a media that does not belong to the owner of the access_token.
     
     Require scope: comments.
     
     - parameter mediaId: Media id.
     - parameter text:    Text to post as a comment on the media object as specified in media-id.
     
     - returns: `Promise` with Void.
     */
    public class func postComment(mediaId: String, text: String) -> Promise<Void> {
        return Fetcher.fetch("/media/\(mediaId)/comments", method: .POST, parameters: ["text": text]).then { (result, page) -> Void in }
    }
    
    /**
     Remove a comment either on the authenticated user's media object or authored by the authenticated user.
     
     Require scope: comments.
     
     - parameter mediaId:   Media id.
     - parameter commentId: Comment id.
     
     - returns: `Promise` with Void.
     */
    public class func deleteComment(mediaId: String, commentId: String) -> Promise<Void> {
        return Fetcher.fetch("/media/\(mediaId)/comments/\(commentId)", method: .Delete).then({ (result, page) -> Void in })
    }
}