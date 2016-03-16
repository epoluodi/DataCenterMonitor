//
//  LoginViewController.h
//  DataCenterMonitor
//  登录界面
//  Created by Stereo on 16/3/7.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "ServerConfigView.h"
//登录界面控制类
@class ServerConfigView;
@interface LoginViewController : UIViewController<ServiceConfigdelegate>
{
    UITextField *useredit;
    UITextField *pwdedit;
    BOOL IschkRemember,IschkAutoLogin;
    NetEnum NetMode;
    int inport,outport;
    NSString *urlinside,*urloutside;
    BOOL IsShow;
 
    
}



@property (weak, nonatomic) IBOutlet UIImageView *loginview;
@property (weak, nonatomic) IBOutlet UIButton *rememberpwd;
@property (weak, nonatomic) IBOutlet UIButton *autologin;
@property (weak, nonatomic) IBOutlet UIButton *btnlogin;
@property (weak, nonatomic) IBOutlet UIButton *netinside;
@property (weak, nonatomic) IBOutlet UIButton *netoutside;
@property (weak, nonatomic) IBOutlet UIImageView *logintopimgview;



- (IBAction)btnlogin:(id)sender;
- (IBAction)btnsetting:(id)sender;
- (IBAction)chkremember:(id)sender;
- (IBAction)chkautologin:(id)sender;
- (IBAction)btnnetinside:(id)sender;
- (IBAction)btnnetoutside:(id)sender;

//读取用户信息
-(void)LoadUserInfo;


//view 回调关闭
//-(void)closeServerConfigView;
//
//-(void)updateServerConfigInfo:(NSString *)in_url in_port:(NSString *)in_port out_url:(NSString *)out_url out_port:(NSString *)out_port;
@end
