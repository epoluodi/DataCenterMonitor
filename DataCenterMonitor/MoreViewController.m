//
//  MoreViewController.m
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/15.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "MoreViewController.h"
#import <Common/PublicCommon.h>
#import <Common/LoadingView.h>
#import <Common/FileCommon.h>
#import "Common.h"
#import "AlertAndSingalViewController.h"

@interface MoreViewController ()
{
    LoadingView *loadview;
}
@end

@implementation MoreViewController
@synthesize table,btnReturn;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userinfo  = [NSUserDefaults standardUserDefaults];
    isNotification = [userinfo integerForKey:@"IsNotification"];
    [self LoadUserInfo];
    
    table.backgroundColor=[UIColor clearColor];
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

    return 6;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *v=[UIView new];
    v.frame = cell.frame;
    v.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.1];
    cell.selectedBackgroundView=v;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v=[[UIView alloc] init];
    return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
            cell = [[UITableViewCell alloc] init];
            sw= [[UISwitch alloc] init];
            sw.frame = CGRectMake([PublicCommon GetALLScreen].size.width -50-sw.frame.size.width , 15, sw.frame.size.width, sw.frame.size.height);
            [cell.contentView addSubview:sw];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (isNotification ==1)
                sw.on=YES;
            else
                sw.on=NO;
            [sw addTarget:self action:@selector(changeIsNotification) forControlEvents:UIControlEventValueChanged];
            cell.textLabel.text=@"通知提示";
            break;
        case 1:
            cell = [[UITableViewCell alloc] init];
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=@"历史告警";
            break;
        case 2:
            cell = [[UITableViewCell alloc] init];
       
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=@"服务器设置";
            break;
        case 3:
            cell = [[UITableViewCell alloc] init];
           
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=@"视频预览";
            break;
        case 4:
            cell = [[UITableViewCell alloc] init];
        
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=@"清空本地缓存";
            break;
        case 5:
            cell = [[UITableViewCell alloc] init];
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=@"退出系统";
            break;
    }
    
    // Configure the cell...
    cell.backgroundColor = [UIColor clearColor] ;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* xibs;
    switch (indexPath.row) {
        case 1:
    
            [self performSegueWithIdentifier:@"showhestoryalertview" sender:@3];
            
            break;
        case 2:
            xibs = [[NSBundle mainBundle] loadNibNamed:@"serverconfigview" owner:configview options:nil];
            configview = xibs[0];
            configview.VC=self;
            backview = [[UIView alloc] init];
            backview.frame=self.view.frame;
            backview.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.8];
            configview.frame = CGRectMake(20, [PublicCommon GetALLScreen].size.height/2 - 388/2, [PublicCommon GetALLScreen].size.width -40, 388);
            [configview initServerinfo:urlinside in_port:[NSString stringWithFormat:@"%d",inport] out_ip:urloutside out_port:[NSString stringWithFormat:@"%d",outport]];
            [backview addSubview:configview];
            [self.view addSubview:backview];
            break;
        case 3:
            [self performSegueWithIdentifier:@"showcamre" sender:nil];
            break;
        case 4:
            [self ClearCacheFile];
            
            break;
        case 5:
            
            [self dismissViewControllerAnimated:YES completion:nil];
            [_delegate exitMainView];
            break;
    }
}



#pragma mark -




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@",sender);
    
    if ([segue.identifier isEqualToString:@"showhestoryalertview"])
    {
        AlertAndSingalViewController *vc = (AlertAndSingalViewController *)[segue destinationViewController];
        vc.viewtype = [((NSNumber *)sender) intValue];
        return;
    }
}




/**********************
 函数名：closeServerConfigView
 描述:关闭服务设置界面
 参数：
 返回：
 **********************/
-(void)closeServerConfigView
{
    [backview removeFromSuperview];
    [configview removeFromSuperview];
    configview.VC=nil;
    configview=nil;
}

/**********************
 函数名：updateServerConfigInfo
 描述:更新服务配置界面设置的信息
 参数：nstring in_url 内网url
 nstring in_port 内网端口
 nstring out_url 外网url
 nstring out_port 外网端口
 返回：
 **********************/
-(void)updateServerConfigInfo:(NSString *)in_url in_port:(NSString *)in_port out_url:(NSString *)out_url out_port:(NSString *)out_port
{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    [userinfo setObject:in_url forKey:@"urlinside"];
    [userinfo setInteger:[in_port intValue] forKey:@"protinside"];
    [userinfo setObject:out_url forKey:@"urloutside"];
    [userinfo setInteger:[out_port intValue] forKey:@"protoutside"];
    
    urlinside =in_url;
    urloutside = out_url;
    inport =[in_port intValue];
    outport =out_port.intValue;
    
    NSString *weburl;
    if ((NetEnum)[userinfo integerForKey:@"netmode"] == NETINSIDE)
        weburl = [Common HttpString:urlinside port:inport];
    if ((NetEnum)[userinfo integerForKey:@"netmode"] == NETOUTSIDE)
        weburl = [Common HttpString:urloutside port:outport];
    
    NSLog(@"web url :%@",weburl);
    [Common DefaultCommon].webUrl=weburl;
    
    
}


//读取服务配置信息
-(void)LoadUserInfo
{
    NSUserDefaults *userinfo  = [NSUserDefaults standardUserDefaults];

        urlinside =[userinfo stringForKey:@"urlinside"];
        urloutside =[userinfo stringForKey:@"urloutside"];
        inport=[userinfo integerForKey:@"protinside"];
        outport=[userinfo integerForKey:@"protoutside"];

}


//改变通知事件
-(void)changeIsNotification
{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    if (sw.on)
    {
        [userinfo setInteger:1 forKey:@"IsNotification"];
    }
    else
        [userinfo setInteger:0 forKey:@"IsNotification"];
}

//清除缓存
-(void)ClearCacheFile
{
    //显示loadview
    loadview= [[LoadingView alloc] init];
    [loadview setImages:[Common initLoadingImages]];
    [self.view addSubview:loadview];
    [loadview StartAnimation];
    NSString *path = [FileCommon getCacheDirectory];
    dispatch_async([Common getThreadQueue], ^{
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
      
        //清除文件缓存
        for (NSString *p in files) {
            NSError *error;
            NSString *filepath = [path stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
                [[NSFileManager defaultManager] removeItemAtPath:filepath error:&error];
            }
        }
        
        
        dispatch_async([Common getThreadMainQueue], ^{
            [loadview StopAnimation];
            [loadview removeFromSuperview];
            loadview=nil;
            [Common NetOKAlert:@"清除完成"];
        });
        
        
    });
    
    

}
//状态栏设定
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//点击返回按钮
- (IBAction)clickreturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
