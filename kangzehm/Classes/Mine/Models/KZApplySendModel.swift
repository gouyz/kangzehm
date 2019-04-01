//
//  KZApplySendModel.swift
//  kangze
//  申请发货model
//  Created by gouyz on 2018/9/11.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class KZApplySendModel: LHSBaseModel {
    /// 商品的库存
    var stock : String?
    /// 发货的运费
    var freight : String? = "0"
    
    /// 商品信息
    var goodsInfo: KZSendGoodsModel?
    
    var addressList: [KZMyAddressModel]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "goods_info"{
            guard let datas = value as? [String : Any] else { return }
            goodsInfo = KZSendGoodsModel.init(dict: datas)
        }else if key == "address_list"{
            addressList = [KZMyAddressModel]()
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = KZMyAddressModel(dict: dict)
                addressList?.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

/// 发货商品model
@objcMembers
class KZSendGoodsModel: LHSBaseModel {
    /// 商品名称
    var goods_name : String?
    /// 商品的缩略图片url
    var image_url : String?
    /// 单位
    var unit : String? = ""
}
