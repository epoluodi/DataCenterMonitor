//
//  ServerConfigViewController.h
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/8.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@class LoginViewController;
@interface ServerConfigViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (weak,nonatomic) LoginViewController *LC;
@property (weak, nonatomic) IBOutlet UITableView *table;
- (IBAction)clickreturn:(id)sender;
- (IBAction)clicksave:(id)sender;

@end
