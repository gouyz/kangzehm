//
//  KZShouRuModel.swift
//  kangze
//  零售收入 model
//  Created by gouyz on 2018/9/11.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class KZShouRuModel: LHSBaseModel {

    /// 是否有记录
    var is_have : String?
    /// 总金额
    var total : String? = "0"
    ///
    var msg : String? = ""
    
    /// 详情列表
    var detailList: [KZShouRuChildModel]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "list"{
            detailList = [KZShouRuChildModel]()
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = KZShouRuChildModel(dict: dict)
                detailList?.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

/// 零售收入cell model
@objcMembers
class KZShouRuChildModel: LHSBaseModel {
    
    /// 姓名
    var buyer_name : String?
    /// 时间
    var payment_time : String?
    /// 零售金额
    var goods_pay_price : String? = "0"
    /// 商品名称
    var goods_name : String?
    /// 会员id
    var member_id : String?
    
    /// 头像的url
    var member_avatar : String?
    /// 手机号码
    var member_mobile : String?
    /// 会员类型
    var type_name : String? = "0"
    /// 是否完善信息 1.完善  0.没完善
    var is_shehe : String?
    /// 是否通过合伙人购买套餐认证 1.是  0.否
    var is_buydl : String?
}
