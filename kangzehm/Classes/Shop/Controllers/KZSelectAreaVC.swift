//
//  KZSelectAreaVC.swift
//  kangze
//  区域选择
//  Created by gouyz on 2018/9/7.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class KZSelectAreaVC: GYZBaseVC {
    
    /// 选择结果回调
    var resultBlock:((_ proviceModel: KZAreasModel,_ cityModel: KZAreasModel,_ areaModel: KZAreasModel) -> Void)?
    
    var provinceList: [KZAreasModel] = [KZAreasModel]()
    var cityList: [KZAreasModel] = [KZAreasModel]()
    var areaList: [KZAreasModel] = [KZAreasModel]()
    ///area_id=0 获取所有一级地区（省和直辖市）
    var areaId: String = "0"
    ///如果不需要验证代理区域的话，可以为0
    var goodsId: String = "0"
    
    var selectProvinceModel: KZAreasModel?
    var selectCityModel: KZAreasModel?
    var selectAreaModel: KZAreasModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "区域选择"
        self.view.backgroundColor = kWhiteColor
        
        setupUI()
        
        requestGoodsDatas(type: "1")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        
        view.addSubview(desLab)
        view.addSubview(provinceView)
        provinceView.addSubview(provinceLab)
        provinceView.addSubview(arrowImgView1)
        
        view.addSubview(cityView)
        cityView.addSubview(cityLab)
        cityView.addSubview(arrowImgView2)
        
        view.addSubview(areaView)
        areaView.addSubview(areaLab)
        areaView.addSubview(arrowImgView3)
        
        view.addSubview(saveBtn)
        
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin + kTitleAndStateHeight)
            make.right.equalTo(-kMargin)
            make.height.equalTo(kTitleHeight)
        }
        
        provinceView.snp.makeConstraints { (make) in
            make.top.equalTo(desLab.snp.bottom).offset(kMargin)
            make.left.equalTo(desLab)
            make.height.equalTo(30)
            make.width.equalTo(cityView)
        }
        cityView.snp.makeConstraints { (make) in
            make.top.height.equalTo(provinceView)
            make.left.equalTo(provinceView.snp.right).offset(30)
            make.width.equalTo(areaView)
        }
        areaView.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(provinceView)
            make.left.equalTo(cityView.snp.right).offset(30)
            make.right.equalTo(-kMargin)
        }
        
        provinceLab.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.right.equalTo(arrowImgView1.snp.left).offset(-5)
            make.top.bottom.equalTo(provinceView)
        }
        arrowImgView1.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.centerY.equalTo(provinceView)
            make.size.equalTo(CGSize.init(width: 7, height: 4))
        }
        cityLab.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.right.equalTo(arrowImgView2.snp.left).offset(-5)
            make.top.bottom.equalTo(cityView)
        }
        arrowImgView2.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.centerY.equalTo(cityView)
            make.size.equalTo(CGSize.init(width: 7, height: 4))
        }
        areaLab.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.right.equalTo(arrowImgView3.snp.left).offset(-5)
            make.top.bottom.equalTo(areaView)
        }
        arrowImgView3.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.centerY.equalTo(areaView)
            make.size.equalTo(CGSize.init(width: 7, height: 4))
        }
        
        saveBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(kUIButtonHeight)
        }
    }
    
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "选择我的区域"
        
        return lab
    }()

    lazy var provinceView: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        view.cornerRadius = kCornerRadius
        view.tag = 101
        view.addOnClickListener(target: self, action: #selector(onClickedSelect(sender:)))
        
        return view
    }()
    /// 省
    lazy var provinceLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "选择省"
        
        return lab
    }()
    lazy var arrowImgView1: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_arrow_down"))
    
    lazy var areaView: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        view.cornerRadius = kCornerRadius
        view.tag = 103
        view.addOnClickListener(target: self, action: #selector(onClickedSelect(sender:)))
        
        return view
    }()
    /// 区
    lazy var areaLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "选择区"
        
        return lab
    }()
    lazy var arrowImgView3: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_arrow_down"))
    
    lazy var cityView: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        view.cornerRadius = kCornerRadius
        view.tag = 102
        view.addOnClickListener(target: self, action: #selector(onClickedSelect(sender:)))
        
        return view
    }()
    /// 市
    lazy var cityLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "选择市"
        
        return lab
    }()
    lazy var arrowImgView2: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_arrow_down"))
    
    /// 确认
    lazy var saveBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.cornerRadius = kCornerRadius
        btn.setTitle("确认", for: .normal)
        btn.addTarget(self, action: #selector(clickedSaveBtn), for: .touchUpInside)
        
        return btn
    }()
    /// 确认
    @objc func clickedSaveBtn(){
        
        if selectProvinceModel == nil {
            MBProgressHUD.showAutoDismissHUD(message: "请选择省")
            return
        }
        if selectCityModel == nil {
            MBProgressHUD.showAutoDismissHUD(message: "请选择市")
            return
        }
        if selectAreaModel == nil {
            MBProgressHUD.showAutoDismissHUD(message: "请选择区")
            return
        }
        if resultBlock != nil {
            resultBlock!(selectProvinceModel!,selectCityModel!,selectAreaModel!)
        }
        clickedBackBtn()
    }
    
    /// 选择省市区
    @objc func onClickedSelect(sender: UITapGestureRecognizer){
        
        let tag: Int = (sender.view?.tag)!
        
        switch tag {
        case 101:
            areaId = "0"
            showAreaView(type: "1")
        case 102:
            if selectProvinceModel == nil {
                MBProgressHUD.showAutoDismissHUD(message: "请先选择省")
                return
            }
            areaId = (selectProvinceModel?.area_id)!
            requestGoodsDatas(type: "2")
        case 103:
            if selectCityModel == nil {
                MBProgressHUD.showAutoDismissHUD(message: "请先选择市")
                return
            }
            areaId = (selectCityModel?.area_id)!
            requestGoodsDatas(type: "3")
        default:
            break
        }
    
    }
    /// - Parameter type: 1.省2.市3.区
    func showAreaView(type: String){
        let selectView = KZSelectAreaView()
        
        if type == "1"{
            selectView.dataModels = provinceList
        }else if type == "2"{
            selectView.dataModels = cityList
        }else if type == "3"{
            selectView.dataModels = areaList
        }
        
        selectView.resultBlock = {[weak self] (model) in
            
            if type == "1"{
                self?.selectProvinceModel = model
                self?.provinceLab.text = model.area_name
            }else if type == "2"{
                self?.selectCityModel = model
                self?.cityLab.text = model.area_name
            }else if type == "3"{
                self?.selectAreaModel = model
                self?.areaLab.text = model.area_name
            }
            
        }
        selectView.show()
    }
    
    ///获取数据
    ///
    /// - Parameter type: 1.省2.市3.区
    func requestGoodsDatas(type: String){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("area&op=area_list",parameters: ["area_id":areaId,"goods_id":goodsId],method : .get,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["datas"]["area_list"].array else { return }
                
                
                var areaArr: [KZAreasModel] = [KZAreasModel]()
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = KZAreasModel.init(dict: itemInfo)
                    
                    areaArr.append(model)
                }
                
                if type == "1"{
                    weakSelf?.provinceList.removeAll()
                    weakSelf?.provinceList = areaArr
                }else if type == "2"{
                    weakSelf?.cityList.removeAll()
                    weakSelf?.cityList = areaArr
                    weakSelf?.showAreaView(type: "2")
                }else if type == "3"{
                    weakSelf?.areaList.removeAll()
                    weakSelf?.areaList = areaArr
                    weakSelf?.showAreaView(type: "3")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            
        })
    }

}
