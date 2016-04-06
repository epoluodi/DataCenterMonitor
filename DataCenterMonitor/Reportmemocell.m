//
//  Reportmemocell.m
//  DataCenterMonitor
//
//  Created by Stereo on 16/4/6.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "Reportmemocell.h"

@implementation Reportmemocell
@synthesize memo,orderid;
@synthesize Height;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    memo.numberOfLines=0;
    memo.lineBreakMode = NSLineBreakByCharWrapping;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//设置cell 的样式
-(void)setCellStyle:(UITableViewCellAccessoryType)style
{
    self.accessoryType = style;
    if (style == UITableViewCellAccessoryNone){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        selectview = nil;
        self.selectedBackgroundView=selectview;
    }
    else
    {
        selectview = [[UIView alloc] init];
        selectview.frame = self.contentView.frame;
        selectview.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.15];
        self.selectedBackgroundView=selectview;
    }
}

//设置备注内容，并且根据备注内容计算高度
//str  备注内容
-(void)setStrMemo:(NSString *)strmemo
{
    memo.text = strmemo;
    CGSize size =[strmemo sizeWithFont:memo.font forWidth:memo.frame.size.width lineBreakMode:NSLineBreakByCharWrapping];
    if (size.height >21)
        Height = size.height + 50;
    else
        Height = 71;
}
@end
