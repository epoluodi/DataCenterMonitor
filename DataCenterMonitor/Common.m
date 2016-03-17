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
#import "HttpClass.h"

static Common *_common;

@implementation Common
@synthesize ClerkID,ClerkStationID;
@synthesize webMainUrl,webUrl;
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
    [Common DefaultCommon].webMainUrl = [NSString stringWithFormat:@"http://%@:%d",url,port];
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


/**********************
 函数名：NetErrorAlert
 描述:网络错误提示
 参数：msg 提示信息
 返回：
 **********************/
+(void)NetErrorAlert:(NSString *)msg
{
    dispatch_async([Common getThreadMainQueue], ^{
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"错误" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    });
}
/**********************
 函数名：NetOKAlert
 描述:网络OK提示
 参数：msg 提示信息
 返回：
 **********************/
+(void)NetOKAlert:(NSString *)msg
{
    dispatch_async([Common getThreadMainQueue], ^{
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"错误" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    });
}

/**********************
 函数名：downloadFile
 描述:下载文件
 参数：url 下载地址
 返回：文件数据 NSDATA
 **********************/
+(NSData *)downloadFile:(NSString *)url
{
    @try {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        return data;
    }
    @catch (NSException *exception) {
        return nil;
    }
    
    
}

/**********************
 函数名：getphoneX
 描述:获得iphone逻辑分辨率
 参数：
 返回：逻辑分辨率 X
 **********************/
+(int)getphoneX
{
    if (iPhone6plus)
        return 414;
    if (iPhone6)
        return 375;
    if (iPhone5 || iPhone4)
        return 320;
    return 320;
    
}


#pragma mark 实例化



/**********************
 函数名：ShowStationSheet
 描述:打开局站信息sheet
 参数：delegate 参数协议
 返回：
 **********************/
-(void)ShowStationSheet:(UIViewController<SheetDelegate> *)delegate
{
    picktype=1;
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"局站信息" message:@"\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    //添加pickview
    
    pickview =[[UIPickerView alloc] init];
    pickview.frame = CGRectMake(10, 15, [PublicCommon GetALLScreen].size.width-40, pickview.frame.size.height);
    pickview.dataSource=self;
    pickview.delegate=self;
    pickview.backgroundColor=[UIColor clearColor];
    [alert.view addSubview:pickview];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        if ([pickview selectedRowInComponent:0]==0)
            [delegate SheetStationinfo:NULL];
        else{
            Stationinfo *s = [self getStationinfo:[pickview     selectedRowInComponent:0]-1];
            [delegate SheetStationinfo:s];
        }
        pickview.delegate=nil;
        pickview.dataSource = nil;
        pickview = nil;
        
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [delegate presentViewController:alert animated:YES completion:nil];
}




/**********************
 函数名：ShowEquTypeSheet
 描述:打开大类信息sheet
 参数：delegate 参数协议
 stationid 局站ID
 返回：
 **********************/
-(void)ShowEquTypeSheet:(UIViewController<SheetDelegate> *)delegate stationid:(NSString *)statiodid
{
    picktype=2;
    equtypelist =nil;
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"设备大类信息" message:@"\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    //添加pickview
    pickview =[[UIPickerView alloc] init];
    pickview.frame = CGRectMake(10, 15, [PublicCommon GetALLScreen].size.width-40, pickview.frame.size.height);
    pickview.dataSource=self;
    pickview.delegate=self;
    pickview.backgroundColor=[UIColor clearColor];
    [alert.view addSubview:pickview];
    pickview.hidden=YES;
    
    
    indview = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indview.frame = CGRectMake(pickview.frame.size.width /2 -40 +30, pickview.frame.size.height /2 -20 +15, 40, 40);
    [alert.view addSubview:indview];
    [indview startAnimating];

    actionok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        switch (picktype) {
            case 1:
                if ([pickview selectedRowInComponent:0]==0)
                    [delegate SheetStationinfo:NULL];
                else{
                    Stationinfo *s = [self getStationinfo:[pickview  selectedRowInComponent:0]-1];
                    [delegate SheetStationinfo:s];
                }
                break;
            case 2:
                if ([pickview selectedRowInComponent:0]==0)
                    [delegate SheetEquTypeinfo:nil EquName:nil];
                else{
                    NSDictionary *d = [equtypelist objectAtIndex:[pickview  selectedRowInComponent:0]-1];
                    [delegate SheetEquTypeinfo:[ d objectForKey:@"EquTypeID"] EquName:[ d objectForKey:@"EquTypeName"]];
                }
                
                
                break;
        }

        pickview.delegate=nil;
        pickview.dataSource = nil;
        pickview = nil;
        
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    actionok.enabled=NO;
    [alert addAction:actionok];
    [alert addAction:action2];
    [delegate presentViewController:alert animated:YES completion:nil];
    [self LoadEquTypeBase:statiodid];
}

