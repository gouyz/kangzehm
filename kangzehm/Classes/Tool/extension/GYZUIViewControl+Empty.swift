//
//  GYZUIViewControl+Empty.swift
//  LazyHuiSellers
//  空页面
//  Created by gouyz on 2017/3/8.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

extension UIViewController{
    
    struct EmptyKey {
        static var emptyKey = "emptyViewKey"
    }
    
    var emptyView : GYZEmptyView?{
        get{
            return objc_getAssociatedObject(self, &EmptyKey.emptyKey) as! GYZEmptyView?
        }
        set{
            objc_setAssociatedObject(self, &EmptyKey.emptyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 显示空页面
    ///
    /// - Parameters:
    ///   - content: 描述内容
    ///   - iconImgName: 图片
    ///   - reload: 重新加载闭包
    func showEmptyView(content: String? = nil,iconImgName: String? = nil,reload:(()->Void)? = nil){
        
        if emptyView == nil{
            emptyView = GYZEmptyView()
            view.addSubview(emptyView!)
            
            emptyView?.snp.makeConstraints({ (make) in
                make.left.right.equalTo(view)
                make.top.equalTo(view)
                make.bottom.equalTo(view)
            })
            
            if content != nil {
                emptyView?.desLab.text = content
            }
            
            if iconImgName != nil {
                emptyView?.iconImgView.image = UIImage.init(named: iconImgName!)
            }
            emptyView?.reloadBlock = reload
        }
    }
    
    /// 自定义位置显示空页面
    ///
    /// - Parameters:
    ///   - content: 描述内容
    ///   - iconImgName: 图片
    ///   - reload: 重新加载闭包
    func showEmptyViewByCustom(content: String? = nil,iconImgName: String? = nil,reload:(()->Void)? = nil){
        
        if content != nil {
            emptyView?.desLab.text = content
        }
        
        if iconImgName != nil {
            emptyView?.iconImgView.image = UIImage.init(named: iconImgName!)
        }
        emptyView?.reloadBlock = reload
    }
    
    /// 隐藏加载动画
    func hiddenEmptyView(){
        if emptyView != nil {
            emptyView?.removeFromSuperview()
            emptyView = nil
        }
    }
}
