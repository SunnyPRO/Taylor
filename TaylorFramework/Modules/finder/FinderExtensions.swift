//
//  FinderExtensions.swift
//  Finder
//
//  Created by Simion Schiopu on 9/7/15.
//  Copyright © 2015 YOPESO. All rights reserved.
//

import Foundation

typealias FilePath = String

extension FilePath {
    static let Separator = "/"
    
    func isKindOfType(_ type: String) -> Bool {
        return self.hasSuffix(type)
    }
}

extension String {
    static let Empty = ""
    
    func deleteSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        
        return (self as NSString).substring(to: self.characters.count - suffix.characters.count)
    }
    
    func stringByAppendingPathComponent(_ string: String) -> String {
        return (self as NSString).appendingPathComponent(string)
    }
}

extension Sequence where Iterator.Element == FilePath {
    
    func keepPathsMatchingType(_ type: String) -> [FilePath] {
        return self.filter { $0.isKindOfType(type) }
    }
    
    func excludePathsContainingSubpath(_ subpath: FilePath) -> [FilePath] {
        return self.filter { !$0.hasPrefix(subpath) }
    }
    
    func excludePathsContainingSubpathsInArray(_ subpaths: [FilePath]) -> [FilePath] {
        guard var remainedPaths = self as? [FilePath] else {
            return []
        }
        for subpath in subpaths {
            remainedPaths = remainedPaths.excludePathsContainingSubpath(subpath)
        }
        
        return remainedPaths
    }
    
    func deleteRootPath(_ rootPath: FilePath) -> [FilePath] {
        let fullRootPath = rootPath + FilePath.Separator
        return self.map {
            $0.replacingOccurrences(of: fullRootPath, with: FilePath.Empty)
        }
    }
}
