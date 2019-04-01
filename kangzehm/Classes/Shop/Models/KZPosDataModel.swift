//
//  KZPosDataModel.swift
//  kangze
//  POS 支付数据
//  Created by gouyz on 2018/9/13.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class KZPosDataModel: LHSBaseModel {
    /// 订单总价格
    var total : String? = "0"
    /// 加密的订单支付编号
    var pas_sn_encode : String?
    /// 支付订单编号
    var pay_sn : String?
    
    /// 商品列表
    var goodList: [KZGoodsModel]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "goods_list"{
            goodList = [KZGoodsModel]()
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = KZGoodsModel(dict: dict)
                goodList?.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
