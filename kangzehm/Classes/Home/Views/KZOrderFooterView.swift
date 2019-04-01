//
//  KZOrderFooterView.swift
//  kangze
//  我的订单 footer 
//  Created by gouyz on 2018/9/3.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZOrderFooterView: UITableViewHeaderFooterView {
    
    /// 填充数据
    var dataModel : KZOrderModel?{
        didSet{
            if let model = dataModel {
                
                totalLab.text = "合计：￥\(model.goods_amount!)"
                ///订单状态：0(已取消)10(默认):未付款;20:已付款;30:已发货;40:已收货;
                let status: String = model.order_state!
                if status == "0"{
                    deleteBtn.isHidden = false
                    operatorBtn.isHidden = true
                    operatorBtn.snp.updateConstraints({ (make) in
                        make.width.equalTo(0)
                        make.height.equalTo(0)
                    })
                }else if status == "10"{
                    deleteBtn.isHidden = false
                    operatorBtn.isHidden = false
                    operatorBtn.snp.updateConstraints({ (make) in
                        make.width.equalTo(70)
                        make.height.equalTo(20)
                    })
                }else{
                    deleteBtn.isHidden = true
                    operatorBtn.isHidden = true
                }
            }
        }
    }

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(totalLab)
        contentView.addSubview(lineView)
        contentView.addSubview(deleteBtn)
        contentView.addSubview(operatorBtn)
        
        totalLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(contentView)
            make.height.equalTo(34)
        }
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(totalLab.snp.bottom)
            make.left.right.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
        deleteBtn.snp.makeConstraints { (make) in
            make.right.equalTo(operatorBtn.snp.left).offset(-20)
            make.top.equalTo(lineView.snp.bottom).offset(8)
            make.width.equalTo(70)
            make.height.equalTo(20)
        }
        operatorBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.equalTo(deleteBtn)
            make.width.equalTo(70)
            make.height.equalTo(20)
        }
    }
    
    /// 合计
    lazy var totalLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .right
        
        return lab
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    /// 删除订单
    lazy var deleteBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kWhiteColor
        btn.titleLabel?.font = k12Font
        btn.setTitleColor(kBlueFontColor, for: .normal)
        btn.setTitle("删除订单", for: .normal)
        btn.borderColor = kBlueFontColor
        btn.cornerRadius = kCornerRadius
        btn.borderWidth = klineWidth
        
        return btn
    }()
    /// 去结算
    lazy var operatorBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBlueFontColor
        btn.titleLabel?.font = k12Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("去结算", for: .normal)
        btn.cornerRadius = kCornerRadius
        
        return btn
    }()
}
