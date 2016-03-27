//
//  SignalControlViewCOntroller.h
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/26.
//  Copyright © 2016年 pxzdh. All rights reserved.
//
//信号控制
#import <UIKit/UIKit.h>
#import "Common.h"
#import <Common/LoadingView.h>
#import "HttpClass.h"
#import <Common/PublicCommon.h>

@interface SignalControlViewCOntroller : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITextField *username,*pwd,*simvalue;
    int signaltype;
    __block UILabel *controlvalue;
    __block LoadingView *loadview;
    NSDictionary *signalcontrolinfo;
}

@property (weak, nonatomic) IBOutlet UILabel *strtitle;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak,nonatomic) NSDictionary *signaldata;



- (IBAction)clickreturn:(id)sender;
- (IBAction)clicksave:(id)sender;



@end
