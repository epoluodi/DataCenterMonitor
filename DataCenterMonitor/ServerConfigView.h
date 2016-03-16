//
//  ServerConfigView.h
//  DataCenterMonitor
//
//  Created by Stereo on 16/3/9.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>









//服务器配置view类


//配置委托
@protocol ServiceConfigdelegate

//回调更新
-(void)updateServerConfigInfo:(NSString *)in_url in_port:(NSString *)in_port out_url:(NSString *)out_url out_port:(NSString *)out_port;
//关闭配置页面
-(void)closeServerConfigView;

@end


@interface ServerConfigView : UIView
@property (weak,nonatomic) NSObject<ServiceConfigdelegate> *VC;
@property (weak, nonatomic) IBOutlet UITextField *inip;
@property (weak, nonatomic) IBOutlet UITextField *inport;

@property (weak, nonatomic) IBOutlet UITextField *outip;
@property (weak, nonatomic) IBOutlet UITextField *ouport;


- (IBAction)btnOK:(id)sender;
- (IBAction)btnCancel:(id)sender;


-(void)initServerinfo:(NSString *)in_ip in_port:(NSString *)in_port out_ip:(NSString *)out_ip out_port:(NSString *)out_port;

@end
