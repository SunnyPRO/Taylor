//
//  ComponentsBuilder.swift
//  Scissors
//
//  Created by Alexandru Culeva on 9/3/15.
//  Copyright © 2015 com.yopeso.aculeva. All rights reserved.
//

@testable import TaylorFramework

func arrayComponents() -> [ExtendedComponent] {
    return [ExtendedComponent(type: ComponentType.function, range: OffsetRange(start: 2, end: 4)),
            ExtendedComponent(type: ComponentType.class, range: OffsetRange(start: 1, end: 8)),
            ExtendedComponent(type: ComponentType.comment, range: OffsetRange(start: 5, end: 7)),
            ExtendedComponent(type: ComponentType.emptyLines, range: OffsetRange(start: 3, end: 3)),
            ExtendedComponent(type: ComponentType.function, range: OffsetRange(start: 9, end: 10))]
}

func componentsForArrayComponents() -> ExtendedComponent {
    let rootComponent = ExtendedComponent(type: ComponentType.class, range: OffsetRange(start: 0, end: 11))
    let classComponent = rootComponent.addChild(ComponentType.class, range: OffsetRange(start: 1, end: 8))
    let funcComponent = classComponent.addChild(ComponentType.function, range: OffsetRange(start: 2, end: 4))
    _ = funcComponent.addChild(ComponentType.emptyLines, range: OffsetRange(start: 3, end: 3))
    _ = classComponent.addChild(ComponentType.comment, range: OffsetRange(start: 5, end: 7))
    _ = rootComponent.addChild(ComponentType.function, range: OffsetRange(start: 9, end: 10))
    
    return rootComponent
}

func componentsOneClass() -> [Component] {
    return [Component(type: .class,
        range: ComponentRange(sl: 2, el: 3))]
}

func componentsClassAndFunc() -> [Component] {
    return [Component(type: .class,
        range: ComponentRange(sl: 2, el: 3)),
        Component(type: .function,
            range: ComponentRange(sl: 4, el: 5))]
}

func componentsEmptyLines() -> [Component] {
    let rootComponent = Component(type: ComponentType.function, range:ComponentRange(sl: 1, el: 7))
    _ = rootComponent.makeComponent(type: .emptyLines,
        range: ComponentRange(sl: 2, el: 6))
    return [rootComponent]
}

func componentsComments() -> [Component] {
    return [Component(type: .comment,
        range: ComponentRange(sl: 1, el: 1)),
        Component(type: .comment,
            range: ComponentRange(sl: 2, el: 2)),
        Component(type: .comment,
            range: ComponentRange(sl: 3, el: 5)),
        Component(type: .comment,
            range: ComponentRange(sl: 6, el: 7)),
        Component(type: .comment,
            range: ComponentRange(sl: 8, el: 8))]
}

func componentsForStrings() -> [Component] {
    return [Component(type: .variable,
        range: ComponentRange(sl: 1, el: 1)),
        Component(type: .variable,
            range: ComponentRange(sl: 2, el: 2)),
        Component(type: .variable,
            range: ComponentRange(sl: 3, el: 3))]
}

func componentsForRandom() -> [Component] {
    
    let rootComponent = Component(type: ComponentType.class, range:ComponentRange(sl: 1, el: 8))
    let child = rootComponent.makeComponent(type: .function, range: ComponentRange(sl: 2, el: 4))
    _ = rootComponent.makeComponent(type: .comment, range:ComponentRange(sl: 5, el: 7))
    
    _ = child.makeComponent(type: .emptyLines, range: ComponentRange(sl: 3, el: 3))
    
    return [rootComponent,
        Component(type: .function,
            range: ComponentRange(sl: 9, el: 10))]
}

func componentsOneStructOneEnum() -> [Component] {
    return [Component(type: ComponentType.struct,
        range: ComponentRange(sl: 1, el: 2)),
        Component(type:ComponentType.enum,
            range: ComponentRange(sl: 3, el: 3))]
}

func componentsIfElse() -> [Component] {
    let rootComponent = Component(type: ComponentType.function,
        range: ComponentRange(sl: 1, el: 7))
    _ = rootComponent.makeComponent(type: .if, range: ComponentRange(sl: 2, el: 3))
    _ = rootComponent.makeComponent(type: .if, range: ComponentRange(sl: 4, el: 4))
    _ = rootComponent.makeComponent(type: .else, range: ComponentRange(sl: 5, el: 6))
    
    return [rootComponent]
}

func componentsElseIf() -> [Component] {
    let rootComponent = Component(type: ComponentType.function, range: ComponentRange(sl: 1, el: 4))
    _ = rootComponent.makeComponent(type: .if, range: ComponentRange(sl: 2, el: 2))
    _ = rootComponent.makeComponent(type: .elseIf, range: ComponentRange(sl: 3, el: 4))
    return [rootComponent]
}

