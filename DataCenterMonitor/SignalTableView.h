//
//  SignalTableView.h
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/23.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

//设备信号view
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SignalTableView : NSObject<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
  
    
    UILabel *headview;//头部
    UIView *footview;//底部
    UIButton *btnleft, *btnright;//左右 按钮
    UILabel *pagesinfo;
    int page;
}
@property (copy,nonatomic)NSArray *json;

-(UITableView *)getTable:(CGRect)frame;
-(void)setHeadinfo:(NSString *)info;

@end
