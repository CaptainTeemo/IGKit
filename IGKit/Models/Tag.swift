//
//  Tag.swift
//  IGKit
//
//  Created by CaptainTeemo on 5/16/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

import Foundation

/// Tag
public final class Tag: NSObject, JSONConvertible {
    public var name = ""
    public var media_count = ""
}

// MARK: - Tag information.
extension Tag {
    
    /**
     Get information about a tag object.
     
     Require scope: public_content.
     
     - parameter name: Tag name.
     
     - returns: `Promise` with Tag.
     */
    public class func fetchTag(name: String) -> Promise<Tag> {
        return Fetcher.fetch("/tags/\(name)").then({ (result, page) -> Tag in
            let tag = Tag.generateModel(result.dictionaryValue)
            return tag
        })
    }
    
    /**
     Get a list of recently tagged media.
     
     Require scope: public_content.
     
     - parameter name:       Tag name.
     - parameter pagination: Optional.
     
     - returns: `Promise` with ([Media], Pagination?).
     */
    public class func fetchTagMedia(name: String, pagination: Pagination? = nil) -> Promise<([Media], Pagination?)> {
        return Fetcher.fetch("/tags/\(name)/media/recent").then({ (result, page) -> ([Media], Pagination?) in
            let media = result.jsonArrayValue.map { Media.generateModel($0.dictionaryValue) }
            return (media, page)
        })
    }
    
    /**
     Search for tags by name.

     Require scope: public_content.
     
     - parameter query: A valid tag name without a leading #. (eg. snowy, nofilter).
     
     - returns: `Promise` with [Tag].
     */
    public class func searchTag(query: String) -> Promise<[Tag]> {
        return Fetcher.fetch("/tags/search", parameters: ["q": query]).then({ (result, page) -> [Tag] in
            let tags = result.jsonArrayValue.map { Tag.generateModel($0.dictionaryValue) }
            return tags
        })
    }
}