//
//  DebugExt.swift
//  sdyd
//
//  Created by DKJone on 16/9/28.
//  Copyright © 2016年 milanosoft. All rights reserved.
//

import Foundation
import UIKit
let ScreenWidth = UIScreen.mainScreen().bounds.size.width
let ScreenHeight = UIScreen.mainScreen().bounds.size.height
let DebugExt = true
extension AppDelegate {
    func showDeBugExt() {
        if DebugExt {
            assistiveTouch = AssistiveTouch(frame: CGRect(x: ScreenWidth - 100, y: ScreenHeight - 120, width: 60, height: 60))
            // showMessage("调试工具已打开")
            window!.makeKeyAndVisible()
        }
    }
}

/// 全局浮动视图，用于显示测试工具
class AssistiveTouch: UIWindow {
    let btn = UIButton(type: .Custom)
    let bgView = UIView()
    let operatView = UIView()
    var lastFrame = CGRectZero

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.windowLevel = UIWindowLevelAlert + 1
        // 先显示
        self.makeKeyAndVisible()
        self.backgroundColor = UIColor.clearColor()
        let img = drawImg()
        btn.setImage(img, forState: .Normal)
        btn.setImage(img, forState: .Normal)
        btn.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        let frameHight = (ScreenWidth < ScreenHeight ? ScreenWidth : ScreenHeight) - 100
        operatView.frame = CGRect(x: 0, y: 0, width: frameHight, height: frameHight)

        operatView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        operatView.layer.cornerRadius = 15
        operatView.layer.masksToBounds = true
        bgView.frame = UIScreen.mainScreen().bounds
        operatView.center = bgView.center
        bgView.backgroundColor = UIColor.clearColor()
        bgView.hidden = true
        operatView.hidden = true
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(btnClick), forControlEvents: .TouchUpInside)
        let panGuestrue = UIPanGestureRecognizer(target: self, action: #selector(changePostion))
        btn.addGestureRecognizer(panGuestrue)
        let tapGuestrue = UITapGestureRecognizer(target: self, action: #selector(bgClicked))
        bgView.addGestureRecognizer(tapGuestrue)
        self.addSubview(bgView)
        self.addSubview(operatView)
        self.addSubview(btn)
        setupOperatcions()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     调整视图位置
     
     - parameter pan: panGuestrue
     */
    func changePostion(pan: UIPanGestureRecognizer) {
        let point = pan.translationInView(self)
        var originalFrame = frame
        if (originalFrame.origin.x > 0 && originalFrame.origin.x + originalFrame.size.width <= ScreenWidth) {
            originalFrame.origin.x += point.x
        }
        if (originalFrame.origin.y > 0 && originalFrame.origin.y + originalFrame.size.height <= ScreenHeight) {
            originalFrame.origin.y += point.y;
        }
        self.frame = originalFrame
        pan.setTranslation(CGPointZero, inView: self)

        if (pan.state == .Began) {
            btn.enabled = false
        } else if (pan.state == .Changed) {

        } else {
            var frame = self.frame
            // 记录是否越界
            var isOver = false

            if (frame.origin.x <= 0) {
                frame.origin.x = 1;
                isOver = true
            } else if (frame.origin.x + frame.size.width > ScreenWidth) {
                frame.origin.x = ScreenWidth - frame.size.width
                isOver = true
            }
            if (frame.origin.y <= 0) {
                frame.origin.y = 1
                isOver = true
            } else if (frame.origin.y + frame.size.height > ScreenHeight) {
                frame.origin.y = ScreenHeight - frame.size.height
                isOver = true
            }
            if (isOver) {
                UIView.animateWithDuration(0.3, animations: {
                    self.frame = frame
                })
            }
            btn.enabled = true
        }
    }
    func bgClicked() {
        bgView.hidden = true
        UIView.animateWithDuration(0.3, animations: {
            self.operatView.frame = self.lastFrame
        }) { (isEnd) in
            self.btn.hidden = !isEnd
            self.operatView.hidden = isEnd
            self.frame = self.lastFrame
        }
    }
    /**
     按钮点击弹出设置选项
     */
    func btnClick() {

        lastFrame = frame
        operatView.frame = frame
        self.frame = UIScreen.mainScreen().bounds
        btn.hidden = true
        bgView.hidden = false
        operatView.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            let frameHight = (ScreenWidth < ScreenHeight ? ScreenWidth : ScreenHeight) - 100
            self.operatView.frame = CGRect(x: 0, y: 0, width: frameHight, height: frameHight)
            self.operatView.center = self.center
        }) { (isEnd) in }
    }

    /**
     绘制AsstisTouch 图片
     
     - returns: AssistiveTouch图
     */
    func drawImg() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 100, height: 100))
        let ctx = UIGraphicsGetCurrentContext()
        CGContextAddRect(ctx!, CGRect(x: 0, y: 0, width: 100, height: 100))
        UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).set()
        CGContextFillPath(ctx!)
        var r = 48 // 半径
        // 根据半径获取圆的frame
        var frame: CGRect {
            return CGRect(x: 50 - r, y: 50 - r, width: r * 2, height: r * 2)
        }
        for _ in 1...3 {
            r -= 8
            CGContextAddEllipseInRect(ctx!, frame)
            UIColor(white: 1, alpha: 0.5).set()
            CGContextFillPath(ctx!)
        }

        let img = UIGraphicsGetImageFromCurrentImageContext()

        return img!
    }
    /**
     设置具体的操作
     */
    func setupOperatcions () {
        // 0~8
        var itemIndex = 4
        // 返回按钮
        let frameHight = ((ScreenWidth < ScreenHeight ? ScreenWidth : ScreenHeight) - 100) / 3
        var itemFrame: CGRect {
            return CGRect(
                x: CGFloat(itemIndex % 3) * frameHight,
                y: CGFloat(itemIndex / 3) * frameHight,
                width: frameHight, height: frameHight) }
        let backItem = UIButton(frame: itemFrame)
        backItem.backgroundColor = UIColor.clearColor()
        backItem.setAttributedTitle(NSAttributedString(string: "➪", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: 40)!]), forState: .Normal)
        backItem.addTarget(self, action: #selector(bgClicked), forControlEvents: .TouchUpInside)
        operatView.addSubview(backItem)
        // 隐藏按钮
        let itemText = [
            "隐藏调\n试工具", "切换\n服务器", "❀",
            "✋", "4", "⑤",
            "⑥", "⑦", "⑧"]
        for i in 0...8 {
            if (i == 4) { continue }
            itemIndex = i
            let Item1 = UIButton(frame: itemFrame)
            Item1.titleLabel?.numberOfLines = 0
            Item1.titleLabel?.textAlignment = .Center
            Item1.tag = itemIndex
            Item1.backgroundColor = UIColor.clearColor()
            Item1.setAttributedTitle(NSAttributedString(string: itemText[i], attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: 17)!]), forState: .Normal)
            Item1.addTarget(self, action: #selector(itemClick), forControlEvents: .TouchUpInside)
            operatView.addSubview(Item1)
        }
    }

    func itemClick(sender: UIButton) {
        sender.tag == 1 ? self.hidden = true: ()
        print("item\(sender.tag)Click")
    }
}
