//
//  Bundle+cache.swift
//  Parade
//
//  Created by Simon Le Bras on 12/09/2018.
//  Copyright © 2018 Parade Protection. All rights reserved.
//

import UIKit

extension URL {
    static func urlFromCacheOrBundle(forResource resource: String, withExtension ext: String) -> URL? {
        let fileManager = FileManager.default
        
        let cacheContentPath = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("content")
        
        let url = cacheContentPath.appendingPathComponent(resource).appendingPathExtension(ext)
        
        guard fileManager.fileExists(atPath: url.path) else {
            return Bundle.main.url(forResource: resource, withExtension: ext)
        }
        
        return url
    }
}
