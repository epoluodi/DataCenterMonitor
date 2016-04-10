//
//  MemoViewController.m
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/4/7.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "MemoViewController.h"

@interface MemoViewController ()

@end

@implementation MemoViewController
@synthesize viewcontroller,memotxt,index,str;
- (void)viewDidLoad {
    [super viewDidLoad];
    memotxt.inputAccessoryView = [PublicCommon getInputToolbar:self sel:@selector(closeinput)];
    memotxt.text=str;
    // Do any additional setup after loading the view.
}
-(void)closeinput
{
    [memotxt resignFirstResponder];
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

//系统方法
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)clickreturn:(id)sender {
    [viewcontroller setMemoStr:memotxt.text index:index];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
