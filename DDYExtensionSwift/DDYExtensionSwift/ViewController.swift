//
//  ViewController.swift
//  DDYExtensionSwift
//
//  Created by ddy on 2019/7/28.
//  Copyright © 2019 SmartMeshFoundation. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // swizzleAllRegistedMethodWhenDidFinishLaunching()
        testExtensionLabel()
        testExtentsionView()
        testStringRange()
        testExtensionButton()
        testImageView()
    }

    private func testImageView() {
        var images:[UIImage]! = []
        images.append(colorImage(UIColor.red, 50, 50)!)
        images.append(colorImage(UIColor.black, 50, 50)!)
        images.append(colorImage(UIColor.blue, 50, 50)!)
        images.append(colorImage(UIColor.green, 50, 50)!)
        images.append(colorImage(UIColor.yellow, 50, 50)!)

        let imageView = UIImageView()
        imageView.animationImages = images
        imageView.animationRepeatCount = 0
        imageView.animationDuration = 5 * 0.5
        imageView.startAnimating()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp_left).offset(10)
            make.top.equalTo(view.snp_top).offset(180)
            make.width.height.equalTo(50)
        }
    }

    private func testExtensionButton() {

        var button1 = UIButton(type: .custom)
        button1.setImage(colorImage(UIColor.blue, 25, 25), for: .normal)
        button1.setTitle("8899", for: .normal)
        button1.backgroundColor = UIColor.lightGray
        button1.ddy.style = .imageRight
        button1.ddy.padding = 5
        button1.contentEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 30)
        button1.setTitleShadowColor(UIColor.red, for: .normal)
        button1.titleLabel?.shadowOffset = CGSize(width: -1.5, height: -1.5)
        button1.titleLabel?.font = UIFont(name: "Zapfino", size: 13)
//        button1.addTarget(self, action: #selector(handleTap), for: UIControl.Event.touchUpInside)
//        button1.setImage(UIImage(named:"icon")?.withRenderingMode(.alwaysOriginal), for:.normal)
        view.addSubview(button1)
        button1.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp_left).offset(200)
            make.top.equalTo(view.snp_top).offset(70)
        }
    }

    private func testStringRange() {
        let allStr = "1234567890"
        let subStr = "456"
        let ranges = allStr.ddy.nsranges(of: subStr)
        print("\(ranges)")
    }

    private func testExtensionLabel() {
        // 便利构造器
        var label = UILabel(text: "TestConvenienceLabel1234567890", font: UIFont.systemFont(ofSize: 12), numberOfLines: 0)
        label.backgroundColor = UIColor.lightGray
        label.shadowColor = UIColor.red
        label.shadowOffset = CGSize(width: 1.5, height: 1.5)
        // 扩展 内边距(因为扩展属性，用到setter，所以var声明变量)
        label.ddy.contentEdgeInsets = UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp_left).offset(10)
            make.top.equalTo(view.snp_top).offset(70)
            make.width.lessThanOrEqualTo(70)
        }
    }
    
    private func testExtentsionView() {
        var customView = UIView(frame: CGRect(x: 90, y: 140, width: 100, height: 100))
        customView.ddy.y = 70
        customView.ddy.tapGesture(self, #selector(testTap(_:)))
        customView.ddy.partRadius([.bottomLeft, .bottomRight], 8)
        customView.backgroundColor = UIColor.red
        view.addSubview(customView)
    }

    @objc func testTap(_ tap: UIGestureRecognizer) {
        print("\(tap)")
    }

    private func colorImage(_ color: UIColor,_ width: CGFloat,_ height: CGFloat) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? nil
    }
}

