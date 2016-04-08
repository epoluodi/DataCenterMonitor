//
//  LoginViewController.m
//  DataCenterMonitor
//
//  Created by Stereo on 16/3/7.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "LoginViewController.h"
#import <Common/PublicCommon.h>
#import <Common/LoadingView.h>

#import "HttpClass.h"
#import "AppDelegate.h"

@class ServerConfigViewController;
@interface LoginViewController ()
{
    ServerConfigView *scv;
    UIView *backview;
    LoadingView *loadview;
    AppDelegate *app;
}

@end

@implementation LoginViewController
@synthesize loginview,rememberpwd,autologin;
@synthesize btnlogin,netinside,netoutside;
@synthesize logintopimgview;

//系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    IsShow = NO;
    // Do any additional setup after loading the view.
}


#pragma mark 界面适应


//系统重载
-(void)viewDidAppear:(BOOL)animated
{
    if (!IsShow){
        [self updateLayout];
        IsShow=YES;
    }
}


/**********************
 函数名：updateLayout
 描述:更新界面布局，自适应不同尺寸设备
 参数：
 返回：
 **********************/
-(void)updateLayout
{
    NSArray *layoutlist =  self.view.constraints;
    
    for (NSLayoutConstraint *layout in layoutlist) {
        if ([layout.identifier isEqualToString:@"loginviewTop"])
        {
            if (iPhone6plus)
                layout.constant=45;
            if (iPhone6)
                layout.constant=40;
            if (iPhone5)
                layout.constant=35;
            
        }
        
    }
    
    layoutlist =logintopimgview.constraints;
    for (NSLayoutConstraint *layout in layoutlist) {
        if ([layout.identifier isEqualToString:@"blueheight"])
        {
            if (iPhone6plus)
                layout.constant=220;
            if (iPhone6)
                layout.constant=200;
            if (iPhone5)
                layout.constant=190;
            
        }
        
    }
    
    [self InitLoginView];
    [self LoadUserInfo];
    [self UpdateUI];
    
    //判断是否自动登录
    if (IschkAutoLogin)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"自动登陆");
            [self btnlogin:nil];
        });
    }
}
#pragma mark -

#pragma mark 用户界面和信息

/**********************
 函数名：LoadUserInfo
 描述:app启动，加载用户信息：用户名，密码和服务配置相关参数
 参数：
 返回：
 **********************/
-(void)LoadUserInfo
{
    NSUserDefaults *userinfo  = [NSUserDefaults standardUserDefaults];
    if ([userinfo integerForKey:@"IsFrist"] == 0)//第一次启动预先创建用户信息
    {
        [userinfo setObject:@"" forKey:@"UserName"];
        [userinfo setObject:@"" forKey:@"UserPwd"];
        [userinfo setInteger:1 forKey:@"rememberpwd"];
        [userinfo setInteger:0 forKey:@"autologin"];
        [userinfo setInteger:NETOUTSIDE forKey:@"netmode"];
        [userinfo setObject:@"192.168.1.1" forKey:@"urlinside"];
        [userinfo setInteger:86 forKey:@"protinside"];
        [userinfo setObject:@"14546223xi.51mypc.cn" forKey:@"urloutside"];
        [userinfo setInteger:86 forKey:@"protoutside"];
        [userinfo setInteger:1 forKey:@"IsNotification"];
        [userinfo setInteger:1 forKey:@"IsFrist"];
        
        IschkAutoLogin = NO;
        IschkRemember=YES;
        NetMode = NETOUTSIDE;
        inport = 86;
        outport=86;
        urlinside = @"192.168.1.1";
        urloutside=@"14546223xi.51mypc.cn";
        
    }
    else
    {
        
        IschkRemember = [userinfo integerForKey:@"rememberpwd"];
        
        NSString *_username =[userinfo stringForKey:@"UserName"] ;
        if (![_username isEqualToString:@""])
        {
            useredit.text=_username;
            
            if (IschkRemember)
            {
                pwdedit.text= [userinfo stringForKey:@"UserPwd"];
            }
        }
        IschkAutoLogin = [userinfo integerForKey:@"autologin"];
        NetMode=(NetEnum)[userinfo integerForKey:@"netmode"];
        urlinside =[userinfo stringForKey:@"urlinside"];
        urloutside =[userinfo stringForKey:@"urloutside"];
        inport=[userinfo integerForKey:@"protinside"];
        outport=[userinfo integerForKey:@"protoutside"];
 
        
    }
}

