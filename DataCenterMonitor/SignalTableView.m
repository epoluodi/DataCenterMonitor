//
//  SignalTableView.m
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/23.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "SignalTableView.h"
#import <Common/PublicCommon.h>
#import "signalCell.h"

@implementation SignalTableView
@synthesize json;
//类初始化
-(instancetype)init
{
    self=[super init];
    table = [[UITableView alloc] init];
    table.backgroundColor= [UIColor clearColor];
    [self initheadAndFootwhitView];
    return self;
}

//初始化头部和地步view
-(void)initheadAndFootwhitView
{
    headview = [[UILabel alloc] init];
    headview.frame=CGRectMake(0, 0, [PublicCommon GetALLScreen].size.width, 25);
    headview.backgroundColor = [UIColor clearColor];
    headview.textColor = [UIColor grayColor];
    headview.font=[UIFont systemFontOfSize:20];
    
    footview = [[UIView alloc] init];
    footview.frame=CGRectMake(0, 0, [PublicCommon GetALLScreen].size.width, 50);
    footview.backgroundColor = [UIColor clearColor];
    
    btnleft = [[UIButton alloc] init];
    btnleft.frame=CGRectMake(20, 5, 40, 40);
    [btnleft setBackgroundImage:[UIImage imageNamed:@"buttonleft_disable"] forState:UIControlStateNormal];
    btnright = [[UIButton alloc] init];
    btnright.frame=CGRectMake(20 +40 +10, 5, 40, 40);
    [btnright setBackgroundImage:[UIImage imageNamed:@"buttonright_normal"] forState:UIControlStateNormal];
    [btnright setBackgroundImage:[UIImage imageNamed:@"buttonright_down"] forState:UIControlStateNormal];
    
    [footview addSubview:btnleft];
    [footview addSubview:btnright];
    
    pagesinfo = [[UILabel alloc] init];
    pagesinfo.frame=CGRectMake(20 +80 +30, 15, 50, 25);
    pagesinfo.backgroundColor=[UIColor clearColor];
    pagesinfo.textColor=[[UIColor blackColor] colorWithAlphaComponent:0.85];
    [footview addSubview:pagesinfo];
    
    
    
}


/**********************
 函数名：changepages
 描述:页面改变是改变左右按钮状态
 参数：page 当前页面
 返回：
 **********************/
-(void)changepages:(int)page
{
    pagesinfo.text= [NSString stringWithFormat:@"%d / %d",page+1,[json count]];
    if ([json count]==1)
    {
        [btnleft setBackgroundImage:[UIImage imageNamed:@"buttonleft_disable"] forState:UIControlStateNormal];
        [btnright setBackgroundImage:[UIImage imageNamed:@"buttonright_disable"] forState:UIControlStateNormal];
        return;
    }
    
    
    
    if (page == 0)
    {
        [btnleft setBackgroundImage:[UIImage imageNamed:@"buttonleft_disable"] forState:UIControlStateNormal];
        return;
        [btnright setBackgroundImage:[UIImage imageNamed:@"buttonright_normal"] forState:UIControlStateNormal];
 
    }
    
    
    else if (page == [json count] -1)
    {
        [btnright setBackgroundImage:[UIImage imageNamed:@"buttonright_disable"] forState:UIControlStateNormal];
        [btnleft setBackgroundImage:[UIImage imageNamed:@"buttonleft_normal"] forState:UIControlStateNormal];

        return;
    }
    else
    {
        [btnright setBackgroundImage:[UIImage imageNamed:@"buttonright_normal"] forState:UIControlStateNormal];

        [btnleft setBackgroundImage:[UIImage imageNamed:@"buttonleft_normal"] forState:UIControlStateNormal];

    }
}


/**********************
 函数名：getTable
 描述:获得设备信号tableview
 参数：frame 布局参数

 返回：tableview 类
 **********************/
-(UITableView *)getTable:(CGRect)frame
{
    page=0;
    [self changepages:page];
    table.frame = frame;
    table.delegate=self;
    table.dataSource=self;
    UINib *nib  = [UINib nibWithNibName:@"signalCell" bundle:nil];
    [table registerNib:nib forCellReuseIdentifier:@"cell"];
    

  
    
    return table;
}


/**********************
 函数名：setHeadinfo
 描述:设置设备信号 table  设备名称和局站信息
 参数：info 信息名称
 返回：
 **********************/
-(void)setHeadinfo:(NSString *)info
{
    headview.text = info;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!json)
        return 0;
    return [json count];;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    return footview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return headview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    signalCell *cell = [table dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    NSDictionary *d = [json objectAtIndex:page];
    
    cell.signalname.text=@"温度";
    cell.signalstate.text=@"报警";
    cell.signalunit.text=@"!!!";
    cell.signalvalue.text=@"123123";
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


#pragma mark -



@end







