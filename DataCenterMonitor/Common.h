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
#define GetEquTypebaseByUser @"GetEquTypebaseByUser"
#define GetEquipment @"GetEquipment"
#define GetSignal @"GetSignal"


//信号列表
#define GetListSignalAndControlByUser @"GetListSignalAndControlByUser"
#define GetListSignalAndControlByStation @"GetListSignalAndControlByStation"
#define GetListSignalAndControlByStationAndTypebase @"GetListSignalAndControlByStationAndTypebase"
#define GetListSignalAndControl @"GetListSignalAndControl"
#define GetControlableSignal @"GetControlableSignal"
#define ControlEquipment @"ControlEquipment"


//刷新时间
#define GetLastCommTime @"GetLastCommTime"

//告警总数
#define GetSumOfAlarm @"GetSumOfAlarm"
#define GetAllListAlarm @"GetAllListAlarm"
#define GetListAlarmByStation @"GetListAlarmByStation"
#define GetListAlarmByStationAndTypebase @"GetListAlarmByStationAndTypebase"
#define GetListAlarm @"GetListAlarm"
#define ConfirmAlarm @"ConfirmAlarm"

//告警历史
#define GetListAlarmDataedByStation @"GetListAlarmDataedByStation"
#define GetListAlarmDataedByStationAndTypebase @"GetListAlarmDataedByStationAndTypebase"
#define GetListAlarmDataed @"GetListAlarmDataed"

//视频
#define GetAllCamera @"GetAllCamera"
#define GetCamera @"GetCamera"
#define GetVideoPicture @"GetVideoPicture"

//报告
#define GetListCruiseReport @"GetListCruiseReport"
#define GetCruiseReportDetail @"GetCruiseReportDetail"
#define DeleteCruiseReport @"DeleteCruiseReport"
#define SaveCruiseReport @"SaveCruiseReport"

#import <Foundation/Foundation.h>
#import <Common/FileCommon.h>
#import <Common/PublicCommon.h>


#define AlertY [UIColor colorWithRed:255/255 green:250/255 blue:107/255 alpha:1]
#define AlertZ [UIColor colorWithRed:186/255 green:2/255 blue:255/255 alpha:1]
#define AlertR [UIColor colorWithRed:255/255 green:55/255 blue:0/255 alpha:1]
#define AlertH [UIColor colorWithRed:128/255 green:128/255 blue:128/255 alpha:1]

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



//sheet委托
@protocol SheetDelegate

//返回sheeti选择的局站信息
-(void)SheetStationinfo:(Stationinfo *)stationinfo;


@optional
//返回选择的大类信息
-(void)SheetEquTypeinfo:(NSString *)EquTypeID EquName:(NSString *)EquName;
-(void)SheetEquipmenyinfo:(NSString *)EquipmentID EquipmentName:(NSString *)EquipmentName;

@end


@interface Common :NSObject<UIPickerViewDataSource,UIPickerViewDelegate>
{
    //存当前局站信息字典
    NSMutableArray *stationinfolist;
    NSArray *equtypelist;//大类信息暂存
    NSArray *devicelist;//设备信息
    Stationinfo stationinfo;
    __block UIPickerView *pickview;
    __block UIActivityIndicatorView *indview;
    int picktype;
    __block UIAlertAction *actionok;
     
}




@property (copy,nonatomic)NSString *ClerkID;//用户ID
@property (copy,nonatomic)NSString *ClerkStationID;//局站ID

@property (strong,nonatomic)NSString *webMainUrl;
@property (copy,nonatomic)NSString *webUrl;
@property (assign)NetEnum NetType;
@property (assign) __block BOOL IsPickALL;


+(instancetype)DefaultCommon;
+(NSString *)HttpString:(NSString *)url port:(int)port;
+(NSString *)HttpString:(NSString *)srv;
+(NSArray *)initLoadingImages;
+(dispatch_queue_t)getThreadQueue;
+(dispatch_queue_t)getThreadMainQueue;
+(void)NetErrorAlert:(NSString *)msg;
+(void)NetOKAlert:(NSString *)msg;
+(int)getphoneX;
+(NSData *)downloadFile:(NSString *)url;

-(BOOL)SaveStationinfo:(NSArray *)arry;
-(Stationinfo *)getStationinfo:(int)index;
-(int)getStationS;
-(void)ShowStationSheet:(UIViewController<SheetDelegate>*) delegate;
-(void)ShowEquTypeSheet:(UIViewController<SheetDelegate> *)delegate stationid:(NSString *)statiodid;
-(void)ShowEquipmentSheet:(UIViewController<SheetDelegate> *)delegate stationid:(NSString *)statiodid equdtypeid:(NSString *)equdtypeid;

-(void)Uninit;
@end