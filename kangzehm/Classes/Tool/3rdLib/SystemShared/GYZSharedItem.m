//
//  GYZSharedItem.m
//  kangze
//  实现UIActivityItemSource协议的类 ShareItem
//  Created by gouyz on 2018/9/25.
//  Copyright © 2018年 gyz. All rights reserved.
//

#import "GYZSharedItem.h"

@implementation GYZSharedItem
-(instancetype)initWithData:(UIImage *)img andFile:(NSURL *)file
{
    self = [super init];
    if (self) {
        _img = img;
        _path = file;
    }
    return self;
}

-(instancetype)init
{
    //不期望这种初始化方式，所以返回nil了。
    return nil;
}

#pragma mark - UIActivityItemSource
-(id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return _img;
}

-(id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    return _path;
}

-(NSString*)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType
{
    // 这里对我这分享图好像没啥用....   是的 没啥用....
    return @"";
}
@end
