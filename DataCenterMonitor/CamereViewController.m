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
    [Common DefaultCommon].IsPickALL=YES;
    [self loadAllCamera:stationid];
    
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
    cell.detailTextLabel.text= [NSString stringWithFormat:@"摄像头:%@",[d objectForKey:@"ShowCameraName"]];
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *d = [CameraList objectAtIndex:indexPath.row];
    
    [self initjpgview:d];
    
}
#pragma mark -


#pragma mark 显示照片

/**********************
 函数名：initjpgview
 描述:根据选择摄像头获取图片
 参数：d 当前选择的摄像头信息
 返回：
 **********************/
-(void)initjpgview:(NSDictionary *)d
{
    backview = [[UIView alloc] init];
    backview.frame=self.view.frame;
    backview.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:backview];
    
    btnclose = [[UIButton alloc] init];
    btnclose.frame = CGRectMake([PublicCommon GetALLScreen].size.width - 50, 30, 30, 30);
    [btnclose setBackgroundImage:[UIImage imageNamed:@"button-close"] forState:UIControlStateNormal];
    [backview addSubview:btnclose];
    [btnclose addTarget:self action:@selector(closejpgview) forControlEvents:UIControlEventTouchUpInside];
    indview = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indview.frame = CGRectMake(backview.frame.size.width /2 - indview.frame.size.width /2, backview.frame.size.height/2 - indview.frame.size.height /2, indview.frame.size.width, indview.frame.size.height);
    [backview addSubview:indview];
    [indview startAnimating];
    jpgview = [[UIImageView alloc] init];
    jpgview.frame = CGRectMake(30, 60, backview.frame.size.width-60, backview.frame.size.height - 120);
    jpgview.contentMode = UIViewContentModeScaleAspectFit;
    IsExit = NO;
    
    dispatch_async([Common getThreadQueue], ^{
        
        HttpClass *httpclass = [[HttpClass alloc] init:[Common HttpString:GetVideoPicture]];
        [httpclass addParamsString:@"clerkStationID" values:[d objectForKey:@"StationID"]];
        [httpclass addParamsString:@"clerkID" values:[Common DefaultCommon].ClerkID];
        [httpclass addParamsString:@"serverIP" values:[d objectForKey:@"ServerIP"]];
        [httpclass addParamsString:@"portNo" values:[d objectForKey:@"PortNo"]];
        [httpclass addParamsString:@"userName" values:[d objectForKey:@"UserName"]];
        [httpclass addParamsString:@"userPwd" values:[d objectForKey:@"UserPwd"]];
        [httpclass addParamsString:@"seqNo" values:[d objectForKey:@"SeqNo"]];
        [httpclass addParamsString:@"requestClientIp" values:@"192.168.1.1"];
        
        NSData *data = [httpclass httprequest:[httpclass getDataForArrary]];
        NSString *result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        if (!result)
        {
            dispatch_async([Common getThreadMainQueue], ^{
                [indview stopAnimating];
                [self closejpgview];
            });
            if (!IsExit)
                [Common NetErrorAlert:@"图片信息获取失败"];
            return ;
        }
        NSDictionary *jpgjson = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        if (!jpgjson)
        {
            dispatch_async([Common getThreadMainQueue], ^{
                [indview stopAnimating];
                [self closejpgview];
            });
            if (!IsExit)
                [Common NetErrorAlert:@"没有图片数据"];
            return ;
        }
        
        NSString *url = [NSString stringWithFormat:@"%@%@",[Common DefaultCommon].webMainUrl,[d objectForKey:@"VideoPicPath"]];
        if (!IsExit)
            return;
        data = [Common downloadFile:url];
        if (!data)
        {
            dispatch_async([Common getThreadMainQueue], ^{
                [indview stopAnimating];
                [self closejpgview];
            });
            if (!IsExit)
                [Common NetErrorAlert:@"没有图片数据"];
            return ;
        }
        if (!IsExit)
            return;
        jpgview.image = [UIImage imageWithData:data];
        dispatch_async([Common getThreadMainQueue], ^{
            [indview stopAnimating];
            [indview removeFromSuperview];
            [backview addSubview:jpgview];
        });
        
        
    });
    
}

//关闭摄像头玉兰
-(void)closejpgview
{
    IsExit = YES;
    btnclose=nil;
    indview=nil;
    jpgview=nil;
    [backview removeFromSuperview];
    backview=nil;
    
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

/**********************
 函数名：loadAllCamera
 描述:根据局站加载所有摄像头信息
 参数：stationid 局站id
 返回：
 **********************/
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
            [Common NetErrorAlert:@"没有数据"];
          
        
        
        
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

//点击所有局站
- (IBAction)clicksearch1:(id)sender {
    [[Common DefaultCommon] ShowStationSheet:self];
}

//点击查询
- (IBAction)btnsearch:(id)sender {
    [self loadAllCamera:stationid];
}

//状态栏设定
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
