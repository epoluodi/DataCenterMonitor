//
//  AlertAndSingalViewController.m
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/16.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "AlertAndSingalViewController.h"
#import <Common/LoadingView.h>

@interface AlertAndSingalViewController ()
{
    LoadingView *loadview;
}
@end

@implementation AlertAndSingalViewController
@synthesize btndevicetype,btnEquType,btnstationinfo;
@synthesize viewtype,bartitle,table;
- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib;
    Stationinfo *s;
    dataarry = [[NSMutableArray alloc] init];
    chkAlertidList = [[NSMutableArray alloc] init];
    NSArray *arryviews= [[NSBundle mainBundle] loadNibNamed:@"moreCell" owner:morecell options:nil];
    morecell = arryviews[0];
    morecell.delegate=self;
    startrecordAlert= 0;
    Isfoot = NO;
    switch (viewtype) {
        case 1:
            bartitle.text=@"信号列表";
            [Common DefaultCommon].IsPickALL = YES;
            break;
        case 2:
            bartitle.text=@"告警列表";
            nib = [UINib nibWithNibName:@"alertlistathome" bundle:nil];
            [table registerNib:nib forCellReuseIdentifier:@"cell"];
            s = [[Common DefaultCommon]getStationinfo:0];
            [btnstationinfo setTitle:[NSString stringWithUTF8String:s->StationName] forState:UIControlStateNormal];
            stationid = [NSString stringWithUTF8String:s->stationid];
            break;
        case 3:
            
            bartitle.text=@"历史告警";
            nib = [UINib nibWithNibName:@"alertlistathome" bundle:nil];
            [table registerNib:nib forCellReuseIdentifier:@"cell"];
            s = [[Common DefaultCommon]getStationinfo:0];
            [btnstationinfo setTitle:[NSString stringWithUTF8String:s->StationName] forState:UIControlStateNormal];
            stationid = [NSString stringWithUTF8String:s->stationid];
            startrecordAlert=0;
            break;
    }
    
    table.backgroundColor=[UIColor clearColor];
    table.delegate=self;
    table.dataSource=self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**********************
 函数名：AddalertId
 描述:告警确认选择
 参数：alerid告警ID
 返回：YES 添加 NO 删除
 **********************/
-(BOOL)AddalertId:(NSString *)alerid
{
    if ([chkAlertidList containsObject:alerid])
    {
        Isfoot =NO;
        [chkAlertidList removeObject:alerid];
        
    }
    else
    {
        Isfoot =YES;
        [chkAlertidList addObject:alerid];
    }
    return Isfoot;
}

#pragma mark 信号列表刷新



#pragma mark -

#pragma mark 告警列表刷新



/**********************
 函数名：loadAlertBystationid
 描述:根据局站加载告警列表信息
 参数：
 返回：
 **********************/
-(void)loadAlertBystationid
{
    
    
    
    dispatch_async([Common getThreadQueue], ^{
        
        HttpClass *httpclass = [[HttpClass alloc] init:[Common HttpString:GetListAlarmByStation]];
        [httpclass addParamsString:@"stationID" values:stationid];
        [httpclass addParamsString:@"startRecord" values:[NSString stringWithFormat:@"%d",startrecordAlert]];
        int sum=EveryOnceCounts;
        [httpclass addParamsString:@"sumRecord" values:[NSString stringWithFormat:@"%d",sum]];
        
        NSData *data = [httpclass httprequest:[httpclass getDataForArrary]];
        NSString *result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        if (!result)
        {
            dispatch_async([Common getThreadMainQueue], ^{
                [morecell.indview stopAnimating];
                if (loadview){
                    [loadview StopAnimation];
                    [loadview removeFromSuperview];
                    loadview = nil;
                }
            });
            [Common NetErrorAlert:@"信息获取失败"];
            return ;
        }
        NSArray * arry = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        if (!arry)
            [Common NetErrorAlert:@"没有数据"];
        else
            [dataarry addObjectsFromArray:arry];
        
        dispatch_async([Common getThreadMainQueue], ^{
            [morecell.indview stopAnimating];
            if (loadview){
                [loadview StopAnimation];
                [loadview removeFromSuperview];
                loadview = nil;
            }
            [table reloadData];
        });
        
        
    });
    
}



