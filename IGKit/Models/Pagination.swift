//
//  Pagination.swift
//  IGKit
//
//  Created by CaptainTeemo on 5/13/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

import Foundation

/**
 *  Pagination information.
 */
public final class Pagination: NSObject, JSONConvertible {
    public var next_url = ""
    public var next_max_id = ""
}