//
//  OutputCoordinator.swift
//  Temper
//
//  Created by Mihai Seremet on 8/28/15.
//  Copyright © 2015 Yopeso. All rights reserved.
//

import Foundation

final class OutputCoordinator {
    var filePath: String
    var reporters = [Reporter]()
    
    init(filePath: String) {
        self.filePath = filePath
    }
    
    func writeTheOutput(_ violations: [Violation], reporters: [Reporter]) {
        self.reporters = reporters
        for reporter in reporters {
            if reporter.fileName.isEmpty && (reporter.concreteReporter as? XcodeReporter) == nil { continue }
            let path = NSString.init(string: filePath).appendingPathComponent(reporter.fileName)
            reporter.coordinator().writeViolations(violations, atPath: path)
        }
    }
}

protocol WritingCoordinator {
    func writeViolations(_ violations: [Violation], atPath path: String)
}
