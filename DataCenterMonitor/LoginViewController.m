//
//  LoginViewController.m
//  DataCenterMonitor
//
//  Created by Stereo on 16/3/7.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "LoginViewController.h"
#import <Common/PublicCommon.h>
#import "ServerConfigViewController.h"

@class ServerConfigViewController;
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize loginview,rememberpwd,autologin;
@synthesize btnlogin,netinside,netoutside;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    IsShow = NO;
    // Do any additional setup after loading the view.
}


#pragma mark 界面适应



-(void)viewDidAppear:(BOOL)animated
{
    if (!IsShow){
        [self updateLayout];
        IsShow=YES;
    }
}


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
    
    [self InitLoginView];
    [self LoadUserInfo];
    [self UpdateUI];
}
#pragma mark -

#pragma mark 用户界面和信息


-(void)LoadUserInfo
{
    NSUserDefaults *userinfo  = [NSUserDefaults standardUserDefaults];
    if ([userinfo integerForKey:@"IsFrist"] == 0)
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
        urloutside =[userinfo stringForKey:@"protoutside"];
        inport=[userinfo integerForKey:@"protinside"];
        outport=[userinfo integerForKey:@"protoutside"];
        
    }
}

//更新界面状态
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


//初始化登录UI
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

-(void)closeinput
{
    [useredit resignFirstResponder];
    [pwdedit resignFirstResponder];
}

#pragma mark -

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"showconfig"])
    {
        ServerConfigViewController *SC = [segue destinationViewController];
        SC.LC = self;
        
        return;
    }
}



- (IBAction)btnlogin:(id)sender {
}

- (IBAction)btnsetting:(id)sender {
    [self performSegueWithIdentifier:@"showconfig" sender:self];
}

- (IBAction)chkremember:(id)sender {
    IschkRemember = (IschkRemember)?NO:YES;
    [self UpdateUI];
    
}

- (IBAction)chkautologin:(id)sender {
    IschkAutoLogin = (IschkAutoLogin)?NO:YES;
    [self UpdateUI];
}

- (IBAction)btnnetinside:(id)sender {
    NetMode =NETINSIDE;
    [self UpdateUI];
}

- (IBAction)btnnetoutside:(id)sender {
    NetMode = NETOUTSIDE;
    [self UpdateUI];
}
@end
