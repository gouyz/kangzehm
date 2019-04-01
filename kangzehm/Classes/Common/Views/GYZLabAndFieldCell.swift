//
//  GYZLabAndFieldCell.swift
//  kangze
//  label 和 textField cell
//  Created by gouyz on 2018/9/4.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class GYZLabAndFieldCell: UITableViewCell {

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
        contentView.addSubview(textFiled)
        
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.height.equalTo(kTitleHeight)
            make.width.equalTo(80)
        }
        textFiled.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLab)
            make.left.equalTo(titleLab.snp.right).offset(kMargin)
            make.right.equalTo(-kMargin)
            make.height.greaterThanOrEqualTo(kTitleHeight)
        }
    }
    
    /// 标题
    var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    /// 输入框
    lazy var textFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.textAlignment = .right
        textFiled.placeholder = "请填写备注"
        
        return textFiled
    }()
}
