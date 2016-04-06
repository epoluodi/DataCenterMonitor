//
//  Reportmemocell.h
//  DataCenterMonitor
//
//  Created by Stereo on 16/4/6.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Reportmemocell : UITableViewCell
{
    UIView *selectview;
}

@property (weak, nonatomic) IBOutlet UILabel *orderid;
@property (weak, nonatomic) IBOutlet UILabel *memo;
@property (assign) float Height;

-(void)setCellStyle:(UITableViewCellAccessoryType)style;
-(void)setStrMemo:(NSString *)strmemo;


@end
