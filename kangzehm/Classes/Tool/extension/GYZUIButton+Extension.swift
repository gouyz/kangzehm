//
//  GYZUIButton+Extension.swift
//  baking
//
//  Created by gouyz on 2017/3/23.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    /// 方便快速的设置图片和文字的相对位置
    ///
    /// - Parameters:
    ///   - anImage: 图片
    ///   - title: 标题
    ///   - titlePosition: 文字位置
    ///   - additionalSpacing: 间距
    ///   - state: 按钮状态
    func set(image anImage: UIImage?, title: String,
                   titlePosition: UIViewContentMode, additionalSpacing: CGFloat, state: UIControlState){
        self.imageView?.contentMode = .center
        self.setImage(anImage, for: state)
        
        positionLabelRespectToImage(title: title, position: titlePosition, spacing: additionalSpacing)
        
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: state)
    }
    
    private func positionLabelRespectToImage(title: String, position: UIViewContentMode,
                                             spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title.size(withAttributes: [NSAttributedStringKey.font: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(titleSize.height + spacing)/2,
                                       left: -(imageSize.width)/2, bottom: (titleSize.height + spacing)/2, right: (imageSize.width)/2)
            imageInsets = UIEdgeInsets(top: (imageSize.height + spacing)/2, left: titleSize.width/2, bottom: -(imageSize.height + spacing)/2, right: -titleSize.width/2)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (titleSize.height + spacing)/2,
                                       left: -imageSize.width, bottom: -(titleSize.height + spacing)/2, right: 0)
            imageInsets = UIEdgeInsets(top: -(imageSize.height + spacing)/2, left: 0, bottom: (imageSize.height + spacing)/2, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width + spacing), bottom: 0, right: imageSize.width + spacing)
            imageInsets = UIEdgeInsets(top: 0, left: (titleSize.width + spacing), bottom: 0,
                                       right: -(titleSize.width + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
    
    /// 倒计时
    ///
    /// - Parameter duration: 倒计时时间
    func startSMSWithDuration(duration:Int){
        var times = duration
        
        let timer:DispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.global())
        
        timer.setEventHandler {
            if times > 0{
                DispatchQueue.main.async(execute: {
                    self.isEnabled = false
                    self.setTitle("剩余\(times)s", for: .disabled)
                    self.backgroundColor = kBtnNoClickBGColor
                    
                    times -= 1
                })
            } else{
                DispatchQueue.main.async(execute: {
                    self.isEnabled = true
                    self.backgroundColor = kBtnClickBGColor
                    timer.cancel()
                })
            }
        }
        
        // timer.scheduleOneshot(deadline: .now())
        timer.schedule(deadline: .now(), repeating: .seconds(1), leeway: .milliseconds(100))
        
        timer.resume()
        
        // 在调用DispatchSourceTimer时, 无论设置timer.scheduleOneshot, 还是timer.scheduleRepeating代码 不调用cancel(), 系统会自动调用
        // 另外需要设置全局变量引用, 否则不会调用事件
    }
}
