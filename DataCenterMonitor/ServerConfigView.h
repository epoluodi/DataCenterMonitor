//
//  ServerConfigView.h
//  DataCenterMonitor
//
//  Created by Stereo on 16/3/9.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@class LoginViewController;



//服务器配置view类
@interface ServerConfigView : UIView



@property (weak,nonatomic) LoginViewController *loginVC;
@property (weak, nonatomic) IBOutlet UITextField *inip;
@property (weak, nonatomic) IBOutlet UITextField *inport;

@property (weak, nonatomic) IBOutlet UITextField *outip;
@property (weak, nonatomic) IBOutlet UITextField *ouport;



- (IBAction)btnOK:(id)sender;
- (IBAction)btnCancel:(id)sender;


-(void)initServerinfo:(NSString *)in_ip in_port:(NSString *)in_port out_ip:(NSString *)out_ip out_port:(NSString *)out_port;

@end
