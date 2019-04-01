//
//  KZAreasModel.swift
//  kangze
//  区域model
//  Created by gouyz on 2018/9/9.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class KZAreasModel: LHSBaseModel {

    /// id
    var area_id : String?
    /// 名称
    var area_name : String?
    /// 是否被代理过   1，是    0，否
    var is_used : String? = "0"
}
