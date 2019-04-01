//
//  GYZSharedItem.h
//  kangze
//
//  Created by gouyz on 2018/9/25.
//  Copyright © 2018年 gyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GYZSharedItem : NSObject <UIActivityItemSource>

-(instancetype)initWithData:(UIImage*)img andFile:(NSURL*)file;

@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong) NSURL *path;

@end
