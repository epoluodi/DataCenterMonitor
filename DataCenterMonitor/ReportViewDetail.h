//
//  ReportViewDetail.h
//  DataCenterMonitor
//
//  Created by Stereo on 16/4/1.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import <Common/LoadingView.h>
#import "HttpClass.h"
#import <Common/PublicCommon.h>
#import "ReportCell.h"
#import "Reportmemocell.h"
#import "MemoViewController.h"

typedef enum {
    EDITMODE,BROWERSERMODE,
} ViewMode;


@interface ReportViewDetail : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    __block LoadingView *loadview;
    NSDictionary *detailDict;
    ViewMode viewmode;
    float heightlist[5] ;
    NSMutableDictionary *memodict;
    int selectmemo;
}


@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak,nonatomic)NSString *CRID;
@property (weak, nonatomic) IBOutlet UIButton *btnmore;
@property (weak, nonatomic) IBOutlet UILabel *bartitle;
@property (weak, nonatomic) IBOutlet UILabel *reportinfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabletop;



- (IBAction)clickreturn:(id)sender;
- (IBAction)clickmore:(id)sender;

-(void)setMemoStr:(NSString *)str index:(int)index;

@end
