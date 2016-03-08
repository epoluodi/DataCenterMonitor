//
//  LoginViewController.m
//  DataCenterMonitor
//
//  Created by Stereo on 16/3/7.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "LoginViewController.h"
#import <Common/PublicCommon.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    
    // Do any additional setup after loading the view.
}

-(void)updateViewConstraints
{
    [super updateViewConstraints];
    [self updateLayout];
}




-(void)updateLayout
{
    NSArray *layoutlist =  self.view.constraints;

    for (NSLayoutConstraint *layout in layoutlist) {
        if ([layout.identifier isEqualToString:@"loginviewTop"])
        {
            if (iPhone6plus)
                layout.constant=40;
        }
    }
    
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnlogin:(id)sender {
}

- (IBAction)btnsetting:(id)sender {
}

- (IBAction)chkremember:(id)sender {
}

- (IBAction)chkautologin:(id)sender {
}

- (IBAction)btnnetinside:(id)sender {
}

- (IBAction)btnnetoutside:(id)sender {
}
@end
