//
//  KZMyAddressModel.swift
//  kangze
//  我的地址
//  Created by gouyz on 2018/9/9.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class KZMyAddressModel: LHSBaseModel {
    /// id
    var address_id : String?
    /// 会员id
    var member_id : String?
    /// 会员姓名
    var true_name : String?
    /// 会员详细地址
    var address : String?
    /// 收货人电话
    var mob_phone : String?
    /// 是否是默认地址
    var is_default : String?
    /// 性别
    var sex : String?
    /// 省
    var province_name : String? = ""
    /// 市
    var city_name : String? = ""
    /// 区
    var area_name : String? = ""
    /// 省id
    var province_id : String?
    /// 市id
    var city_id : String?
    /// 区id
    var area_id : String?
}
