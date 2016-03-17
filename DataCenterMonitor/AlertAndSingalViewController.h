//
//  AlertAndSingalViewController.h
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/16.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"




@interface AlertAndSingalViewController : UIViewController<SheetDelegate>
{
    NSString *stationid;
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
