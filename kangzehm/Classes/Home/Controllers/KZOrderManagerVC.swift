//
//  KZOrderManagerVC.swift
//  kangze
//  我的订单
//  Created by gouyz on 2018/9/3.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZOrderManagerVC: GYZBaseVC {
    
    let titleArr : [String] = ["全部","待付款","已付款"]
    
    //订单状态        空                全部订单
    //state_new         待付款
    //state_pay         已付款
    let stateValue : [String] = ["","state_new","state_pay"]
    var scrollPageView: ScrollPageView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的订单"
        
        setScrollView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///设置控制器
    func setChildVcs() -> [UIViewController] {
        
        var childVC : [KZOrderVC] = []
        for index in 0 ..< titleArr.count{
            
            let vc = KZOrderVC()
            vc.orderStatus = stateValue[index]
            childVC.append(vc)
        }
        
        return childVC
    }
    
    /// 设置scrollView
    func setScrollView(){
        // 这个是必要的设置
        automaticallyAdjustsScrollViewInsets = false
        
        var style = SegmentStyle()
        // 滚动条
        style.showLine = true
        style.scrollTitle = false
        // 颜色渐变
        style.gradualChangeTitleColor = true
        // 滚动条颜色
        style.scrollLineColor = kBlueFontColor
        style.normalTitleColor = kBlackFontColor
        style.selectedTitleColor = kBlueFontColor
        /// 显示角标
        style.showBadge = false
        
        scrollPageView = ScrollPageView.init(frame: CGRect.init(x: 0, y: kTitleAndStateHeight, width: kScreenWidth, height: self.view.frame.height - kTitleAndStateHeight), segmentStyle: style, titles: titleArr, childVcs: setChildVcs(), parentViewController: self)
        view.addSubview(scrollPageView!)
    }
}
