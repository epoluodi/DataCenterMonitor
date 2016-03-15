//
//  GridCell.h
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/12.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Common/PublicCommon.h>
#import "Common.h"

//首页大类显示样式
@interface GridCell : UICollectionViewCell
{
    
    UIView *backview;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indview;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (copy,nonatomic)NSString *EquTypeID;

-(void)LoadPng:(NSString *)EquTypePicturePath;

@end
