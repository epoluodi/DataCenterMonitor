//
//  CamereViewController.m
//  DataCenterMonitor
//
//  Created by Stereo on 16/3/16.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "CamereViewController.h"

@interface CamereViewController ()

@end

@implementation CamereViewController
@synthesize table,searchar1;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    table.backgroundColor=[UIColor clearColor];
    stationid=nil;
    
    table.delegate=self;
    table.dataSource=self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (!CameraList)
        return 0;
    return [CameraList count];;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] init];
    return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell1"];
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *d = [CameraList objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"局站:%@",[d objectForKey:@"StationName"]] ;
    cell.detailTextLabel.text= [NSString stringWithFormat:@"摄像头:%@",[d objectForKey:@"TitleText"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *v =[[UIView alloc] init];
    v.frame=cell.frame;
    v.backgroundColor= [[UIColor blackColor] colorWithAlphaComponent:0.1];
    cell.selectedBackgroundView =v;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
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


#pragma mark sheet 回调

//sheet 选择
-(void)SheetStationinfo:(Stationinfo *)stationinfo
{
    if (stationinfo == NULL)
    {
        stationid=nil;
            [searchar1 setTitle:@"<全部>" forState:UIControlStateNormal];
    }
    else
    {
    stationid =[NSString stringWithUTF8String:stationinfo->stationid];
    [searchar1 setTitle:[NSString stringWithUTF8String:stationinfo->StationName] forState:UIControlStateNormal];
    }
}

#pragma mark -


-(void)loadAllCamera:(NSString *)stationid
{
    loadview= [[LoadingView alloc] init];
    [loadview setImages:[Common initLoadingImages]];
    [self.view addSubview:loadview];
    [loadview StartAnimation];
    
    __block HttpClass *httpclass;
    dispatch_async([Common getThreadQueue], ^{

        httpclass = [[HttpClass alloc] init:[Common HttpString:(stationid)?GetCamera:GetAllCamera]];
        [httpclass addParamsString:@"clerkStationID" values:[Common DefaultCommon].ClerkStationID];
        [httpclass addParamsString:@"clerkID" values:[Common DefaultCommon].ClerkID];
        if (stationid)
            [httpclass addParamsString:@"stationID" values:stationid];

        NSData *data = [httpclass httprequest:[httpclass getDataForArrary]];
        NSString *result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        if (!result)
        {
            dispatch_async([Common getThreadMainQueue], ^{
                [loadview StopAnimation];
                [loadview removeFromSuperview];
                loadview = nil;
            });
            [Common NetErrorAlert:@"信息获取失败"];
            return ;
        }
        CameraList = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        if (!CameraList)
        {
            dispatch_async([Common getThreadMainQueue], ^{
                [loadview StopAnimation];
                [loadview removeFromSuperview];
                loadview = nil;
                [table reloadData];
            });
            [Common NetErrorAlert:@"没哟数据"];
            return ;
        }
        
        
        dispatch_async([Common getThreadMainQueue], ^{
            [loadview StopAnimation];
            [loadview removeFromSuperview];
            loadview = nil;
            [table reloadData];
        });

        
    });

}


// 点击返回
- (IBAction)clickreturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clicksearch1:(id)sender {
    [[Common DefaultCommon] ShowStationSheet:self];
}

- (IBAction)btnsearch:(id)sender {
    [self loadAllCamera:stationid];
}
@end