func componentsForRepeatWhile() -> [Component] {
    let rootComponent = Component(type: .function, range: ComponentRange(sl: 1, el: 6))
    let repeatComponent = rootComponent.makeComponent(type: .repeat, range: ComponentRange(sl: 2, el: 5))
    _ =  repeatComponent.makeComponent(type: .and, range: ComponentRange(sl: 5, el: 5))
    _ = repeatComponent.makeComponent(type: .or, range: ComponentRange(sl: 5, el: 5))
    return [rootComponent]
}

func componentsForTernaryNilc() -> [Component] {
    let rootComponent = Component(type: .function, range: ComponentRange(sl: 1, el: 17))
    var ifComponent = rootComponent.makeComponent(type: .if, range: ComponentRange(sl: 2, el: 4))
    _ = ifComponent.makeComponent(type: .ternary, range: ComponentRange(sl: 3, el: 3))
    ifComponent = rootComponent.makeComponent(type: .if, range: ComponentRange(sl: 5, el: 7))
    _ = ifComponent.makeComponent(type: .nilCoalescing, range: ComponentRange(sl: 6, el: 6))
    ifComponent = rootComponent.makeComponent(type: .if, range: ComponentRange(sl: 8, el: 10))
    _ = ifComponent.makeComponent(type: .ternary, range: ComponentRange(sl: 9, el: 9))
    ifComponent = rootComponent.makeComponent(type: .if, range: ComponentRange(sl: 11, el: 13))
    _ = ifComponent.makeComponent(type: .nilCoalescing, range: ComponentRange(sl: 12, el: 12))
    ifComponent = rootComponent.makeComponent(type: .if, range: ComponentRange(sl: 14, el: 16))
    _ = ifComponent.makeComponent(type: .ternary, range: ComponentRange(sl: 15, el: 15))
    return [rootComponent]
}

func componentsForIfElifElse() -> [Component] {
    let component = Component(type: ComponentType.function, range: ComponentRange(sl: 1, el: 20))
    let ifComponent = component.makeComponent(type: ComponentType.if, range: ComponentRange(sl: 2, el: 6))
    let whileComponent = ifComponent.makeComponent(type: ComponentType.while, range: ComponentRange(sl: 3, el: 5))
    _ = whileComponent.makeComponent(type: .and, range: ComponentRange(sl: 3, el: 3))
    _ = whileComponent.makeComponent(type: .ternary, range: ComponentRange(sl: 4, el: 4))
    let elseIfComponent = component.makeComponent(type: ComponentType.elseIf, range: ComponentRange(sl: 6, el: 10))
    _ = elseIfComponent.makeComponent(type: .or, range: ComponentRange(sl: 6, el: 6))
    let forComponent = elseIfComponent.makeComponent(type: .for, range: ComponentRange(sl: 7, el: 9))
    _ = forComponent.makeComponent(type: .or, range: ComponentRange(sl: 7, el: 7))
    _ = forComponent.makeComponent(type: .ternary, range: ComponentRange(sl: 8, el: 8))
    let elseComponent = component.makeComponent(type: ComponentType.else, range: ComponentRange(sl: 10, el: 16))
    let switchComponent = elseComponent.makeComponent(type: .switch, range: ComponentRange(sl: 11, el: 15))
    _ = switchComponent.makeComponent(type: .case, range: ComponentRange(sl: 12, el: 12))
    _ = switchComponent.makeComponent(type: .case, range: ComponentRange(sl: 13, el: 13))
    _ = switchComponent.makeComponent(type: .case, range: ComponentRange(sl: 14, el: 14)).makeComponent(type: .if, range: ComponentRange(sl: 14, el: 14))
    let secondIfComponent = component.makeComponent(type: .if, range: ComponentRange(sl: 17, el: 19))
    _ = secondIfComponent.makeComponent(type: .emptyLines, range: ComponentRange(sl: 18, el: 18))
    return [component]
}

func componentsForDoCatchInsideIf() -> [Component] {
    let root = Component(type: .function, range: ComponentRange(sl: 2, el: 8))
    let ifComponent = root.makeComponent(type: .if, range: ComponentRange(sl: 3, el: 7))
    _ = root.makeComponent(type: .parameter, range: ComponentRange(sl: 2, el: 2))
    _ = ifComponent.makeComponent(type: .brace, range: ComponentRange(sl: 4, el: 6))
    _ = ifComponent.makeComponent(type: .brace, range: ComponentRange(sl: 6, el: 6))
    return [root]
}

func componentsForComputedProperty() -> [Component] {
    let root = Component(type: .class, range: ComponentRange(sl: 1, el: 8))
    let computedProperty = root.makeComponent(type: .function, range: ComponentRange(sl: 2, el: 4))
    _ = computedProperty.makeComponent(type: .if, range: ComponentRange(sl: 3, el: 3))
    _ = root.makeComponent(type: .variable, range: ComponentRange(sl: 5, el: 7))
    return [root]
}

