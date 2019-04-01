//
//  KZMyKuCunModel.swift
//  kangze
//  我的库存model
//  Created by gouyz on 2018/9/10.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class KZMyKuCunModel: LHSBaseModel {
    /// id
    var id : String?
    /// 会员id
    var member_id : String?
    /// 商品id
    var goods_id : String?
    /// 库存
    var stock : String?
    /// 商品名称
    var goods_name : String?
    /// 商品的缩略图片url
    var image_url : String?
    /// 单位
    var unit : String? = ""
}
