//
//  ReportViewDetail.m
//  DataCenterMonitor
//
//  Created by Stereo on 16/4/1.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "ReportViewDetail.h"

@interface ReportViewDetail ()

@end

@implementation ReportViewDetail
@synthesize table,btnmore,bartitle,reportinfo,tabletop;
@synthesize CRID;
- (void)viewDidLoad {
    [super viewDidLoad];
    table.backgroundColor = [UIColor clearColor];
    reportinfo.text = @"";
    celllist = [[NSMutableArray alloc] init];
    if (CRID){
        [btnmore setTitle:@"删除" forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadReportDetail];
        });
        viewmode=BROWERSERMODE;
        bartitle.text=@"查看报告";
        
    }
    else{
        
        memodict = [[NSMutableDictionary alloc] init];
        bartitle.text=@"生成报告";
        table.delegate=self;
        table.dataSource=self;
        viewmode = EDITMODE;
        [btnmore setTitle:@"保存" forState:UIControlStateNormal];
    }
    
    UINib *nib = [UINib nibWithNibName:@"reportmemocell" bundle:nil];
    [table registerNib:nib forCellReuseIdentifier:@"cell2"];
    
    for (int i =0; i<5; i++) {
        heightlist[i] = 71;
    }
    
    // Do any additional setup after loading the view.
}


