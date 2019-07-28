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

extension UILabel {
    public static func ddySwizzleMethod() {
        ddySwizzle(#selector(UILabel.textRect(forBounds:limitedToNumberOfLines:)), #selector(ddyTextRect(_:_:)), swizzleClass: self)
        ddySwizzle(#selector(UILabel.drawText(in:)), #selector(ddyDrawText(in:)), swizzleClass: self)
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



