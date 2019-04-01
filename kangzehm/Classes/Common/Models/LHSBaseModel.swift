//
//  LHSBaseModel.swift
//  LazyHuiService
//  封装model基类
//  Created by gouyz on 2017/6/27.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

///
/// 在swift3中，编译器自动推断@objc，换句话说，它自动添加@objc
/// 在swift4中，编译器不再自动推断，你必须显式添加@objc
/// 还有一种更简单的方法，不必一个一个属性的添加,下面这种写法
/// @objcMembers
/// class Test {
///
/// }

class LHSBaseModel: NSObject {

    override init() {
        
    }
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if value == nil {//字段为null不做填充，防止为null报错,设置值为空
            super.setValue("", forKey: key)
            return
        }
        ///此处对每个字段进行字符串格式化，防止数据类型不是string时报错
        super.setValue(String.init(format: "%@", value as! CVarArg), forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