func componentsForClosures() -> [Component] {
    let root = Component(type: .class, range: ComponentRange(sl: 1, el: 20))
    let var1 = root.makeComponent(type: .closure, range: ComponentRange(sl: 2, el: 4))
    _ = var1.makeComponent(type: .parameter, range: ComponentRange(sl: 2, el: 2))
    _ = root.makeComponent(type: .closure, range: ComponentRange(sl: 5, el: 5))
    let var3 = root.makeComponent(type: .closure, range: ComponentRange(sl: 6, el: 8))
    _ = var3.makeComponent(type: .parameter, range: ComponentRange(sl: 6, el: 6))
    let var4 = root.makeComponent(type: .closure, range: ComponentRange(sl: 9, el: 12))
    _ = var4.makeComponent(type: .if, range: ComponentRange(sl: 10, el: 10))
    let function = root.makeComponent(type: .function, range: ComponentRange(sl: 13, el: 19))
    _ = function.makeComponent(type: .closure, range: ComponentRange(sl: 14, el: 14))
    let var6 = function.makeComponent(type: .closure, range: ComponentRange(sl: 15, el: 17))
    _ = var6.makeComponent(type: .parameter, range: ComponentRange(sl: 15, el: 15))
    _ = var6.makeComponent(type: .parameter, range: ComponentRange(sl: 15, el: 15))
    let var7 = function.makeComponent(type: .closure, range: ComponentRange(sl: 18, el: 18))
    _ = var7.makeComponent(type: .parameter, range: ComponentRange(sl: 18, el: 18))
    _ = var7.makeComponent(type: .parameter, range: ComponentRange(sl: 18, el: 18))
    
    return [root]
}

func componentsForGettersSetters() -> [Component] {
    let root = Component(type: .class, range: ComponentRange(sl: 1, el: 14))
    let var1 = root.makeComponent(type: .function, range: ComponentRange(sl: 2, el: 8))
    _ = var1.makeComponent(type: .function, range: ComponentRange(sl: 3, el: 5), name: "get")
    let setter = var1.makeComponent(type: .function, range: ComponentRange(sl: 5, el: 8), name: "set") //Incorrect range
    _ = setter.makeComponent(type: .if, range: ComponentRange(sl: 6, el: 6))
    let var2 = root.makeComponent(type: .function, range: ComponentRange(sl: 9, el: 13))
    _ = var2.makeComponent(type: .function, range: ComponentRange(sl: 10, el: 11), name: "didSet")
    _ = var2.makeComponent(type: .function, range: ComponentRange(sl: 11, el: 13), name: "willSet") //Incorrect range
    let root2 = Component(type: .class, range: ComponentRange(sl: 15, el: 24))
    let var3 = root2.makeComponent(type: .function, range: ComponentRange(sl: 16, el: 20))
    _ = var3.makeComponent(type: .function, range: ComponentRange(sl: 17, el: 20), name: "get")
    let var4 = root2.makeComponent(type: .function, range: ComponentRange(sl: 21, el: 23))
    _ = var4.makeComponent(type: .function, range: ComponentRange(sl: 22, el: 23), name: "willSet")
    
    
    return [root, root2]
}

func componentsForBraceWithParameters() -> [Component] {
    let root = Component(type: .function, range: ComponentRange(sl: 1, el: 6))
    let var1 = root.makeComponent(type: .closure, range: ComponentRange(sl: 2, el: 5))
    _ = var1.makeComponent(type: .parameter, range: ComponentRange(sl: 2, el: 2))
    _ = var1.makeComponent(type: .if, range: ComponentRange(sl: 3, el: 3))
    return [root]
}

func componentsForClosureParameters() -> [Component] {
    let function1 = Component(type: .function, range: ComponentRange(sl: 1, el: 3))
    _ = function1.makeComponent(type: .parameter, range: ComponentRange(sl: 1, el: 1))
    _ = function1.makeComponent(type: .parameter, range: ComponentRange(sl: 1, el: 1))
    _ = function1.makeComponent(type: .parameter, range: ComponentRange(sl: 1, el: 1))
    let closure = function1.makeComponent(type: .closure, range: ComponentRange(sl: 2, el: 2))
    _ = closure.makeComponent(type: .parameter, range: ComponentRange(sl: 2, el: 2))
    _ = closure.makeComponent(type: .parameter, range: ComponentRange(sl: 2, el: 2))
    
    let function2 = Component(type: .function, range: ComponentRange(sl: 4, el: 7))
    _ = function2.makeComponent(type: .parameter, range: ComponentRange(sl: 4, el: 4))
    _ = function2.makeComponent(type: .parameter, range: ComponentRange(sl: 4, el: 4))
    _ = function2.makeComponent(type: .parameter, range: ComponentRange(sl: 4, el: 4))
    _ = function2.makeComponent(type: .closure, range: ComponentRange(sl: 5, el: 5))
    let closure2 = function2.makeComponent(type: .closure, range: ComponentRange(sl: 6, el: 6))
    _ = closure2.makeComponent(type: .parameter, range: ComponentRange(sl: 6, el: 6))

    return [function1, function2]
}

func componentsForGuard() -> [Component] {
    let function = Component(type: .function, range: ComponentRange(sl: 1, el: 3))
    _ = function.makeComponent(type: .guard, range: ComponentRange(sl: 2, el: 2))
    
    return [function]
}
