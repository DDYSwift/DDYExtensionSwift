import UIKit

// MARK:- 命名空间
// extension DDYWrapperProtocol where DDYT : UIView
// extension DDYWrapperProtocol where DDYT == String
// 值类型(结构体String/Array/Dictionary等)用 ==
// 引用类型(类)用 == 和 : 都可以，但 == 只对本类生效，子类无效
public protocol DDYNameSpaceProtocol {
    associatedtype DDYT
    var ddy: DDYT { get set }
    static var ddy: DDYT.Type { get }
}

public protocol DDYWrapperProtocol {
    associatedtype DDYT
    var ddyValue: DDYT { get }
    init(value: DDYT)
}

public struct DDYNameSpaceWrapper<T>: DDYWrapperProtocol {
    public let ddyValue: T
    public init(value: T) {
        self.ddyValue = value
    }
}

public extension DDYNameSpaceProtocol {
    var ddy: DDYNameSpaceWrapper<Self> {
        get {
            return DDYNameSpaceWrapper.init(value: self)
        }
        set {

        }
    }

    static var ddy: DDYNameSpaceWrapper<Self>.Type {
        return DDYNameSpaceWrapper.self
    }
}

public func ddySwizzle(_ oldSel: Selector,_ newSel: Selector, swizzleClass: AnyClass) {
    guard let m1 = class_getInstanceMethod(swizzleClass, oldSel) else {
        return
    }
    guard let m2 = class_getInstanceMethod(swizzleClass, newSel) else {
        return
    }

    if (class_addMethod(swizzleClass, newSel, method_getImplementation(m2), method_getTypeEncoding(m2))) {
        class_replaceMethod(swizzleClass, newSel, method_getImplementation(m1), method_getTypeEncoding(m1))
    } else {
        method_exchangeImplementations(m1, m2)
    }
}

public func swizzleAllRegistedMethodWhenDidFinishLaunching() {
    UILabel.ddySwizzleMethod()
    UIButton.ddySwizzleMethod() 
}