/**********************
 函数名：UpdateUI
 描述:根据用户信息更新界面相关元素
 参数：
 返回：
 **********************/
-(void)UpdateUI
{
    if(IschkRemember)
        [rememberpwd setImage:[UIImage imageNamed:@"checkbox_button_selected"] forState:UIControlStateNormal];
    else
        [rememberpwd setImage:[UIImage imageNamed:@"checkbox_button_normal"] forState:UIControlStateNormal];
    if(IschkAutoLogin)
        [autologin setImage:[UIImage imageNamed:@"checkbox_button_selected"] forState:UIControlStateNormal];
    else
        [autologin setImage:[UIImage imageNamed:@"checkbox_button_normal"] forState:UIControlStateNormal];
    if(NetMode == NETOUTSIDE){
        [netinside setImage:[UIImage imageNamed:@"radiobutton_focussize_small_normal"] forState:UIControlStateNormal];
        [netoutside setImage:[UIImage imageNamed:@"radiobutton_focussize_large_checked"] forState:UIControlStateNormal];
    }
    else{
        [netinside setImage:[UIImage imageNamed:@"radiobutton_focussize_large_checked"] forState:UIControlStateNormal];
        [netoutside setImage:[UIImage imageNamed:@"radiobutton_focussize_small_normal"] forState:UIControlStateNormal];
    }
}


/**********************
 函数名：InitLoginView
 描述:初始化登陆界面中用户名和密码ui
 参数：
 返回：
 **********************/
-(void)InitLoginView
{
    UIImageView *imgview1 = [[UIImageView alloc] init];
    imgview1.image= [UIImage imageNamed:@"logintable_logo_username"];
    imgview1.frame= CGRectMake(0, 0, 40, 40);
    UIImageView *imgview2 = [[UIImageView alloc] init];
    imgview2.image= [UIImage imageNamed:@"logintable_logo_password"];
    imgview2.frame= CGRectMake(0, 0, 40, 40);
    loginview.userInteractionEnabled=YES;
    useredit = [[UITextField alloc] init];
    useredit.placeholder=@"用户";
    useredit.clearButtonMode = UITextFieldViewModeWhileEditing;
    useredit.frame = CGRectMake(20, 10, loginview.frame.size.width-40, 40);
    useredit.autocorrectionType = UITextAutocorrectionTypeNo;
    [useredit setLeftView:imgview1];
    useredit.leftViewMode = UITextFieldViewModeAlways;
    useredit.keyboardType = UIKeyboardTypeDefault;
    useredit.returnKeyType=UIReturnKeyDone;
    useredit.inputAccessoryView = [PublicCommon getInputToolbar:self sel:@selector(closeinput)];
    [loginview addSubview:useredit];
    
    pwdedit = [[UITextField alloc] init];
    pwdedit.placeholder=@"密码";
    pwdedit.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdedit.inputAccessoryView = [PublicCommon getInputToolbar:self sel:@selector(closeinput)];
    pwdedit.keyboardType = UIKeyboardTypeNumberPad;
    pwdedit.returnKeyType=UIReturnKeyDone;
    pwdedit.autocorrectionType = UITextAutocorrectionTypeNo;
    pwdedit.secureTextEntry = YES; //密码
    pwdedit.frame = CGRectMake(20, 60, loginview.frame.size.width-40, 40);
    [pwdedit setLeftView:imgview2];
    pwdedit.leftViewMode = UITextFieldViewModeAlways;
    [loginview addSubview:pwdedit];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.view.bounds];
    [shapeLayer setPosition:self.view.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0f] CGColor]];
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
     [NSNumber numberWithInt:1],nil];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 15, loginview.bounds.size.height/2 );
    CGPathAddLineToPoint(path, NULL, loginview.frame.size.width -15,loginview.bounds.size.height/2 );
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [loginview.layer addSublayer:shapeLayer];
}

