//
//  kangze-Bridging-Header.h
//  kangze
//
//  Created by gouyz on 2018/8/28.
//  Copyright © 2018年 gyz. All rights reserved.
//
#import <UIKit/UIKit.h>

/// OC工具类 验证银行卡等
#import "GYZCheckTool.h"

/// 搜索框
//#import "PYSearchViewController.h"

/// 多标签选择
#import "HXTagsView.h"
#import "HXTagAttribute.h"
#import "HXTagCollectionViewFlowLayout.h"

/// 极光推送相关头文件
// 引入JPush功能所需头文件
//#import "JPUSHService.h"
// iOS10注册APNs所需头文件
//#ifdef NSFoundationVersionNumber_iOS_9_x_Max
//#import <UserNotifications/UserNotifications.h>
//#endif

//Alipay
#import <AlipaySDK/AlipaySDK.h>

/// 微信支付
#import "WXApi.h"
/// qq
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>


/// 用于实现系统分享
#import "GYZSharedItem.h"
#import "TSShareHelper.h"
