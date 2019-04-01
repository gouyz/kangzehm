//
//  KZMyShouRuHeaderView.swift
//  kangze
//  零售收入 header
//  Created by gouyz on 2018/9/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZMyShouRuHeaderView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(timeDesLab)
        contentView.addSubview(timeLab)
        contentView.addSubview(arrowImgView)
        contentView.addSubview(moneyLab)
        
        timeDesLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.bottom.equalTo(contentView)
            make.width.equalTo(50)
        }
        timeLab.snp.makeConstraints { (make) in
            make.left.equalTo(timeDesLab.snp.right)
            make.top.bottom.equalTo(timeDesLab)
            make.width.equalTo(55)
        }
        arrowImgView.snp.makeConstraints { (make) in
            make.left.equalTo(timeLab.snp.right)
            make.centerY.equalTo(timeLab)
            make.size.equalTo(CGSize.init(width: 7, height: 4))
        }
        moneyLab.snp.makeConstraints { (make) in
            make.left.equalTo(arrowImgView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(timeLab)
            make.right.equalTo(-kMargin)
        }
    }

    /// 时间
    lazy var timeDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "时间："
        
        return lab
    }()
    ///
    lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        
        return lab
    }()
    lazy var arrowImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_arrow_down"))
    /// 零售收入
    lazy var moneyLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .right
        lab.text = "零售收入：￥0.00"
        
        return lab
    }()
}
