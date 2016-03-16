//
//  MoreViewController.h
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/15.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerConfigView.h"

//委托
@protocol MoreViewdelegate

//退出到首页
-(void)exitMainView;

@end


@interface MoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ServiceConfigdelegate>
{
    int isNotification;//是否需要通知
    UISwitch *sw;
    ServerConfigView *configview;//配置view
    UIView *backview;
    int inport,outport;
    NSString *urlinside,*urloutside;
}


@property (weak, nonatomic) IBOutlet UIButton *btnReturn;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak,nonatomic) NSObject<MoreViewdelegate> *delegate;

- (IBAction)clickreturn:(id)sender;



@end
