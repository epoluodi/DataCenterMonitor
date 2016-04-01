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



typedef enum {
    EDITMODE,BROWERSER,
} ViewMode;


@interface ReportViewDetail : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    __block LoadingView *loadview;
    NSDictionary *detailDict;

}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak,nonatomic)NSString *CRID;
@property (assign)ViewMode viewmode;



- (IBAction)clickreturn:(id)sender;
- (IBAction)clickmore:(id)sender;



@end
