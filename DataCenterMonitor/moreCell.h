//
//  moreCell.h
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/14.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>

//更多委托
@protocol MoreDelegate

-(void)clickMore;

@end



@interface moreCell : UITableViewCell
@property (weak,nonatomic) NSObject<MoreDelegate> *delegate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indview;


//点击显示更多进行
- (IBAction)clickmore:(id)sender;


@end
