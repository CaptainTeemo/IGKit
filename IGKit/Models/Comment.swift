//
//  Comment.swift
//  IGKit
//
//  Created by CaptainTeemo on 5/16/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

import Foundation

/// Comment
public final class Comment: NSObject, JSONConvertible {
    public var id = ""
    public var text = ""
    public var created_time = ""
     /// Actually a User object.
    public var from = [String: AnyObject]()
}