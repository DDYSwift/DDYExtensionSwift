import UIKit

public enum DDYButtonStyle: Int {
    case defaultStyle   = 0 // 默认效果(为了处理无调用状态，不可赋值)
    case imageLeft      = 1 // 左图右文
    case imageRight     = 2 // 右图左文
    case imageTop       = 3 // 上图下文
    case imageBottom    = 4 // 下图上文
}

private var enlargedKey: UInt8 = 0
private var styleKey: Void?
private var paddingKey: Void?

extension DDYWrapperProtocol where DDYT : UIButton {

    /// 扩大热区(可点击区域)
    var enlargedEdge: UIEdgeInsets {
        get {
            guard let contentEdgeInsets = objc_getAssociatedObject(ddyValue, &enlargedKey) as? UIEdgeInsets else {
                return UIEdgeInsets.zero
            }
            return contentEdgeInsets
        }
        set {
            objc_setAssociatedObject(ddyValue, &enlargedKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    /// 设置图文样式(不可逆，一旦设置不能百分百恢复系统原来样式)
    var style: DDYButtonStyle {
        get {
            guard let style = objc_getAssociatedObject(ddyValue, &styleKey) as? DDYButtonStyle else {
                return .defaultStyle
            }
            return style
        }
        set {
            objc_setAssociatedObject(ddyValue, &styleKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            ddyValue.layoutIfNeeded()
        }
    }

    var padding: CGFloat {
        get {
            guard let padding = objc_getAssociatedObject(ddyValue, &paddingKey) as? CGFloat else {
                return 0.5
            }
            return padding
        }
        set {
            objc_setAssociatedObject(ddyValue, &paddingKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            ddyValue.layoutIfNeeded()
        }
    }

    public func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        guard let color = color else {
            return
        }
        func colorImage() -> UIImage? {
            let rect = CGRect(x: 0.0, y: 0.0, width: 1, height: 1)
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            context?.setFillColor(color.cgColor)
            context?.fill(rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image ?? nil
        }
        ddyValue.setImage(colorImage(), for: state)
    }
}

extension UIButton {
    public static func ddySwizzleMethod() {
        ddySwizzle(#selector(point(inside:with:)), #selector(ddyPoint(inside:with:)), swizzleClass: self)
        ddySwizzle(#selector(layoutSubviews), #selector(ddyLayoutSubviews), swizzleClass: self)
    }

    @objc private func ddyPoint(inside point: CGPoint, with event: UIEvent?) -> Bool {

        func myABS(_ number: CGFloat) -> CGFloat {
            return CGFloat(fabsf(Float(number)))
        }
        if self.ddyPoint(inside: point, with: event) {
            return true
        } else {
            let x = self.bounds.minX - myABS(self.ddy.enlargedEdge.left)
            let y = self.bounds.minY - myABS(self.ddy.enlargedEdge.top)
            let w = self.bounds.width + myABS(self.ddy.enlargedEdge.left) + myABS(self.ddy.enlargedEdge.right)
            let h = self.bounds.height + myABS(self.ddy.enlargedEdge.top) + myABS(self.ddy.enlargedEdge.bottom)
            let rect = CGRect(x: x, y: y, width: w, height: h)
            let result = rect.contains(point)
            return result
        }
    }

    @objc private func ddyLayoutSubviews() {
        self.ddyLayoutSubviews()
        adjustRect(margin: (contentEdgeInsets.top, contentEdgeInsets.left, contentEdgeInsets.bottom, contentEdgeInsets.right))

    }

    private func adjustRect(margin:(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat)) {
        guard let imageSize = self.imageView?.frame.size, let titleSize = self.titleLabel?.frame.size else {
            return
        }
        guard imageSize != CGSize.zero && titleSize != CGSize.zero else {
            return
        }
        func horizontal(_ leftView: UIView,_ rightView: UIView) {
            let contentW = leftView.frame.width + self.ddy.padding + rightView.frame.width
            let contentH = max(leftView.frame.height, rightView.frame.height)
            let leftOrigin = CGPoint(x: margin.left, y: (contentH-leftView.frame.height)/2.0 + margin.top)
            let rightOrigin = CGPoint(x: margin.left + leftView.frame.width + self.ddy.padding, y: (contentH-rightView.frame.height)/2.0 + margin.top)

            self.bounds = CGRect(x: 0, y: 0, width: contentW + margin.left + margin.right, height: contentH + margin.top + margin.bottom)
            leftView.frame = CGRect(origin: leftOrigin, size: leftView.frame.size)
            rightView.frame = CGRect(origin: rightOrigin, size: rightView.frame.size)
        }
        func vertical(_ topView: UIView,_ bottomView: UIView,_ backSize: CGSize) {
            let contentW = max(max(topView.frame.width, bottomView.frame.width), backSize.width-margin.left-margin.right)
            let contentH = max(topView.frame.height + self.ddy.padding + bottomView.frame.height, backSize.height-margin.top-margin.bottom)
            let topOrigin = CGPoint(x: (contentW-topView.frame.width)/2.0 + margin.left, y: margin.top)
            let bottomOrigin = CGPoint(x: (contentW-bottomView.frame.width)/2.0 + margin.left, y: margin.top + topView.frame.height + self.ddy.padding)

            self.bounds = CGRect(x: 0, y: 0, width: contentW + margin.left + margin.right, height: contentH + margin.top + margin.bottom)
            topView.frame = CGRect(origin: topOrigin, size: topView.frame.size)
            bottomView.frame = CGRect(origin: bottomOrigin, size: bottomView.frame.size)
            print("layout: \(self.bounds) \(topView.frame) \(bottomView.frame)")
        }

        print("0000: \(self.bounds) \(self.imageView!.frame) \(self.titleLabel!.frame)")
        titleLabel?.sizeToFit()
        switch self.ddy.style {
        case .imageLeft: horizontal(self.imageView!, self.titleLabel!)
        case .imageRight: horizontal(self.titleLabel!, self.imageView!)
        case .imageTop: vertical(self.imageView!, self.titleLabel!, self.frame.size)
        case .imageBottom: vertical(self.titleLabel!, self.imageView!, self.frame.size)
        default: return
        }
    }
}
