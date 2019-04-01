//
//  KZPosPayVC.swift
//  kangze
//  pos机核单
//  Created by gouyz on 2018/9/4.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import DKImagePickerController

class KZPosPayVC: GYZBaseVC {
    
    /// 选择结果回调
    var resultBlock:(() -> Void)?
    
    /// 选择的图片
    var selectImgs: [UIImage] = []
    /// 最大选择图片数量
    var maxImgCount: Int = 1
    /// 订单支付编号
    var paySN: String = ""
    
    var dataModel: KZPosDataModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "pos机核单"
        self.view.backgroundColor = kWhiteColor
        setUpUI()
        
        requestPosInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI(){
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(nameDesLab)
        contentView.addSubview(nameLab)
        contentView.addSubview(numberDesLab)
        contentView.addSubview(numberLab)
        contentView.addSubview(lineView)
        contentView.addSubview(lineView1)
        contentView.addSubview(totalDesLab)
        contentView.addSubview(totalLab)
        contentView.addSubview(lineView2)
        contentView.addSubview(desLab)
        contentView.addSubview(addPhotosView)
        
        view.addSubview(submitBtn)
        
        addPhotosView.delegate = self
        
        scrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.bottom.equalTo(submitBtn.snp.top)
        }
        submitBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.width.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            // 这个很重要！！！！！！
            // 必须要比scroll的高度大一，这样才能在scroll没有填充满的时候，保持可以拖动
            make.height.greaterThanOrEqualTo(scrollView).offset(1)
        }
        nameDesLab.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(kMargin)
            make.height.equalTo(50)
            make.width.equalTo(80)
        }
        nameLab.snp.makeConstraints { (make) in
            make.top.height.equalTo(nameDesLab)
            make.left.equalTo(nameDesLab.snp.right)
            make.right.equalTo(-kMargin)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(nameDesLab.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        numberDesLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameDesLab)
            make.top.equalTo(lineView.snp.bottom)
        }
        numberLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameLab)
            make.top.equalTo(numberDesLab)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(numberDesLab.snp.bottom)
        }
        totalDesLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameDesLab)
            make.top.equalTo(lineView1.snp.bottom)
        }
        totalLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameLab)
            make.top.equalTo(totalDesLab)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(totalDesLab.snp.bottom)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(lineView2.snp.bottom)
            make.height.equalTo(nameDesLab)
        }
        addPhotosView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(desLab.snp.bottom)
            make.height.equalTo(kPhotosImgHeight)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
        }
    }
    
    /// scrollView
    lazy var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    lazy var contentView: UIView = UIView()
    /// 商品名称
    lazy var nameDesLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        lab.text = "商品名称："
        
        return lab
    }()
    /// 商品名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k12Font
        lab.numberOfLines = 2
        
        
        return lab
    }()
    /// 线
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 商品数量
    lazy var numberDesLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        lab.text = "商品数量："
        
        return lab
    }()
    /// 商品数量
    lazy var numberLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        
        
        return lab
    }()
    /// 线
    lazy var lineView1: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 商品总额
    lazy var totalDesLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        lab.text = "商品总额："
        
        return lab
    }()
    /// 商品总额
    lazy var totalLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        
        
        return lab
    }()
    /// 线
    lazy var lineView2: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 上传凭证
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "上传凭证："
        
        return lab
    }()
    /// 添加照片View
    lazy var addPhotosView: LHSAddPhotoView = LHSAddPhotoView.init(frame: CGRect.zero, maxCount: maxImgCount)
    
    /// 确定
    lazy var submitBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("确 定", for: .normal)
        btn.addTarget(self, action: #selector(clickedSubmitBtn), for: .touchUpInside)
        
        return btn
    }()
    /// 确定
    @objc func clickedSubmitBtn(){
        
        if selectImgs.count == 0 {
            MBProgressHUD.showAutoDismissHUD(message: "请选择图片")
            return
        }
        requestUpdateConfirm(img: selectImgs[0], fileName: "posImg0.png")
    }
    
    /// 获取pos支付数据
    func requestPosInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member_payment&op=pay_new", parameters: ["key": userDefaults.string(forKey: "key") ?? "","pay_sn":paySN,"is_html":"1","payment_code":" pos"],method : .get,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["datas"].dictionaryObject else { return }
                weakSelf?.dataModel = KZPosDataModel.init(dict: data)
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
        var goodsName: String = ""
        var num: Int = 0
        for item in (dataModel?.goodList)! {
            goodsName += item.goods_name! + ","
            num += Int(item.goods_num!)!
        }
        if goodsName.count > 0 {
            nameLab.text = goodsName.subString(start: 0, length: goodsName.count - 1)
        }
        numberLab.text = "\(num)"
        totalLab.text = "￥" + (dataModel?.total)!
    }
    
    /// 上传凭证
    func requestUpdateConfirm(img: UIImage,fileName: String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        let imgParam: ImageFileUploadParam = ImageFileUploadParam()
        imgParam.name = "image"
        imgParam.fileName = fileName
        imgParam.mimeType = "image/png"
        imgParam.data = UIImageJPEGRepresentation(img, 0.5)
        
        GYZNetWork.uploadImageRequest("upload&op=pos_pay_upload", uploadParam: [imgParam], success: { (response) in
            
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.requestSubmitPosInfo(url:response["datas"]["img"].stringValue)
                
            }else{
                weakSelf?.hud?.hide(animated: true)
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 上传pos支付数据
    func requestSubmitPosInfo(url: String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        
        GYZNetWork.requestNetwork("member_payment&op=pay_new", parameters: ["key": userDefaults.string(forKey: "key") ?? "","pay_sn":paySN,"pas_sn_encode":(dataModel?.pas_sn_encode)!,"payment_code":" pos","pos_pay_img":url],method : .get,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.dealResult()
                MBProgressHUD.showAutoDismissHUD(message: response["datas"].stringValue)
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    func dealResult(){
        if resultBlock != nil{
            resultBlock!()
        }else{
            _ = navigationController?.popToRootViewController(animated: true)
        }
    }
    
    ///打开相机
    func openCamera(){
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            MBProgressHUD.showAutoDismissHUD(message: "该设备无摄像头")
            return
        }
        
        GYZOpenCameraPhotosTool.shareTool.checkCameraPermission { (granted) in
            if granted{
                let photo = UIImagePickerController()
                photo.delegate = self
                photo.sourceType = .camera
                photo.allowsEditing = true
                self.present(photo, animated: true, completion: nil)
            }else{
                GYZOpenCameraPhotosTool.shareTool.showPermissionAlert(content: "请在iPhone的“设置-隐私”选项中，允许访问你的摄像头",controller : self)
            }
        }
        
    }
    
    ///打开相册
    func openPhotos(){
        
        let pickerController = DKImagePickerController()
        pickerController.maxSelectableCount = maxImgCount
        
        weak var weakSelf = self
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            var count = 0
            for item in assets {
                item.fetchFullScreenImage(completeBlock:{ (image, info) in
                    
                    weakSelf?.selectImgs.append(image!)
                    weakSelf?.maxImgCount = kMaxSelectCount - (weakSelf?.selectImgs.count)!
                    
                    count += 1
                    if count == assets.count{
                        weakSelf?.resetAddImgView()
                    }
                })
            }
        }
        
        self.present(pickerController, animated: true) {}
    }
    
}

extension KZPosPayVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        guard let image = info[picker.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage] as? UIImage else { return }
        picker.dismiss(animated: true) { [weak self] in
            
            if self?.selectImgs.count == kMaxSelectCount{
                MBProgressHUD.showAutoDismissHUD(message: "最多只能上传\(kMaxSelectCount)张图片")
                return
            }
            self?.selectImgs.append(image)
            self?.maxImgCount -= 1
            self?.resetAddImgView()
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    /// 选择图片后重新设置图片显示
    func resetAddImgView(){
        var rowIndex = ceil(CGFloat.init(selectImgs.count) / 4.0)//向上取整
        /// 预留出增加按钮位置
        if selectImgs.count < kMaxSelectCount && selectImgs.count % 4 == 0 {
            rowIndex += 1
        }
        let height = kPhotosImgHeight * rowIndex + kMargin * (rowIndex - 1)
        
        addPhotosView.snp.updateConstraints({ (make) in
            make.height.equalTo(height)
        })
        addPhotosView.selectImgs = selectImgs
    }
}

extension KZPosPayVC :LHSAddPhotoViewDelegate
{
    ///MARK LHSAddPhotoViewDelegate
    ///添加图片
    func didClickAddImage(photoView: LHSAddPhotoView) {
        GYZAlertViewTools.alertViewTools.showSheet(title: "选择照片", message: nil, cancleTitle: "取消", titleArray: ["拍照","从相册选取"], viewController: self) { [weak self](index) in
            
            if index == 0{//拍照
                self?.openCamera()
            }else if index == 1 {//从相册选取
                self?.openPhotos()
            }
        }
    }
    
    func didClickDeleteImage(index: Int, photoView: LHSAddPhotoView) {
        selectImgs.remove(at: index)
        maxImgCount += 1
        resetAddImgView()
    }
}
