//
//  MemoViewController.h
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/4/7.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportViewDetail.h"

@class ReportViewDetail;
@interface MemoViewController : UIViewController

@property (assign)int index;
@property (weak,nonatomic) ReportViewDetail *viewcontroller;
@property (weak, nonatomic) IBOutlet UITextView *memotxt;
- (IBAction)clickreturn:(id)sender;

@end
