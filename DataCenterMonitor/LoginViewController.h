//
//  LoginViewController.h
//  DataCenterMonitor
//
//  Created by Stereo on 16/3/7.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface LoginViewController : UIViewController
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



- (IBAction)btnlogin:(id)sender;
- (IBAction)btnsetting:(id)sender;
- (IBAction)chkremember:(id)sender;
- (IBAction)chkautologin:(id)sender;
- (IBAction)btnnetinside:(id)sender;
- (IBAction)btnnetoutside:(id)sender;

//读取用户信息
-(void)LoadUserInfo;

@end
