//
//  KZCartBottomView.swift
//  kangze
//  购物车 底部 View
//  Created by gouyz on 2018/9/3.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZCartBottomView: UIView {

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        addSubview(checkView)
        addSubview(totalLab)
        addSubview(jieSuanLab)
        
        checkView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.bottom.equalTo(self)
            make.width.equalTo(100)
        }
        
        totalLab.snp.makeConstraints { (make) in
            make.left.equalTo(checkView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(self)
            make.right.equalTo(jieSuanLab.snp.left).offset(-kMargin)
        }
        jieSuanLab.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(self)
            make.width.equalTo(80)
        }
    }
    
    /// 图片tag
    lazy var checkView : LHSCheckView = {
        let view = LHSCheckView()
        view.nameLab.text = "全选"
        view.tagImgView.image = UIImage.init(named: "icon_check")
        
        return view
    }()
    /// 合计
    lazy var totalLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .right
        
        return lab
    }()
    /// 结算
    lazy var jieSuanLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.backgroundColor = kBlueFontColor
        
        return lab
    }()
}
