//
//  signalCell.h
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/21.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface signalCell : UITableViewCell
{
    UIActivityIndicatorView *indview;
}

@property (weak, nonatomic) IBOutlet UIImageView *signalimg;
@property (weak, nonatomic) IBOutlet UILabel *signalname;
@property (weak, nonatomic) IBOutlet UILabel *signalstate;
@property (weak, nonatomic) IBOutlet UILabel *signalvalue;
@property (weak, nonatomic) IBOutlet UILabel *signalunit;

@property (weak,nonatomic)NSString *signalimgpath;
@property (weak,nonatomic)NSString *signalimgpathalert;
-(void)downloadimg:(int)flag;


@end
