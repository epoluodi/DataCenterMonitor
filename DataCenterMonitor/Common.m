//
//  Common.m
//  DataCenterMonitor
//
//  Created by Stereo on 16/3/7.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "Common.h"
#import <Foundation/Foundation.h>


@implementation Common

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

@end