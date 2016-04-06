//
//  ReportViewController.m
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/31.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportViewDetail.h"

@interface ReportViewController ()

@end

@implementation ReportViewController
@synthesize table;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    table.backgroundColor = [UIColor clearColor];
    UINib *nib=[UINib nibWithNibName:@"reportlistcell" bundle:nil];
    [table registerNib:nib forCellReuseIdentifier:@"cell"];
    table.dataSource=self;
    table.delegate=self;

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clickquery:nil];
    });
}

#pragma mark table委托
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (reportlist)
        return [reportlist count];
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 62;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([reportlist count]> 0)
        return 50;
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v= [[UIView alloc] init];
    if ([reportlist count] > 0){
        v.frame=CGRectMake(0, 15, [PublicCommon GetALLScreen].size.width, 50);
        btnmakeReport = [[UIButton alloc] init];
        btnmakeReport.frame=CGRectMake([PublicCommon GetALLScreen].size.width /2 - ([PublicCommon GetALLScreen].size.width -150) /2, 5, [PublicCommon GetALLScreen].size.width - 150, 30);
        [btnmakeReport setBackgroundImage:[UIImage imageNamed:@"longlongnormalbutton_normal"] forState:UIControlStateNormal];
        [btnmakeReport setBackgroundImage:[UIImage imageNamed:@"longlongnormalbutton_down"] forState:UIControlStateHighlighted];
        [btnmakeReport setTitle:@"生成报告" forState:UIControlStateNormal];
        [btnmakeReport addTarget:self action:@selector(clickmakereport) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:btnmakeReport];
    }
    
    return v;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ReportListCell *cell = [table dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *d = [reportlist objectAtIndex:indexPath.row];
    cell.ClerkName.text = [NSString stringWithFormat:@"巡检人:%@", [d objectForKey:@"ClerkName"]];
    cell.ShowCruiseType.text = [d objectForKey:@"ShowCruiseType"];
    cell.CruiseTime.text =[d objectForKey:@"CruiseTime"];
    cell.backgroundColor = [UIColor clearColor];
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
    NSDictionary *d = [reportlist objectAtIndex:indexPath.row];
    cRid = [d objectForKey:@"CRID"];
    [self performSegueWithIdentifier:@"showreportdetail" sender:self];
    
}


#pragma mark -


//生成报告
-(void)clickmakereport
{
    cRid=nil;
     [self performSegueWithIdentifier:@"showreportdetail" sender:self];
}

/**********************
 函数名：loadReportList
 描述:加载报告列表
 参数：
 返回：
 **********************/
-(void)loadReportList
{
    loadview= [[LoadingView alloc] init];
    [loadview setImages:[Common initLoadingImages]];
    [self.view addSubview:loadview];
    [loadview StartAnimation];
    
    
    dispatch_async([Common getThreadQueue], ^{
        
        HttpClass *httpclass = [[HttpClass alloc] init:[Common HttpString:GetListCruiseReport]];
        [httpclass addParamsString:@"clerkStationID" values:[Common DefaultCommon].ClerkStationID];
        [httpclass addParamsString:@"clerkID" values:[Common DefaultCommon].ClerkID];
        
        
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
            return ;
        }
        reportlist = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        
        
        if (!reportlist)
        {
            [Common NetErrorAlert:@"没有数据"];
            return;
        }
        
        
        dispatch_async([Common getThreadMainQueue], ^{
            
            [table reloadData];
        });
        
        
    });
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//系统方法
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showreportdetail"])
    {
        ReportViewDetail *vc = (ReportViewDetail *)[segue destinationViewController];
        vc.CRID = cRid;
        return;
    }
    
}

//点击查询
- (IBAction)clickquery:(id)sender {
    [self loadReportList];
}

//点击返回
- (IBAction)clickreturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
