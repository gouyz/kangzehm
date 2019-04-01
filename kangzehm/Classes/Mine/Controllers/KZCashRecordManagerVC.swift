//
//  KZCashRecordManagerVC.swift
//  kangze
//  提现记录
//  Created by gouyz on 2018/9/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZCashRecordManagerVC: GYZBaseVC {

    let titleArr : [String] = ["全部","待打款","已打款","已拒绝"]
    
    //状态值 0待打款 1已打款 2，已拒绝 99，全部记录
    let stateValue : [String] = ["99","0","1","2"]
    var scrollPageView: ScrollPageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "提现记录"
        
        setScrollView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///设置控制器
    func setChildVcs() -> [UIViewController] {
        
        var childVC : [KZCashRecordVC] = []
        for index in 0 ..< titleArr.count{
            
            let vc = KZCashRecordVC()
            vc.status = stateValue[index]
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
