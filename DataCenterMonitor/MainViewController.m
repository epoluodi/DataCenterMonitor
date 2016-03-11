//
//  MainViewController.m
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/8.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize scrollview,gridview;
@synthesize alertview,alertinfo,btnalert;
@synthesize btnreturn,btnmodeview,btnmoreview,btnalertview,btnhome;

//系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
     [self InitscrollView];
        // Do any additional setup after loading the view.
}


#pragma mark 初始化scroll



/**********************
 函数名：InitscrollView
 描述:初始化局站信息图片
 参数：
 返回：
 **********************/
-(void)InitscrollView
{
    int stations =[[Common DefaultCommon] getStationS];
    scrollview.contentSize = CGSizeMake([PublicCommon GetALLScreen].size.width*stations , 0);
    scrollview.bounces=YES;
    scrollview.pagingEnabled=YES;
    scrollview.showsHorizontalScrollIndicator=NO;
    scrollview.showsVerticalScrollIndicator=NO;
    scrollview.userInteractionEnabled=YES;
    
    Stationinfo *stationinfo;
    NSString *path = [FileCommon getCacheDirectory];

    for (int i = 0; i< stations; i++) {
        
        stationinfo = [[Common DefaultCommon]getStationinfo:i];
        NSString* _filename = [path stringByAppendingPathComponent:[NSString stringWithCString:stationinfo->imgpath encoding:NSUTF8StringEncoding]];
        NSData *data = [NSData dataWithContentsOfFile:_filename];
        UIImageView *img = [[UIImageView alloc] init];
        img.frame = CGRectMake(i * [PublicCommon GetALLScreen].size.width, 0, [PublicCommon GetALLScreen].size.width, scrollview.frame.size.height);
        img.image = [UIImage imageWithData:data];
        UILabel *lab = [[UILabel alloc] init];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor=[UIColor blackColor];
        lab.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        lab.text =[NSString stringWithCString:stationinfo->StationName encoding:NSUTF8StringEncoding];
        lab.frame = CGRectMake(0, img.frame.size.height -40, img.frame.size.width, 40);
        [img addSubview:lab];
        [scrollview addSubview:img];
        
        
        
        
        
        
    }
    
}


#pragma mark -


//系统方法
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

@end
