//
//  GYZSearchNavBarView.swift
//  kangze
//  导航栏 搜索框View
//  Created by gouyz on 2018/8/28.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class GYZSearchNavBarView: UIView {
    
    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    /// 在iOS11 NavBar自定义titleview里有个button,点击事件不触发了.的解决办法如下：
    override var intrinsicContentSize: CGSize {
        return UILayoutFittingExpandedSize
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        addSubview(searchBtn)
        addSubview(lineView)
        
        searchBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.centerY.equalTo(self)
            make.height.equalTo(34)
        }
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBtn.snp.bottom)
            make.left.right.equalTo(searchBtn)
            make.height.equalTo(klineDoubleWidth)
        }
        
        searchBtn.set(image: UIImage.init(named: "icon_search_black"), title: "请输入您搜索的内容", titlePosition: .right, additionalSpacing: kMargin, state: .normal)
    }
    /// 搜索
    lazy var searchBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.backgroundColor = kWhiteColor
        return btn
    }()
    /// 分割线
    lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kBlackFontColor
        return line
    }()
    
    
}
