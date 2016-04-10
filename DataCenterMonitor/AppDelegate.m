//
//  AppDelegate.m
//  DataCenterMonitor
//
//  Created by Stereo on 16/3/7.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "AppDelegate.h"
#import "HttpClass.h"
#import "Common.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                         settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                         categories:nil]];
    
    

    
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入
    // Override point for customization after application launch.
    return YES;
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    __block NSString *token = [[[[deviceToken description]
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""];
    
        NSLog(@"regisger success:%@",deviceToken);
    
    dispatch_async([Common getThreadQueue], ^{
        
        HttpClass *httpclass = [[HttpClass alloc] init:[Common HttpString:SaveAlarmPushPerson]];
        [httpclass addParamsString:@"deviceID" values:[UIDevice currentDevice].identifierForVendor.UUIDString ];
        [httpclass addParamsString:@"token" values:token];
        [httpclass addParamsString:@"clerkStationID" values:[Common DefaultCommon].ClerkStationID];
        [httpclass addParamsString:@"clerkID" values:[Common DefaultCommon].ClerkID];
        
        
        NSData * data = [httpclass httprequest:[httpclass getDataForArrary]];
        NSString * result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        NSDictionary *resultjson = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        if ([[resultjson objectForKey:@"success"] isEqualToString:@"false"])
        {
            [Common NetOKAlert:@"硬件信息保存失败，可能接受不到新告警提示"];
            return ;
        }

    });
    
}



-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    // 处理推送消息
    NSLog(@"userinfo:%@",userInfo);
//    NSString *title =[[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
//    
//    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"通知" message:title delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alert show];
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    sleep(1);
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
