//
//  ReportCell.m
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/4/3.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "ReportCell.h"

@implementation ReportCell
@synthesize getState;
@synthesize celltitile,state;
- (void)awakeFromNib {
    [super awakeFromNib];
    
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}


-(void)setstate:(int)index
{
   
    [self setstate:index enable:YES];
}

-(void)setstate:(int)index enable:(BOOL)enbale
{
    
    selectindex = (StateEnum)index;
    Isselected = enbale;

    if (!Isselected)
    {
        [state setEnabled:NO forSegmentAtIndex:0];
        [state setEnabled:NO forSegmentAtIndex:1];
        if (state.numberOfSegments >2)
            [state setEnabled:NO forSegmentAtIndex:2];
        [state setEnabled:YES forSegmentAtIndex:selectindex];
    }
    [state setSelectedSegmentIndex:selectindex];
    [state setHighlighted:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)changeMode
{
    [state removeAllSegments];
    [state insertSegmentWithTitle:@"现场" atIndex:0 animated:YES];
    [state insertSegmentWithTitle:@"远程" atIndex:1 animated:YES];
    state.selectedSegmentIndex=0;
}
-(void)setCellInfo:(int)bigid subid:(int)subid
{
    id1 = bigid+1;
    id2= subid+1;
}
-(NSString *)getResultString
{
    return [NSString stringWithFormat:@"%d,%d,%d",id1,id2,state.selectedSegmentIndex+1];
}
@end
