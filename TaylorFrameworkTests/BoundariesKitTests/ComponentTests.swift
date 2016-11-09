//
//  ComponentTests.swift
//  BoundariesKit
//
//  Created by Andrei Raifura on 9/3/15.
//  Copyright © 2015 YOPESO. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import TaylorFramework

func getTestRange() -> ComponentRange {
    return ComponentRange(sl: 0, el: 0);
}

class ComponentTests: QuickSpec {
    override func spec() {
        describe("Component") {
            var component: Component!
            
            beforeEach {
                component = Component(type: .class, range: getTestRange(), name: "Test")
            }
            
            afterEach {
                component = nil
            }
            
            context("when initialized") {
                
                it("should not be nil") {
                    expect(component).notTo(beNil())
                }
                
                it("should not have parent") {
                    expect(component.parent).to(beNil())
                }
                
                it("should not have components") {
                    expect(component.components).to(beEmpty())
                }
            }
            
            context("when initialized with type, range, components and name") {
                
                it("should contain given type, range, components and name") {
                    expect(component.type).to(equal(ComponentType.class))
                    expect(component.range).to(equal(getTestRange()))
                    expect(component.name).to(equal("Test"))
                    expect(component.components).to(equal([]))
                }
            }
            
            context("when initialized with type and range") {
                let componentWithNoName = Component(type: .class, range: getTestRange())
                
                it("should not contain a name") {
                    expect(componentWithNoName.name).to(beNil())
                }
                
                it("should contain given type, range and components") {
                    expect(componentWithNoName.type).to(equal(ComponentType.class))
                    expect(componentWithNoName.range).to(equal(getTestRange()))
                    expect(componentWithNoName.components).to(equal([]))
                }
            }
            
            context("when makes a child component") {
                let parent = Component(type: .class, range: getTestRange())
                let child = parent.makeComponent(type: .if, range: getTestRange())
                
                it("should add the child component to components") {
                    expect(parent.components).to(contain(child))
                }
                
                it("should be set as child's parent component") {
                    expect(child.parent).to(equal(parent))
                }
                
                context("with type and range") {
                    
                    it("child component should contain type and range") {
                        let child = component.makeComponent(type: .if, range: getTestRange())
                        expect(child.type).to(equal(ComponentType.if))
                        expect(child.range).to(equal(getTestRange()))
                    }
                }
                
                context("with type, range and name") {
                    
                    it("child component should contain type and range") {
                        let name = "Test"
                        let childWithName = parent.makeComponent(type: .function, range: getTestRange(), name: name)
                        expect(childWithName.type).to(equal(ComponentType.function))
                        expect(childWithName.range).to(equal(getTestRange()))
                        expect(childWithName.name).to(equal(name))
                    }
                }
                
            }
            
            context("when compared with another component") {

                it("should be equal to an identical component with the same parent") {
                    let component1 = component.makeComponent(type: .class, range: getTestRange(), name: "Test")
                    let component2 = component.makeComponent(type: .class, range: getTestRange(), name: "Test")
                    expect(component2).to(equal(component1))
                }
                
                it("should not be equal with a diffent component") {
                    let functionComponent = Component(type: .function, range: getTestRange(), name: "Test")
                    expect(component).toNot(equal(functionComponent))
                    
                    let componentWithNoName = Component(type: .function, range: getTestRange())
                    expect(component).toNot(equal(componentWithNoName))
                    
                    let range = ComponentRange(sl: 0, el: 1)
                    let componentWithDifferentRange = Component(type: .class, range: range)
                    expect(component).notTo(equal(componentWithDifferentRange))
                }
                
                it("should be equal if they have same components but in different order") {
                    let component1 = Component(type: .function, range: getTestRange(), name: "Test")
                    let component2 = Component(type: .class, range: getTestRange(), name: "Test")
                    component.makeComponent(type: component1.type, range: component1.range)
                    component.makeComponent(type: component2.type, range: component2.range)
                    
                    let testComponent = Component(type: .class, range: getTestRange())
                    testComponent.makeComponent(type: component2.type, range: component2.range)
                    testComponent.makeComponent(type: component1.type, range: component1.range)
                    
                    expect(testComponent).to(equal(component))
                }
            }
        }
    }
    
}
