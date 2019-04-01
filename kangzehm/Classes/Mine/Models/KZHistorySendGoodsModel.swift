//
//  KZHistorySendGoodsModel.swift
//  kangze
//  历史发货model
//  Created by gouyz on 2018/9/10.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class KZHistorySendGoodsModel: LHSBaseModel {

    /// id
    var id : String?
    /// 订单编号
    var sendSn : String?
    /// 发货数量
    var goods_num : String?
    /// 运费
    var freight : String?
    /// 时间
    var add_time : String?
    /// 订单状态  1,已申请发货  2.已发货   3，已收货
    var status : String?
    /// 会员id
    var member_id : String?
    /// 运费支付状态  1.已支付   0未支付
    var pay_status : String? = ""
    
    /// 收货地址info
    var addressInfo: KZMyAddressModel?
    /// 商品info
    var goodsInfo: KZGoodsModel?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "address_info"{
            guard let datas = value as? [String : Any] else { return }
            addressInfo = KZMyAddressModel(dict: datas)
        }else if key == "goods_info"{
            guard let datas = value as? [String : Any] else { return }
            goodsInfo = KZGoodsModel(dict: datas)
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
