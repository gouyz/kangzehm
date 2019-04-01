//
//  MBProgressHUD+Extension.swift
//  LazyHuiSellers
//  对MBProgressHUD扩展封装
//  Created by gouyz on 2017/2/4.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import Foundation
import MBProgressHUD

extension MBProgressHUD{
    
    /// 文字+菊花提示,不自动消失
    ///
    /// - Parameters:
    ///   - message: 要显示的文字
    ///   - toView: 要添加的View
    /// - Returns:
    static func showHUD(message : String,toView : UIView? = nil) -> MBProgressHUD{
        
        var view = toView
        if view == nil{
            view = KeyWindow
        }
        // 快速显示一个提示信息
        let hud = MBProgressHUD.showAdded(to: view!, animated: true)
        hud.label.text = message
        
        return hud
    }
    
    /// 纯文字提示,自动消失
    ///
    /// - Parameters:
    ///   - message: 要显示的文字
    ///   - toView: 要添加的View
    static func showAutoDismissHUD(message : String,toView : UIView? = nil,isBottom: Bool = true){
        MBProgressHUD.showMessageHUD(message: message, time: 2.0, model: .text, view: toView,isBottom: isBottom)
    }
    
    /// 自定义停留时间，纯文字提示
    ///
    /// - Parameters:
    ///   - message: 要显示的文字
    ///   - time: 停留时间
    ///   - toView: 要添加的View
    static func showCustomTimeHUD(message : String,time : CGFloat,toView : UIView? = nil){
        MBProgressHUD.showMessageHUD(message: message, time: time, model: .text, view: toView)
    }
    
    fileprivate static func showMessageHUD(message : String,time : CGFloat,model : MBProgressHUDMode,view : UIView? = nil,isBottom: Bool = true){
        
        var toView = view
        if view == nil{
            toView = KeyWindow
        }
        // 快速显示一个提示信息
        let hud = MBProgressHUD.showAdded(to: toView!, animated: true)
        hud.mode = model
        hud.label.text = message
        if isBottom {
            // Move to bottm center.
            hud.offset = CGPoint.init(x: 0.0, y: MBProgressMaxOffset)
        }
        
        hud.hide(animated: true, afterDelay: TimeInterval(time))
    }
}
