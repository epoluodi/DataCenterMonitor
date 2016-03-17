//
//  AlertAndSingalViewController.m
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/16.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "AlertAndSingalViewController.h"

@interface AlertAndSingalViewController ()

@end

@implementation AlertAndSingalViewController
@synthesize btndevicetype,btnEquType,btnstationinfo;
@synthesize viewtype,bartitle,table;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (viewtype) {
        case 1:
            bartitle.text=@"信号列表";
            break;
        case 2:
            bartitle.text=@"告警列表";

            break;
    }
    
    table.backgroundColor=[UIColor clearColor];
    
    
    // Do any additional setup after loading the view.
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

#pragma mark sheet 回调

//sheet 选择
-(void)SheetStationinfo:(Stationinfo *)stationinfo
{
    if (stationinfo == NULL)
    {
        stationid=nil;
        [btnstationinfo setTitle:@"<全部>" forState:UIControlStateNormal];
    }
    else
    {
        stationid =[NSString stringWithUTF8String:stationinfo->stationid];
        [btnstationinfo setTitle:[NSString stringWithUTF8String:stationinfo->StationName] forState:UIControlStateNormal];
    }
}

//大类选择
-(void)SheetEquTypeinfo:(NSString *)EquTypeID EquName:(NSString *)EquName
{
    if (EquTypeID == NULL)
    {
        stationid=nil;
        [btnEquType setTitle:@"<全部>" forState:UIControlStateNormal];
    }
    else
    {
        [btnEquType setTitle:EquName forState:UIControlStateNormal];
    }
}

#pragma mark -

//系统方法
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}




- (IBAction)clickreturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clicksearch:(id)sender {
}

- (IBAction)clickstation:(id)sender {
    [[Common DefaultCommon] ShowStationSheet:self];
}

- (IBAction)clickequtype:(id)sender {
    [[Common DefaultCommon] ShowEquTypeSheet:self stationid:nil];
}

- (IBAction)clickdevice:(id)sender {
}
@end
