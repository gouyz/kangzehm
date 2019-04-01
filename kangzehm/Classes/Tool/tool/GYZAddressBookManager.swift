//
//  GYZAddressBookManager.swift
//  BenefitPet
//  通讯录Manager
//  iOS9之后，通讯录用CNContactStore实现；iOS9之前使用ABAddressBook
//  Created by gouyz on 2018/8/24.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import Contacts
import AddressBook


///通讯录model
@objcMembers
class AddressBookModel: LHSBaseModel {
    
    /// 姓名
    var name : String? = ""
    /// 电话
    var phone : String? = ""
}

enum AddressBookAuthorizationStatus:Int {
    case deniedOrRestricted = 1  //访问限制或者拒绝 弹出设置对话框
    case authorized = 2 //已授权,加载数据
    case notDeterMined = 3  //从未进行过授权操作、请求授权
}

class GYZAddressBookManager: NSObject {

    /// 单例
    class var sharedInstance: GYZAddressBookManager{
        struct Static {
            static var instance : GYZAddressBookManager = GYZAddressBookManager()
        }
        return Static.instance
    }
    
    //注意调用ABAddressBookCreateWithOptions进行ABAddressBookCreateWithOptions的初始化需要设置为一个lazy变量，否则在用户拒绝授权的情况下，程序将会崩溃。因为ABAddressBookCreateWithOptions(nil, nil)得到的值为nil。
    lazy var addressBook:ABAddressBook = {
        var emptyDictionary: CFDictionary?
        var errorRef: Unmanaged<CFError>?
        let ab:ABAddressBook = ABAddressBookCreateWithOptions(emptyDictionary, &errorRef).takeRetainedValue()
        return ab
    }()
    
    @available(iOS 9.0, *)
    lazy var contact:CNContactStore = CNContactStore()
    
    //获取当前系统版本号
    lazy var current_iOS_Version:String = {
        return UIDevice.current.systemVersion
    }()
    
    var originalAddressData:[AddressBookModel] = [] //用于存放通讯录里的原始有效数据
    
    //检测授权情况
    func cheackAddressBookAuthorizationStatus()->AddressBookAuthorizationStatus {
        
        if #available(iOS 9, *) {
            switch CNContactStore.authorizationStatus(for: .contacts) {
            case .denied,.restricted:
                return .deniedOrRestricted
            case .authorized:
                return .authorized
            case .notDetermined:
                return .notDeterMined
            }
        }else{
            switch ABAddressBookGetAuthorizationStatus() {
            case .denied,.restricted: //访问限制或者拒绝 弹出设置对话框
                return .deniedOrRestricted
            case .authorized://已授权,加载数据
                return .authorized
            case .notDetermined://从未进行过授权操作、请求授权
                return .notDeterMined
            }
        }
    }
    
    //请求授权
    func requestAddressBookAccess(_ success:@escaping ((_ granted:Bool )->Void)) {
        if #available(iOS 9, *){
            self.contact.requestAccess(for: .contacts, completionHandler: { (granted, error) in
                if !granted {
                    success(false)
                }else{
                    success(true)
                }
            })
        }else{
            ABAddressBookRequestAccessWithCompletion(self.addressBook) {(granted, error) in
                if !granted {
                    success(false)
                }else{
                    success(true)
                }
            }
        }
    }
    
    //谓词表达式判断手机号码是否有效
    func validateMobile(_ phoneNum:String)-> Bool {
        if phoneNum.count != 11 || phoneNum.count == 0 {
            return false
        }
        let mobile =  "^1[3-9]\\d{9}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let isValid:Bool = regexMobile.evaluate(with: phoneNum)
        if !isValid {
            return false
        }
        return true
    }
    
    //有的手机系统读取到的手机号都有'-',所以去除'-'
    func removeUnuseChar(str:String) -> String {
        var tmpStr = str
        for char in tmpStr {
            if char == "-" {
                let range = tmpStr.range(of: "-")
                tmpStr.removeSubrange(range!)
            }
        }
        return tmpStr
    }
    //原始有效数据
    func readRecords() -> [AddressBookModel]
    {
        self.originalAddressData.removeAll()
        if #available(iOS 9, *){
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName),CNContactPhoneNumbersKey] as [Any]
            
            try! self.contact.enumerateContacts(with: CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor]), usingBlock: {[weak self] (contact, pointer) in
                var phone = ""
                if contact.phoneNumbers.count > 0 {
                    let phoneNum = contact.phoneNumbers.first
                    
                    guard let phoneNumber = phoneNum?.value else {
                        return
                    }
                    
                    let phoneString = phoneNumber.stringValue
                    
                    let result = self?.removeUnuseChar(str: phoneString)
                    
                    if self!.validateMobile(result!) {
                        phone = result!
                    }
                    
                    if phone != "" {
                        let obj:AddressBookModel = AddressBookModel()
                        obj.phone = phone
                        let name:String = String(format: "%@%@", contact.givenName,contact.familyName)
                        obj.name = name
                        self?.originalAddressData.append(obj)
//                        print("CNContact：\(name):\(phone)")
                    }
                }
            })
            return originalAddressData
        }else{
            
            let peoples = ABAddressBookCopyArrayOfAllPeople(self.addressBook).takeRetainedValue() as [ABRecord]
            
            for people: ABRecord in peoples {
                var firstName = ""
                var lastName = ""
                var phone = ""
                
                if let firstNameUnmanaged = ABRecordCopyValue(people, kABPersonLastNameProperty) {
                    firstName = firstNameUnmanaged.takeRetainedValue() as? String ?? ""
                }
                if let lastNameUnmanaged = ABRecordCopyValue(people, kABPersonFirstNameProperty) {
                    lastName = lastNameUnmanaged.takeRetainedValue() as? String ?? ""
                }
                
                let phoneNums: ABMultiValue = ABRecordCopyValue(people, kABPersonPhoneProperty).takeRetainedValue() as ABMultiValue
                
                for index in 0..<ABMultiValueGetCount(phoneNums){
                    let label = ABMultiValueCopyValueAtIndex(phoneNums, index).takeRetainedValue() as! String
                    
                    let result = self.removeUnuseChar(str: label)
                    
                    if self.validateMobile(result) {
                        phone = result
                        break
                    }
                    
                }
                
                
                if phone != "" {
                    let obj:AddressBookModel = AddressBookModel()
                    obj.phone = phone
                    let name:String = String(format: "%@%@", lastName,firstName)
                    obj.name = name
                    self.originalAddressData.append(obj)
//                    print("ABAddressBook：\(name):\(phone)")
                }
                
            }
            return originalAddressData
        }
    }
    
    
}
