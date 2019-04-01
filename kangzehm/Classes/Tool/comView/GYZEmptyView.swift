//
//  GYZEmptyView.swift
//  LazyHuiSellers
//  空数据提示页面
//  Created by gouyz on 2017/3/8.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZEmptyView: UIView {
    
    /// 重新加载
    var reloadBlock: (()->Void)?

    // MARK: 生命周期方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kBackgroundColor
        self.addOnClickListener(target: self, action: #selector(reloadClicked))
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setupUI(){
        addSubview(viewBg)
        viewBg.addSubview(desLab)
        viewBg.addSubview(iconImgView)
        
        viewBg.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.centerY.equalTo(self).offset(-100)
            make.height.equalTo(200)
        }
        
        iconImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(viewBg)
            make.top.equalTo(viewBg)
            make.width.equalTo(130)
            make.height.equalTo(160)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(iconImgView.snp.bottom).offset(kMargin)
            make.height.equalTo(kTitleHeight)
        }
    }
    
    ///
    lazy var viewBg: UIView = UIView()
    
    /// 无数据默认图片
    lazy var iconImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_blankpage_empty_cry"))
    
    /// 描述
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .center
        lab.text = "暂无数据"
        
        return lab
    }()

    /// 重新加载
    @objc func reloadClicked() {
        if reloadBlock != nil {
            self.isHidden = true
            self.removeFromSuperview()
            reloadBlock!()
        }
    }
}
