//
//  KZSubmitOrderFooterView.swift
//  kangze
//  提交订单 footer
//  Created by gouyz on 2018/9/4.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZSubmitOrderFooterView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(totalLab)
        
        totalLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(contentView)
        }
    }
    
    /// 合计
    lazy var totalLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .right
        lab.text = "共2件商品  合计：￥298"
        
        return lab
    }()
}
