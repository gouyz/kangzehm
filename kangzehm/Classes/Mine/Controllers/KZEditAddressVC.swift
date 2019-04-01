//
//  KZEditAddressVC.swift
//  kangze
//  编辑、新增地址
//  Created by gouyz on 2018/9/5.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class KZEditAddressVC: GYZBaseVC {
    
    /// 选择结果回调
    var resultBlock:(() -> Void)?
    /// 是否新增地址
    var isAdd: Bool = false
    ///  性别 1男 2女
    var sex: String = "1"
    
    var selectProvinceModel: KZAreasModel?
    var selectCityModel: KZAreasModel?
    var selectAreaModel: KZAreasModel?
    /// 编辑时传过来
    var addressModel: KZMyAddressModel?
    ///  0：添加地址 大于0： 编辑地址
    var addressId: String = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kWhiteColor
        setUpUI()
        
        setData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(){
        nameView.textFiled.isSecureTextEntry = false
        addressView.textFiled.isSecureTextEntry = false
        
        if isAdd {
            self.navigationItem.title = "新增地址"
            manCheckBtn.isSelected = true
        }else{
            self.navigationItem.title = "编辑地址"
            nameView.textFiled.text = addressModel?.true_name
            sex = (addressModel?.sex)!
            if sex == "1" {/// 先生
                womanCheckBtn.isSelected = false
                manCheckBtn.isSelected = true
            } else {/// 女士
                manCheckBtn.isSelected = false
                womanCheckBtn.isSelected = true
            }
            phoneView.textFiled.text = addressModel?.mob_phone
            
            selectProvinceModel = KZAreasModel()
            selectProvinceModel?.area_name = addressModel?.province_name
            selectProvinceModel?.area_id = addressModel?.province_id
            
            selectCityModel = KZAreasModel()
            selectCityModel?.area_name = addressModel?.city_name
            selectCityModel?.area_id = addressModel?.city_id
            
            selectAreaModel = KZAreasModel()
            selectAreaModel?.area_name = addressModel?.area_name
            selectAreaModel?.area_id = addressModel?.area_id
            areasLab.text = (selectProvinceModel?.area_name)! + (selectCityModel?.area_name)! + (selectAreaModel?.area_name)!
            
            addressView.textFiled.text = addressModel?.address
        }
    }
    
    func setUpUI(){
        
        view.addSubview(nameView)
        view.addSubview(lineView)
        view.addSubview(manCheckBtn)
        view.addSubview(womanCheckBtn)
        view.addSubview(lineView1)
        view.addSubview(phoneView)
        view.addSubview(lineView2)
        view.addSubview(areasView)
        areasView.addSubview(areasDesLab)
        areasView.addSubview(areasLab)
        areasView.addSubview(rightIconView)
        view.addSubview(lineView4)
        view.addSubview(addressView)
        view.addSubview(lineView3)
        
        view.addSubview(submitBtn)
        
        nameView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(50)
            make.top.equalTo(kMargin + kTitleAndStateHeight)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(nameView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        manCheckBtn.snp.makeConstraints { (make) in
            make.right.equalTo(nameView.snp.centerX).offset(-kMargin)
            make.top.equalTo(lineView.snp.bottom)
            make.width.equalTo(60)
            make.height.equalTo(nameView)
        }
        womanCheckBtn.snp.makeConstraints { (make) in
            make.left.equalTo(nameView.snp.centerX).offset(kMargin)
            make.top.size.equalTo(manCheckBtn)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(manCheckBtn.snp.bottom)
        }
        phoneView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameView)
            make.top.equalTo(lineView1.snp.bottom)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(phoneView.snp.bottom)
        }
        areasView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameView)
            make.top.equalTo(lineView2.snp.bottom)
        }
        areasDesLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.bottom.equalTo(areasView)
            make.width.equalTo(80)
        }
        areasLab.snp.makeConstraints { (make) in
            make.left.equalTo(areasDesLab.snp.right).offset(kMargin)
            make.top.bottom.equalTo(areasDesLab)
            make.right.equalTo(rightIconView.snp.left).offset(-kMargin)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(areasView)
            make.right.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 7, height: 12))
        }
        lineView4.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(areasView.snp.bottom)
        }
        addressView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameView)
            make.top.equalTo(lineView4.snp.bottom)
        }
        lineView3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(addressView.snp.bottom)
        }
        submitBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(kBottomTabbarHeight)
            make.top.equalTo(lineView3.snp.bottom).offset(80)
        }
    }
    /// 联系人
    lazy var nameView : GYZLabAndFieldView = {
        let lab = GYZLabAndFieldView.init(desName: "联系人：", placeHolder: "请填写收货人的姓名", isPhone: false)
        
        return lab
    }()
    /// 线
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 先生
    lazy var manCheckBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.setTitle("先生", for: .normal)
        btn.setImage(UIImage.init(named: "icon_check"), for: .normal)
        btn.setImage(UIImage.init(named: "icon_check_selected"), for: .selected)
        btn.addTarget(self, action: #selector(radioBtnChecked(btn:)), for: .touchUpInside)
        btn.tag = 101
        
        return btn
    }()
    
    /// 女士
    lazy var womanCheckBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.setTitle("女士", for: .normal)
        btn.setImage(UIImage.init(named: "icon_check"), for: .normal)
        btn.setImage(UIImage.init(named: "icon_check_selected"), for: .selected)
        btn.addTarget(self, action: #selector(radioBtnChecked(btn:)), for: .touchUpInside)
        btn.tag = 102
        
        return btn
    }()
    /// 线
    lazy var lineView1: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 手机号
    lazy var phoneView : GYZLabAndFieldView = {
        let lab = GYZLabAndFieldView.init(desName: "手机号：", placeHolder: "请填写收货人手机号", isPhone: true)
        
        return lab
    }()
    /// 线
    lazy var lineView2: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 我的区域
    lazy var areasView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.addOnClickListener(target: self, action: #selector(onClickedSelectArea))
        
        return view
    }()
    
    ///
    lazy var areasDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "选择区域"
        
        return lab
    }()
    
    ///
    lazy var areasLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .right
        lab.text = "请选择区域"
        
        return lab
    }()
    
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    
    
    /// 分割线
    var lineView4 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 收货地址
    lazy var addressView : GYZLabAndFieldView = {
        let lab = GYZLabAndFieldView.init(desName: "收货地址：", placeHolder: "请填写收货地址", isPhone: false)
        
        return lab
    }()
    /// 线
    lazy var lineView3: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    
    /// 完成
    lazy var submitBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("完 成", for: .normal)
        btn.addTarget(self, action: #selector(clickedSubmitBtn), for: .touchUpInside)
        
        return btn
    }()
    /// 完成
    @objc func clickedSubmitBtn(){
        if nameView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入联系人")
            return
        }
        if phoneView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入手机号")
            return
        }
        if selectProvinceModel == nil || selectCityModel == nil || selectAreaModel == nil {
            MBProgressHUD.showAutoDismissHUD(message: "请选择区域")
            return
        }
        if addressView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入地址")
            return
        }
        
        requestAddAddress()
    }
    
    /// 选择先生/女士
    ///
    /// - Parameter btn:
    @objc func radioBtnChecked(btn: UIButton){
        let tag = btn.tag
        
        btn.isSelected = !btn.isSelected
        
        if tag == 101 {/// 先生
            sex = "1"
            womanCheckBtn.isSelected = false
        } else {/// 女士
            sex = "2"
            manCheckBtn.isSelected = false
        }
    }
    /// 选择区域
    @objc func onClickedSelectArea(){
        let vc = KZSelectAreaVC()
        vc.resultBlock = { [weak self] (provinceModel,cityModel,areaModel) in
            
            self?.selectProvinceModel = provinceModel
            self?.selectCityModel = cityModel
            self?.selectAreaModel = areaModel
            
            self?.areasLab.text = provinceModel.area_name! + cityModel.area_name! + areaModel.area_name!
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///编辑、添加地址
    func requestAddAddress(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member_address&op=address_add",parameters: ["address_id":addressId,"key": userDefaults.string(forKey: "key") ?? "","true_name": nameView.textFiled.text!,"mob_phone": phoneView.textFiled.text!,"address": addressView.textFiled.text!,"sex": sex,"province_id":(selectProvinceModel?.area_id)!,"city_id":(selectCityModel?.area_id)!,"area_id":(selectAreaModel?.area_id)!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                if weakSelf?.resultBlock != nil{
                    weakSelf?.resultBlock!()
                }
                weakSelf?.clickedBackBtn()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
