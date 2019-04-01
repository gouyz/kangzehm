//
//  GYZUIViewController+Loading.swift
//  LazyHuiSellers
//  控制器加载页面
//  Created by gouyz on 2016/12/23.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit
import SnapKit

extension UIViewController{
    
    struct LoadingKey {
        static var loadingViewKey = "loadingViewKey"
    }
    
    var loadingView : GYZLoadingView?{
        get{
            return objc_getAssociatedObject(self, &LoadingKey.loadingViewKey) as! GYZLoadingView?
        }
        set{
            objc_setAssociatedObject(self, &LoadingKey.loadingViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 显示加载动画
    func showLoadingView(){
        if loadingView == nil {
            loadingView = GYZLoadingView()
            view.addSubview(loadingView!)
            
            loadingView?.snp.makeConstraints({ (make) in
                make.centerX.equalTo(view.snp.centerX).offset(-40)
                make.centerY.equalTo(view.snp.centerY).offset(-kTitleAndStateHeight)
                make.size.equalTo(CGSize.init(width: kScreenWidth, height: 40))
            })
            loadingView?.startAnimating()
        }
    }
    
    /// 隐藏加载动画
    func hiddenLoadingView(){
        if loadingView != nil {
            loadingView?.removeFromSuperview()
            loadingView = nil
        }
    }
}
