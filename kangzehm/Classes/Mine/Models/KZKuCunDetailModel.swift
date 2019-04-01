//
//  KZKuCunDetailModel.swift
//  kangze
//  库存明细model
//  Created by gouyz on 2018/9/12.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
@objcMembers
class KZKuCunDetailModel: LHSBaseModel {

    /// 是否有库存    1有  0没有
    var is_have : String?
    /// 总库存数
    var total : String? = "0"
    
    /// 详情列表
    var detailList: [KZKuCunChildModel]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "list"{
            detailList = [KZKuCunChildModel]()
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = KZKuCunChildModel(dict: dict)
                detailList?.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

/// 库存明细cell model
@objcMembers
class KZKuCunChildModel: LHSBaseModel {
    
    /// 库存数
    var stock : String? = "0"
    /// 商品
    var goods_name : String?
    /// 单位
    var unit : String? = ""
}