/**********************
 函数名：loadAlertBystationidAndEqutypeid
 描述:根据局站和大类加载告警列表信息
 参数：
 返回：
 **********************/
-(void)loadAlertBystationidAndEqutypeid
{
    
    
    
    dispatch_async([Common getThreadQueue], ^{
        
        HttpClass *httpclass = [[HttpClass alloc] init:[Common HttpString:GetListAlarmByStationAndTypebase]];
        [httpclass addParamsString:@"stationID" values:stationid];
        [httpclass addParamsString:@"typeBaseID" values:equtypeid];
        [httpclass addParamsString:@"startRecord" values:[NSString stringWithFormat:@"%d",startrecordAlert]];
        int sum=EveryOnceCounts;
        [httpclass addParamsString:@"sumRecord" values:[NSString stringWithFormat:@"%d",sum]];
        
        NSData *data = [httpclass httprequest:[httpclass getDataForArrary]];
        NSString *result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        if (!result)
        {
            dispatch_async([Common getThreadMainQueue], ^{
                [morecell.indview stopAnimating];
                if (loadview){
                    [loadview StopAnimation];
                    [loadview removeFromSuperview];
                    loadview = nil;
                }
            });
            [Common NetErrorAlert:@"信息获取失败"];
            return ;
        }
        NSArray * arry = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        if (!arry)
            [Common NetErrorAlert:@"没有数据"];
        else
            [dataarry addObjectsFromArray:arry];
        
        dispatch_async([Common getThreadMainQueue], ^{
            [morecell.indview stopAnimating];
            if (loadview){
                [loadview StopAnimation];
                [loadview removeFromSuperview];
                loadview = nil;
            }
            [table reloadData];
        });
        
        
    });
    
}


/**********************
 函数名：loadAlertByALL
 描述:根据局站和大类和设备加载告警列表信息
 参数：
 返回：
 **********************/
-(void)loadAlertByALL
{
    
    
    
    dispatch_async([Common getThreadQueue], ^{
        
        HttpClass *httpclass = [[HttpClass alloc] init:[Common HttpString:GetListAlarm]];
        [httpclass addParamsString:@"stationID" values:stationid];
        [httpclass addParamsString:@"typeBaseID" values:equtypeid];
        [httpclass addParamsString:@"equipmentID" values:deviceid];
        [httpclass addParamsString:@"startRecord" values:[NSString stringWithFormat:@"%d",startrecordAlert]];
        int sum=EveryOnceCounts;
        [httpclass addParamsString:@"sumRecord" values:[NSString stringWithFormat:@"%d",sum]];
        
        NSData *data = [httpclass httprequest:[httpclass getDataForArrary]];
        NSString *result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        if (!result)
        {
            dispatch_async([Common getThreadMainQueue], ^{
                [morecell.indview stopAnimating];
                if (loadview){
                    [loadview StopAnimation];
                    [loadview removeFromSuperview];
                    loadview = nil;
                }
            });
            [Common NetErrorAlert:@"信息获取失败"];
            return ;
        }
        NSArray * arry = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        if (!arry)
            [Common NetErrorAlert:@"没有数据"];
        else
            [dataarry addObjectsFromArray:arry];
        
        dispatch_async([Common getThreadMainQueue], ^{
            [morecell.indview stopAnimating];
            if (loadview){
                [loadview StopAnimation];
                [loadview removeFromSuperview];
                loadview = nil;
            }
            [table reloadData];
        });
        
        
    });
    
}


#pragma mark -

#pragma mark 告警历史刷新


/**********************
 函数名：loadHestoryAlertBystationid
 描述:根据局站加载告警历史信息
 参数：
 返回：
 **********************/
