//
//  MoreViewController.h
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/15.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerConfigView.h"

@protocol MoreViewdelegate

-(void)exitMainView;

@end


@interface MoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    int isNotification;//是否需要通知
    UISwitch *sw;
    ServerConfigView *configview;//配置view
}


@property (weak, nonatomic) IBOutlet UIButton *btnReturn;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak,nonatomic) NSObject<MoreViewdelegate> *delegate;

- (IBAction)clickreturn:(id)sender;



@end
