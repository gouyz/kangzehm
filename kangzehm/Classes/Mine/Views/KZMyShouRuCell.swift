//
//  KZMyShouRuCell.swift
//  kangze
//  零售收入 cell
//  Created by gouyz on 2018/9/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZMyShouRuCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(nameLab)
        contentView.addSubview(dateLab)
        contentView.addSubview(moneyLab)
        contentView.addSubview(productLab)
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.bottom.equalTo(contentView)
            make.width.equalTo(dateLab)
        }
        dateLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right)
            make.top.bottom.equalTo(nameLab)
            make.width.equalTo(moneyLab)
        }
        moneyLab.snp.makeConstraints { (make) in
            make.left.equalTo(dateLab.snp.right)
            make.top.bottom.equalTo(nameLab)
            make.width.equalTo(productLab)
        }
        productLab.snp.makeConstraints { (make) in
            make.left.equalTo(moneyLab.snp.right)
            make.top.bottom.equalTo(nameLab)
            make.width.equalTo(nameLab)
            make.right.equalTo(-kMargin)
        }
    }
    
    /// 姓名
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        
        return lab
    }()
    /// 时间
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        
        return lab
    }()
    /// 零售金额
    lazy var moneyLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        
        return lab
    }()
    /// 产品
    lazy var productLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        
        return lab
    }()
}
