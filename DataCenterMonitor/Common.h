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
#define GetStation @"GetStation"
#define GetEquTypebase @"GetEquTypebase"
#define GetLastCommTime @"GetLastCommTime"
#define GetSumOfAlarm @"GetSumOfAlarm"
#define GetAllListAlarm @"GetAllListAlarm"

#import <Foundation/Foundation.h>
#import <Common/FileCommon.h>
#import <Common/PublicCommon.h>


typedef enum {
    NETINSIDE,//内网
    NETOUTSIDE,//外网
} NetEnum;


//局站信息结构
struct StationStruct{
    const char *stationid;
    const char *StationName;
    const char *StationPicturePath;
    const char *imgpath;
};

typedef struct StationStruct Stationinfo;

@interface Common :NSObject
{
    //存当前局站信息字典
    NSMutableArray *stationinfolist;
    Stationinfo stationinfo;
}


@property (copy,nonatomic)NSString *ClerkID;//用户ID
@property (copy,nonatomic)NSString *ClerkStationID;//局站ID

@property (strong,nonatomic)NSString *webMainUrl;
@property (copy,nonatomic)NSString *webUrl;
@property (assign)NetEnum NetType;

+(instancetype)DefaultCommon;
+(NSString *)HttpString:(NSString *)url port:(int)port;
+(NSString *)HttpString:(NSString *)srv;
+(NSArray *)initLoadingImages;
+(dispatch_queue_t)getThreadQueue;
+(dispatch_queue_t)getThreadMainQueue;
+(void)NetErrorAlert:(NSString *)msg;
+(void)NetOKAlert:(NSString *)msg;
+(int)getphoneX;


-(BOOL)SaveStationinfo:(NSArray *)arry;
-(Stationinfo *)getStationinfo:(int)index;
-(int)getStationS;
@end