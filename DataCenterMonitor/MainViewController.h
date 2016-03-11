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

@interface MainViewController : UIViewController<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
 
   
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






@end
