// UILabel扩展


import UIKit

private var contentEdgeInsetsKey: Void?

extension DDYWrapperProtocol where DDYT : UILabel {

    var contentEdgeInsets: UIEdgeInsets {
        get {
            guard let contentEdgeInsets = objc_getAssociatedObject(ddyValue, &contentEdgeInsetsKey) as? UIEdgeInsets else {
                return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            }
            return contentEdgeInsets
        }
        set {
            objc_setAssociatedObject(ddyValue, &contentEdgeInsetsKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}

private var shimmerKey: UInt8 = 0
extension UILabel {
    public static func ddySwizzleMethod() {
        ddySwizzle(#selector(UILabel.textRect(forBounds:limitedToNumberOfLines:)), #selector(ddyTextRect(_:_:)), swizzleClass: self)
        ddySwizzle(#selector(UILabel.drawText(in:)), #selector(ddyDrawText(in:)), swizzleClass: self)
        ddySwizzle(#selector(layoutSubviews), #selector(ddyLayoutSubviews), swizzleClass: self)
    }

    @objc private func ddyTextRect(_ bounds: CGRect,_ numberOfLines: Int) -> CGRect {
        var rect = self.ddyTextRect(bounds.inset(by: self.ddy.contentEdgeInsets), numberOfLines)
        rect.origin.x -= self.ddy.contentEdgeInsets.left;
        rect.origin.y -= self.ddy.contentEdgeInsets.top;
        rect.size.width += self.ddy.contentEdgeInsets.left + self.ddy.contentEdgeInsets.right;
        rect.size.height += self.ddy.contentEdgeInsets.top + self.ddy.contentEdgeInsets.bottom;
        return rect
    }
    
    @objc private func ddyDrawText(in rect: CGRect) {
        self.ddyDrawText(in: rect.inset(by: self.ddy.contentEdgeInsets))
    }
    
    private var shimmerLayer: CAGradientLayer {
        get {
            if let tempLayer = objc_getAssociatedObject(self, &shimmerKey) as? CAGradientLayer {
                return tempLayer
            } else {
                let tempLayer = CAGradientLayer()
                objc_setAssociatedObject(self, &shimmerKey, tempLayer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return tempLayer
            }
        }
        set { objc_setAssociatedObject(self, &shimmerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func startAnimate() {
        shimmerLayer.colors = [UIColor.clear.cgColor,UIColor.white.cgColor,UIColor.clear.cgColor,]
        shimmerLayer.locations = [0, 0.5, 1]
        layer.mask = shimmerLayer
        addAnimation()
    }
    
    @objc private func ddyLayoutSubviews() {
        //ddyLayoutSubviews()
        layer.mask?.frame = self.frame
        addAnimation()
    }
    
    private func addAnimation() {
        shimmerLayer.removeAllAnimations()
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -self.frame.size.width
        animation.toValue = self.frame.size.width
        animation.duration = 5.0
        animation.repeatCount = .infinity
        shimmerLayer.add(animation, forKey: "animationKey")
    }
}


extension UILabel {
    /// 便利构造器
    convenience init(text: String, font: UIFont = UIFont.systemFont(ofSize: 12), textAlignment: NSTextAlignment = .center, numberOfLines: Int = 0) {
        self.init()
        self.text = text
        self.font = font
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}



