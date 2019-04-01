//
//  KZMessageDetailVC.swift
//  kangze
//  消息详情
//  Created by gouyz on 2018/9/30.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class KZMessageDetailVC: GYZBaseVC {
    
    /// 选择结果回调
    var resultBlock:(() -> Void)?

    var dataModel: KZMessageModel?
    var msgId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "消息详情"
        self.view.backgroundColor = kWhiteColor
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestDatas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func clickedBackBtn() {
        if resultBlock != nil {
            resultBlock!()
        }
        
        super.clickedBackBtn()
    }
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        ///设置透明背景
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        
        webView.scrollView.bouncesZoom = false
        webView.scrollView.bounces = false
        webView.scrollView.alwaysBounceHorizontal = false
        webView.navigationDelegate = self
        
        return webView
    }()
    
    ///获取数据
    func requestDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("message&op=article_show",parameters: ["key": userDefaults.string(forKey: "key") ?? "","article_id":msgId],method:.get,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["datas"].dictionaryObject else { return }
                weakSelf?.dataModel = KZMessageModel.init(dict: data)
                weakSelf?.hiddenEmptyView()
                weakSelf?.loadContent()
            }else{
                weakSelf?.showEmptyView(content: "亲，暂时没有消息~", iconImgName: "icon_empty_msg", reload: nil)
                weakSelf?.emptyView?.iconImgView.snp.updateConstraints({ (make) in
                    make.height.equalTo(65)
                    make.width.equalTo(136)
                })
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 加载
    func loadContent(){
        self.navigationItem.title = dataModel?.article_title
        let url: String = (dataModel?.article_content)!
        if url.hasPrefix("http://") || url.hasPrefix("https://") {
            
            webView.load(URLRequest.init(url: URL.init(string: url)!))
        }else{
            webView.loadHTMLString(url.dealFuTextImgSize(), baseURL: nil)
        }
    }
}
extension KZMessageDetailVC : WKNavigationDelegate{
    ///MARK WKNavigationDelegate
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        createHUD(message: "加载中...")
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        /// 获取网页title
        //        self.title = self.webView.title
        self.hud?.hide(animated: true)
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        self.hud?.hide(animated: true)
    }
}
