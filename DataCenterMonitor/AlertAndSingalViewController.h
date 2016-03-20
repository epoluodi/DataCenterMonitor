//
//  AlertAndSingalViewController.h
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/16.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "moreCell.h"
#import "HttpClass.h"
#import "alertlisthome.h"
#define EveryOnceCounts 10;//一次最多加载总数


@interface AlertAndSingalViewController : UIViewController<SheetDelegate,MoreDelegate,AlertCellDelegate, UITableViewDataSource,UITableViewDelegate>
{
    NSString *stationid;
    NSString *equtypeid;
    NSString *deviceid;
    
    int startrecordAlert;//当前加载位置
    moreCell *morecell;//更多view
    NSMutableArray *chkAlertidList;//告警确认队列
    NSMutableArray *dataarry;//数据加载队列
    BOOL Isfoot;//是否显示脚
    
    UIButton *btnAlertConfim;
}

@property (weak, nonatomic) IBOutlet UIButton *btnstationinfo;
@property (weak, nonatomic) IBOutlet UIButton *btnEquType;
@property (weak, nonatomic) IBOutlet UIButton *btndevicetype;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *bartitle;
@property (assign)int viewtype;//1信号 2 警告



- (IBAction)clickreturn:(id)sender;
- (IBAction)clicksearch:(id)sender;


- (IBAction)clickstation:(id)sender;
- (IBAction)clickequtype:(id)sender;
- (IBAction)clickdevice:(id)sender;






@end
