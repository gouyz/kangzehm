//
//  KZPublicFriendCircleVC.swift
//  kangze
//  发布朋友圈
//  Created by gouyz on 2018/9/3.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import DKImagePickerController

class KZPublicFriendCircleVC: GYZBaseVC {
    
    /// 选择结果回调
    var resultBlock:(() -> Void)?
    
    ///txtView 提示文字
    let placeHolder = "这一刻的想法..."
    /// 选择的图片
    var selectImgs: [UIImage] = []
    /// 最大选择图片数量
    var maxImgCount: Int = kMaxSelectCount
    // 内容
    var content: String = ""
    // 上传图URL 多个图片用英文逗号隔开
    var imgsUrl: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = kWhiteColor
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("发表", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kBlackFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
        
        contentTxtView.delegate = self
        contentTxtView.text = placeHolder
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI(){
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(contentTxtView)
        contentView.addSubview(addPhotosView)
        
        addPhotosView.delegate = self
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.width.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            // 这个很重要！！！！！！
            // 必须要比scroll的高度大一，这样才能在scroll没有填充满的时候，保持可以拖动
            make.height.greaterThanOrEqualTo(scrollView).offset(1)
        }
        contentTxtView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kMargin)
            make.height.equalTo(120)
        }
        addPhotosView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentTxtView)
            make.top.equalTo(contentTxtView.snp.bottom).offset(kMargin)
            make.height.equalTo(kPhotosImgHeight)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
        }
    }
    
    /// scrollView
    var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    var contentView: UIView = UIView()
    /// 描述
    lazy var contentTxtView: UITextView = {
        
        let txtView = UITextView()
        txtView.font = k15Font
        txtView.textColor = kGaryFontColor
        
        return txtView
    }()
    /// 添加照片View
    lazy var addPhotosView: LHSAddPhotoView = LHSAddPhotoView.init(frame: CGRect.zero, maxCount: maxImgCount)
    
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
               
                item.fetchFullScreenImage(completeBlock: { (image, info) in
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
    
    /// 发表
    @objc func onClickRightBtn(){
        if content.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入内容")
            return
        }
        if selectImgs.count == 0 {
            MBProgressHUD.showAutoDismissHUD(message: "请选择至少一张图片")
            return
        }
        createHUD(message: "加载中...")
        if selectImgs.count > 0 {
            for (index,item) in selectImgs.enumerated(){
                requestUpdateImg(img: item, fileName: "friendCircle\(index).png",index:index)
            }
        }else{
            requestPublicCircle()
        }
    }
    
    /// 上传凭证
    func requestUpdateImg(img: UIImage,fileName: String,index: Int){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        
        let imgParam: ImageFileUploadParam = ImageFileUploadParam()
        imgParam.name = "image"
        imgParam.fileName = fileName
        imgParam.mimeType = "image/png"
        imgParam.data = UIImageJPEGRepresentation(img, 0.5)
        
        GYZNetWork.uploadImageRequest("upload&op=friend_message_upload", uploadParam: [imgParam], success: { (response) in
            
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.imgsUrl += response["datas"]["img"].stringValue + ","
                if index + 1 == weakSelf?.selectImgs.count{// 所有图片上传完成
                    weakSelf?.requestPublicCircle()
                }
                
            }else{
                weakSelf?.hud?.hide(animated: true)
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 发表朋友圈
    func requestPublicCircle(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        
        if imgsUrl.count > 0 {
            imgsUrl = imgsUrl.subString(start: 0, length: imgsUrl.count - 1)
        }
        
        GYZNetWork.requestNetwork("friend_message&op=add_message", parameters: ["key": userDefaults.string(forKey: "key") ?? "","content":content,"image":imgsUrl],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                if weakSelf?.resultBlock != nil{
                    weakSelf?.resultBlock!()
                }
                weakSelf?.clickedBackBtn()
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["msg"].stringValue)
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}

extension KZPublicFriendCircleVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate
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

extension KZPublicFriendCircleVC : UITextViewDelegate,LHSAddPhotoViewDelegate
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
    
    ///MARK UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let text = textView.text
        if text == placeHolder {
            textView.text = ""
            textView.textColor = kBlackFontColor
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = kGaryFontColor
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        
        content = textView.text
    }
}