/**********************
 函数名：ShowEquipmentSheet
 描述:打开设备信息sheet
 参数：delegate 参数协议
 stationid 局站ID
 equdtypeid 大类ID
 返回：
 **********************/
-(void)ShowEquipmentSheet:(UIViewController<SheetDelegate> *)delegate stationid:(NSString *)statiodid equdtypeid:(NSString *)equdtypeid
{
    picktype=3;
    equtypelist =nil;
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"设备信息" message:@"\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    //添加pickview
    pickview =[[UIPickerView alloc] init];
    pickview.frame = CGRectMake(10, 15, [PublicCommon GetALLScreen].size.width-40, pickview.frame.size.height);
    pickview.dataSource=self;
    pickview.delegate=self;
    pickview.backgroundColor=[UIColor clearColor];
    [alert.view addSubview:pickview];
    pickview.hidden=YES;
    
    
    indview = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indview.frame = CGRectMake(pickview.frame.size.width /2 -40 +30, pickview.frame.size.height /2 -20 +15, 40, 40);
    [alert.view addSubview:indview];
    [indview startAnimating];
    
    actionok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        switch (picktype) {
            case 1:
                if ([pickview selectedRowInComponent:0]==0)
                    [delegate SheetStationinfo:NULL];
                else{
                    Stationinfo *s = [self getStationinfo:[pickview  selectedRowInComponent:0]-1];
                    [delegate SheetStationinfo:s];
                }
                break;
            case 2:
                if ([pickview selectedRowInComponent:0]==0)
                    [delegate SheetEquTypeinfo:nil EquName:nil];
                else{
                    NSDictionary *d = [equtypelist objectAtIndex:[pickview  selectedRowInComponent:0]-1];
                    [delegate SheetEquTypeinfo:[ d objectForKey:@"EquTypeID"] EquName:[ d objectForKey:@"EquTypeName"]];
                }
                
                
                break;
            case 3:
                if ([pickview selectedRowInComponent:0]==0)
                    [delegate SheetEquipmenyinfo:nil EquipmentName:nil];
                else{
                    NSDictionary *d = [devicelist objectAtIndex:[pickview  selectedRowInComponent:0]-1];
                    [delegate SheetEquipmenyinfo:[ d objectForKey:@"EquipmentID"] EquipmentName:[ d objectForKey:@"EquipmentName"]];
                }
                
                
                break;
        }
        
        pickview.delegate=nil;
        pickview.dataSource = nil;
        pickview = nil;
        
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    actionok.enabled=NO;
    [alert addAction:actionok];
    [alert addAction:action2];
    [delegate presentViewController:alert animated:YES completion:nil];
    [self LoadEquipment:statiodid EquTypeid:equdtypeid];
}
#pragma mark 读取大类信息和设备信息

/**********************
 函数名：LoadEquTypeBase
 描述:获取局站下面的大类
 参数：当前局站索引
 返回：
 **********************/
-(void)LoadEquTypeBase:(NSString *)stationid
{
    dispatch_async([Common getThreadQueue], ^{
       
        HttpClass *httpclass;
        if (stationid)
        {
            httpclass= [[HttpClass alloc] init:[Common HttpString:GetEquTypebase]];
            [httpclass addParamsString:@"clerkStationID" values:ClerkStationID];
            [httpclass addParamsString:@"clerkID" values:ClerkID];
            [httpclass addParamsString:@"stationID" values:stationid];
            [httpclass addParamsString:@"isReturnPicture" values:@"0"];
        }
        else
        {
            httpclass= [[HttpClass alloc] init:[Common HttpString:GetEquTypebaseByUser]];
            [httpclass addParamsString:@"clerkStationID" values:ClerkStationID];
            [httpclass addParamsString:@"clerkID" values:ClerkID];
            [httpclass addParamsString:@"isReturnPicture" values:@"0"];
        }
        NSData *data = [httpclass httprequest:[httpclass getDataForArrary]];
        NSString *result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        if (result)
        {
            equtypelist = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
            if (!equtypelist)
            {
                equtypelist = [[NSArray alloc] init];
            }
        }
        else
            equtypelist = [[NSArray alloc] init];

        dispatch_async([Common getThreadMainQueue], ^{
            [indview stopAnimating];
            [indview removeFromSuperview];
            actionok.enabled=YES;
            pickview.hidden=NO;
            [pickview reloadAllComponents];
            indview = nil;
            return ;
        });

        
    });
}



