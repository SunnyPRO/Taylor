//
//  ComponentExtensionsTests.swift
//  Temper
//
//  Created by Mihai Seremet on 9/8/15.
//  Copyright © 2015 Yopeso. All rights reserved.
//

import Nimble
import Quick
@testable import TaylorFramework

class ComponentExtensionsTests: QuickSpec {
    
    override func spec() {
        
        let nonClassComponent = Component(type: ComponentType.function, range: ComponentRange(sl: 10, el: 30), name: "function")
        let classComponent = Component(type: ComponentType.class, range: ComponentRange(sl: 10, el: 30), name: "class")
        let classChildComponent = classComponent.makeComponent(type: ComponentType.comment, range: ComponentRange(sl: 10, el: 30))
        
        it("should find the parent component of class type, or nil") {
            expect(nonClassComponent.classComponent()).to(beNil())
            expect(classComponent.classComponent()).toNot(beNil())
            expect(classChildComponent.classComponent()).toNot(beNil())
        }
        it("should find the next component") {
            let component = Component(type: ComponentType.if, range: ComponentRange(sl: 1, el: 1))
            let component1 = component.makeComponent(type: ComponentType.if, range: ComponentRange(sl: 1, el: 1))
            let component2 = component.makeComponent(type: ComponentType.if, range: ComponentRange(sl: 1, el: 1))
            let component3 = component.makeComponent(type: ComponentType.if, range: ComponentRange(sl: 1, el: 1))
            expect(component.nextComponent()).to(beNil())
            expect(component1.nextComponent()).to(equal(component2))
            expect(component2.nextComponent()).to(equal(component3))
            expect(component3.nextComponent()).to(beNil())
        }
        
        describe("deserializer") {
            context("when given wrong dict") {
                it("should return nil when no startLine key present") {
                    expect(ComponentRange.deserialize(["endline": 12 as AnyObject])).to(beNil())
                }
                it("should return nil when no endLine key present") {
                    expect(ComponentRange.deserialize(["path": "somepath" as AnyObject])).to(beNil())
                }
            }
        }
    }
}
