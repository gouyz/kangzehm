//
//  KZGoodsFavouriteCell.swift
//  kangze
//  商品收藏 cell
//  Created by gouyz on 2018/9/4.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZGoodsFavouriteCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : KZGoodsModel?{
        didSet{
            if let model = dataModel {
                
                iconView.kf.setImage(with: URL.init(string: model.goods_image_url!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                
                let name: String = model.goos_type_str! + model.goods_name!
                let nameAttr : NSMutableAttributedString = NSMutableAttributedString(string: name)
                nameAttr.addAttribute(NSAttributedStringKey.foregroundColor, value: kRedFontColor, range: NSMakeRange(0, (model.goos_type_str?.count)!))
                nameLab.attributedText = nameAttr
                priceLab.text = "￥" + model.goods_price!
                numberLab.text = "\(model.goods_collect!)人收藏"
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
        contentView.addSubview(iconView)
        contentView.addSubview(nameLab)
        contentView.addSubview(priceLab)
        contentView.addSubview(numberLab)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 100, height: 100))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.equalTo(iconView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(kTitleHeight)
        }
        priceLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.bottom.equalTo(numberLab.snp.top)
        }
        numberLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.bottom.equalTo(iconView)
            make.height.equalTo(20)
        }
    }
    
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
        lab.numberOfLines = 2
        
        return lab
    }()
    /// 单价
    lazy var priceLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kRedFontColor
        lab.text = "￥298"
        
        return lab
    }()
    /// 付款人数
    lazy var numberLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kBlackFontColor
        lab.text = "1258人收藏"
        
        return lab
    }()
}
