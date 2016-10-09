//
//  DebugExt.swift
//  sdyd
//
//  Created by DKJone on 16/9/28.
//  Copyright © 2016年 milanosoft. All rights reserved.
//

import Foundation
import UIKit
let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
#if DEBUG
    extension AppDelegate {
        func showDeBugExt() {
            assistiveTouch = AssistiveTouch(frame: CGRect(x: ScreenWidth - 100, y: ScreenHeight - 120, width: 60, height: 60))
            // showMessage("调试工具已打开")
            window!.makeKeyAndVisible()
        }
    }
#endif

/// 全局浮动视图，用于显示测试工具
class AssistiveTouch: UIWindow {
    let btn = UIButton(type: .custom)
    let bgView = UIView()
    let operatView = UIView()
    var lastFrame = CGRect.zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.windowLevel = UIWindowLevelAlert + 1
        // 先显示
        self.makeKeyAndVisible()
        self.backgroundColor = UIColor.clear
        let img = drawImg()
        btn.setImage(img, for: UIControlState())
        btn.setImage(img, for: UIControlState())
        btn.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        let frameHight = (ScreenWidth < ScreenHeight ? ScreenWidth : ScreenHeight) - 100
        operatView.frame = CGRect(x: 0, y: 0, width: frameHight, height: frameHight)

