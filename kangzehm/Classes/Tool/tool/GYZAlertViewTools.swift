//
//  GYZAlertViewTools.swift
//  GYZActionSheet
//  封装系统AlertController，支持iOS8以上
//  Created by gouyz on 2016/12/28.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit

class GYZAlertViewTools: NSObject {
    
    static let alertViewTools = GYZAlertViewTools()
    override init() {}
    
    /**
     *  创建提示框(可变参数版)
     *
     *  @param title        标题
     *  @param message      提示内容
     *  @param cancelTitle  取消按钮(无操作,为nil则只显示一个按钮)
     *  @param viewController           VC
     *  @param buttonTitles 按钮(为nil,默认为"确定",传参数时必须以nil结尾，否则会崩溃)
     *  @param alertActionBlock      点击按钮的回调
     */
    func showAlert(title: String?,
                   message:String?,
                   cancleTitle:String?,
                   viewController: UIViewController,
                   buttonTitles: String...,
        alertActionBlock :((Int)->Void)? = nil){
        
        var titleArray = [String]()
        
        for item in buttonTitles {
            titleArray.append(item)
        }
        showAlertController(title: title, message: message, cancleTitle: cancleTitle, titleArray: titleArray, viewController: viewController,alertActionBlock: alertActionBlock)
    }
    
    //UIAlertController(iOS8及其以后)
    fileprivate func showAlertController(title: String?,
                                         message:String?,
                                         cancleTitle:String?,
                                         titleArray:[String],
                                         viewController: UIViewController,
                                         alertActionBlock :((Int)->Void)? = nil){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //        if let desTitle = title {
        //            if !desTitle.isEmpty {
        //                // 下面两行代码 是修改 title颜色和字体的代码
        //                let attributedMessage = NSAttributedString.init(string: desTitle, attributes: [NSForegroundColorAttributeName: UIColor.red, NSFontAttributeName: k15Font])
        //                alertController.setValue(attributedMessage, forKey: "attributedTitle")//"attributedMessage"修改message的
        //            }
        //        }
        
        // 取消
        if let cancleDesTitle = cancleTitle {
            
            if !cancleDesTitle.isEmpty {
                let cancelAction = UIAlertAction.init(title: cancleDesTitle, style: .cancel, handler: { (action) in
                    
                    if alertActionBlock != nil{
                        alertActionBlock!(cancelIndex)
                    }
                })
                alertController.addAction(cancelAction)
            }
            
        }
        
        if titleArray.count == 0 {
            // 确定
            let confirmAction = UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
                
                if alertActionBlock != nil{
                    alertActionBlock!(0)
                }
            })
            alertController.addAction(confirmAction)
        } else {
            for (index,item) in titleArray.enumerated() {
                let otherAction = UIAlertAction.init(title: item, style: .default, handler: { (action) in
                    
                    if alertActionBlock != nil{
                        alertActionBlock!(index)
                    }
                })
                // 此代码 可以修改按钮颜色
                //                otherAction.setValue(UIColor.red, forKey: "titleTextColor")
                alertController.addAction(otherAction)
            }
        }
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    /**
     *  创建菜单(Sheet 可变参数版)
     *
     *  @param title        标题
     *  @param message      提示内容
     *  @param cancelTitle  取消按钮(无操作,为nil则只显示一个按钮)
     *  @param viewController           VC
     *  @param buttonTitles 按钮(为nil,默认为"确定",传参数时必须以nil结尾，否则会崩溃)
     *  @param alertActionBlock      点击按钮的回调
     */
    func showSheet(title: String?,
                   message:String?,
                   cancleTitle:String,
                   viewController: UIViewController,
                   buttonTitles: String...,
        alertActionBlock :((Int)->Void)? = nil){
        
        var titleArray = [String]()
        
        for item in buttonTitles {
            titleArray.append(item)
        }
        showSheetController(title: title, message: message, cancleTitle: cancleTitle, titleArray: titleArray, viewController: viewController,alertActionBlock: alertActionBlock)
        
    }
    /**
     *  创建菜单(Sheet)
     *
     *  @param title        标题
     *  @param message      提示内容
     *  @param cancelTitle  取消按钮(无操作,为nil则只显示一个按钮)
     *  @param titleArray   标题字符串数组(为nil,默认为"确定")
     *  @param viewController           VC
     *  @param alertActionBlock      点击确认按钮的回调
     */
    func showSheet(title: String?,
                   message:String?,
                   cancleTitle:String,
                   titleArray:[String],
                   viewController: UIViewController,
                   alertActionBlock :((Int)->Void)? = nil){
        
        showSheetController(title: title, message: message, cancleTitle: cancleTitle, titleArray: titleArray, viewController: viewController,alertActionBlock: alertActionBlock)
    }
    
    //UIAlertController(iOS8及其以后) ActionSheet的封装
    fileprivate func showSheetController(title: String?,
                                         message:String?,
                                         cancleTitle:String,
                                         titleArray:[String],
                                         viewController: UIViewController,
                                         alertActionBlock :((Int)->Void)? = nil){
        
        let sheet = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        
        // 取消
        let cancelAction = UIAlertAction.init(title: cancleTitle, style: .cancel, handler: { (action) in
            
            if alertActionBlock != nil{
                alertActionBlock!(cancelIndex)
            }
        })
        sheet.addAction(cancelAction)
        
        for (index,item) in titleArray.enumerated() {
            let otherAction = UIAlertAction.init(title: item, style: .default, handler: { (action) in
                
                if alertActionBlock != nil{
                    alertActionBlock!(index)
                }
            })
            sheet.addAction(otherAction)
        }
        
        viewController.present(sheet, animated: true, completion: nil)
    }
}
