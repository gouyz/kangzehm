//
//  GYZScanQrcodeVC.swift
//  LazyHuiSellers
//  扫描二维码
//  Created by gouyz on 2016/12/15.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit
import AVFoundation


/// 视图透明度
let viewAlpha : CGFloat = 0.4

//设置扫描的结构体
enum ScanQRCodeType: Int {
    case qrCode = 1  //二维码
    case barCode     //条形码
}

class GYZScanQrcodeVC: UIViewController {
    
    var lightOn = false///开光灯
    //扫描的类型
    var scanType : ScanQRCodeType?
    //会话
    var scanSession :  AVCaptureSession?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "扫描二维码"
        self.view.backgroundColor = kWhiteColor
        
        setupUI()
        setupScanSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startScan()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 顶部视图
    fileprivate lazy var topView : UIView = {
        let top = UIView()
        top.backgroundColor = kBlackColor
        top.alpha = viewAlpha
        
        return top
    }()
    
    /// 描述
    fileprivate lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "将取景框对准二维/条形码，即可自动扫描"
        
        return lab
    }()
    /// 左边视图
    fileprivate lazy var leftView : UIView = {
        let top = UIView()
        top.backgroundColor = kBlackColor
        top.alpha = viewAlpha
        
        return top
    }()
    /// 右边视图
    fileprivate lazy var rightView : UIView = {
        let top = UIView()
        top.backgroundColor = kBlackColor
        top.alpha = viewAlpha
        
        return top
    }()
    /// 底部视图
    fileprivate lazy var bottomView : UIView = {
        let top = UIView()
        top.backgroundColor = kBlackColor
        top.alpha = viewAlpha
        
        return top
    }()
    
    /// 扫描框
    lazy var scanPane: UIImageView = UIImageView(image: UIImage(named: "icon_scanbox"))
    /// 扫描线
    lazy var scanLine : UIImageView = UIImageView(image: UIImage(named: "icon_scanline"))
    
    /// 底部Btn视图
    fileprivate lazy var bottomBtnView : UIView = {
        let top = UIView()
        top.backgroundColor = kBlackColor
        top.alpha = 0.8
        
        return top
    }()
    
    /// 相册
    lazy var photosBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage(named: "icon_scan_photo_normal"), for: .normal)
        btn.setImage(UIImage(named: "icon_scan_photo_highlighted"), for: .highlighted)
        btn.addTarget(self, action: #selector(clickedPhotosBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    
    /// 开光灯
    lazy var lightBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage(named: "icon_scan_light_normal"), for: .normal)
        btn.setImage(UIImage(named: "icon_scan_light_highlighted"), for: .selected)
        btn.addTarget(self, action: #selector(clickedLightBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    
    /// 设置UI
    func setupUI(){
        view.addSubview(topView)
        topView.addSubview(desLab)
        view.addSubview(leftView)
        view.addSubview(rightView)
        view.addSubview(scanPane)
        scanPane.addSubview(scanLine)
        view.addSubview(bottomView)
        view.addSubview(bottomBtnView)
        bottomBtnView.addSubview(photosBtn)
        bottomBtnView.addSubview(lightBtn)
        
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.bottom.equalTo(scanPane.snp.top)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(topView)
            make.bottom.equalTo(topView).offset(-30)
            make.height.equalTo(30)
        }
        leftView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(scanPane.snp.left)
            make.height.equalTo(scanPane)
        }
        rightView.snp.makeConstraints { (make) in
            make.top.height.equalTo(leftView)
            make.left.equalTo(scanPane.snp.right)
            make.right.equalTo(view)
        }
        
        scanPane.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-20)
            make.width.equalTo(view).multipliedBy(0.6)
            make.height.equalTo(scanPane.snp.width)
        }
        scanLine.snp.makeConstraints { (make) in
            make.left.top.equalTo(scanPane)
            make.width.equalTo(scanPane)
            make.height.equalTo(3)
        }
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(scanPane.snp.bottom)
            make.left.right.equalTo(view)
            make.bottom.equalTo(bottomBtnView.snp.top)
        }
        bottomBtnView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(80)
        }
        photosBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(bottomBtnView)
            make.centerX.equalTo(bottomBtnView).offset(-kScreenWidth*0.25)
            make.width.equalTo(45)
            make.height.equalTo(60)
        }
        lightBtn.snp.makeConstraints { (make) in
            make.centerY.size.equalTo(photosBtn)
            make.centerX.equalTo(bottomBtnView).offset(kScreenWidth*0.25)
        }
        
        view.layoutIfNeeded()
    }
    func setupScanSession(){
        do
        {
            //设置捕捉设备
            guard let device = AVCaptureDevice.default(for: .video) else{
                
                GYZAlertViewTools.alertViewTools.showAlert(title: "温馨提示", message: "摄像头不可用", cancleTitle: nil, viewController: self, buttonTitles: "确定")
                return
            }
            //设置设备输入输出
            let input = try AVCaptureDeviceInput(device: device)
            
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            //设置会话
            let  scanSession = AVCaptureSession()
            scanSession.canSetSessionPreset(AVCaptureSession.Preset.high)
            
            if scanSession.canAddInput(input)
            {
                scanSession.addInput(input)
            }
            
            if scanSession.canAddOutput(output)
            {
                scanSession.addOutput(output)
            }
            
            //设置扫描类型(二维码和条形码)
            output.metadataObjectTypes = [
                AVMetadataObject.ObjectType.qr,
                AVMetadataObject.ObjectType.code39,
                AVMetadataObject.ObjectType.code128,
                AVMetadataObject.ObjectType.code39Mod43,
                AVMetadataObject.ObjectType.ean13,
                AVMetadataObject.ObjectType.ean8,
                AVMetadataObject.ObjectType.code93]
            
            //预览图层
            let scanPreviewLayer = AVCaptureVideoPreviewLayer(session:scanSession)
            scanPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            scanPreviewLayer.frame = view.layer.bounds
            
            view.layer.insertSublayer(scanPreviewLayer, at: 0)
            
            //设置扫描区域
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil, using: { (noti) in
                output.rectOfInterest = scanPreviewLayer.metadataOutputRectConverted(fromLayerRect: self.scanPane.frame)
            })
            
            //保存会话
            self.scanSession = scanSession
            
        }catch{
            //摄像头不可用
            GYZAlertViewTools.alertViewTools.showAlert(title: "温馨提示", message: "摄像头不可用", cancleTitle: nil, viewController: self, buttonTitles: "确定")
            
            return
        }
        
    }
    /// 相册
    @objc func clickedPhotosBtn(btn : UIButton){
        GYZOpenCameraPhotosTool.shareTool.choosePicture(self, editor: true, options: .photoLibrary){[weak self] (image) in
            
            DispatchQueue.global().async {
                //播放声音
                GYZTool.playAlertSound(sound: "noticeMusic.caf")
                
                let recognizeResult = image.recognizeQRCode()
                let result = recognizeResult?.count > 0 ? recognizeResult : "无法识别"
                DispatchQueue.main.async {
                    GYZAlertViewTools.alertViewTools.showAlert(title: "扫描结果", message: result, cancleTitle: nil, viewController: self!, buttonTitles: "确定")
                }
            }
        }
    }
    /// 闪光灯
    @objc func clickedLightBtn(btn : UIButton){
        lightOn = !lightOn
        btn.isSelected = lightOn
        turnTorchOn()
    }
    
    //开始扫描
    fileprivate func startScan()
    {
        scanLine.layer.add(scanAnimation(), forKey: "scan")
        
        guard let scanSession = scanSession else { return }
        
        if !scanSession.isRunning{
            scanSession.startRunning()
        }
    }
    
    //扫描动画
    private func scanAnimation() -> CABasicAnimation
    {
        
        let startPoint = CGPoint(x: scanLine .center.x  , y: 1)
        let endPoint = CGPoint(x: scanLine.center.x, y: scanPane.bounds.size.height - 2)
        
        let translation = CABasicAnimation(keyPath: "position")
        translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        translation.fromValue = NSValue(cgPoint: startPoint)
        translation.toValue = NSValue(cgPoint: endPoint)
        translation.duration = 3.0
        translation.repeatCount = MAXFLOAT
        translation.autoreverses = true
        
        return translation
    }
    
    
    ///闪光灯
    private func turnTorchOn()
    {
        
        guard let device = AVCaptureDevice.default(for: .video) else{
            
            if lightOn{
                GYZAlertViewTools.alertViewTools.showAlert(title: "温馨提示", message: "闪光灯不可用", cancleTitle: nil, viewController: self, buttonTitles: "确定")
            }
            return
        }
        
        if device.hasTorch {
            do
            {
                try device.lockForConfiguration()
                
                if lightOn && device.torchMode == .off {
                    device.torchMode = .on
                }
                
                if !lightOn && device.torchMode == .on {
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            }
            catch{ }
        }
    }
    //MARK: Dealloc
    deinit{
        ///移除通知
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: AVCaptureMetadataOutputObjectsDelegate

//扫描捕捉完成
extension GYZScanQrcodeVC : AVCaptureMetadataOutputObjectsDelegate
{
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        
        //停止扫描
        self.scanLine.layer.removeAllAnimations()
        self.scanSession!.stopRunning()
        
        //播放声音
        GYZTool.playAlertSound(sound: "noticeMusic.caf")
        
        //扫完完成
        if metadataObjects.count > 0 {
            
            if let resultObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject
            {
                
                GYZAlertViewTools.alertViewTools.showAlert(title: "扫描结果", message: resultObj.stringValue, cancleTitle: nil, viewController: self, buttonTitles: "确定", alertActionBlock: { (index) in
                    //继续扫描
                    self.startScan()
                })
            }
        }
    }
}

