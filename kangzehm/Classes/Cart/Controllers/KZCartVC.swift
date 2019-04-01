//
//  KZCartVC.swift
//  kangze
//  购物车
//  Created by gouyz on 2018/8/28.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let cartCell = "cartCell"

class KZCartVC: GYZBaseVC {
    
    var cartModel: KZCartModel?
    /// 选择购物车商品
    var selectGoods: [String : KZCartGoodsModel] = [String : KZCartGoodsModel]()
    /// 是否全选
    var isAllSelected: Bool = false
    /// 总金额
    var totalMoney: Double = 0.00
    /// 总数量
    var totalNum: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "购物车"
        
        view.addSubview(tableView)
        view.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)

            make.bottom.equalTo(view)
            make.height.equalTo(kTitleHeight)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(bottomView.snp.top)
            }else{
                make.bottom.equalTo(-kTitleHeight)
            }
        }
        
        bottomView.jieSuanLab.addOnClickListener(target: self, action: #selector(onClickedJieSuan))
        bottomView.checkView.addOnClickListener(target: self, action: #selector(onClickedAllSelect))
        
        setBottomData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        cartModel = nil
        totalMoney = 0.0
        totalNum = 0
        selectGoods.removeAll()
        setBottomData()
        tableView.reloadData()
        requestCartDatas()
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        
        table.register(KZCartCell.self, forCellReuseIdentifier: cartCell)
        
        return table
    }()
    /// 底部View
    lazy var bottomView: KZCartBottomView = KZCartBottomView()
    
    /// 结算
    @objc func onClickedJieSuan(){
        if selectGoods.count > 0 {
            var cartIds: String = ""
            for item in selectGoods.values {
                cartIds += item.cart_id! + "|" + item.goods_num! + ","
            }
            cartIds = cartIds.subString(start: 0, length: cartIds.count - 1)
            
            let vc = KZSubmitOrderVC()
            vc.isCart = "1"
            vc.cartIds = cartIds
            vc.totalNum = totalNum
            navigationController?.pushViewController(vc, animated: true)
        }else{
            MBProgressHUD.showAutoDismissHUD(message: "请选择要结算的商品")
        }
        
    }
    
    /// 全选
    @objc func onClickedAllSelect(){
        isAllSelected = !isAllSelected
        
        selectGoods.removeAll()
        totalNum = 0
        totalMoney = 0.00
        
        if isAllSelected {//全选
            for item in (cartModel?.goodList)! {
                selectGoods[item.cart_id!] = item
                totalNum += Int(item.goods_num!)!
                totalMoney += Double(item.goods_price!)! * Double(item.goods_num!)!
            }
            bottomView.checkView.tagImgView.image = UIImage.init(named: "icon_check_selected")
        }else{
            bottomView.checkView.tagImgView.image = UIImage.init(named: "icon_check")
        }
        tableView.reloadData()
        setBottomData()
    }
    /// 设置底部数据
    func setBottomData(){
        let total: String = "合计：￥" + String(format:"%.2f",totalMoney)
        let totalAttr : NSMutableAttributedString = NSMutableAttributedString(string: total)
        totalAttr.addAttribute(NSAttributedStringKey.foregroundColor, value: kBlackFontColor, range: NSMakeRange(0, 3))
        bottomView.totalLab.attributedText = totalAttr
        
        bottomView.jieSuanLab.text = "结算(\(totalNum))"
    }
    
    ///获取购物车数据
    func requestCartDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("member_cart&op=cart_list",parameters: ["key": userDefaults.string(forKey: "key") ?? ""],method : .post,  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["datas"]["cart_list"].array else { return }
                
                if data.count > 0{
                    guard let itemInfo = data[0].dictionaryObject else { return }
                    weakSelf?.cartModel = KZCartModel.init(dict: itemInfo)
                }
                if weakSelf?.cartModel?.goodList?.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "购物车是空的~")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestCartDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    /// 添加商品
    @objc func didClickAddBtn(sender: UITapGestureRecognizer){
        
        let tag = sender.view?.tag
        let model = cartModel?.goodList![tag!]
        let num: Int = Int((model?.goods_num)!)! + 1
        
        requestGoodsNumber(model: model!, num: "\(num)", index: tag!,isAdd:true)
    }
    /// 减商品
    @objc func didClickMinusBtn(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        let model = cartModel?.goodList![tag!]
        let num: Int = Int((model?.goods_num)!)! - 1
        
        if num == 0 {
            MBProgressHUD.showAutoDismissHUD(message: "已减至最小数量")
            return
        }
        
        requestGoodsNumber(model: model!, num: "\(num)", index: tag!,isAdd:false)
    }
    
    /// 选择商品
    @objc func onClickedCheckGoods(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        let model = cartModel?.goodList![tag!]
        let cartId: String = (model?.cart_id)!
        
        if selectGoods.keys.contains(cartId) {
            selectGoods.removeValue(forKey: cartId)
            totalNum -= Int((model?.goods_num)!)!
            totalMoney -= Double((model?.goods_price)!)! * Double((model?.goods_num)!)!
        }else{
            selectGoods[cartId] = model
            
            totalNum += Int((model?.goods_num)!)!
            totalMoney += Double((model?.goods_price)!)! * Double((model?.goods_num)!)!
        }
        
        /// 全选
        if selectGoods.count == cartModel?.goodList?.count {
            isAllSelected = true
            bottomView.checkView.tagImgView.image = UIImage.init(named: "icon_check_selected")
        }else{
            isAllSelected = false
            bottomView.checkView.tagImgView.image = UIImage.init(named: "icon_check")
        }
        tableView.reloadRows(at: [IndexPath.init(row: tag!, section: 0)], with: .none)
        setBottomData()
    }
    
    /// 删除
    @objc func onClickedDeleteGoods(sender: UITapGestureRecognizer){
        let tag: Int = (sender.view?.tag)!
        let model = cartModel?.goodList![tag]
        
        showDeleteView(model: model!, rowIndex: tag)
    }
    /// 删除
    func showDeleteView(model: KZCartGoodsModel,rowIndex: Int){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "删除购物车商品", message: "确定要删除该商品吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
            
            if index != cancelIndex{
                weakSelf?.requestDeleteGoods(model: model, index: rowIndex)
            }
        }
    }
    
    /// 修改购物车商品数量
    ///
    /// - Parameters:
    ///   - model: model
    ///   - index: 索引
    ///   - isAdd: 是否是增加
    func requestGoodsNumber(model: KZCartGoodsModel,num: String,index: Int,isAdd: Bool){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member_cart&op=cart_edit_quantity", parameters: ["key": userDefaults.string(forKey: "key") ?? "","cart_id":model.cart_id!,"quantity": num],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                /// 如果已经选择，同时更新数量
                if (weakSelf?.selectGoods.keys.contains(model.cart_id!))! {
                    weakSelf?.selectGoods[model.cart_id!]?.goods_num = num
                    if isAdd{
                        weakSelf?.totalNum += 1
                        weakSelf?.totalMoney += Double(model.goods_price!)!
                    }else{
                        weakSelf?.totalNum -= 1
                        weakSelf?.totalMoney -= Double(model.goods_price!)!
                    }
                }
                weakSelf?.cartModel?.goodList![index].goods_num = num
                weakSelf?.tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .none)
                
                weakSelf?.setBottomData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 删除商品
    func requestDeleteGoods(model: KZCartGoodsModel,index: Int){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member_cart&op=cart_del", parameters: ["key": userDefaults.string(forKey: "key") ?? "","cart_id":model.cart_id!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                /// 如果已经选择，同时更新数量
                if (weakSelf?.selectGoods.keys.contains(model.cart_id!))! {
                    weakSelf?.selectGoods.removeValue(forKey: model.cart_id!)
                    weakSelf?.totalNum -= Int(model.goods_num!)!
                    weakSelf?.totalMoney -= Double(model.goods_price!)! * Double(model.goods_num!)!
                }
                weakSelf?.cartModel?.goodList?.remove(at: index)
                weakSelf?.tableView.reloadData()
                
                if weakSelf?.cartModel?.goodList?.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "购物车是空的~")
                }
                
                weakSelf?.setBottomData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension KZCartVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cartModel != nil {
            return (cartModel?.goodList?.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cartCell) as! KZCartCell
        
        let model = cartModel?.goodList![indexPath.row]
        cell.dataModel = model
        
        if selectGoods.keys.contains((model?.cart_id)!) {
            cell.checkImgView.image = UIImage.init(named: "icon_check_selected")
        }else{
            cell.checkImgView.image = UIImage.init(named: "icon_check")
        }
        
        cell.addIconView.tag = indexPath.row
        cell.minusIconView.tag = indexPath.row
        cell.addIconView.addOnClickListener(target: self, action: #selector(didClickAddBtn(sender:)))
        cell.minusIconView.addOnClickListener(target: self, action: #selector(didClickMinusBtn(sender:)))
        
        cell.checkImgView.tag = indexPath.row
        cell.checkImgView.addOnClickListener(target: self, action: #selector(onClickedCheckGoods(sender:)))
        
        cell.deleteView.tag = indexPath.row
        cell.deleteView.addOnClickListener(target: self, action: #selector(onClickedDeleteGoods(sender:)))
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
