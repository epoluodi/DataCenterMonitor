//
//  MemoViewController.h
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/4/7.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportViewDetail.h"
#import <Common/PublicCommon.h>

@class ReportViewDetail;
@interface MemoViewController : UIViewController

@property (assign)int index;
@property (weak,nonatomic) ReportViewDetail *viewcontroller;
@property (weak, nonatomic) IBOutlet UITextView *memotxt;
@property (weak,nonatomic)NSString *str;
- (IBAction)clickreturn:(id)sender;

@end
