//
//  KZFriendCircleModel.swift
//  kangze
//  朋友圈model
//  Created by gouyz on 2018/9/13.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class KZFriendCircleModel: LHSBaseModel {
    /// id
    var id : String?
    /// 会员id
    var member_id : String?
    /// 朋友圈内容
    var content : String?
    /// 是否显示
    var is_show : String?
    /// 添加时间  "2018-08-27 11:07:30"
    var add_time : String?
    /// 会员名称
    var member_name : String?
    /// 会员头像
    var headpic : String? = ""
    
    /// 朋友圈图片列表
    var imageList: [String]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "image_list"{
            imageList = [String]()
            guard let datas = value as? [String] else { return }
            for item in datas {
                imageList?.append(item)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
