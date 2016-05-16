//
//  Location.swift
//  IGKit
//
//  Created by CaptainTeemo on 5/16/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

import Foundation

/// Location
public final class Location: NSObject, JSONConvertible {
    public var id = ""
    public var name = ""
    public var lantitude = ""
    public var longitude = ""
}

// MARK: - Location information.
extension Location {
    
    /**
     Get information about a location.
     
     Require scope: public_content.
     
     - parameter locationId: Location id.
     
     - returns: `Promise` with Location.
     */
    public class func fetchLocation(locationId: String) -> Promise<Location> {
        return Fetcher.fetch("/locations/\(locationId)").then({ (result, page) -> Location in
            let location = Location.generateModel(result.dictionaryValue)
            return location
        })
    }
    
    /**
     Get a list of recent media objects from a given location.

     Require scope: public_content.

     - parameter locationId: Location id.
     
     - returns: `Promise` with ([Media], Pagination?).
     */
    public class func fetchLocationMedia(locationId: String) -> Promise<([Media], Pagination?)> {
        return Fetcher.fetch("/locations/\(locationId)/media/recent").then({ (result, page) -> ([Media], Pagination?) in
            let media = result.jsonArrayValue.map { Media.generateModel($0.dictionaryValue) }
            return (media, page)
        })
    }
    
    /**
     Search for a location by geographic coordinate.

     Require scope: public_content.
     
     - parameter lantitude: Latitude of the center search coordinate.
     - parameter longitude: Longitude of the center search coordinate.
     - parameter distance:  Default is 500m (distance=500), max distance is 750.
     
     - returns: `Promise` with [Location].
     */
    public class func searchLocation(lantitude: Double, longitude: Double, distance: Double?) -> Promise<[Location]> {
        var param = ["lat": lantitude, "lng": longitude]
        if let dis = distance {
            param["distance"] = dis
        }
        return Fetcher.fetch("/locations/search", parameters: param).then({ (result, page) -> [Location] in
            let locations = result.jsonArrayValue.map { Location.generateModel($0.dictionaryValue) }
            return locations
        })
    }
    
    /**
     Search for a location by geographic coordinate.
     
     Require scope: public_content.
     
     - parameter placeId:  Returns a location mapped off of a Facebook places id
     - parameter distance: Default is 500m (distance=500), max distance is 750.
     
     - returns: `Promise` with [Location].
     */
    public class func searchLocation(placeId: String, distance: Double?) -> Promise<[Location]> {
        var param: [String: AnyObject] = ["facebook_places_id": placeId]
        if let dis = distance {
            param["distance"] = dis
        }
        return Fetcher.fetch("/locations/search", parameters: param).then({ (result, page) -> [Location] in
            let locations = result.jsonArrayValue.map { Location.generateModel($0.dictionaryValue) }
            return locations
        })
    }
}