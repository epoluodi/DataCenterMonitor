//
//  ReportCell.h
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/4/3.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    NORMAL,EXCEPTION,NOTHING,
} StateEnum;


@interface ReportCell : UITableViewCell
{
    StateEnum selectindex;
    BOOL Isselected;
    int id1,id2;
}
@property (assign,getter=selectindex,readonly)StateEnum getState;
@property (weak, nonatomic) IBOutlet UILabel *celltitile;
@property (weak, nonatomic) IBOutlet UISegmentedControl *state;

-(void)setstate:(int)index;
-(void)setstate:(int)index enable:(BOOL)enbale;

-(void)changeMode;
-(void)setCellInfo:(int)bigid subid:(int)subid;
-(NSString *)getResultString;
@end
