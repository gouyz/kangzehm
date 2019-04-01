//
//  KZOrderHeaderView.swift
//  kangze
//  我的订单 header
//  Created by gouyz on 2018/9/3.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZOrderHeaderView: UITableViewHeaderFooterView {
    
    /// 填充数据
    var dataModel : KZOrderModel?{
        didSet{
            if let model = dataModel {
                
                orderNoLab.text = "订单号：" + model.order_sn!
                orderStatusLab.text = model.state_desc
            }
        }
    }

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(bgView)
        bgView.addSubview(orderNoLab)
        bgView.addSubview(orderStatusLab)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(kMargin)
        }
        orderNoLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(orderStatusLab.snp.left).offset(-kMargin)
            make.top.bottom.equalTo(bgView)
        }
        orderStatusLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(orderNoLab)
            make.width.equalTo(80)
        }
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    /// 订单编号
    lazy var orderNoLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "订单号："
        
        return lab
    }()
    /// 订单状态
    lazy var orderStatusLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .right
        lab.text = "待付款"
        
        return lab
    }()
}
