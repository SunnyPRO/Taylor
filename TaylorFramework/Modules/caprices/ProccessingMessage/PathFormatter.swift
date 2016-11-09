//
//  PathFormatter.swift
//  Caprices
//
//  Created by Dmitrii Celpan on 9/2/15.
//  Copyright © 2015 yopeso.dmitriicelpan. All rights reserved.
//

import Cocoa

typealias Path = String

private let TildeSymbol = "~"
private let SearchIndicator = ".*"
private let CurrentDirectorySymbol = "."
private let ParentDirectorySymbol = ".."
private let RecursiveSymbol = "*"

extension Path {
    
    func lastComponentFromPath() -> String {
        if self.isEmpty { return String.Empty }
        let pathComponents = self.components(separatedBy: FilePath.Separator)
        return pathComponents.last! // Safe to force unwrap
    }
    
    
    func absolutePath(_ analyzePath: String = FileManager.default.currentDirectoryPath) -> Path {
        if self.hasPrefix(TildeSymbol) { return NSHomeDirectory() + self.replacingOccurrences(of: TildeSymbol, with: String.Empty) }
        if self.hasPrefix(FilePath.Separator) { return self }
        let concatenatedPaths = analyzePath + FilePath.Separator + self
        
        return concatenatedPaths.editAbsolutePath()
    }
    
    
    func formattedExcludePath(_ analyzePath: String = FileManager.default.currentDirectoryPath) -> Path {
        if self.hasPrefix(SearchIndicator) && self.hasSuffix(SearchIndicator) { return self }
        if containsSymbolAsPrefixOrSuffix(SearchIndicator) { return String.Empty }

        return self.absolutePath(analyzePath)
    }
    
    
    fileprivate func containsSymbolAsPrefixOrSuffix(_ symbol: String) -> Bool {
        return (self.hasPrefix(symbol) && !self.hasSuffix(symbol)) || (!self.hasPrefix(symbol) && self.hasSuffix(symbol))
    }
    
    
    fileprivate func editAbsolutePath() -> Path {
        var pathComponents = self.components(separatedBy: FilePath.Separator)
        editPathComponentsForDotShortcuts(&pathComponents)
        checkLastPathComponentsElement(&pathComponents)
        
        return pathComponents.joined(separator: FilePath.Separator)
    }
    
    
    fileprivate func editPathComponentsForDotShortcuts(_ pathComponents: inout [String]) {
        for (index, element) in pathComponents.enumerated() {
            if element == CurrentDirectorySymbol {
                pathComponents.remove(at: index)
            }
            if element == ParentDirectorySymbol {
                pathComponents.remove(at: index)
                pathComponents.remove(at: index - 1)
            }
        }
    }
    
    
    fileprivate func checkLastPathComponentsElement(_ pathComponents: inout [String]) {
        if pathComponents.isEmpty { return }
        if [String.Empty, RecursiveSymbol].contains(pathComponents.last!) {
            pathComponents.removeLast()
        }
    }
}
