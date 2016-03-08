//
//  Common.h
//  DataCenterMonitor
//
//  Created by Stereo on 16/3/7.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#define Webserver @"http://14546223xi.51mypc.cn:86/CSharpBackground/WebServer.asmx"

#define UrlBody @"CSharpBackground/WebServer.asmx/"

#define UserLogin @"UserLogin"



#import <Foundation/Foundation.h>



typedef enum {
    NETINSIDE,NETOUTSIDE,
} NetEnum;


@interface Common :NSObject


@property (strong,nonatomic)NSString *webUrl;
@property (assign)NetEnum NetType;


+(void)InitVar;


@end