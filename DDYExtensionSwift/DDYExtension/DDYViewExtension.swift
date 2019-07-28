// UIView扩展


import UIKit

extension UIView: DDYNameSpaceProtocol { }

extension DDYWrapperProtocol where DDYT : UIView {
    // MARK:- 布局
    var x: CGFloat {
        get {
            return ddyValue.frame.origin.x
        }
        set {
            var frame = ddyValue.frame
            frame.origin.x = newValue
            ddyValue.frame = frame
        }
    }

    var y: CGFloat {
        get {
            return ddyValue.frame.origin.y
        }
        set {
            var frame = ddyValue.frame
            frame.origin.y = newValue
            ddyValue.frame = frame
        }
    }

    var w: CGFloat {
        get {
            return ddyValue.frame.size.width
        }
        set {
            var frame = ddyValue.frame
            frame.size.width = newValue
            ddyValue.frame = frame
        }
    }

    var h: CGFloat {
        get {
            return ddyValue.frame.size.height
        }
        set {
            var frame = ddyValue.frame
            frame.size.height = newValue
            ddyValue.frame = frame
        }
    }

    var centerX: CGFloat {
        get {
            return ddyValue.center.x
        }
        set {
            var center = ddyValue.center
            center.x = newValue
            ddyValue.center = center
        }
    }

    var centerY: CGFloat {
        get {
            return ddyValue.center.y
        }
        set {
            var center = ddyValue.center
            center.y = newValue
            ddyValue.center = center
        }
    }

    var left: CGFloat {
        get {
            return ddyValue.frame.origin.x
        }
        set {
            var frame = ddyValue.frame
            frame.origin.x = newValue
            ddyValue.frame = frame
        }
    }

    var top: CGFloat {
        get {
            return ddyValue.frame.origin.y
        }
        set {
            var frame = ddyValue.frame
            frame.origin.y = newValue
            ddyValue.frame = frame
        }
    }

    var right: CGFloat {
        get {
            return ddyValue.frame.origin.x + ddyValue.frame.size.width
        }
        set {
            var frame = ddyValue.frame
            frame.origin.x = newValue - frame.size.width
            ddyValue.frame = frame
        }
    }

    var bottom: CGFloat {
        get {
            return ddyValue.frame.origin.y + ddyValue.frame.size.height
        }
        set {
            var frame = ddyValue.frame
            frame.origin.y = newValue - frame.size.height
            ddyValue.frame = frame
        }
    }

    var size: CGSize {
        get {
            return ddyValue.frame.size
        }
        set {
            var frame = ddyValue.frame
            frame.size = newValue
            ddyValue.frame = frame
        }
    }

    var origin: CGPoint {
        get {
            return ddyValue.frame.origin
        }
        set {
            var frame = ddyValue.frame
            frame.origin = newValue
            ddyValue.frame = frame
        }
    }

    // MARK:- 手势
    /// 点击手势(默认代理和target相同)
    public func tapGesture(_ target: Any?,_ action: Selector,_ numberOfTapsRequired: Int = 1) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        tapGesture.numberOfTapsRequired = numberOfTapsRequired
        tapGesture.delegate = target as? UIGestureRecognizerDelegate
        ddyValue.isUserInteractionEnabled = true
        ddyValue.addGestureRecognizer(tapGesture)
    }

    /// 长按手势(默认代理和target相同)
    public func longGesture(_ target: Any?,_ action: Selector,_ minDuration: TimeInterval = 0.5) {
        let longGesture = UILongPressGestureRecognizer(target: target, action: action)
        longGesture.minimumPressDuration = minDuration
        longGesture.delegate = target as? UIGestureRecognizerDelegate
        ddyValue.isUserInteractionEnabled = true
        ddyValue.addGestureRecognizer(longGesture)
    }

    /// 圆角与边线
    public func borderRadius(_ radius: CGFloat,_ masksToBounds: Bool,_ borderWidth: CGFloat = 0,_ borderColor: UIColor = UIColor.clear) {
        ddyValue.layer.borderWidth = borderWidth
        ddyValue.layer.borderColor =  borderColor.cgColor
        ddyValue.layer.cornerRadius = radius
        ddyValue.layer.masksToBounds = masksToBounds
    }
    /// 部分圆角
    public func partRadius(_ corners: UIRectCorner,_ radius: CGFloat) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = ddyValue.bounds
        shapeLayer.path = UIBezierPath(roundedRect: ddyValue.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        ddyValue.layer.mask = shapeLayer
    }

    /// 移除所有子视图
    public func removeAllChildView() {
        if ddyValue.subviews.count>0 {
            var result = ddyValue.subviews.map { $0.removeFromSuperview() }
            if result.count > 0 {
                result.removeAll()
            }
        }
    }
}

/**
 如果要使用属性写操作(setter)，务必用var声明变量
 var view = UIView()
 view.ddy.x = 1 // setter
 print("\(view.ddy.x)") // getter

 view.ddy.removeAllChildView()
 */
