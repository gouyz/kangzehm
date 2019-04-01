//
//  KZSubmitOrderModel.swift
//  kangze
//  确认订单 model
//  Created by gouyz on 2018/9/11.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class KZSubmitOrderModel: LHSBaseModel {
    /// 该商品订单总价格
    var store_goods_total : String?
    /// 店铺名称
    var store_name : String?
    
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
