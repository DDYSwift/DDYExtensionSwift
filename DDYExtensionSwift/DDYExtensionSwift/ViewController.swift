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
}

