//
//  moreCell.m
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/14.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "moreCell.h"

@implementation moreCell
@synthesize indview;


- (void)awakeFromNib {
    // Initialization code
    indview.hidden=YES;
    self.backgroundColor=[UIColor clearColor];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)clickmore:(id)sender {
    [_delegate clickMore];
}
@end
