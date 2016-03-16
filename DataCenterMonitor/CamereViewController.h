//
//  CamereViewController.h
//  DataCenterMonitor
//
//  Created by Stereo on 16/3/16.
//  Copyright © 2016年 pxzdh. All rights reserved.
//


//视频预览界面
#import <UIKit/UIKit.h>
#import "Common.h"
#import <Common/PublicCommon.h>

@interface CamereViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *searchar1;
@property (weak, nonatomic) IBOutlet UITableView *table;

//点击返回
- (IBAction)clickreturn:(id)sender;
- (IBAction)clicksearch1:(id)sender;
- (IBAction)btnsearch:(id)sender;


@end
