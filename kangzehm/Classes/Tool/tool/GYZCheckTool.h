//
//  GYZCheckTool.h
//  pureworks
// OC 验证银行卡等
//  Created by gouyz on 2018/6/28.
//  Copyright © 2018年 gyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYZCheckTool : NSObject
/// 检验银行卡
+ (BOOL) IsBankCard:(NSString *)cardNumber;
/// 根据银行卡号判断银行名称
+ (NSString *)getBankName:(NSString*) cardId;
@end
