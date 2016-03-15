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

    return 5;
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
            cell.textLabel.text=@"服务器设置";
            break;
        case 2:
            cell = [[UITableViewCell alloc] init];
           
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=@"视频预览";
            break;
        case 3:
            cell = [[UITableViewCell alloc] init];
        
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=@"清空本地缓存";
            break;
        case 4:
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
    switch (indexPath.row) {
        case 3:
            [self ClearCacheFile];
            
            break;
        case 4:
            
            [self dismissViewControllerAnimated:YES completion:nil];
            [_delegate exitMainView];
            break;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -

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
