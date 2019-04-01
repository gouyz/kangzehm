//
//  GYZLoadingView.swift
//  LazyHuiSellers
//  加载动画loading
//  Created by gouyz on 2016/12/22.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit

class GYZLoadingView: UIView {

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setupUI(){
        addSubview(desLab)
        addSubview(loadView)
        
        loadView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(loadView.snp.right)
            make.centerY.equalTo(self)
            make.height.equalTo(loadView)
            make.width.equalTo(100)
        }
    }
    
    /// 描述
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k14Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "正在加载..."
        
        return lab
    }()
    
    /// 菊花动画
    lazy var loadView : UIActivityIndicatorView = {
        let indView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        return indView
    }()
    
    /// 开始动画
    func startAnimating(){
        loadView.startAnimating()
    }
}