-(void)loadHestoryAlertBystationid
{
    
    
    
    dispatch_async([Common getThreadQueue], ^{
        
        HttpClass *httpclass = [[HttpClass alloc] init:[Common HttpString:GetListAlarmDataedByStation]];
        [httpclass addParamsString:@"stationID" values:stationid];
        [httpclass addParamsString:@"startRecord" values:[NSString stringWithFormat:@"%d",startrecordAlert]];
        [httpclass addParamsString:@"sumRecord" values:[NSString stringWithFormat:@"%d",10]];
        
        NSData *data = [httpclass httprequest:[httpclass getDataForArrary]];
        NSString *result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        if (!result)
        {
            dispatch_async([Common getThreadMainQueue], ^{
                [morecell.indview stopAnimating];
                if (loadview){
                    [loadview StopAnimation];
                    [loadview removeFromSuperview];
                    loadview = nil;
                }
            });
            [Common NetErrorAlert:@"信息获取失败"];
            return ;
        }
        NSArray * arry = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        if (!arry)
            [Common NetErrorAlert:@"没有数据"];
        else
            [dataarry addObjectsFromArray:arry];
        
        dispatch_async([Common getThreadMainQueue], ^{
            [morecell.indview stopAnimating];
            if (loadview){
                [loadview StopAnimation];
                [loadview removeFromSuperview];
                loadview = nil;
            }
            [table reloadData];
        });
        
        
    });
    
}


#pragma mark -
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


//点击告警chk
-(void)clickchk:(NSString *)alertid
{
    
    
    [self AddalertId:alertid];
    
    if ([chkAlertidList count]>0)
        Isfoot =YES;
    else
        Isfoot =NO;
    [table reloadData];
    
}

// 点击更多委托
-(void)clickMore
{
    [morecell.indview startAnimating];
    startrecordAlert += EveryOnceCounts;
    [self clicksearch:nil];
}


#pragma mark table委托
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([dataarry count] == 0)
        return 0;
    return [dataarry count] +1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [dataarry count])
        return 44;
    return 175;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (Isfoot)
        return 50;
    else
        return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v= [[UIView alloc] init];
    if (Isfoot){
        v.frame=morecell.frame;
        v.backgroundColor=[UIColor clearColor];
        if (!btnAlertConfim)
        {
            btnAlertConfim.userInteractionEnabled=YES;
            btnAlertConfim = [[UIButton alloc ] init];
            btnAlertConfim.frame = CGRectMake(120, 5, [PublicCommon GetALLScreen].size.width - 240, 40);
            [btnAlertConfim setTitle:@"确认" forState:UIControlStateNormal];
            [btnAlertConfim setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnAlertConfim setBackgroundImage:[UIImage imageNamed:@"normalbutton_normal"] forState:UIControlStateNormal];
            [btnAlertConfim setBackgroundImage:[UIImage imageNamed:@"normalbutton_down"] forState:UIControlStateHighlighted];
            [btnAlertConfim addTarget:self action:@selector(alertconfim) forControlEvents:UIControlEventTouchUpInside];
            [v addSubview:btnAlertConfim];
            
        }
        else
        {
            [v addSubview:btnAlertConfim];
        }
    }
    else
    {
        [btnAlertConfim removeFromSuperview];
        btnAlertConfim = nil;
    }
    
    return v;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == [dataarry count])
    {
        return morecell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *d = [dataarry objectAtIndex:indexPath.row];
    switch (viewtype) {
        case 1:
            
            break;
            
        case 2:
            return  [self alertlistcell:(alertlisthome *)cell d:d];
        case 3:
            return  [self halertlistcell:(alertlisthome *)cell d:d];
            
    }
    
    return cell;
}



/**********************
 函数名：halertlistcell
 描述:返回告警历史cell
 参数：cell 告警历史cell对象
 d 数据
 返回：UITableViewCell 对象
 **********************/
