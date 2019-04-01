//
//  KZOrderCell.swift
//  kangze
//  我的订单 cell
//  Created by gouyz on 2018/9/3.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZOrderCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : KZGoodsModel?{
        didSet{
            if let model = dataModel {
                
                iconView.kf.setImage(with: URL.init(string: model.goods_image_url!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                nameLab.text = model.goods_name
                priceLab.text = "￥" + model.goods_price!
                numberLab.text = "x" + model.goods_num!
                unitLab.text = (model.unit?.isEmpty)! ? "" : "单位：\(model.unit!)"
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(iconView)
        contentView.addSubview(nameLab)
        contentView.addSubview(numberLab)
        contentView.addSubview(priceLab)
        contentView.addSubview(unitLab)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 80, height: 80))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.equalTo(iconView)
            make.right.equalTo(-kMargin)
        }
        priceLab.snp.makeConstraints { (make) in
            make.top.equalTo(nameLab.snp.bottom).offset(kMargin)
            make.left.equalTo(nameLab)
            make.right.equalTo(numberLab.snp.left).offset(-kMargin)
            make.bottom.equalTo(unitLab.snp.top)
        }
        numberLab.snp.makeConstraints { (make) in
            make.right.equalTo(nameLab)
            make.top.height.top.equalTo(priceLab)
            make.width.equalTo(80)
        }
        unitLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(priceLab)
            make.bottom.equalTo(iconView)
            make.height.equalTo(20)
        }
    }
    /// 图标
    lazy var iconView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kWhiteColor
        
        return imgView
    }()
    
    /// cell title
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 3
        
        return lab
    }()
    
    /// 数量
    lazy var numberLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        lab.textAlignment = .right
        lab.text = "x1"
        
        return lab
    }()
    /// 单价
    lazy var priceLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kRedFontColor
        
        return lab
    }()
    /// 单位
    lazy var unitLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        
        return lab
    }()
}
