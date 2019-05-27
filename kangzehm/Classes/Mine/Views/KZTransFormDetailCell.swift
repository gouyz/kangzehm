//
//  KZTransFormDetailCell.swift
//  kangzehm
//  转让明细cell
//  Created by gouyz on 2019/5/27.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class KZTransFormDetailCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : KZTransFormModel?{
        didSet{
            if let model = dataModel {
                
                titleLab.text = model.log_msg
                dateLab.text = model.log_time?.getDateTime(format: "yyyy-MM-dd")
            }
        }
    }

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
        contentView.addSubview(accountLab)
        contentView.addSubview(dateLab)
        contentView.addSubview(numLab)
        
        dateLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.height.equalTo(30)
            make.right.equalTo(titleLab.snp.left).offset(-5)
        }
        titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.height.equalTo(20)
            make.centerX.equalTo(contentView)
            make.width.equalTo(120)
        }
        accountLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(titleLab)
            make.top.equalTo(titleLab.snp.bottom)
        }
        numLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(dateLab)
            make.left.equalTo(titleLab.snp.right)
        }
    }
    
    /// 标题
    var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        
        return lab
    }()
    ///
    var accountLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        
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
    ///
    var numLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .right
        lab.text = "-2222.00"
        
        return lab
    }()

}
