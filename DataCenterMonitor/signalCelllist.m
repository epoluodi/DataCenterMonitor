//
//  signalCelllist.m
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/21.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "signalCelllist.h"

@implementation signalCelllist
@synthesize delegate,data;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickcontrol:(id)sender {
    [delegate Control:data];
}
@end
