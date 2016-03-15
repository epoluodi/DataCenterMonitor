//
//  MainViewController.h
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/8.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Common/PublicCommon.h>
#import "Common.h"
#import "moreCell.h"
#import "MoreViewController.h"


@interface MainViewController : UIViewController<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,MoreDelegate,MoreViewdelegate>
{
    BOOL IsShow;
    int scrollheight;
    UIImageView *imgview1;
    UILabel *serverrefreshtime;
    NSArray *NowEquTypeBaseArry;//当前大类
    int nowPage;//当前页面索引
    NSLayoutConstraint *alertviewheight;//alertview高度
    UITableView *table;
    NSMutableArray *alertlist;
    moreCell *morecell;
    int startrecordAlert;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UICollectionView *gridview;
@property (weak, nonatomic) IBOutlet UIView *alertview;
@property (weak, nonatomic) IBOutlet UILabel *alertinfo;
@property (weak, nonatomic) IBOutlet UIButton *btnalert;

@property (weak, nonatomic) IBOutlet UIButton *btnreturn;
@property (weak, nonatomic) IBOutlet UIButton *btnmodeview;
@property (weak, nonatomic) IBOutlet UIButton *btnmoreview;
@property (weak, nonatomic) IBOutlet UIButton *btnalertview;
@property (weak, nonatomic) IBOutlet UIButton *btnhome;


- (IBAction)clickAlert:(id)sender;
- (IBAction)clickmore:(id)sender;




@end