/**********************
 函数名：closeinput
 描述:关闭键盘
 参数：
 返回：
 **********************/
-(void)closeinput
{
    [useredit resignFirstResponder];
    [pwdedit resignFirstResponder];
}

#pragma mark -



#pragma mark view回调控制


/**********************
 函数名：closeServerConfigView
 描述:关闭服务设置界面
 参数：
 返回：
 **********************/
-(void)closeServerConfigView
{
    [backview removeFromSuperview];
    [scv removeFromSuperview];
    scv.VC=nil;
    scv=nil;
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
}
#pragma mark -

//系统方法
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


//系统方法
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //    if ([segue.identifier isEqualToString:@"showconfig"])
    //    {
    //        ServerConfigViewController *SC = [segue destinationViewController];
    //        SC.LC = self;
    //
    //        return;
    //    }
}


/**********************
 函数名：btnsetting
 描述:点击登录
 参数：sender 系统对象
 返回：IBAction 系统对象
 **********************/
- (IBAction)btnlogin:(id)sender {
    if ([useredit.text isEqualToString:@""] ||
        [pwdedit.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名和密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *weburl;
    if (NetMode == NETINSIDE)
        weburl = [Common HttpString:urlinside port:inport];
    if (NetMode == NETOUTSIDE)
        weburl = [Common HttpString:urloutside port:outport];
    
    NSLog(@"web url :%@",weburl);
    [Common DefaultCommon].webUrl=weburl;
    //初始化连接http
    __block HttpClass *httpclass;
    //显示loadview
    loadview= [[LoadingView alloc] init];
    [loadview setImages:[Common initLoadingImages]];
    [self.view addSubview:loadview];
    [loadview StartAnimation];
    dispatch_async([Common getThreadQueue], ^{
        httpclass = [[HttpClass alloc] init:[Common HttpString:UserLogin]];
        [httpclass addParamsString:@"userName" values:useredit.text];
        [httpclass addParamsString:@"userPwd" values:pwdedit.text];
        
        NSData *data = [httpclass httprequest:[httpclass getDataForArrary]];
        NSString *result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        if (!result)
        {
            [self CloseLoadingView];
            [Common NetErrorAlert:@"网络错误，无法登录"];
            
            return ;
        }
        
        NSDictionary *resultjson = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        if ([[resultjson objectForKey:@"success"] isEqualToString:@"false"])
        {
            [self CloseLoadingView];
            [Common NetErrorAlert:@"登录失败!!"];
            return ;
        }
        
        //登录成功记录当前登录界面状态信息
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        [userinfo setInteger:IschkAutoLogin forKey:@"autologin"];
        [userinfo setInteger:IschkRemember forKey:@"rememberpwd"];
        [userinfo setInteger:NetMode forKey:@"netmode"];
        [userinfo setObject:useredit.text forKey:@"UserName"];
        if (IschkRemember)
            [userinfo setObject:pwdedit.text forKey:@"UserPwd"];
        
        //登录信息保存
        NSDictionary *returndata = [resultjson objectForKey:@"data"];
        [Common DefaultCommon].ClerkID =[returndata objectForKey:@"ClerkID"];
        [Common DefaultCommon].ClerkStationID =[returndata objectForKey:@"ClerkStationID"];
        
        
        
        
        
        
        httpclass = [[HttpClass alloc] init:[Common HttpString:SaveAlarmPushPerson]];
        [httpclass addParamsString:@"deviceID" values:[UIDevice currentDevice].identifierForVendor.UUIDString ];
        [httpclass addParamsString:@"token" values:app.token];
        [httpclass addParamsString:@"clerkStationID" values:[Common DefaultCommon].ClerkStationID];
        [httpclass addParamsString:@"clerkID" values:[Common DefaultCommon].ClerkID];
        
        
        data = [httpclass httprequest:[httpclass getDataForArrary]];
        result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);

        
        
        
        httpclass = [[HttpClass alloc] init:[Common HttpString:GetStation]];
        [httpclass addParamsString:@"clerkStationID" values:[Common DefaultCommon].ClerkStationID];
        [httpclass addParamsString:@"clerkID" values:[Common DefaultCommon].ClerkID];
        [httpclass addParamsString:@"isReturnPicture" values:@"1"];
        data = [httpclass httprequest:[httpclass getDataForArrary]];
        result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        if (!result)
        {
            [self CloseLoadingView];
            [Common NetErrorAlert:@"网络错误，无法登录"];
            return ;
        }
        NSArray *arry = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        if (!arry)
        {
            [self CloseLoadingView];
            [Common NetErrorAlert:@"获取局站信息失败!!"];
            return ;
        }
        
        
        if (![[Common DefaultCommon] SaveStationinfo:arry])
        {
            [self CloseLoadingView];
            [Common NetErrorAlert:@"获取局站信息失败!!"];
            return ;
        }
        
        [self CloseLoadingView];
        dispatch_async([Common getThreadMainQueue], ^{
           
            
            [self performSegueWithIdentifier:@"showmain" sender:nil];
     
        });
        
        
    });

    
}

// 关闭load
-(void)CloseLoadingView
{
    dispatch_async([Common getThreadMainQueue], ^{
        if (loadview){
            [loadview StopAnimation];
            [loadview removeFromSuperview];
            loadview=nil;
        }
    });

}


/**********************
 函数名：btnsetting
 描述:点击服务器设置
 参数：sender 系统对象
 返回：IBAction 系统对象
 **********************/
- (IBAction)btnsetting:(id)sender {
    NSArray* xibs = [[NSBundle mainBundle] loadNibNamed:@"serverconfigview" owner:scv options:nil];
    scv = xibs[0];
    scv.VC=self;
    backview = [[UIView alloc] init];
    backview.frame=self.view.frame;
    backview.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.8];
    scv.frame = CGRectMake(20, [PublicCommon GetALLScreen].size.height/2 - 388/2, [PublicCommon GetALLScreen].size.width -40, 388);
    [scv initServerinfo:urlinside in_port:[NSString stringWithFormat:@"%d",inport] out_ip:urloutside out_port:[NSString stringWithFormat:@"%d",outport]];
    [backview addSubview:scv];
    [self.view addSubview:backview];
    
}


/**********************
 函数名：chkremember
 描述:点击记住密码
 参数：sender 系统对象
 返回：IBAction 系统对象
 **********************/
- (IBAction)chkremember:(id)sender {
    IschkRemember = (IschkRemember)?NO:YES;
    [self UpdateUI];
}

/**********************
 函数名：chkautologin
 描述:点击自动登陆
 参数：sender 系统对象
 返回：IBAction 系统对象
 **********************/
- (IBAction)chkautologin:(id)sender {
    IschkAutoLogin = (IschkAutoLogin)?NO:YES;
    [self UpdateUI];
}

/**********************
 函数名：btnnetinside
 描述:点击内网
 参数：sender 系统对象
 返回：IBAction 系统对象
 **********************/
- (IBAction)btnnetinside:(id)sender {
    NetMode =NETINSIDE;
    [self UpdateUI];
}

/**********************
 函数名：btnnetoutside
 描述:点击外网
 参数：sender 系统对象
 返回：IBAction 系统对象
 **********************/
- (IBAction)btnnetoutside:(id)sender {
    NetMode = NETOUTSIDE;
    [self UpdateUI];
}
@end
