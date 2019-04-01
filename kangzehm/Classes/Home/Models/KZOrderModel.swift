//
//  KZOrderModel.swift
//  kangze
//  订单model
//  Created by gouyz on 2018/9/8.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class KZOrderModel: LHSBaseModel {

    /// 订单id
    var order_id : String?
    /// 订单编号
    var order_sn : String?
    /// 购买者id
    var buyer_id : String?
    /// 购买者姓名
    var buyer_name : String?
    /// 订单时间
    var add_time : String?
    /// 订单总价格
    var goods_amount : String?
    /// 订单状态：0(已取消)10(默认):未付款;20:已付款;30:已发货;40:已收货;
    var order_state : String? = ""
    /// 订单状态字符串
    var state_desc : String?
    /// 付款方式
    var payment_name : String?
    /// 支付订单编号
    var pay_sn : String?
    
    /// 商品列表
    var goodList: [KZGoodsModel]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "extend_order_goods"{
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
