//
//  Error.swift
//  IGKit
//
//  Created by CaptainTeemo on 5/13/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

import Foundation

extension NSError {
    static func error(code: Int, description: String) -> NSError {
        return NSError(domain: ErrorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
}