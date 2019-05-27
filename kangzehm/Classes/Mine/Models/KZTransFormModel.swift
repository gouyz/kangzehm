//
//  KZTransFormModel.swift
//  kangzehm
//  转让model
//  Created by gouyz on 2019/5/27.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class KZTransFormModel: LHSBaseModel {
    /// id
    var log_id : String?
    /// 转出描述
    var log_msg : String?
    ///  转出时间
    var log_time : String?
    ///  转出对方手机号
    var log_to_mobile : String?
    /// 转让数量
    var log_num : String?
    ///  转入对方手机号
    var log_mobile : String?
}
