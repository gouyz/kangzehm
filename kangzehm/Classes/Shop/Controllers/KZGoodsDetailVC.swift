//
//  KZGoodsDetailVC.swift
//  kangze
//  商品详情
//  Created by gouyz on 2018/8/29.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class KZGoodsDetailVC: GYZBaseVC {
    
    /// header 高度
    var headerViewH: CGFloat = kScreenWidth * 0.75 + 80 + kTitleHeight * 3
    
    var goodsId: String = ""
    var dataModel: KZGoodsModel?
    
    var selectProvinceModel: KZAreasModel?
    var selectCityModel: KZAreasModel?
    var selectAreaModel: KZAreasModel?

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationItem.title = "商品详情"
        navBarBgAlpha = 0
//        automaticallyAdjustsScrollViewInsets = false
        
        setLeftNavItem(imgName: "icon_back_white")
        
        view.addSubview(webView)
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        
        headerView.productView.addOnClickListener(target: self, action: #selector(onClickedProductView))
        headerView.areasView.addOnClickListener(target: self, action: #selector(onClickedAreasView))
        
        bottomView.favouriteBtn.addTarget(self, action: #selector(onClickedFavourite), for: .touchUpInside)
        
        bottomView.cartBtn.addTarget(self, action: #selector(onClickedAddCart), for: .touchUpInside)
        bottomView.shopBtn.addTarget(self, action: #selector(onClickedGoShop), for: .touchUpInside)
        bottomView.buyBtn.addTarget(self, action: #selector(onClickedBuyGoods), for: .touchUpInside)
        
        requestDetailDatas()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// 设置返回键
    func setLeftNavItem(imgName: String){
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedBackBtn))
    }
    
    lazy var headerView: KZGoodsDetailHeaderView = KZGoodsDetailHeaderView.init(frame: CGRect.zero)
    
    /// 加载富文本 商品详情
    lazy var webView: WKWebView = {
        let webView = WKWebView.init(frame: CGRect.init(x: 0, y: -kTitleAndStateHeight, width: kScreenWidth, height: kScreenHeight + kTitleAndStateHeight - kBottomTabbarHeight))
        ///设置透明背景
        webView.backgroundColor = UIColor.white
        webView.isOpaque = false
        
        webView.scrollView.bouncesZoom = false
//        webView.scrollView.bounces = false
        webView.scrollView.alwaysBounceHorizontal = false
        
        webView.navigationDelegate = self
        
//        webView.scrollView.contentInset = UIEdgeInsets.init(top: headerViewH, left: 0, bottom: 0, right: 0)
        webView.scrollView.delegate = self
        
        webView.scrollView.addSubview(headerView)
        
        return webView
    }()
    
    /// 底部View
    lazy var bottomView: KZGoodDetailBottomView = KZGoodDetailBottomView()
    
    /// 产品参数
    @objc func onClickedProductView(){
        let paramView = KZGoodsParamsView()
        paramView.dataModel = dataModel?.attr
        paramView.show()
    }
    /// 我的区域
    @objc func onClickedAreasView(){
        
        let vc = KZSelectAreaVC()
        vc.goodsId = (dataModel?.goods_id)!
        vc.resultBlock = { [weak self] (provinceModel,cityModel,areaModel) in
            
            self?.selectProvinceModel = provinceModel
            self?.selectCityModel = cityModel
            self?.selectAreaModel = areaModel
            
            self?.headerView.areasLab.text = provinceModel.area_name! + cityModel.area_name! + areaModel.area_name!
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///获取详情数据
    func requestDetailDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("goods&op=goods_detail_kz",parameters: ["goods_id":goodsId,"key": userDefaults.string(forKey: "key") ?? ""],method : .get,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["datas"].dictionaryObject else { return }
                weakSelf?.dataModel = KZGoodsModel.init(dict: data)
                weakSelf?.setData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    func setData(){
        if !(dataModel?.goods_type == "2" && dataModel?.attr?.is_area == "1") {// 合伙人套餐并且需要显示选择区域是才显示区域
            headerViewH = kScreenWidth * 0.75 + 80 + kTitleHeight * 2
            headerView.areasView.isHidden = true
            headerView.areasView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }

        }
        
        webView.scrollView.contentInset = UIEdgeInsets.init(top: headerViewH, left: 0, bottom: 0, right: 0)
        headerView.frame = CGRect.init(x: 0, y: -headerViewH, width: kScreenWidth, height: headerViewH)
        
        headerView.iconView.kf.setImage(with: URL.init(string: (dataModel?.goods_image)!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        headerView.nameLab.text = dataModel?.goods_name
        headerView.priceLab.text = "￥" + (dataModel?.goods_price)!
//        headerView.typeLab.text = dataModel?.member_type_name
//        headerView.saleLab.text = "月销：" + (dataModel?.month_sell_count)! + "件"
        
        if !(dataModel?.mobile_body?.isEmpty)! {
            webView.loadHTMLString((dataModel?.mobile_body)!.dealFuTextImgSize(), baseURL: nil)
        }
        
        if dataModel?.is_collect == "0" {// 是否收藏
            bottomView.favouriteBtn.set(image: UIImage.init(named: "icon_favorite_rating"), title: "收藏", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
            bottomView.favouriteBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
        }else{
            bottomView.favouriteBtn.set(image: UIImage.init(named: "icon_favorite_rating_selected"), title: "收藏", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
            bottomView.favouriteBtn.setTitleColor(kBlueFontColor, for: .normal)
        }
    }
    /// 收藏
    @objc func onClickedFavourite(){
        
        if !userDefaults.bool(forKey: kIsLoginTagKey) {
            showLogin()
            return
        }
        // 是否收藏
        if dataModel?.is_collect == "0" {
            requestFavouriteGoods()
        }else{
            showCancleFavourite()
        }
    }
    
    /// 立即购买
    @objc func onClickedBuyGoods(){
        
        if !userDefaults.bool(forKey: kIsLoginTagKey) {
            showLogin()
            return
        }
        
        if dataModel?.goods_type == "2"  && dataModel?.attr?.is_area == "1" {// 合伙人套餐
            if selectProvinceModel == nil{
                MBProgressHUD.showAutoDismissHUD(message: "请选择区域")
                return
            }
        }
        /// 普通商品 ：都可以买（不限制）
        /// 合伙人商品  :实名认证
        /// 续货型套餐 :购买了合伙人套餐+实名认证
        if dataModel?.goods_type == "2" {//合伙人套餐
            let status: String = (dataModel?.member?.sm_status)!
            //0 您还未实名认证，认证后才能享受合伙人制度！ 1 您的实名资料正在审核中！   2(无提示)    3 您的实名资料被拒绝！
            if status == "0"{
                showRealNameConfirm(isBuy: true)
                return
            }else if status == "1"{
                showRealNameConfirmShenHe(isBuy: true)
                return
            }else if status == "3"{
                showReViewRealNameConfirm(isBuy: true)
                return
            }
        }else if dataModel?.goods_type == "3" {//续货型套餐
            if dataModel?.member?.is_buydl == "0" || dataModel?.member?.sm_status != "2"{
                showProfile()
                return
            }
        }
        
        submitOrder()
        
    }
    /// 立即购买
    func submitOrder(){
        let vc = KZSubmitOrderVC()
        vc.cartIds = (dataModel?.goods_id)! + "|1"
        vc.totalNum = 1
        
        if selectProvinceModel != nil {
            vc.selectProvinceModel = selectProvinceModel
            vc.selectCityModel = selectCityModel
            vc.selectAreaModel = selectAreaModel
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 显示完善个人信息
    func showProfile(){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "完善个人信息", message: "请前往个人中心完善个人信息", cancleTitle: "取消", viewController: self, buttonTitles: "前往") { (index) in
            
            if index != cancelIndex{
                weakSelf?.goConfirmProfile()
            }
        }
    }
    /// 显示实名认证 重新认证
    func showReViewRealNameConfirm(isBuy: Bool){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "您的实名资料被拒绝！", cancleTitle: "取消", viewController: self, buttonTitles: "继续购买","重新认证") { (index) in
            
            if index != cancelIndex{
                if index == 0{
                    if isBuy{//继续购买
                        weakSelf?.submitOrder()
                    }else{
                        weakSelf?.addCart()
                    }
                }else{
                    weakSelf?.goRealNameConfirm()
                }
                
            }
        }
    }
    /// 显示实名认证
    func showRealNameConfirm(isBuy: Bool){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "您还未实名认证，认证后才能享受合伙人制度！", cancleTitle: "取消", viewController: self, buttonTitles: "继续购买","前往认证") { (index) in
            
            if index != cancelIndex{
                if index == 0{
                    if isBuy{//继续购买
                        weakSelf?.submitOrder()
                    }else{
                        weakSelf?.addCart()
                    }
                }else{
                    weakSelf?.goRealNameConfirm()
                }
                
            }
        }
    }
    
    /// 显示实名认证 审核中
    func showRealNameConfirmShenHe(isBuy: Bool){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "您的实名资料正在审核中", cancleTitle: "取消", viewController: self, buttonTitles: "继续购买") { (index) in
            
            if index != cancelIndex{
                if isBuy{//继续购买
                    weakSelf?.submitOrder()
                }else{
                    weakSelf?.addCart()
                }
            }
        }
    }
    /// 完善个人信息
    func goConfirmProfile(){
        let vc = KZConfirmHeHuoRenVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 实名认证
    func goRealNameConfirm(){
        let vc = KZRealNameConfirmVC()
        vc.resultBlock = { [weak self] in
            self?.dataModel?.member?.sm_status = "1"
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCancleFavourite(){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "取消收藏", message: "确定要取消收藏吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
            
            if index != cancelIndex{
                weakSelf?.requestCancleFavouriteGoods()
            }
        }
    }
    
    func showLogin(){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "请先登录", cancleTitle: nil, viewController: self, buttonTitles: "去登录") { (index) in
            
            if index != cancelIndex{
                weakSelf?.goLogin()
            }
        }
    }
    func goLogin(){
        let vc = BPLoginVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 去商城
    @objc func onClickedGoShop(){
        self.tabBarController?.selectedIndex = 1
        navigationController?.popToRootViewController(animated: true)
    }
    /// 添加购物车
    @objc func onClickedAddCart(){
        if !userDefaults.bool(forKey: kIsLoginTagKey) {
            showLogin()
            return
        }
        /// 普通商品 ：都可以买（不限制）
        /// 合伙人商品  :实名认证
        /// 续货型套餐 :购买了合伙人套餐+实名认证
        if dataModel?.goods_type == "2" {//合伙人套餐
            let status: String = (dataModel?.member?.sm_status)!
            //0 您还未实名认证，认证后才能享受合伙人制度！ 1 您的实名资料正在审核中！   2(无提示)    3 您的实名资料被拒绝！
            if status == "0"{
                showRealNameConfirm(isBuy: false)
                return
            }else if status == "1"{
                showRealNameConfirmShenHe(isBuy: false)
                return
            }else if status == "3"{
                showReViewRealNameConfirm(isBuy: false)
                return
            }
        }else if dataModel?.goods_type == "3" {//续货型套餐
            if dataModel?.member?.is_buydl == "0" || dataModel?.member?.sm_status != "2"{
                showProfile()
                return
            }
        }
        addCart()
    }
    /// 添加购物车
    func addCart(){
        if Int((dataModel?.goods_storage)!) > 0 {
            requestAddCart()
        }else{
            MBProgressHUD.showAutoDismissHUD(message: "库存不足")
        }
    }
    ///商品收藏
    func requestFavouriteGoods(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member_favorites&op=favorites_add",parameters: ["goods_id":goodsId,"key": userDefaults.string(forKey: "key") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                MBProgressHUD.showAutoDismissHUD(message: "收藏成功")
                weakSelf?.dataModel?.is_collect = "1"
                weakSelf?.bottomView.favouriteBtn.set(image: UIImage.init(named: "icon_favorite_rating_selected"), title: "收藏", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
                weakSelf?.bottomView.favouriteBtn.setTitleColor(kBlueFontColor, for: .normal)
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    ///商品取消收藏
    func requestCancleFavouriteGoods(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member_favorites&op=favorites_del",parameters: ["fav_id":goodsId,"key": userDefaults.string(forKey: "key") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.dataModel?.is_collect = "0"
                weakSelf?.bottomView.favouriteBtn.set(image: UIImage.init(named: "icon_favorite_rating"), title: "收藏", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
                weakSelf?.bottomView.favouriteBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///添加购物车
    func requestAddCart(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        var dic: [String: String] = ["goods_id":goodsId,"key": userDefaults.string(forKey: "key") ?? "","quantity":"1"]
        if dataModel?.goods_type == "2" && dataModel?.attr?.is_area == "1" {// 合伙人套餐
            if selectProvinceModel == nil{
                MBProgressHUD.showAutoDismissHUD(message: "请选择区域")
                return
            }
            dic["provinceid"] = selectProvinceModel?.area_id!
            dic["cityid"] = selectCityModel?.area_id!
            dic["areaid"] = selectAreaModel?.area_id!
        }
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member_cart&op=cart_add",parameters: dic,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                MBProgressHUD.showAutoDismissHUD(message: "成功加入购物车")
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension KZGoodsDetailVC : WKNavigationDelegate,UIScrollViewDelegate{
    ///MARK WKNavigationDelegate
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        /// 获取网页title
        //        self.title = self.webView.title
        //        self.hud?.hide(animated: true)
        
//        tableView.reloadData()
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        //        self.hud?.hide(animated: true)
    }
    
    //MARK:UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetY = scrollView.contentOffset.y
        let showNavBarOffsetY = -kScreenWidth * 0.75 - topLayoutGuide.length
        
        
        //navigationBar alpha
        if contentOffsetY > showNavBarOffsetY  {
            
            var navAlpha = (contentOffsetY - (showNavBarOffsetY)) / 40.0
            if navAlpha > 1 {
                navAlpha = 1
            }
            navBarBgAlpha = navAlpha
            self.navigationItem.title = "商品详情"
            setLeftNavItem(imgName: "icon_back")
        }else{
            navBarBgAlpha = 0
            self.navigationItem.title = ""
            setLeftNavItem(imgName: "icon_back_white")
        }
    }
}

