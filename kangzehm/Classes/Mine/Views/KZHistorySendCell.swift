//
//  KZHistorySendCell.swift
//  kangze
//  历史发货 cell
//  Created by gouyz on 2018/9/5.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZHistorySendCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : KZHistorySendGoodsModel?{
        didSet{
            if let model = dataModel {
                
                orderNoLab.text = "订单号：" + model.sendSn!
                dateLab.text = model.add_time
                personLab.text = "收件人：" + (model.addressInfo?.true_name)!
                phoneLab.text = "电话：" + (model.addressInfo?.mob_phone)!
                addressLab.text = "地址：" + (model.addressInfo?.province_name)! + (model.addressInfo?.city_name)! + (model.addressInfo?.area_name)! + (model.addressInfo?.address)!
                
                iconView.kf.setImage(with: URL.init(string: (model.goodsInfo?.goods_image_url)!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                
                nameLab.text = model.goodsInfo?.goods_name
                numberLab.text = "X\(model.goods_num!)"
                unitLab.text = (model.goodsInfo?.unit?.isEmpty)! ? "" : "单位：\((model.goodsInfo?.unit)!)"
                
                if model.status == "2" && model.pay_status == "1"{
                    receivedBtn.isHidden = false
                    receivedBtn.isEnabled = true
                    receivedBtn.setTitle("确认收货", for: .normal)
                    receivedBtn.setTitleColor(kWhiteColor, for: .normal)
                    receivedBtn.backgroundColor = kBlueFontColor
                    receivedBtn.snp.updateConstraints({ (make) in
                        make.height.equalTo(20)
                    })
                }else if model.status == "3"{
                    receivedBtn.isEnabled = true
                    receivedBtn.setTitle("已收货", for: .normal)
                    receivedBtn.setTitleColor(kBlueFontColor, for: .normal)
                    receivedBtn.backgroundColor = kWhiteColor
                    receivedBtn.isHidden = false
                    receivedBtn.snp.updateConstraints({ (make) in
                        make.height.equalTo(20)
                    })
                }else{
                    receivedBtn.isHidden = true
                    receivedBtn.snp.updateConstraints({ (make) in
                        make.height.equalTo(0)
                    })
                }
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
        
        contentView.addSubview(bgView)
        bgView.addSubview(orderNoLab)
        bgView.addSubview(dateLab)
        bgView.addSubview(personLab)
        bgView.addSubview(phoneLab)
        bgView.addSubview(addressLab)
        
        bgView.addSubview(iconView)
        bgView.addSubview(nameLab)
        bgView.addSubview(numberLab)
        bgView.addSubview(unitLab)
        bgView.addSubview(receivedBtn)
        
        bgView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(contentView)
            make.top.equalTo(kMargin)
        }
        orderNoLab.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(24)
        }
        dateLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(orderNoLab)
            make.top.equalTo(orderNoLab.snp.bottom)
        }
        personLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(orderNoLab)
            make.top.equalTo(dateLab.snp.bottom)
        }
        phoneLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(orderNoLab)
            make.top.equalTo(personLab.snp.bottom)
        }
        addressLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(orderNoLab)
            make.top.equalTo(phoneLab.snp.bottom)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(orderNoLab)
            make.top.equalTo(addressLab.snp.bottom).offset(kMargin)
            make.size.equalTo(CGSize.init(width: 50, height: 50))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.equalTo(iconView)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(numberLab.snp.top)
        }
        unitLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.bottom.equalTo(iconView)
            make.height.equalTo(20)
            make.right.equalTo(numberLab.snp.left).offset(-kMargin)
        }
        numberLab.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.height.bottom.equalTo(unitLab)
            make.width.equalTo(80)
        }
        receivedBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(-kMargin)
            make.width.equalTo(70)
            make.height.equalTo(20)
            make.top.equalTo(iconView.snp.bottom)
        }
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    /// 订单号
    lazy var orderNoLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlueFontColor
        
        return lab
    }()
    /// 日期
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.text = "2018-06-03 08:23:08"
        
        return lab
    }()
    /// 收件人
    lazy var personLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    /// 电话
    lazy var phoneLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.text = "电话：138812324343"
        
        return lab
    }()
    /// 地址
    lazy var addressLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.text = "地址：常州市新北区"
        
        return lab
    }()
    
    /// 商品图标
    lazy var iconView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        
        return imgView
    }()
    
    /// 商品名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 2
        
        return lab
    }()
    /// 单位
    lazy var unitLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        
        return lab
    }()
    /// 数量
    lazy var numberLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .right
        lab.text = "X2"
        
        return lab
    }()
    /// 确认收货
    lazy var receivedBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBlueFontColor
        btn.titleLabel?.font = k12Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("确认收货", for: .normal)
        btn.borderColor = kBlueFontColor
        btn.cornerRadius = kCornerRadius
        btn.borderWidth = klineWidth
        btn.addTarget(self, action: #selector(clickedReceivedBtn), for: .touchUpInside)
        
        return btn
    }()
    /// 确认收货
    @objc func clickedReceivedBtn(){
        
    }
}
