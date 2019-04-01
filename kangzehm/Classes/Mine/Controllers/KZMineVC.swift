//
//  KZMineVC.swift
//  kangze
//  我的
//  Created by gouyz on 2018/8/28.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON

private let mineCell = "mineCell"

class KZMineVC: GYZBaseVC {
    
    ///工作平台模块
    var menuModels: [KZMineModel] = [KZMineModel]()
    /// 选择用户头像
    var selectUserImg: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        navBarBgAlpha = 0
        automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = kWhiteColor
        
        ///读取功能模块
        let plistPath : String = Bundle.main.path(forResource: "mineMenuData", ofType: "plist")!
        let menuArr : [[String:String]] = NSArray(contentsOfFile: plistPath) as! [[String : String]]
        
        for item in menuArr {
            let model = KZMineModel.init(dict: item)
            menuModels.append(model)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            if #available(iOS 11.0, *) {
                make.top.equalTo(-kTitleAndStateHeight)
            }else{
                make.top.equalTo(0)
            }
            make.left.right.equalTo(view)
            make.bottom.equalTo(-kBottomTabbarHeight)
        }
        
        tableView.tableHeaderView = userHeaderView
        
        userHeaderView.bgView.addOnClickListener(target: self, action: #selector(onClickedLogin))
        userHeaderView.userHeaderView.addOnClickListener(target: self, action: #selector(onClickedUpdateHeader))
        userHeaderView.leftView.addOnClickListener(target: self, action: #selector(onClickedFavourite))
        userHeaderView.rightView.addOnClickListener(target: self, action: #selector(onClickedKuCun))
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if userDefaults.bool(forKey: kIsLoginTagKey) {
            requestMineData()
        }else{
            setEmptyHeaderData()
        }
    }
    
    
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
//        table.bounces = false
        
        table.register(GYZCommonIconArrowCell.self, forCellReuseIdentifier: mineCell)
        
        return table
    }()
    
    lazy var userHeaderView: KZMineHeaderView = KZMineHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 0.49 + kStateHeight))
    
    
    /// 获取我的 数据
    func requestMineData(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member_index&op=member_indexkz", parameters: ["key": userDefaults.string(forKey: "key") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            //            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.setHeaderData(data: response["datas"])
                
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 设置header
    func setHeaderData(data: JSON){
        userHeaderView.nameLab.text = data["user_name"].string
        userHeaderView.userHeaderView.kf.setImage(with: URL.init(string: data["avatar"].stringValue), placeholder: UIImage.init(named: "icon_header_default"), options: nil, progressBlock: nil, completionHandler: nil)
        userHeaderView.typeLab.text = data["type_name"].string
        userHeaderView.phoneLab.text = data["member_mobile"].string
        userHeaderView.favouriteNumberLab.text = data["fav_count"].stringValue
        userHeaderView.kuCunNumberLab.text = data["stock"].stringValue
        
        userDefaults.set(data["is_shehe"].stringValue, forKey: "is_shehe")//是否完成实名认证
        userDefaults.set(data["is_buydl"].stringValue, forKey: "is_buydl")//是否完成合伙人套餐购买认证   1.是     0.否
    }
    
    ///
    func setEmptyHeaderData(){
        userHeaderView.nameLab.text = "登录/注册"
        userHeaderView.userHeaderView.image = UIImage.init(named: "icon_header_default")
        userHeaderView.typeLab.text = "会员"
        userHeaderView.phoneLab.text = "手机号"
        userHeaderView.favouriteNumberLab.text = "0"
        userHeaderView.kuCunNumberLab.text = "0"
        
    }
    
    /// 未登录时，点击登录
    @objc func onClickedLogin(){
        
        if userDefaults.bool(forKey: kIsLoginTagKey) {
            onClickedUpdateHeader()
        }else {
            goLogin()
        }
        
    }
    /// 登录
    func goLogin(){
        let vc = BPLoginVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 商品收藏
    @objc func onClickedFavourite(){
        let vc = KZGoodsFavouriteVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 库存
    @objc func onClickedKuCun(){
        let vc = KZMyKuCunVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 修改头像
    @objc func onClickedUpdateHeader(){
        if userDefaults.bool(forKey: kIsLoginTagKey) {
            GYZOpenCameraPhotosTool.shareTool.choosePicture(self, editor: true, finished: { [weak self] (image) in
                
                self?.selectUserImg = image
                self?.userHeaderView.userHeaderView.image = image
                self?.requestUpdateHeaderImg()
            })
        }else {
            goLogin()
        }
        
    }
    ///控制跳转
    func goController(menu: KZMineModel){
        //1:动态获取命名空间
        guard let name = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            GYZLog("获取命名空间失败")
            return
        }
        
        let cls: AnyClass? = NSClassFromString(name + "." + menu.controller!) //VCName:表示试图控制器的类名
        
        // Swift中如果想通过一个Class来创建一个对象, 必须告诉系统这个Class的确切类型
        guard let typeClass = cls as? GYZBaseVC.Type else {
            GYZLog("cls不能当做UIViewController")
            return
        }
        
        let controller = typeClass.init()
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    /// 上传头像
    func requestUpdateHeaderImg(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        let imgParam: ImageFileUploadParam = ImageFileUploadParam()
        imgParam.name = "image"
        imgParam.fileName = "idCardImg.png"
        imgParam.mimeType = "image/png"
        imgParam.data = UIImageJPEGRepresentation(selectUserImg, 0.5)
        
        GYZNetWork.uploadImageRequest("upload&op=headpic_upload", uploadParam: [imgParam], success: { (response) in
            
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.requestUpdateUrl(url:response["datas"]["img"].stringValue)
                
            }else{
                weakSelf?.hud?.hide(animated: true)
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 修改头像
    func requestUpdateUrl(url: String){
    
        weak var weakSelf = self
        
        GYZNetWork.requestNetwork("member&op=check_member_avatar", parameters: ["key": userDefaults.string(forKey: "key") ?? "","member_avatar":url],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
}

extension KZMineVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: mineCell) as! GYZCommonIconArrowCell
        
        let model = menuModels[indexPath.row]
        cell.iconView.image = UIImage.init(named: model.image!)
        cell.nameLab.text = model.title
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        goController(menu: menuModels[indexPath.row])
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    //MARK:UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetY = scrollView.contentOffset.y
        let showNavBarOffsetY = kTitleAndStateHeight + kStateHeight - topLayoutGuide.length
        
        
        //navigationBar alpha
        if contentOffsetY > showNavBarOffsetY  {
            
            var navAlpha = (contentOffsetY - (showNavBarOffsetY)) / 40.0
            if navAlpha > 1 {
                navAlpha = 1
            }
            navBarBgAlpha = navAlpha
            self.navigationItem.title = "我的"
        }else{
            navBarBgAlpha = 0
            self.navigationItem.title = ""
        }
    }
}