-(UITableViewCell *)halertlistcell:(alertlisthome *)cell d:(NSDictionary *)d
{
    cell.btncheck.hidden=YES;
    cell.website.text=[NSString stringWithFormat:@"网站:%@",[d objectForKey:@"StationName"]];
    cell.device.text = [NSString stringWithFormat:@"设备:%@",[d objectForKey:@"EquipmentName"]];
    cell.alertid.text=[NSString stringWithFormat:@"告警编号:%@", [d objectForKey:@"AlarmNo"]];
    
    //    告警类型:0-普通;-1-前置机不在线告警;-2-前置机所在磁盘容量低
    //    告警;-3-过滤告警
    //    告警级别:0-正常;1-一般告警;2-重要告警;3-紧急告警
    
    NSString *str1,*str2;
    if ([[d objectForKey:@"AlarmType"] isEqualToString:@"0"])
        str1=@"普通";
    else if([[d objectForKey:@"AlarmType"] isEqualToString:@"1"])
        str1 = @"前置机不在线告警";
    else if([[d objectForKey:@"AlarmType"] isEqualToString:@"2"])
        str1 = @"前置机所在磁盘容量低告警";
    else if([[d objectForKey:@"AlarmType"] isEqualToString:@"3"])
        str1 = @"过滤告警";
    
    if ([[d objectForKey:@"AlarmGrade"] isEqualToString:@"0"])
        str2=@"正常";
    else if([[d objectForKey:@"AlarmGrade"] isEqualToString:@"1"])
        str2 = @"一般告警";
    else if([[d objectForKey:@"AlarmGrade"] isEqualToString:@"2"])
        str2 = @"重要告警";
    else if([[d objectForKey:@"AlarmGrade"] isEqualToString:@"3"])
        str2 = @"紧急告警";
    
    
    cell.alerttype.text = [NSString stringWithFormat:@"类别:%@  级别:%@",str1,str2];
    cell.temp.text=[NSString stringWithFormat:@"%@:%@",[d objectForKey:@"SignalName"],[d objectForKey:@"Meanings"]];
    cell.value.text=[NSString stringWithFormat:@"触发值:%@",[d objectForKey:@"TriggerValue"]];
    
    if ([[d objectForKey:@"StartTime"] isEqualToString:@"1900/1/1 0:00:00"])
        str1 =@"未开始";
    else
        str1 = [d objectForKey:@"StartTime"];
    
    if ([[d objectForKey:@"EndTime"] isEqualToString:@"1900/1/1 0:00:00"])
        str2 =@"未结束";
    else
        str2 = [d objectForKey:@"EndTime"];
    
    
    
    cell.times.text=[NSString stringWithFormat:@"开始时间:%@ 结束时间:%@",str1,str2];
    if ([[d objectForKey:@"ConfirmTime"] isEqualToString:@"1900/1/1 0:00:00"])
        cell.state.text=[NSString stringWithFormat:@"确认时间:%@",@"未确认"];
    else
        cell.state.text=[NSString stringWithFormat:@"确认时间:%@",[d objectForKey:@"ConfirmTime"] ];
    return cell;
}



/**********************
 函数名：alertlistcell
 描述:返回告警列表cell
 参数：cell 告警历史cell对象
 d 数据
 返回：UITableViewCell 对象
 **********************/
