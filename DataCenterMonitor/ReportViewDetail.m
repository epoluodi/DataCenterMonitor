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
@synthesize table;
@synthesize CRID,viewmode;
- (void)viewDidLoad {
    [super viewDidLoad];
    table.backgroundColor = [UIColor clearColor];

 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadReportDetail];
    });
    // Do any additional setup after loading the view.
}




#pragma mark table委托
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (detailDict)
    {
        NSArray *arry =[detailDict objectForKey:@"CruiseState"];
        return [arry count];
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (detailDict)
    {
        NSArray *arry =[detailDict objectForKey:@"CruiseState"];
        NSDictionary *d = [arry objectAtIndex:section];
        NSArray* arrysub = [d objectForKey:@"SubType"];
        return [arrysub count];
    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 62;
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v= [[UIView alloc] init];
    return v;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    ReportListCell *cell = [table dequeueReusableCellWithIdentifier:@"cell"];
//    NSDictionary *d = [reportlist objectAtIndex:indexPath.row];
//    cell.ClerkName.text = [NSString stringWithFormat:@"巡检人:%@", [d objectForKey:@"ClerkName"]];
//    cell.ShowCruiseType.text = [d objectForKey:@"ShowCruiseType"];
//    cell.CruiseTime.text =[d objectForKey:@"CruiseTime"];
//    cell.backgroundColor = [UIColor clearColor];
//    return cell;
    return nil;
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
            
//            [table reloadData];
        });
        
        
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//系统方法
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



- (IBAction)clickreturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickmore:(id)sender {
}
@end
