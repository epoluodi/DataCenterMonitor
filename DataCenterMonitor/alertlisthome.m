//
//  alertlisthome.m
//  DataCenterMonitor
//
//  Created by Stereo on 16/3/14.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "alertlisthome.h"

@implementation alertlisthome
@synthesize website,alertid,alerttype,device;
@synthesize temp,value,times,state;
@synthesize btncheck;
- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=[UIColor clearColor];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickchk:(id)sender {
    if (_delegate)
    {
        [_delegate clickchk:[alertid.text stringByReplacingOccurrencesOfString:@"告警编号:" withString:@""]];
    }
}
@end
