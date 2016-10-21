//
//  FinderPath.swift
//  Finder
//
//  Created by Simion Schiopu on 8/26/15.
//  Copyright © 2015 YOPESO. All rights reserved.
//

import Foundation

final class Finder {
    fileprivate let fileManager: FileManager
    fileprivate let printer: ErrorPrinter
    fileprivate var parameters: Parameters?
    fileprivate var excludes: [FilePath]!
    
    init(fileManager: FileManager = FileManager.default, printer: Printer = Printer(verbosityLevel: .error)) {
        self.fileManager = fileManager
        self.printer = ErrorPrinter(printer: printer)
    }
    
    func findFilePaths(parameters dictionary: Options) -> [String] {
        parameters = Parameters(dictionary: dictionary, printer: printer)
        guard parameters != nil && validateParameters(parameters!) else {
            return []
        }
        _ = parameters!.rootPath.deleteSuffix(FilePath.Separator)
        excludes = parameters!.excludes.deleteRootPath(parameters!.rootPath)
        let pathsFromDirectory = findPathsInDirectory(parameters!.rootPath)
        
        return (pathsFromDirectory + parameters!.files).unique
    }
    
    fileprivate func validateParameters(_ parameters: Parameters) -> Bool {
        return validatePath(parameters.rootPath) && validateFiles(parameters.files)
    }
    
    fileprivate func findPathsInDirectory(_ path: String) -> [String] {
        do {
            let pathsInDirectory = try fileManager.subpathsOfDirectory(atPath: path)
            let paths = exclude(excludes, fromPaths: pathsInDirectory)
            return paths.map { absolutePath(parameters!.rootPath, fileName: $0) }
        } catch _ {
            printer.printSubpathsError(directoryPath: path)
            return []
        }
    }
    
    fileprivate func exclude(_ excludes: [FilePath], fromPaths files: [FilePath]) -> [FilePath] {
        return files.keepPathsMatchingType(parameters!.type)
            .excludePathsContainingSubpathsInArray(excludes)
    }
    
    fileprivate func validateFiles(_ files: [FilePath]) -> Bool {
        for filePath in files {
            guard fileManager.fileExists(atPath: filePath) else {
                printer.printMissingFileError(filePath: filePath)
                return false
            }
            
            guard filePath.isKindOfType(parameters!.type) else {
                printer.printWrongFileTypeError(filePath: filePath)
                return false
            }
        }
        return true
    }
    
    fileprivate func existsFileOfTypeAtPath(_ path: FilePath, type: String) -> Bool {
        return fileManager.fileExists(atPath: path) && path.isKindOfType(type)
    }
    
    fileprivate func validatePath(_ path: FilePath) -> Bool {
        if !directoryExistsAtPath(path) {
            printer.printWrongRootPathMessage()
            return false
        }
        return true
    }
    
    fileprivate func directoryExistsAtPath(_ path: FilePath) -> Bool {
        let rootPath = parameters!.rootPath
        return fileManager.fileExists(atPath: path) && fileManager.isDirectory(rootPath)
    }
    
    fileprivate func absolutePath(_ path: FilePath, fileName: String) -> FilePath {
        return path + FilePath.Separator + fileName
    }
}

extension Array where Element: Equatable {
    var unique: [Element] {
        return self.reduce([]) { !$0.contains($1) ? $0 + $1 : $0 }
    }
}