//系统方法，重新更新布局
-(void)updateViewConstraints
{
    [super updateViewConstraints];
    if (!CRID){
        tabletop.constant=-20;
        [self updateFocusIfNeeded];
    }
}
#pragma mark table委托
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 7;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
        case 1:
            return 8;
        case 2:
            return 1;
        case 3:
            return 1;
        case 4:
            return 4;
        case 5:
            return 1;
        case 6:
            return 5;
    }
    
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section  == 6)
    {
        return heightlist[indexPath.row];
    }
    return 71;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lab;
    lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(0, 0, [PublicCommon GetALLScreen].size.width, 40);
    lab.textAlignment=NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:14];
    lab.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
    lab.textColor = RGB(127, 127, 127);
    switch (section) {
        case 0:
            lab.text=@"供电";
            break;
        case 1:
            lab.text=@"环境控制";
            break;
        case 2:
            lab.text=@"防火";
            break;
        case 3:
            lab.text=@"监控";
            break;
        case 4:
            lab.text=@"机柜";
            break;
        case 5:
            lab.text=@"巡检方式";
            break;
        case 6:
            lab.text=@"备注";
            break;
    }
    
    
    return lab;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v= [[UIView alloc] init];
    return v;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell2;
    NSArray *arry;
    NSDictionary *dict;
    if (indexPath.section==6)
    {
        Reportmemocell *cell2 = (Reportmemocell*)[table dequeueReusableCellWithIdentifier:@"cell2"];
        cell2.orderid.text = [NSString stringWithFormat:@"序号:%d",indexPath.row+1];
        if (viewmode == EDITMODE)
        {
            [cell2 setCellStyle:UITableViewCellAccessoryDisclosureIndicator];
            
            [cell2 setStrMemo:[memodict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
            heightlist[indexPath.row] = cell2.Height;
            
        }
        else
        {
            [cell2 setCellStyle:UITableViewCellAccessoryNone];
            arry = [detailDict objectForKey:@"CruiseErrorRecord"];
            if (indexPath.row+1<= [arry count] ){
                dict =arry[indexPath.row];
                [cell2 setStrMemo:[dict objectForKey:@"ErrorDescription"]];
                heightlist[indexPath.row] = cell2.Height;
            }
            else{
                [cell2 setStrMemo:@"空"];
                heightlist[indexPath.row] = 71;
            }
        }
        
        return  cell2;
    }
 
    ReportCell *cell = [table dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%i%i",indexPath.section,indexPath.row]];
    if (!cell)
    {
        UINib *nib = [UINib nibWithNibName:@"reportcell" bundle:nil];
        [table registerNib:nib forCellReuseIdentifier:[NSString stringWithFormat:@"%i%i",indexPath.section,indexPath.row]];
        cell = [table dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%i%i",indexPath.section,indexPath.row]];
        
        
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        cell.celltitile.text = @"电源插座工作正常";
                        break;
                    case 1:
                        cell.celltitile.text = @"配电柜开关及电线是否有损坏或有异味异响";
                        break;
                    case 2:
                        cell.celltitile.text = @"UPS无告警";
                        break;
                    case 3:
                        cell.celltitile.text = @"电池外观完好，无膨胀，漏液或变形";
                        break;
                }
                break;
            case 1:
                switch (indexPath.row) {
                    case 0:
                        cell.celltitile.text = @"机房内物品摆放整齐，无垃圾和灰尘";
                        break;
                    case 1:
                        cell.celltitile.text = @"机房地面、墙面是否有漏水及裂缝";
                        break;
                    case 2:
                        cell.celltitile.text = @"室内照明系统是否工作正常";
                        break;
                    case 3:
                        cell.celltitile.text = @"门锁是否有锁芯或把手松动";
                        break;
                    case 4:
                        cell.celltitile.text = @"空调无故障";
                        break;
                    case 5:
                        cell.celltitile.text = @"机房室内温度范围在22℃ - 26℃";
                        break;
                    case 6:
                        cell.celltitile.text = @"机房室内湿度范围在25% - 60%";
                        break;
                    case 7:
                        cell.celltitile.text = @"室外机的运行声音是否正常";
                        break;
                }
                break;
            case 2:
                switch (indexPath.row) {
                    case 0:
                        cell.celltitile.text = @"气体消防是否正常";
                        break;
                        
                        
                }
                break;
            case 3:
                switch (indexPath.row) {
                    case 0:
                        cell.celltitile.text = @"视频监控运行是否正常";
                        break;
                        
                        
                }
                break;
            case 4:
                switch (indexPath.row) {
                    case 0:
                        cell.celltitile.text = @"清除机柜内所有无用的东西";
                        break;
                    case 1:
                        cell.celltitile.text = @"机柜内所有线路应在其各自线槽中";
                        break;
                    case 2:
                        cell.celltitile.text = @"机柜门上锁（包括前、后）";
                        break;
                    case 3:
                        cell.celltitile.text = @"设备指示灯正常，设备运行无异声";
                        break;
                }
                break;
            case 5:
                cell.celltitile.text = @"巡检方式";
                [cell changeMode];
                break;
                
                
        }
        
        
        
        if (viewmode == EDITMODE){
            
            if (indexPath.section != 5)
                [cell setstate:2];
            
        }
        else
        {
            if (indexPath.section == 5)
            {
                if ([[detailDict  objectForKey:@"CruiseType"] isEqualToString:@"1"])
                {
                    [cell setstate:0 enable:NO];
                }
                if ([[detailDict  objectForKey:@"CruiseType"] isEqualToString:@"2"])
                {
                    [cell setstate:1 enable:NO];
                }
                return cell;
                
            }
            arry = [detailDict objectForKey:@"CruiseState"];
            dict =arry[indexPath.section];
            NSArray *arry2 =[dict objectForKey:@"CruiseSubType"];
            NSDictionary *dict2 =arry2[indexPath.row];
            if ([[dict2  objectForKey:@"CState"] isEqualToString:@"1"])
            {
                [cell setstate:0 enable:NO];
            }
            if ([[dict2  objectForKey:@"CState"] isEqualToString:@"2"])
            {
                [cell setstate:1 enable:NO];
            }
            if ([[dict2  objectForKey:@"CState"] isEqualToString:@"3"])
            {
                [cell setstate:2 enable:NO];
            }
            
        }
        [cell setCellInfo:indexPath.section subid:indexPath.row];
        [celllist addObject:cell];
        return cell;
    }
    else
        return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *v = [[UIView alloc] init];
    v.frame = cell.contentView.frame;
    v.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.15];
    cell.selectedBackgroundView=v;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (viewmode == EDITMODE){
        if (indexPath.section == 6)
        {
            selectmemo = indexPath.row;
            [self performSegueWithIdentifier:@"showeditmemo" sender:self];
        }
    }
    
}


