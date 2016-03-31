//
//  ReportListCell.m
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/31.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "ReportListCell.h"

@implementation ReportListCell
@synthesize ClerkName,CruiseTime,ShowCruiseType;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