-(UITableViewCell *)alertlistcell:(alertlisthome *)cell d:(NSDictionary *)d
{
    cell.delegate=self;
    cell.btncheck.hidden=NO;
    
    cell.website.text=[NSString stringWithFormat:@"网站:%@",[d objectForKey:@"StationName"]];
    cell.device.text = [NSString stringWithFormat:@"设备:%@",[d objectForKey:@"EquipmentName"]];
    cell.alertid.text=[NSString stringWithFormat:@"告警编号:%@", [d objectForKey:@"AlarmNo"]];
    if ([chkAlertidList containsObject:[d objectForKey:@"AlarmNo"]])
    {
        [cell.btncheck setBackgroundImage:[UIImage imageNamed:@"checkbox_button_selected"] forState:UIControlStateNormal];
    }
    else
        [cell.btncheck setBackgroundImage:[UIImage imageNamed:@"checkbox_button_normal"] forState:UIControlStateNormal];
    //    告警类型:0-普通;-1-前置机不在线告警;-2-前置机所在磁盘容量低
    //    告警;-3-过滤告警
    //    告警级别:0-正常;1-一般告警;2-重要告警;3-紧急告警
    
    NSString *str1,*str2;
    if ([[d objectForKey:@"AlarmType"] isEqualToString:@"0"])
        str1=@"普通";
    else if([[d objectForKey:@"AlarmType"] isEqualToString:@"1"])
        str1 = @"前置机不在线告警";
    else if([[d objectForKey:@"AlarmType"] isEqualToString:@"2"])
        str1 = @"前置机所在磁盘容量低告警";
    else if([[d objectForKey:@"AlarmType"] isEqualToString:@"3"])
        str1 = @"过滤告警";
    
    if ([[d objectForKey:@"AlarmGrade"] isEqualToString:@"0"])
        str2=@"正常";
    else if([[d objectForKey:@"AlarmGrade"] isEqualToString:@"1"])
        str2 = @"一般告警";
    else if([[d objectForKey:@"AlarmGrade"] isEqualToString:@"2"])
        str2 = @"重要告警";
    else if([[d objectForKey:@"AlarmGrade"] isEqualToString:@"3"])
        str2 = @"紧急告警";
    
    
    cell.alerttype.text = [NSString stringWithFormat:@"类别:%@  级别:%@",str1,str2];
    cell.temp.text=[NSString stringWithFormat:@"%@:%@",[d objectForKey:@"SignalName"],[d objectForKey:@"Meanings"]];
    cell.value.text=[NSString stringWithFormat:@"触发值:%@",[d objectForKey:@"TriggerValue"]];
    
    if ([[d objectForKey:@"StartTime"] isEqualToString:@"1900/1/1 0:00:00"])
        str1 =@"未开始";
    else
        str1 = [d objectForKey:@"StartTime"];
    
    if ([[d objectForKey:@"EndTime"] isEqualToString:@"1900/1/1 0:00:00"])
        str2 =@"未结束";
    else
        str2 = [d objectForKey:@"EndTime"];
    
    
    
    cell.times.text=[NSString stringWithFormat:@"开始时间:%@ 结束时间:%@",str1,str2];
    if ([[d objectForKey:@"ConfirmTime"] isEqualToString:@"1900/1/1 0:00:00"])
        cell.state.text=[NSString stringWithFormat:@"确认时间:%@",@"未确认"];
    else{
        cell.state.text=[NSString stringWithFormat:@"确认时间:%@",[d objectForKey:@"ConfirmTime"] ];
        cell.btncheck.hidden=YES;
    }
    
    return cell;
}



#pragma mark -
#pragma mark sheet 回调

//局站 选择
-(void)SheetStationinfo:(Stationinfo *)stationinfo
{
    
    if (stationinfo == NULL)
    {
        stationid=nil;
        [btnstationinfo setTitle:@"<全部>" forState:UIControlStateNormal];
    }
    else
    {
        stationid =[NSString stringWithUTF8String:stationinfo->stationid];
        [btnstationinfo setTitle:[NSString stringWithUTF8String:stationinfo->StationName] forState:UIControlStateNormal];
    }
    
    equtypeid=nil;
    deviceid =nil;
    startrecordAlert=0;
    [dataarry removeAllObjects];
    [btnEquType setTitle:@"<全部>" forState:UIControlStateNormal];
    [btndevicetype setTitle:@"<全部>" forState:UIControlStateNormal];
}

//大类选择
-(void)SheetEquTypeinfo:(NSString *)EquTypeID EquName:(NSString *)EquName
{
    
    
    if (EquTypeID == NULL)
    {
        equtypeid =nil;
        [btnEquType setTitle:@"<全部>" forState:UIControlStateNormal];
    }
    else
    {
        equtypeid=EquTypeID;
        [btnEquType setTitle:EquName forState:UIControlStateNormal];
    }
    deviceid =nil;
    startrecordAlert=0;
    [dataarry removeAllObjects];
    [btndevicetype setTitle:@"<全部>" forState:UIControlStateNormal];
}

