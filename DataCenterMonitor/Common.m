//
//  Common.m
//  DataCenterMonitor
//
//  Created by Stereo on 16/3/7.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "Common.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static Common *_common;

@implementation Common

/**********************
 函数名：DefaultCommon
 描述:返回Common对象实例
 参数：
 返回：Common对象
 **********************/
+(instancetype)DefaultCommon
{
    if (!_common)
    {
        _common = [[Common alloc] init];
    }
    return _common;
}

/**********************
 函数名：HttpString
 描述:组合http请求字符串
 参数：url 服务地址
         port 端口
 返回：http字符串
 **********************/
+(NSString *)HttpString:(NSString *)url port:(int)port
{
    return [NSString stringWithFormat:@"http://%@:%d/%@",url,port,UrlBody];
}

/**********************
 函数名：HttpString
 描述:组合http请求字符串
 参数：srv 各个业务url地址名称
 返回：http字符串
 **********************/
+(NSString *)HttpString:(NSString *)srv
{
    return [NSString stringWithFormat:@"%@%@",[Common DefaultCommon].webUrl,srv];
}
/**********************
 函数名：initLoadingImages
 描述:将loading  图片数组初始化
 参数：
 返回：http字符串
 **********************/
+(NSArray *)initLoadingImages
{
    NSArray *images = @[
                        [UIImage imageNamed:@"progress_1"],
                        [UIImage imageNamed:@"progress_2"],
                        [UIImage imageNamed:@"progress_3"],
                        [UIImage imageNamed:@"progress_4"],
                        [UIImage imageNamed:@"progress_5"],
                        [UIImage imageNamed:@"progress_6"],
                        [UIImage imageNamed:@"progress_7"],
                        [UIImage imageNamed:@"progress_8"]
                        ];
    return images;
}

//得到全局线程队列
+(dispatch_queue_t)getThreadQueue
{
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}
// 得到UI线程队列
+(dispatch_queue_t)getThreadMainQueue
{
    return dispatch_get_main_queue();
}

@end