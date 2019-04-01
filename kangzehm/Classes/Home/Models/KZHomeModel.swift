//
//  KZHomeModel.swift
//  kangze
//  首页model
//  Created by gouyz on 2018/9/9.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class KZHomeModel: LHSBaseModel {

    /// 首页图片
    var header_pic : String? = ""
    
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
