//
//  alertlisthome.h
//  DataCenterMonitor
//
//  Created by Stereo on 16/3/14.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>

//委托
@protocol AlertCellDelegate


@optional
-(void)clickchk:(NSString *)alertid;
@end
//告警信息列表样式
@interface alertlisthome : UITableViewCell



@property (weak, nonatomic) IBOutlet UIButton *btncheck;

@property (weak, nonatomic) IBOutlet UILabel *website;
@property (weak, nonatomic) IBOutlet UILabel *device;
@property (weak, nonatomic) IBOutlet UILabel *alertid;
@property (weak, nonatomic) IBOutlet UILabel *alerttype;
@property (weak, nonatomic) IBOutlet UILabel *temp;
@property (weak, nonatomic) IBOutlet UILabel *value;
@property (weak, nonatomic) IBOutlet UILabel *times;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak,nonatomic) NSObject<AlertCellDelegate> *delegate;

- (IBAction)clickchk:(id)sender;




@end
