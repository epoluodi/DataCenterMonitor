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
#import "Common.h"
@implementation SignalTableView
@synthesize json,devicename;
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
    
//    UIView *lineview = [[UIView alloc] init];
//    lineview.frame=CGRectMake(0, 1, [PublicCommon GetALLScreen].size.width, 1);
//    lineview.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
//    [footview addSubview:lineview];
    
    btnleft = [[UIButton alloc] init];
    btnleft.frame=CGRectMake(20, 5, 40, 40);
    [btnleft setBackgroundImage:[UIImage imageNamed:@"buttonleft_disable"] forState:UIControlStateNormal];
    btnright = [[UIButton alloc] init];
    btnright.frame=CGRectMake(20 +40 +10, 5, 40, 40);
    [btnright setBackgroundImage:[UIImage imageNamed:@"buttonright_normal"] forState:UIControlStateNormal];
    [btnright setBackgroundImage:[UIImage imageNamed:@"buttonright_down"] forState:UIControlStateNormal];
    
    [btnleft addTarget:self action:@selector(clickleft) forControlEvents:UIControlEventTouchUpInside];
    [btnright addTarget:self action:@selector(clickright) forControlEvents:UIControlEventTouchUpInside];
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
    NSDictionary *d = [json objectAtIndex:page];
    NSArray *a = [d objectForKey:@"SignalInfor"];
    [self setHeadinfo:[NSString stringWithFormat:@"  %@ %@",devicename,[d objectForKey:@"EquipmentName"]]];
    return [a count];
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
    NSArray *a = [d objectForKey:@"SignalInfor"];
    NSDictionary *dict = [a objectAtIndex:indexPath.row];
    cell.signalname.text=[dict objectForKey:@"SignalName"];
    NSString *alertdesc;
    UIColor *colordesc;
    if ([[dict objectForKey:@"AlarmGrade"] isEqualToString:@"0"]){
        alertdesc = @"";//@"无告警";
        colordesc = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        cell.signalimgpath = [dict objectForKey:@"SignalPicturePath"];
        [cell downloadimg:0];
    }
    else     if ([[dict objectForKey:@"AlarmGrade"] isEqualToString:@"1"]){
        alertdesc = @"一般告警";//@"无告警";
        colordesc = AlertY;
                cell.signalimgpath = [dict objectForKey:@"SignalAlarmPicturePath"];
        [cell downloadimg:1];
    }
    else  if ([[dict objectForKey:@"AlarmGrade"] isEqualToString:@"2"]){
        alertdesc = @"重要告警";//@"无告警";
        colordesc = AlertZ;
        cell.signalimgpath = [dict objectForKey:@"SignalAlarmPicturePath"];
        [cell downloadimg:1];
    }
    else  if ([[dict objectForKey:@"AlarmGrade"] isEqualToString:@"3"]){
        alertdesc = @"紧急告警";//@"无告警";
        colordesc = AlertR;
        cell.signalimgpath = [dict objectForKey:@"SignalAlarmPicturePath"];
        [cell downloadimg:1];
    }

    cell.signalstate.text=alertdesc;
    cell.signalstate.textColor=colordesc;
    cell.signalunit.text=[dict objectForKey:@"UnitName"];
    
    NSString *value =[dict objectForKey:@"SignalValue"];
    if ([value isEqualToString:@""])
    {
        if ([[dict objectForKey:@"SignalType"] isEqualToString:@"A"])
        {
            value = [dict objectForKey:@"ShowPrecision"];
        }
    }
    else
    {
        if ([[dict objectForKey:@"SignalType"] isEqualToString:@"A"])
        {
            if ( [[dict objectForKey:@"ShowPrecision"] isEqualToString:@"0"])
            {
                value = [NSString stringWithFormat:@"%d" ,[value intValue]];
            }
            else if ( [[dict objectForKey:@"ShowPrecision"] isEqualToString:@"0.0"])
            {
                value = [NSString stringWithFormat:@"%.1f" ,[value floatValue]];

            }
            else if ( [[dict objectForKey:@"ShowPrecision"] isEqualToString:@"0.00"])
            {
                value = [NSString stringWithFormat:@"%.2f" ,[value floatValue]];

            }
        }
    }
    
    
    cell.signalvalue.text=value;
    cell.signalvalue.textColor=colordesc;
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


#pragma mark -

//设置table 高度
//height 高度
-(void)setTableHeight:(int)height
{
    table.frame = CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width, height);
}

#pragma mark 左右按钮

-(void)clickleft
{
    if (page ==0)
        return;
    page--;
    [self changepages:page];
    [table reloadData];
        
}

-(void)clickright
{
    if (page == [json count] -1)
        return;
    page++;
    [self changepages:page];
    [table reloadData];
}

#pragma mark -

@end







