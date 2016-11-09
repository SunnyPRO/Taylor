//
//  CyclomaticComplexityTests.swift
//  Temper
//
//  Created by Mihai Seremet on 9/9/15.
//  Copyright © 2015 Yopeso. All rights reserved.
//

import Nimble
import Quick
@testable import TaylorFramework

class CyclomaticComplexityTests: QuickSpec {
    let rule = CyclomaticComplexityRule()
    var component = TestsHelper().componentForCyclomaticComplexity
    override func spec() {
        describe("Cyclomatic Complexity Rule") {
            
            beforeEach {
                self.component = TestsHelper().componentForCyclomaticComplexity
            }
            
            it("should return false and message when there is high cyclomatic complexity") {
                let result = self.rule.checkComponent(self.component)
                expect(result.isOk).to(beFalse())
                expect(result.message).toNot(beNil())
                expect(result.value).to(equal(12))
            }
            it("should return true and nil when there is low cyclomatic complexity") {
                if let first = self.component.components.first {
                    self.component.components = [first]
                }
                let result = self.rule.checkComponent(self.component)
                expect(result.isOk).to(beTrue())
                expect(result.message).to(beNil())
                expect(result.value).to(equal(4))
            }
            it("should return 1 when there are no components") {
                self.component.components = []
                let result = self.rule.checkComponent(self.component)
                expect(result.isOk).to(beTrue())
                expect(result.message).to(beNil())
                expect(result.value).to(equal(1))
            }
            it("should not check the non-function components") {
                let component = Component(type: .for, range: ComponentRange(sl: 0, el: 0))
                let result = self.rule.checkComponent(component)
                expect(result.isOk).to(beTrue())
                expect(result.message).to(beNil())
                expect(result.value).to(beNil())
            }
            it("should set the priority") {
                self.rule.priority = 4
                expect(self.rule.priority).to(equal(4))
            }
        }
    }
}
