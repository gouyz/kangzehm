//
//  GYZOpenCameraPhotosTool.swift
//  LazyHuiSellers
//  打开系统相机及相册
//  Created by gouyz on 2016/12/16.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

struct PhotoSource:OptionSet
{
    let rawValue:Int
    
    static let camera = PhotoSource(rawValue: 1)
    static let photoLibrary = PhotoSource(rawValue: 1<<1)
    
}

typealias finishedImage = (_ image:UIImage) -> ()

class GYZOpenCameraPhotosTool: NSObject {
    
    var finishedImg : finishedImage?
    
    /// 图片是否可编辑
    var isEditor = false
    
    ///单例
    static let shareTool = GYZOpenCameraPhotosTool()
    private override init() {}
    
    ///选择图片
    ///
    /// - Parameters:
    ///   - controller: 控制器
    ///   - editor: 图片是否可编辑
    ///   - options: 类型
    ///   - finished: 完成后的回调闭包
    
    func choosePicture(_ controller : UIViewController,  editor : Bool,options : PhotoSource = [.camera,.photoLibrary], finished : @escaping finishedImage){
        
        finishedImg = finished
        isEditor = editor
        
        if options.contains(.camera) && options.contains(.photoLibrary){
            
            let alertController = UIAlertController(title: "请选择图片", message: nil, preferredStyle: .actionSheet)
            
            let photographAction = UIAlertAction(title: "拍照", style: .default) { (_) in
                
                self.openCamera(controller: controller, editor: editor)
            }
            let photoAction = UIAlertAction(title: "从相册选取", style: .default) { (_) in
                
                self.openPhotoLibrary(controller: controller, editor: editor)
            }
            
            let cannelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            alertController.addAction(photographAction)
            alertController.addAction(photoAction)
            alertController.addAction(cannelAction)
            
            controller.present(alertController, animated: true, completion: nil)
            
        } else if options.contains(.photoLibrary){
            
            self.openPhotoLibrary(controller: controller, editor: editor)
        }else if options.contains(.camera){
            
            self.openCamera(controller: controller, editor: editor)
        }
    }
    
    ///打开相册
    
    func openPhotoLibrary(controller : UIViewController,  editor : Bool){
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        weak var weakSelf = self
        checkPhotoPermission { (granted) in
            if granted{
                
                let photo = UIImagePickerController()
                photo.delegate = self
                photo.sourceType = .photoLibrary
                photo.allowsEditing = editor
                
                controller.present(photo, animated: true, completion: nil)
            }else{
                weakSelf?.showPermissionAlert(content: "请在iPhone的“设置-隐私”选项中，允许懒人社访问你的手机相册",controller : controller)
            }
        }
        
    }
    
    ///打开相机
    func openCamera(controller : UIViewController,  editor : Bool){
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        
        weak var weakSelf = self
        checkCameraPermission { (granted) in
            if granted{
                let photo = UIImagePickerController()
                photo.delegate = self
                photo.sourceType = .camera
                photo.allowsEditing = editor
                controller.present(photo, animated: true, completion: nil)
            }else{
                weakSelf?.showPermissionAlert(content: "请在iPhone的“设置-隐私”选项中，允许懒人社访问你的摄像头",controller : controller)
            }
        }
        
        
    }
    
    /// 显示提示权限
    func showPermissionAlert(content: String,controller : UIViewController){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: nil, message: content, cancleTitle: "取消", viewController: controller, buttonTitles: "确定") { (index) in
            
            if index != cancelIndex{
                weakSelf?.gotoSettings()
            }
        }
    }
    
    /// 打开设置界面
    func gotoSettings() {
        if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.openURL(appSettings)
        }
    }
    
    /// 检测相机权限
    ///
    /// - Parameter handler:
    func checkCameraPermission(_ handler: @escaping (_ granted: Bool) -> Void) {
        func hasCameraPermission() -> Bool {
            return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        }
        
        func needsToRequestCameraPermission() -> Bool {
            return AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined
        }
        
        hasCameraPermission() ? handler(true) : (needsToRequestCameraPermission() ?
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                DispatchQueue.main.async(execute: { () -> Void in
                    hasCameraPermission() ? handler(true) : handler(false)
                })
            }) : handler(false))
    }
    /// 检测相册权限
    ///
    /// - Parameter handler:
    func checkPhotoPermission(_ handler: @escaping (_ granted: Bool) -> Void) {
        func hasPhotoPermission() -> Bool {
            return PHPhotoLibrary.authorizationStatus() == .authorized
        }
        
        func needsToRequestPhotoPermission() -> Bool {
            return PHPhotoLibrary.authorizationStatus() == .notDetermined
        }
        
        hasPhotoPermission() ? handler(true) : (needsToRequestPhotoPermission() ?
            PHPhotoLibrary.requestAuthorization({ status in
                DispatchQueue.main.async(execute: { () in
                    hasPhotoPermission() ? handler(true) : handler(false)
                })
            }) : handler(false))
    }
}

//MARK:  UIImagePickerControllerDelegate,UINavigationControllerDelegate

extension GYZOpenCameraPhotosTool : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        guard let image = info[isEditor ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage] as? UIImage else { return }
        picker.dismiss(animated: true) { [weak self] in
            guard let tmpFinishedImg = self?.finishedImg else { return }
            tmpFinishedImg(image)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        picker.dismiss(animated: true, completion: nil)
        
    }
}
