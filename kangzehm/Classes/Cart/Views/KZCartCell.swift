//
//  KZCartCell.swift
//  kangze
//  购物车 cell
//  Created by gouyz on 2018/9/3.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZCartCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : KZCartGoodsModel?{
        didSet{
            if let model = dataModel {
                
                iconView.kf.setImage(with: URL.init(string: model.goods_image_url!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                
                nameLab.text = model.goods_name
                priceLab.text = "￥" + model.goods_price!
                saleLab.text = (model.unit?.isEmpty)! ? "" : "单位：\(model.unit!)"
                countLab.text = model.goods_num
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(checkImgView)
        contentView.addSubview(iconView)
        contentView.addSubview(nameLab)
        contentView.addSubview(saleLab)
        contentView.addSubview(deleteView)
        contentView.addSubview(priceLab)
        contentView.addSubview(minusIconView)
        contentView.addSubview(countLab)
        contentView.addSubview(addIconView)
        
        checkImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(checkImgView.snp.right).offset(kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 80, height: 80))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.equalTo(iconView)
            make.right.equalTo(-kMargin)
        }
        saleLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.right.equalTo(minusIconView.snp.left).offset(-5)
            make.height.equalTo(20)
        }
        deleteView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(saleLab)
            make.size.equalTo(CGSize.init(width: 10, height: 13))
        }
        priceLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.bottom.equalTo(iconView)
            make.height.equalTo(20)
            make.right.equalTo(saleLab)
        }
        addIconView.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconView)
            make.right.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        countLab.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(addIconView)
            make.right.equalTo(addIconView.snp.left)
            make.width.equalTo(30)
        }
        minusIconView.snp.makeConstraints { (make) in
            make.centerY.size.equalTo(addIconView)
            make.right.equalTo(countLab.snp.left)
        }
    }
    
    /// 选择图标
    lazy var checkImgView : UIImageView = UIImageView.init(image: UIImage.init(named: "icon_check"))
    /// 商品图标
    lazy var iconView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        
        return imgView
    }()
    
    /// 商品名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 0
        lab.text = "澳洲原装天然海藻油DHA帮助大脑发育增强记忆降低血糖全球妈妈的首选"
        
        return lab
    }()
    /// 月销
    lazy var saleLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kGaryFontColor
        
        return lab
    }()
    /// 删除图标
    lazy var deleteView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_cart_delete"))
    /// 单价
    lazy var priceLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kRedFontColor
        lab.text = "￥298"
        
        return lab
    }()
    /// 加
    lazy var addIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_add"))
    
    /// 数量
    lazy var countLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "1"
        lab.textAlignment = .center
        
        return lab
    }()
    
    /// 减
    lazy var minusIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_minus"))
}