//设备选择
-(void)SheetEquipmenyinfo:(NSString *)EquipmentID EquipmentName:(NSString *)EquipmentName
{
    
    if (EquipmentID == NULL)
    {
        deviceid =nil;
        [btndevicetype setTitle:@"<全部>" forState:UIControlStateNormal];
    }
    else
    {
        deviceid=EquipmentID;
        [btndevicetype setTitle:EquipmentName forState:UIControlStateNormal];
    }
    startrecordAlert=0;
    [dataarry removeAllObjects];
}
#pragma mark -

//系统方法
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


//告警确认
-(void)alertconfim
{
    
    loadview= [[LoadingView alloc] init];
    [loadview setImages:[Common initLoadingImages]];
    [self.view addSubview:loadview];
    [loadview StartAnimation];
    dispatch_async([Common getThreadQueue], ^{
        
        HttpClass *httpclass = [[HttpClass alloc] init:[Common HttpString:ConfirmAlarm]];
        
        [httpclass addParamsString:@"alarmNos" values:[chkAlertidList componentsJoinedByString:@","]];
        [httpclass addParamsString:@"clerkStationID" values:[Common DefaultCommon].ClerkStationID];
        [httpclass addParamsString:@"clerkID" values:[Common DefaultCommon].ClerkID];
        
        
        NSData *data = [httpclass httprequest:[httpclass getDataForArrary]];
        NSString *result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        if (!result)
        {
            dispatch_async([Common getThreadMainQueue], ^{
                
                if (loadview){
                    [loadview StopAnimation];
                    [loadview removeFromSuperview];
                    loadview = nil;
                }
            });
            [Common NetErrorAlert:@"告警确认失败"];
            return ;
        }
        NSDictionary * dataresult = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        if (!dataresult)
            [Common NetErrorAlert:@"告警确认失败"];
        else{
            if ([[dataresult objectForKey:@"success"] isEqualToString:@"false"])
                [Common NetErrorAlert:@"告警确认失败"];
            else
                [Common NetErrorAlert:@"告警确认成功"];
            
        }
        
        dispatch_async([Common getThreadMainQueue], ^{
            
            if (loadview){
                [loadview StopAnimation];
                [loadview removeFromSuperview];
                loadview = nil;
            }
            [self clicksearch:btnAlertConfim];
        });
        
        
    });
}


//返回
- (IBAction)clickreturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//点击查询
- (IBAction)clicksearch:(id)sender {
    
    if (sender)
    {
        startrecordAlert=0;
        [dataarry removeAllObjects];
        [chkAlertidList removeAllObjects];
        Isfoot=NO;
        loadview= [[LoadingView alloc] init];
        [loadview setImages:[Common initLoadingImages]];
        [self.view addSubview:loadview];
        [loadview StartAnimation];
        
    }
    switch (viewtype) {
        case 1:
            
            break;
            
        case 2:
            if (stationid && !equtypeid && !deviceid)
                [self loadAlertBystationid];
            if (stationid && equtypeid && !deviceid)
                [self loadAlertBystationidAndEqutypeid];
            if (stationid && equtypeid && deviceid)
                [self loadAlertByALL];
            break;
        case 3:
            if (stationid && !equtypeid && !deviceid)
                [self loadHestoryAlertBystationid];
            break;
    }
    
}


//点击局站
- (IBAction)clickstation:(id)sender {
    if (viewtype !=1)
        [Common DefaultCommon].IsPickALL = NO;
    [[Common DefaultCommon] ShowStationSheet:self];
}


//点击大类
- (IBAction)clickequtype:(id)sender {
    
    [Common DefaultCommon].IsPickALL = YES;
    [[Common DefaultCommon] ShowEquTypeSheet:self stationid:stationid];
}

//点击设备
- (IBAction)clickdevice:(id)sender {
    
    if (stationid==nil || equtypeid==nil)
        return;
    [Common DefaultCommon].IsPickALL = YES;
    [[Common DefaultCommon] ShowEquipmentSheet:self stationid:stationid equdtypeid:equtypeid];
}
@end
