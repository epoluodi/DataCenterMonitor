//
//  ServerConfigView.m
//  DataCenterMonitor
//
//  Created by Stereo on 16/3/9.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "ServerConfigView.h"
#import <Common/PublicCommon.h>
@implementation ServerConfigView
@synthesize inip,inport,ouport,outip;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//系统方法
-(void)awakeFromNib
{
    inip.inputAccessoryView = [PublicCommon getInputToolbar:self sel:@selector(closeinput)];
    inport.inputAccessoryView = [PublicCommon getInputToolbar:self sel:@selector(closeinput)];
    ouport.inputAccessoryView = [PublicCommon getInputToolbar:self sel:@selector(closeinput)];
    outip.inputAccessoryView = [PublicCommon getInputToolbar:self sel:@selector(closeinput)];
    
    
}


/**********************
 函数名：initServerinfo
 描述:初始化服务配置界面信息
 参数：nstring in_ip 内网url
 nstring in_port 内网端口
 nstring out_ip 外网url
 nstring out_port 外网端口
 返回：
 **********************/
-(void)initServerinfo:(NSString *)in_ip in_port:(NSString *)in_port out_ip:(NSString *)out_ip out_port:(NSString *)out_port
{
    inip.text = in_ip;
    inport.text = in_port;
    outip.text = out_ip;
    ouport.text  =out_port;
}

/**********************
 函数名：closeinput
 描述:关闭键盘
 参数：
 返回：
 **********************/
-(void)closeinput
{
    [inip resignFirstResponder];
    [inport resignFirstResponder];
    [ouport resignFirstResponder];
    [outip resignFirstResponder];
}

/**********************
 函数名：btnOK
 描述:点击确定
 参数：sender 系统对象
 返回：IBAction 系统对象
 **********************/
- (IBAction)btnOK:(id)sender {
    
    if ([inip.text isEqualToString:@""]
        || [inport.text isEqualToString:@""]
        || [outip.text isEqualToString:@""]
        || [ouport.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务和端口输入不能为空,请填写正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    [_VC updateServerConfigInfo:inip.text in_port:inport.text out_url:outip.text out_port:ouport.text];
     [_VC closeServerConfigView];
}


/**********************
 函数名：btnCancel
 描述:点击取消
 参数：sender 系统对象
 返回：IBAction 系统对象
 **********************/
- (IBAction)btnCancel:(id)sender {
    [_VC closeServerConfigView];
    
}
@end
