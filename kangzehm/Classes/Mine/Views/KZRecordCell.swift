//
//  KZRecordCell.swift
//  kangze
//  充值、提现等记录cell
//  Created by gouyz on 2018/9/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZRecordCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.backgroundColor = kWhiteColor
        
        contentView.addSubview(titleLab)
        contentView.addSubview(statusLab)
        contentView.addSubview(dateLab)
        contentView.addSubview(moneyLab)
        
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.height.equalTo(30)
            make.width.equalTo(statusLab)
        }
        statusLab.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(titleLab)
            make.right.equalTo(-kMargin)
            make.left.equalTo(titleLab.snp.right).offset(kMargin)
        }
        dateLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(titleLab)
            make.top.equalTo(titleLab.snp.bottom)
        }
        moneyLab.snp.makeConstraints { (make) in
            make.width.right.equalTo(statusLab)
            make.top.height.equalTo(dateLab)
        }
    }
    
    /// 标题
    var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "提现"
        
        return lab
    }()
    /// 状态
    var statusLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        lab.text = "待打款"
        lab.textAlignment = .right
        
        return lab
    }()
    /// 日期
    var dateLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "2018-08-15 09:45:50"
        
        return lab
    }()
    /// 金额
    var moneyLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .right
        lab.text = "￥-2222.00"
        
        return lab
    }()
}
