//
//  signalCelllist.h
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/21.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol ControlDelegate

-(void)Control:(NSDictionary *)celldata;

@end


@interface signalCelllist : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *txtdevicename;
@property (weak, nonatomic) IBOutlet UILabel *txtsignalname;
@property (weak, nonatomic) IBOutlet UILabel *txtsigstate;
@property (weak, nonatomic) IBOutlet UILabel *signalvalue;
@property (weak, nonatomic) IBOutlet UILabel *signalunit;
@property (weak, nonatomic) IBOutlet UIButton *btncontrol;
@property (weak,nonatomic) NSDictionary * data;
@property (weak,nonatomic) NSObject<ControlDelegate> *delegate;


- (IBAction)clickcontrol:(id)sender;






@end
