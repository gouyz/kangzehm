//
//  KZCartModel.swift
//  kangze
//  购物车 model
//  Created by gouyz on 2018/9/11.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class KZCartModel: LHSBaseModel {
    /// 商铺id
    var store_id : String?
    /// 商铺名称
    var store_name : String?
    
    /// 商品列表
    var goodList: [KZCartGoodsModel]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "goods"{
            goodList = [KZCartGoodsModel]()
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = KZCartGoodsModel(dict: dict)
                goodList?.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

/// 购物车商品model
@objcMembers
class KZCartGoodsModel: LHSBaseModel{
    
    /// 购物车id
    var cart_id : String?
    /// 会员id
    var buyer_id : String?
    /// 商品id
    var goods_id : String? = ""
    /// 商品名称
    var goods_name : String? = ""
    /// 商品价格
    var goods_price : String? = ""
    /// 商品个数
    var goods_num : String? = "1"
    /// 商品图片链接
    var goods_image_url : String?
    /// 该商品总价格 100*3
    var goods_total : String? = ""
    /// 月销数量
    var month_sell : String? = "0"
    /// 单位
    var unit : String? = ""
}