/**********************
 函数名：LoadEquipment
 描述:获取局站下面的大类
 参数：当前局站索引
 返回：
 **********************/
-(void)LoadEquipment:(NSString *)stationid EquTypeid:(NSString *)EquTypeid
{
    dispatch_async([Common getThreadQueue], ^{
        
        HttpClass *httpclass;
      
        httpclass= [[HttpClass alloc] init:[Common HttpString:GetEquipment]];
        [httpclass addParamsString:@"clerkStationID" values:ClerkStationID];
        [httpclass addParamsString:@"clerkID" values:ClerkID];
        [httpclass addParamsString:@"stationID" values:stationid];
        [httpclass addParamsString:@"typeBaseID" values:EquTypeid];
        
        NSData *data = [httpclass httprequest:[httpclass getDataForArrary]];
        NSString *result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        if (result)
        {
            devicelist = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
            if (!devicelist)
            {
                devicelist = [[NSArray alloc] init];
            }
        }
        else
            devicelist = [[NSArray alloc] init];
        
        dispatch_async([Common getThreadMainQueue], ^{
            [indview stopAnimating];
            [indview removeFromSuperview];
            actionok.enabled=YES;
            pickview.hidden=NO;
            [pickview reloadAllComponents];
            indview = nil;
            return ;
        });
        
        
    });
}




#pragma mark -


#pragma mark pickview delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (picktype) {
        case 1:
            return [stationinfolist count] +1;
        case 2:
            return [equtypelist count] +1;
        case 3:
            return [devicelist count] +1;
    }
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row==0)
        return @"<全部>";
    if (picktype ==1){
        Stationinfo *s = [self getStationinfo:row-1];
        return [NSString stringWithUTF8String:s->StationName];
    }
    if (picktype==2)
    {
        NSDictionary *d =[equtypelist objectAtIndex:row-1];
        return [d objectForKey:@"EquTypeName"];
    }
    if (picktype==3)
    {
        NSDictionary *d =[devicelist objectAtIndex:row-1];
        return [d objectForKey:@"EquipmentName"];
    }
    return @"";
}



#pragma mark -

/**********************
 函数名：SaveStationinfo
 描述:存当前登录后局站信息
 参数：arry 局站信息json
 返回：YES 成功  NO 失败
 **********************/
-(BOOL)SaveStationinfo:(NSArray *)arry
{
    NSString *path = [FileCommon getCacheDirectory];
    int index=0;
    stationinfolist = [arry copy];
    for (NSDictionary *d in stationinfolist) {
        NSString *url = [NSString stringWithFormat:@"%@%@",webMainUrl,[d objectForKey:@"StationPicturePath"]];
        NSData *data = [Common downloadFile:url];
        
        if (!data)
            return NO;
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *filename = [NSString stringWithFormat:@"%@_%@_%d.png",[d objectForKey:@"StationID"],[d objectForKey:@"StationName"],index];
        NSString* _filename = [path stringByAppendingPathComponent:filename];
        //NSString* new_folder = [doc_path stringByAppendingPathComponent:@"test"];
        //创建目录
        //[fm createDirectoryAtPath:new_folder withIntermediateDirectories:YES attributes:nil error:nil];
        [fm createFileAtPath:_filename contents:data attributes:nil];
        index++;
    }
    
    return YES;
    
}

/**********************
 函数名：getStationS
 描述:获取局站信息数量
 参数：
 返回：数量
 **********************/
-(int)getStationS
{
    return [stationinfolist count];
}

/**********************
 函数名：getStationinfo
 描述:获取局站信息
 参数：index 当前索引
 返回：Stationinfo 结构
 **********************/
-(Stationinfo *)getStationinfo:(int)index
{
    
    NSDictionary *d =stationinfolist[index];
    stationinfo.stationid=[[d objectForKey:@"StationID"] UTF8String];
    stationinfo.StationName=[[d objectForKey:@"StationName"] UTF8String];
    stationinfo.StationPicturePath=[[d objectForKey:@"StationPicturePath"] UTF8String];
    stationinfo.imgpath = [[NSString stringWithFormat:@"%@_%@_%d.png",[d objectForKey:@"StationID"],[d objectForKey:@"StationName"],index] UTF8String];
    return &stationinfo;
}



// 释放Common
-(void)Uninit
{
    [stationinfolist removeAllObjects];
    stationinfolist=nil;
    _common = nil;
}
#pragma mark -

@end