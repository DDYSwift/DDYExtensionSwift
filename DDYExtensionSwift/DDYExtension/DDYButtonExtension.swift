import UIKit

public enum DDYButtonStyle: Int {
    case imageLeft      = 1 // 左图右文
    case imageRight     = 2 // 右图左文
    case imageTop       = 3 // 上图下文
    case imageBottom    = 4 // 下图上文
}

private var styleKey: Void?
private var paddingKey: Void?

extension DDYWrapperProtocol where DDYT : UIButton {

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


final class DDYButton: UIButton {
    /// 布局样式
    var style: DDYButtonStyle = .imageLeft
    /// 图文间距
    var padding: CGFloat = 0.5

    override func layoutSubviews() {
        super.layoutSubviews()
        adjustRect(margin: (contentEdgeInsets.top, contentEdgeInsets.left, contentEdgeInsets.bottom, contentEdgeInsets.right))
    }

    private func adjustRect(margin:(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat)) {
        guard let imageSize = imageView?.frame.size, let titleSize = titleLabel?.frame.size else {
            return
        }
        guard imageSize != CGSize.zero && titleSize != CGSize.zero else {
            return
        }
        func horizontal(_ leftView: UIView,_ rightView: UIView) {
            let contentW = max(leftView.frame.width + padding + rightView.frame.width, frame.width-margin.left-margin.right)
            let contentH = max(max(leftView.frame.height, rightView.frame.height), frame.height-margin.top-margin.bottom)
            let leftOrigin = CGPoint(x: margin.left, y: (contentH-leftView.frame.height)/2.0 + margin.top)
            let rightOrigin = CGPoint(x: margin.left + leftView.frame.width + padding, y: (contentH-rightView.frame.height)/2.0 + margin.top)

            bounds = CGRect(x: 0, y: 0, width: contentW + margin.left + margin.right, height: contentH + margin.top + margin.bottom)
            leftView.frame = CGRect(origin: leftOrigin, size: leftView.frame.size)
            rightView.frame = CGRect(origin: rightOrigin, size: rightView.frame.size)
        }
        func vertical(_ topView: UIView,_ bottomView: UIView) {
            let contentW = max(max(topView.frame.width, bottomView.frame.width), frame.width-margin.left-margin.right)
            let contentH = max(topView.frame.height + padding + bottomView.frame.height, frame.height-margin.top-margin.bottom)
            let topOrigin = CGPoint(x: (contentW-topView.frame.width)/2.0 + margin.left, y: margin.top)
            let bottomOrigin = CGPoint(x: (contentW-bottomView.frame.width)/2.0 + margin.left, y: margin.top + topView.frame.height + padding)

            bounds = CGRect(x: 0, y: 0, width: contentW + margin.left + margin.right, height: contentH + margin.top + margin.bottom)
            topView.frame = CGRect(origin: topOrigin, size: topView.frame.size)
            bottomView.frame = CGRect(origin: bottomOrigin, size: bottomView.frame.size)
        }

        titleLabel?.sizeToFit()
        switch style {
        case .imageLeft: horizontal(imageView!, titleLabel!)
        case .imageRight: horizontal(titleLabel!, imageView!)
        case .imageTop: vertical(imageView!, titleLabel!)
        case .imageBottom: vertical(titleLabel!, imageView!)
        }
        print("\(bounds) \(titleLabel!.frame) \(imageView!.frame)")
    }
}
