//
//  KZMyBankCell.swift
//  kangze
//  我的银行卡 cell
//  Created by gouyz on 2018/9/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZMyBankCell: UITableViewCell {
    /// 填充数据
    var dataModel : KZBankModel?{
        didSet{
            if let model = dataModel {
                
//                let name: String = model.card_type!
//                var imgName: String = ""
//                if name.contains("建设银行") {
//                    imgName = "icon_bank_jianse"
//                }else if name.contains("农业银行") {
//                    imgName = "icon_bank_nongye"
//                }else if name.contains("中国银行") {
//                    imgName = "icon_bank_china"
//                }else if name.contains("交通银行") {
//                    imgName = "icon_bank_jiaotong"
//                }
//                iconView.image = UIImage.init(named: imgName)
                nameLab.text = model.card_type
                numberLab.text = model.end_num
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
        
//        contentView.addSubview(iconView)
        contentView.addSubview(nameLab)
        contentView.addSubview(numberLab)
        contentView.addSubview(checkImgView)
        
//        iconView.snp.makeConstraints { (make) in
//            make.left.equalTo(kMargin)
//            make.centerY.equalTo(contentView)
//            make.size.equalTo(CGSize.init(width: 30, height: 30))
//        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(checkImgView.snp.left).offset(-kMargin)
            make.height.equalTo(20)
        }
        numberLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
        }
        checkImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
    }
    
    /// 图标
//    lazy var iconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_bank_jianse"))
    
    /// 银行名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "建设银行"
        
        return lab
    }()
    
    /// 银行卡尾号
    var numberLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "尾号4578储蓄卡"
        
        return lab
    }()
    
    /// 选择框
    lazy var checkImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_check"))
}
