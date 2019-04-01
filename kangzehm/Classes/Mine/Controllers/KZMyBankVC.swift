//
//  KZMyBankVC.swift
//  kangze
//  我的银行卡
//  Created by gouyz on 2018/9/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let myBankCell = "myBankCell"

class KZMyBankVC: GYZBaseVC {
    
    /// 选择结果回调
    var resultBlock:((_ model: KZBankModel) -> Void)?
    
    var dataList:[KZBankModel] = [KZBankModel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的银行卡"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named:"icon_add_black")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(onClickedAdd))
        
        setUpUI()
        emptyViewBg.isHidden = true
        requestBankCardDatas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI(){
        
        view.addSubview(emptyViewBg)
        emptyViewBg.addSubview(iconImgView)
        emptyViewBg.addSubview(desLab)
        emptyViewBg.addSubview(addBtn)
        
        view.addSubview(tableView)
        
        emptyViewBg.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.centerY.equalTo(view)
            make.height.equalTo(200)
        }
        
        iconImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(emptyViewBg)
            make.top.equalTo(emptyViewBg)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(iconImgView.snp.bottom).offset(kMargin)
            make.height.equalTo(kTitleHeight)
        }
        addBtn.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(desLab.snp.bottom).offset(30)
            make.height.equalTo(kUIButtonHeight)
        }
        
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }
    }
    
    ///
    lazy var emptyViewBg: UIView = UIView()
    
    /// 无数据默认图片
    lazy var iconImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_bank_add"))
    
    /// 描述
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .center
        lab.text = "您还没有添加过银行卡"
        
        return lab
    }()
    
    /// 添加银行卡
    lazy var addBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("添加银行卡", for: .normal)
        btn.addTarget(self, action: #selector(onClickedAdd), for: .touchUpInside)
        
        return btn
    }()
    
    /// 添加银行卡
    @objc func onClickedAdd(){
        let vc = KZAddBankCardVC()
        vc.resultBlock = {[weak self] () in
            self?.requestBankCardDatas()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        
        table.register(KZMyBankCell.self, forCellReuseIdentifier: myBankCell)
        
        return table
    }()
    
    ///获取银行卡数据
    func requestBankCardDatas(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("member_card&op=card_list",parameters: ["key": userDefaults.string(forKey: "key") ?? ""],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["datas"]["card_list"].array else { return }
                
                weakSelf?.dataList.removeAll()
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = KZBankModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.emptyViewBg.isHidden = true
                    weakSelf?.tableView.isHidden = false
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.emptyViewBg.isHidden = false
                    weakSelf?.tableView.isHidden = true
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            ///显示空页面
            weakSelf?.emptyViewBg.isHidden = false
            weakSelf?.tableView.isHidden = true
        })
    }
}

extension KZMyBankVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: myBankCell) as! KZMyBankCell
        
        cell.dataModel = dataList[indexPath.row]
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
        if resultBlock != nil{
            resultBlock!(dataList[indexPath.row])
        }
        clickedBackBtn()
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
