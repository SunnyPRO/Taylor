//
//  ComponentFinder.swift
//  Scissors
//
//  Created by Alex Culeva on 10/2/15.
//  Copyright © 2015 com.yopeso.aculeva. All rights reserved.
//

import Foundation
import SourceKittenFramework

struct ComponentFinder {
    
    let text: String
    let syntaxMap: SyntaxMap
    
    init(text: String, syntaxMap: SyntaxMap = SyntaxMap(tokens: [])) {
        self.text = text
        self.syntaxMap = syntaxMap
    }
    
    /**
        Finds all comments, logical operators (`??`, `? :`, `&&`, `||`) and
        empty lines in **text**.
    */
    var additionalComponents: [ExtendedComponent] {
        return findComments() + findLogicalOperators() + findEmptyLines()
    }
    
    func findLogicalOperators() -> [ExtendedComponent] {
        var operators = findOROperators()
        operators.append(contentsOf: findANDOperators())
        operators.append(contentsOf: findTernaryOperators())
        operators.append(contentsOf: findNilCoalescingOperators())
        
        return operators
    }
    
    func findOROperators() -> [ExtendedComponent] {
        return text.findMatchRanges("(\\|\\|)").map {
            ExtendedComponent(type: .or, range: $0)
        }
    }
    
    func findANDOperators() -> [ExtendedComponent] {
        return text.findMatchRanges("(\\&\\&)").map {
            ExtendedComponent(type: .and, range: $0)
        }
    }
    
    func findTernaryOperators() -> [ExtendedComponent] {
        return text.findMatchRanges("(\\s+\\?(?!\\?).*?:)").map {
            ExtendedComponent(type: .ternary, range: $0)
        }
    }
    
    func findNilCoalescingOperators() -> [ExtendedComponent] {
        return text.findMatchRanges("(\\?\\?)").map {
            ExtendedComponent(type: .nilCoalescing, range: $0)
        }
    }
    
    func findComments() -> [ExtendedComponent] {
        return syntaxMap.tokens.filter {
            componentTypeUIDs[$0.type] == .comment
            }.reduce([ExtendedComponent]()) {
                $0 + ExtendedComponent(dict: $1.dictionaryValue as [String : AnyObject])
        }
    }
    
    func findEmptyLines() -> [ExtendedComponent] {
        return text.findMatchRanges("(\\n[ \\t\\n]*\\n)").map {
            return ExtendedComponent(type: .emptyLines, range: ($0 as OffsetRange).toEmptyLineRange())
        }
    }
    
    //Ending points of getters and setters will most probably be wrong unless a nice coding-style is being used "} set {"
    func findGetters(_ components: [ExtendedComponent]) -> [ExtendedComponent] {
        return components.filter { ($0 as ExtendedComponent).type.isA(.variable) }.reduce([ExtendedComponent]()) { components, component in
            let range = NSMakeRange(component.offsetRange.start, component.offsetRange.end - component.offsetRange.start)
            return findGetterAndSetter((text as NSString).substring(with: range)).reduce(components) {
                $1.offsetRange.start += component.offsetRange.start
                $1.offsetRange.end += component.offsetRange.start
                return $0 + $1
            }
        }
    }
    
    func findGetterAndSetter(_ text: String) -> [ExtendedComponent] {
        var accessors = [ExtendedComponent]()
        let gettersRanges: [OffsetRange] = text.findMatchRanges("(get($|[ \\t\\n{}]))")
        let settersRanges: [OffsetRange] = text.findMatchRanges("(set($|[ \\t\\n{}]))")
        if gettersRanges.isEmpty { return findObserverGetters(text) }
        
        accessors.append(ExtendedComponent(type: .function, range: gettersRanges.first!, names: ("get", nil)))
        if !settersRanges.isEmpty {
            accessors.append(ExtendedComponent(type: .function, range: settersRanges.first!, names: ("set", nil)))
        }
        accessors.sort { $0.offsetRange.start < $1.offsetRange.start }
        if accessors.count == 1 {
            accessors.first!.offsetRange.end = text.characters.count - 1
        } else {
            accessors.first!.offsetRange.end = accessors.second!.offsetRange.start - 1
            accessors.second!.offsetRange.end = text.characters.count - 1
        }
        
        return accessors
    }
    
    func findObserverGetters(_ text: String) -> [ExtendedComponent] {
        var willSetRanges: [OffsetRange] = text.findMatchRanges("(willSet($|[ \\t\\n{}]))")
        var didSetRanges: [OffsetRange] = text.findMatchRanges("(didSet($|[ \\t\\n{}]))")
        var observers = [ExtendedComponent]()
        if willSetRanges.count > 0 {
            observers.append(ExtendedComponent(type: .function, range: willSetRanges[0], names: ("willSet", nil)))
        }
        if didSetRanges.count > 0 {
            observers.append(ExtendedComponent(type: .function, range: didSetRanges[0], names: ("didSet", nil)))
        }
        observers.sort { $0.offsetRange.start < $1.offsetRange.start }
        if observers.count == 1 {
            observers[0].offsetRange.end = text.characters.count - 1
        } else if observers.count == 2 {
            observers[0].offsetRange.end = observers[1].offsetRange.start - 1
            observers[1].offsetRange.end = text.characters.count - 1
        }
        
        return observers
    }
    
}