#pragma mark -




/**********************
 函数名：loadReportDetail
 描述:加载报告详细界面
 参数：
 返回：
 **********************/
-(void)loadReportDetail
{
    loadview= [[LoadingView alloc] init];
    [loadview setImages:[Common initLoadingImages]];
    [self.view addSubview:loadview];
    [loadview StartAnimation];
    
    
    dispatch_async([Common getThreadQueue], ^{
        
        HttpClass *httpclass = [[HttpClass alloc] init:[Common HttpString:GetCruiseReportDetail]];
        [httpclass addParamsString:@"clerkStationID" values:[Common DefaultCommon].ClerkStationID];
        [httpclass addParamsString:@"clerkID" values:[Common DefaultCommon].ClerkID];
        [httpclass addParamsString:@"cRID" values:CRID];
        
        NSData *data = [httpclass httprequest:[httpclass getDataForArrary]];
        NSString *result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        dispatch_async([Common getThreadMainQueue], ^{
            
            if (loadview){
                [loadview StopAnimation];
                [loadview removeFromSuperview];
                loadview = nil;
            }
            
        });
        if (!result)
        {
            
            [Common NetErrorAlert:@"信息获取失败"];
            dispatch_async([Common getThreadMainQueue], ^{
                
                [self clickreturn:nil];
            });
            return ;
        }
        detailDict = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        
        
        if (!detailDict)
        {
            [Common NetErrorAlert:@"没有数据"];
            dispatch_async([Common getThreadMainQueue], ^{
                
                [self clickreturn:nil];
            });
            return;
        }
        
        
        dispatch_async([Common getThreadMainQueue], ^{
            
            table.delegate=self;
            table.dataSource=self;
            [table reloadData];
            reportinfo.text = [NSString stringWithFormat:@"巡检人:%@      时间:%@",[detailDict objectForKey:@"ClerkName"],[detailDict objectForKey:@"CruiseTime"]];
        });
        
        
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showeditmemo"])
    {
        MemoViewController *vc = (MemoViewController *)[segue destinationViewController];
        vc.viewcontroller = self;
        vc.index = selectmemo;
        vc.str =[memodict objectForKey:[NSString stringWithFormat:@"%d",selectmemo]];
        return;
    }
    
}

//系统方法
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



- (IBAction)clickreturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//点击删除或者是保存
- (IBAction)clickmore:(id)sender {
    if (viewmode == BROWERSERMODE){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认删除" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * action1 =[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self delReport];
        }];
        
        [alert addAction:action];
        [alert addAction:action1];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    else
    {
        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:6] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        
        __block NSString *cruiseType;
        __block NSString *listCruiseState;
        __block NSString *listCruiseErrorRecord;
   
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *arry = [[NSMutableArray alloc] init];

            for (ReportCell *cell in celllist) {
                
                if (cell.state.numberOfSegments == 2)
                {
                    cruiseType = [NSString stringWithFormat:@"%d",cell.state.selectedSegmentIndex+1];
                    NSLog(@"巡检类型 %@",cruiseType);
                    continue;
                }
                [arry addObject:[cell getResultString]];
                
                
            }
           
            NSLog(@"状态字符串 %@",arry);
            listCruiseState =[arry componentsJoinedByString:@";"];
            [arry removeAllObjects];
            NSString *m;
            for (int i = 0; i<5; i++) {
                m=[memodict objectForKey:[NSString stringWithFormat:@"%d",i]];
                if (!m)
                    m=@"";
                [arry addObject:m];
            }
            listCruiseErrorRecord =[arry componentsJoinedByString:@";"];
            
            [self saveReport:cruiseType listCruiseState:listCruiseState listCruiseErrorRecord:listCruiseErrorRecord];
        });
        
        
        
        
        
    }
    
}



/**********************
 函数名：delReport
 描述:删除报告
 参数：
 返回：
 **********************/