        operatView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        operatView.layer.cornerRadius = 15
        operatView.layer.masksToBounds = true
        bgView.frame = UIScreen.main.bounds
        operatView.center = bgView.center
        bgView.backgroundColor = UIColor.clear
        bgView.isHidden = true
        operatView.isHidden = true
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
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
    func changePostion(_ pan: UIPanGestureRecognizer) {
        let point = pan.translation(in: self)
        var originalFrame = frame
        if (originalFrame.origin.x > 0 && originalFrame.origin.x + originalFrame.size.width <= ScreenWidth) {
            originalFrame.origin.x += point.x
        }
        if (originalFrame.origin.y > 0 && originalFrame.origin.y + originalFrame.size.height <= ScreenHeight) {
            originalFrame.origin.y += point.y;
        }
        self.frame = originalFrame
        pan.setTranslation(CGPoint.zero, in: self)

        if (pan.state == .began) {
            btn.isEnabled = false
        } else if (pan.state == .changed) {

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
                UIView.animate(withDuration: 0.3, animations: {
                    self.frame = frame
                })
            }
            btn.isEnabled = true
        }
    }
    func bgClicked() {
        bgView.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.operatView.frame = self.lastFrame
            }, completion: { (isEnd) in
            self.btn.isHidden = !isEnd
            self.operatView.isHidden = isEnd
            self.frame = self.lastFrame
        })
    }
    /**
     按钮点击弹出设置选项
     */
    func btnClick() {

        lastFrame = frame
        operatView.frame = frame
        self.frame = UIScreen.main.bounds
        btn.isHidden = true
        bgView.isHidden = false
        operatView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            let frameHight = (ScreenWidth < ScreenHeight ? ScreenWidth : ScreenHeight) - 100
            self.operatView.frame = CGRect(x: 0, y: 0, width: frameHight, height: frameHight)
            self.operatView.center = self.center
            }, completion: { (isEnd) in })
    }

    /**
     绘制AsstisTouch 图片
     
     - returns: AssistiveTouch图
     */
    func drawImg() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 100, height: 100))
        let ctx = UIGraphicsGetCurrentContext()
        ctx!.addRect(CGRect(x: 0, y: 0, width: 100, height: 100))
        UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).set()
        ctx!.fillPath()
        var r = 48 // 半径
        // 根据半径获取圆的frame
        var frame: CGRect {
            return CGRect(x: 50 - r, y: 50 - r, width: r * 2, height: r * 2)
        }
        for _ in 1...3 {
            r -= 8
            ctx!.addEllipse(in: frame)
            UIColor(white: 1, alpha: 0.5).set()
            ctx!.fillPath()
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
        backItem.backgroundColor = UIColor.clear
        backItem.setAttributedTitle(NSAttributedString(string: "➪", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: 40)!]), for: UIControlState())
        backItem.addTarget(self, action: #selector(bgClicked), for: .touchUpInside)
        operatView.addSubview(backItem)
        // 隐藏按钮
        let itemText = [
            "隐藏调\n试工具", "切换\n服务器", "❀",
            "✋", "4", "⑤",
            "⑥", "结束\n烟火", "放\n烟花"]
        for i in 0...8 {
            if (i == 4) { continue }
            itemIndex = i
            let Item1 = UIButton(frame: itemFrame)
            Item1.titleLabel?.numberOfLines = 0
            Item1.titleLabel?.textAlignment = .center
            Item1.tag = itemIndex
            Item1.backgroundColor = UIColor.clear
            Item1.setAttributedTitle(NSAttributedString(string: itemText[i], attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: 17)!]), for: UIControlState())
            Item1.addTarget(self, action: #selector(itemClick), for: .touchUpInside)
            operatView.addSubview(Item1)
        }
    }

    /**
     more function
     
     - parameter sender: itembtn
     */
    func itemClick(_ sender: UIButton) {
        sender.tag == 0 ? self.isHidden = true: ()
        switch sender.tag {
        case 8:
            bgClicked()
            self.showAnimation()
        case 7:
            bgView.backgroundColor = UIColor.clear
            layerView.removeFromSuperview()
            caLayer.removeFromSuperlayer()
        default:
            break
        }
        print("item\(sender.tag)Click")
    }

    // 烟花动画层
    let layerView = UIView(frame: UIScreen.main.bounds)
    let caLayer: CAEmitterLayer = CAEmitterLayer()
    func showAnimation() {

        // 发射源
        caLayer.emitterPosition = CGPoint(x: ScreenWidth / 2, y: ScreenHeight - 50)
        caLayer.emitterSize = CGSize(width: 50, height: 0)
        caLayer.emitterMode = kCAEmitterLayerOutline
        caLayer.emitterShape = kCAEmitterLayerLine
        // 渲染模式
        caLayer.renderMode = kCAEmitterLayerAdditive
        caLayer.velocity = 1
        caLayer.speed = Float((arc4random() % 100)) / 100 + 1
        let cell = CAEmitterCell()
        cell.birthRate = 1
        // 发射的角度🚀
        cell.emissionRange = 0.11 * CGFloat(M_PI)
        cell.velocity = 300
        cell.velocityRange = 150
        cell.yAcceleration = 75
        cell.lifetime = 2.04
        cell.contents = #imageLiteral(resourceName: "FFRing.png").cgImage
        cell.scale = 0.2
        cell.color = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        cell.greenRange = 1.0
        cell.redRange = 1
        cell.blueRange = 1
        cell.spin = CGFloat(M_PI)
        // 爆炸效果💥
        let burst = CAEmitterCell()
        burst.birthRate = 1
        burst.velocity = 0
        burst.scale = 2.5
        burst.redSpeed = -1.5
        burst.blueSpeed = 1.5
        burst.greenSpeed = 1
        burst.lifetime = 0.35
        // 火花🔥
        let spark = CAEmitterCell()
        spark.birthRate = 400
        spark.velocity = 125
        spark.emissionRange = 2 * CGFloat(M_PI)
        spark.yAcceleration = 75
        spark.lifetime = 3
        spark.contents = #imageLiteral(resourceName: "FFTspark.png").cgImage
        spark.scaleSpeed = -0.2
        spark.greenSpeed = -0.1
        spark.redSpeed = 0.4
        spark.blueSpeed = -0.1
        spark.alphaSpeed = -0.25
        spark.spin = 2 * CGFloat(M_PI)
        spark.spinRange = 2 * CGFloat(M_PI)
        caLayer.emitterCells = [cell]
        cell.emitterCells = [burst]
        burst.emitterCells = [spark]
        layerView.backgroundColor = UIColor.black
        layerView.layer.addSublayer(caLayer)
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(layerView)
    }
}
