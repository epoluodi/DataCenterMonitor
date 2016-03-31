//
//  ReportViewController.h
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/31.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import <Common/LoadingView.h>
#import "HttpClass.h"
#import <Common/PublicCommon.h>
#import "ReportListCell.h"


@interface ReportViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    __block LoadingView *loadview;
    NSArray *reportlist;
    NSString *cRid;
}
@property (weak, nonatomic) IBOutlet UITableView *table;


- (IBAction)clickquery:(id)sender;
- (IBAction)clickreturn:(id)sender;


@end
