//
//  TaylorIntegrationTest.swift
//  TaylorIntegrationTest
//
//  Created by Seremet Mihai on 11/9/15.
//  Copyright © 2015 YOPESO. All rights reserved.
//

import Quick
import Nimble
import TaylorFramework

enum IntegrationTestsError: Error {
    case fileNotFount(String)
    case bundleResourceNotFount(String)
}

class TaylorIntegrationTests: QuickSpec {
    
    var runTaskPath : String {
        let testBundle = Bundle(for: type(of: self))
        let bundlePath = testBundle.bundlePath
        return bundlePath.stringWithoutLastComponent().stringByAppendingPathComponent("Taylor.app/Contents/MacOS/Taylor")
    }
    
    var analyzeFilesPath = String()
    var resultFilePath = String()
    
    let resultFileName = "taylor_report.json"
    let fileNames = ["Wrapper.swift", "WrapperProxy.swift", "CloseDialogWindowOperation.swift"]

    
    func cleanOrDestroyResources() throws {
        if FileManager.default.fileExists(atPath: analyzeFilesPath) {
            try FileManager.default.removeItem(atPath: analyzeFilesPath)
        }
        if FileManager.default.fileExists(atPath: resultFilePath.stringWithoutLastComponent()) {
            try FileManager.default.removeItem(atPath: resultFilePath.stringWithoutLastComponent())
        }
    }
    
    
    func initializePaths() throws {
        let mainBundle = Bundle(for: type(of: self))
        if let resourcesPath = mainBundle.resourcePath {
            analyzeFilesPath = resourcesPath.stringByAppendingPathComponent("AnalyzeFiles")
            resultFilePath = resourcesPath.stringByAppendingPathComponent("Result")
        } else {
            throw IntegrationTestsError.bundleResourceNotFount(mainBundle.bundlePath)
        }
    }
    
    
    func createResources() throws {
        let mainBundle = Bundle(for: type(of: self))
        if let path = mainBundle.path(forResource: "TaylorIntegrationTestResources", ofType: "bundle"), let bundle = Bundle(path: path) {
            if !FileManager.default.fileExists(atPath: analyzeFilesPath) {
                try FileManager.default.createDirectory(atPath: analyzeFilesPath, withIntermediateDirectories: false, attributes: nil)
            }
            if !FileManager.default.fileExists(atPath: resultFilePath) {
                try FileManager.default.createDirectory(atPath: resultFilePath, withIntermediateDirectories: false, attributes: nil)
            }
            try createFiles(bundle)
            try createResultFile(bundle)
        } else {
            throw IntegrationTestsError.bundleResourceNotFount("TaylorIntegrationTestResources")
        }
    }
    
    
    fileprivate func createFiles(_ sourceBundle: Bundle) throws {
        for fileName in fileNames {
            if let path = sourceBundle.path(forResource: fileName.stringByTrimmingTheExtension, ofType: fileName.fileExtension) {
                try FileManager.default.copyItem(atPath: path, toPath: self.analyzeFilesPath.stringByAppendingPathComponent(path.lastPathComponent))
            } else {
                throw IntegrationTestsError.bundleResourceNotFount("fileName")
            }
        }
    }
    
    
    fileprivate func createResultFile(_ sourceBundle: Bundle) throws {
        if let path = sourceBundle.path(forResource: resultFileName.stringByTrimmingTheExtension, ofType: resultFileName.fileExtension) {
            resultFilePath = resultFilePath.stringByAppendingPathComponent(resultFileName)
            try FileManager.default.copyItem(atPath: path, toPath: self.resultFilePath)
        } else {
            throw IntegrationTestsError.bundleResourceNotFount(resultFileName)
        }
    }
    
    
    override func spec() {
        
        do {
            try self.initializePaths()
        } catch let error {
            print(error)
        }
        
        describe("Taylor") {
            
            beforeEach {
                do {
                    try self.createResources()
                } catch let error {
                    print(error)
                }
            }
            
            
            afterEach {
                do {
                    try self.cleanOrDestroyResources()
                } catch let error {
                    print(error)
                }
            }
            
            it("should generate correct reports") {
                let runTask = Process()
                runTask.launchPath = self.runTaskPath
                runTask.arguments = ["-p", self.analyzeFilesPath, "-r", "json:taylor_report.json"]
                runTask.launch()
                runTask.waitUntilExit()
                let reporterPath = self.analyzeFilesPath.stringByAppendingPathComponent("taylor_report.json")
                expect(ReporterComparator().compareReporters(self.resultFilePath, secondReporterPath: reporterPath)).to(beTrue())
                do {
                    if FileManager.default.fileExists(atPath: reporterPath) {
                        try FileManager.default.removeItem(atPath: reporterPath)
                    }
                } catch let error {
                    print(error)
                }
            }
            
        }
        
    }
    
}
