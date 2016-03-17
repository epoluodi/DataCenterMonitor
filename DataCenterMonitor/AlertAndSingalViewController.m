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


#pragma mark 信号列表刷新



#pragma mark -
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark sheet 回调

//局站 选择
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
    
    equtypeid=nil;
    deviceid =nil;
    [btnEquType setTitle:@"<全部>" forState:UIControlStateNormal];
    [btndevicetype setTitle:@"<全部>" forState:UIControlStateNormal];
}

//大类选择
-(void)SheetEquTypeinfo:(NSString *)EquTypeID EquName:(NSString *)EquName
{
    if (EquTypeID == NULL)
    {
        equtypeid =nil;
        [btnEquType setTitle:@"<全部>" forState:UIControlStateNormal];
    }
    else
    {
        equtypeid=EquTypeID;
        [btnEquType setTitle:EquName forState:UIControlStateNormal];
    }
    deviceid =nil;
    [btndevicetype setTitle:@"<全部>" forState:UIControlStateNormal];
}

//设备选择
-(void)SheetEquipmenyinfo:(NSString *)EquipmentID EquipmentName:(NSString *)EquipmentName
{
    if (EquipmentID == NULL)
    {
        deviceid =nil;
        [btndevicetype setTitle:@"<全部>" forState:UIControlStateNormal];
    }
    else
    {
        deviceid=EquipmentID;
        [btndevicetype setTitle:EquipmentName forState:UIControlStateNormal];
    }

}
#pragma mark -

//系统方法
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



//返回
- (IBAction)clickreturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//点击查询
- (IBAction)clicksearch:(id)sender {
}


//点击局站
- (IBAction)clickstation:(id)sender {
    [[Common DefaultCommon] ShowStationSheet:self];
}


//点击大类
- (IBAction)clickequtype:(id)sender {
    [[Common DefaultCommon] ShowEquTypeSheet:self stationid:stationid];
}

//点击设备
- (IBAction)clickdevice:(id)sender {
    
    if (stationid==nil || equtypeid==nil)
        return;
    [[Common DefaultCommon] ShowEquipmentSheet:self stationid:stationid equdtypeid:equtypeid];
}
@end