-(void)delReport
{
    loadview= [[LoadingView alloc] init];
    [loadview setImages:[Common initLoadingImages]];
    [self.view addSubview:loadview];
    [loadview StartAnimation];
    
    
    dispatch_async([Common getThreadQueue], ^{
        
        HttpClass *httpclass = [[HttpClass alloc] init:[Common HttpString:DeleteCruiseReport]];
        [httpclass addParamsString:@"clerkStationID" values:[Common DefaultCommon].ClerkStationID];
        [httpclass addParamsString:@"clerkID" values:[Common DefaultCommon].ClerkID];
        [httpclass addParamsString:@"cRID" values:CRID];
        
        NSData *data = [httpclass httprequest:[httpclass getDataForArrary]];
        NSString *result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        dispatch_async([Common getThreadMainQueue], ^{
            
            if (loadview){
                [loadview StopAnimation];
                [loadview removeFromSuperview];
                loadview = nil;
            }
            
        });
        if (!result)
        {
            
            [Common NetErrorAlert:@"删除失败"];
            return ;
        }
        NSDictionary *dictdata = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        
        
        if (!dictdata)
        {
            [Common NetErrorAlert:@"删除失败"];
            return;
        }
        
        
        dispatch_async([Common getThreadMainQueue], ^{
            NSDictionary *d = [dictdata objectForKey:@"data"];
            if ([[dictdata objectForKey:@"success"] isEqualToString:@"true"])
                [Common NetOKAlert:[d objectForKey:@"runMsg"]];
            else
                [Common NetErrorAlert:[d objectForKey:@"runMsg"]];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        
        
    });
    
}



/**********************
 函数名：saveReport
 描述:生成报告
 参数：
 返回：
 **********************/
-(void)saveReport:(NSString*)cruiseType listCruiseState:(NSString *)listCruiseState listCruiseErrorRecord:(NSString *)listCruiseErrorRecord
{
    loadview= [[LoadingView alloc] init];
    [loadview setImages:[Common initLoadingImages]];
    [self.view addSubview:loadview];
    [loadview StartAnimation];
    
    
    dispatch_async([Common getThreadQueue], ^{
        
        HttpClass *httpclass = [[HttpClass alloc] init:[Common HttpString:SaveCruiseReport]];
        [httpclass addParamsString:@"clerkStationID" values:[Common DefaultCommon].ClerkStationID];
        [httpclass addParamsString:@"clerkID" values:[Common DefaultCommon].ClerkID];
        [httpclass addParamsString:@"cruiseType" values:cruiseType];
        [httpclass addParamsString:@"listCruiseState" values:listCruiseState];
        [httpclass addParamsString:@"listCruiseErrorRecord" values:listCruiseErrorRecord];
        NSData *data = [httpclass httprequest:[httpclass getDataForArrary]];
        NSString *result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        dispatch_async([Common getThreadMainQueue], ^{
            
            if (loadview){
                [loadview StopAnimation];
                [loadview removeFromSuperview];
                loadview = nil;
            }
            
        });
        if (!result)
        {
            
            [Common NetErrorAlert:@"生成失败"];
            return ;
        }
        NSDictionary *dictdata = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        
        
        if (!dictdata)
        {
            [Common NetErrorAlert:@"生成失败"];
            return;
        }
        
        
        dispatch_async([Common getThreadMainQueue], ^{
            NSDictionary *d = [dictdata objectForKey:@"data"];
            if ([[dictdata objectForKey:@"success"] isEqualToString:@"true"])
                [Common NetOKAlert:[d objectForKey:@"runMsg"]];
            else
                [Common NetErrorAlert:[d objectForKey:@"runMsg"]];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        
        
    });
    
}


//设置备注信息
//str 备注内容
//index 备注索引
-(void)setMemoStr:(NSString *)str index:(int)index
{
    [memodict removeObjectForKey:[NSString stringWithFormat:@"%d",index]];
    [memodict setObject:str forKey:[NSString stringWithFormat:@"%d",index]];
    [table reloadData];
}

@end
