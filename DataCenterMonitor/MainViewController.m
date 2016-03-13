//
//  MainViewController.m
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/8.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "MainViewController.h"
#import "HttpClass.h"
#import "GridCell.h"
@interface MainViewController ()
{
    __block HttpClass *httpclass;
}
@end

@implementation MainViewController
@synthesize gridview;
@synthesize alertview,alertinfo,btnalert;
@synthesize btnreturn,btnmodeview,btnmoreview,btnalertview,btnhome;

//系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    IsShow=NO;
    //根据型号适配局站图片显示的高度
    if (iPhone6plus)
        scrollheight=220;
    if (iPhone6)
        scrollheight=200;
    if (iPhone5)
        scrollheight=190;
    nowPage=0;
    serverrefreshtime=[[UILabel alloc] init];
    serverrefreshtime.textAlignment=NSTextAlignmentRight;
    serverrefreshtime.textColor= [[UIColor grayColor] colorWithAlphaComponent:0.8];
    serverrefreshtime.font=[UIFont systemFontOfSize:14];
    
    [gridview addSubview:serverrefreshtime];
    [self updateLayout];
    [self InitscrollView];
    gridview.backgroundColor=[UIColor clearColor];
    imgview1 = [[UIImageView alloc] init];
    imgview1.image= [UIImage imageNamed:@"closeflag"];
    imgview1.frame= CGRectMake([PublicCommon GetALLScreen].size.width /2 +35, 5, 20, 20);
    [btnalert addSubview:imgview1];

    [gridview registerNib:[UINib nibWithNibName:@"girdcell" bundle:nil] forCellWithReuseIdentifier:@"Collectioncell"];

    gridview.delegate=self;
    gridview.dataSource=self;
    
    
    
        // Do any additional setup after loading the view.
}


-(void)viewDidAppear:(BOOL)animated
{
    serverrefreshtime.frame = CGRectMake(10, gridview.frame.size.height - 30, [PublicCommon GetALLScreen].size.width-20, 30);
    [self getAlertCounts];
}

#pragma mark 网络交互
/**********************
 函数名：LoadEquTypeBase
 描述:获取局站下面的大类
 参数：当前局站索引
 返回：
 **********************/
-(void)LoadEquTypeBase:(int)scrollindex
{
    dispatch_async([Common getThreadQueue], ^{
        Stationinfo *stationinfo= [[Common DefaultCommon] getStationinfo:scrollindex];
        httpclass = [[HttpClass alloc] init:[Common HttpString:GetEquTypebase]];
        [httpclass addParamsString:@"clerkStationID" values:[Common DefaultCommon].ClerkStationID];
        [httpclass addParamsString:@"clerkID" values:[Common DefaultCommon].ClerkID];
        [httpclass addParamsString:@"stationID" values:[NSString stringWithCString:stationinfo->stationid encoding:NSUTF8StringEncoding]];
        [httpclass addParamsString:@"isReturnPicture" values:@"1"];
        NSData *data = [httpclass httprequest:[httpclass getDataForArrary]];
        NSString *result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        if (!result)
        {
            [Common NetErrorAlert:@"信息获取失败"];
            return ;
        }
        NSArray *resultjson = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        if (!resultjson)
        {
            [Common NetErrorAlert:@"信息获取失败"];
            return ;
        }
        NowEquTypeBaseArry =[resultjson copy];
        
        dispatch_async([Common getThreadMainQueue], ^{
            [gridview reloadData];
        });
        [self LoadLastserverTime:[NSString stringWithCString:stationinfo->stationid encoding:NSUTF8StringEncoding]];
        
    });
}

/**********************
 函数名：LoadLastserverTime
 描述:获取局站时间
 参数：局站ID 
 返回：
 **********************/
-(void)LoadLastserverTime:(NSString *)stationID
{
    dispatch_async([Common getThreadQueue], ^{
   
        httpclass = [[HttpClass alloc] init:[Common HttpString:GetLastCommTime]];
        [httpclass addParamsString:@"stationID" values:stationID];
       
        NSData *data = [httpclass httprequest:[httpclass getDataForArrary]];
        NSString *result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        if (!result)
        {
            serverrefreshtime.text=@"";
//            [Common NetErrorAlert:@"信息获取失败"];
            return ;
        }
        NSArray *resultjson = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        if (!resultjson)
        {
            serverrefreshtime.text=@"";
//            [Common NetErrorAlert:@"信息获取失败"];
            return ;
        }
     
        
        dispatch_async([Common getThreadMainQueue], ^{
            NSDictionary *d =resultjson[0];
            serverrefreshtime.text = [NSString stringWithFormat:@"%@ 最后刷新时间::%@",[d objectForKey:@"WorkStationName"],[d objectForKey:@"LastCommTime"]];
            
        });
        
        
    });
}


/**********************
 函数名：getAlertCounts
 描述:获取告警总数
 参数：
 返回：
 **********************/
-(void)getAlertCounts
{
    dispatch_async([Common getThreadQueue], ^{
        
        httpclass = [[HttpClass alloc] init:[Common HttpString:GetSumOfAlarm]];
        NSData *data = [httpclass httprequest:[httpclass getDataForArrary]];
        NSString *result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        if (!result)
        {
            alertinfo.text = @"告警总数 0 条";
            return ;
        }
        NSDictionary *resultjson = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        if (!resultjson)
        {
            alertinfo.text=@"告警总数 0 条";
            return ;
        }
        
        
        dispatch_async([Common getThreadMainQueue], ^{
            alertinfo.text=[NSString stringWithFormat:@"告警总数 %@ 条",[resultjson objectForKey:@"SumOfAlarm"]];
            
        });
        
        
    });
}
#pragma mark scroll委托

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag != 1983)//防止中间滚动栏收到委托影响
        return;
    float page =scrollView.contentOffset.x / [Common getphoneX];
    if(floor(page)==page){
        if (nowPage ==page)
            return;
        nowPage =page;
        NowEquTypeBaseArry =nil;
        [gridview reloadData];
       
        [self LoadEquTypeBase:page];
    }

    
}



#pragma mark -

/**********************
 函数名：updateLayout
 描述:更新界面布局
 参数：
 返回：
 **********************/
-(void)updateLayout
{
    
    NSArray *layoutlist = _scrollview.constraints;
    for (NSLayoutConstraint *layout in layoutlist) {
        if ([layout.identifier isEqualToString:@"scrollheight"])
        {
            
            if (iPhone6plus)
                layout.constant=scrollheight;
            if (iPhone6)
                layout.constant=scrollheight;
            if (iPhone5)
                layout.constant=scrollheight;
        }
    }
    layoutlist = alertview.constraints;
    for (NSLayoutConstraint *layout in layoutlist) {
        if ([layout.identifier isEqualToString:@"alertviewheight"])
        {
            alertviewheight = layout;
        }
    }
    
    
}
#pragma mark 初始化

/**********************
 函数名：initAlertList
 描述:初始化alert 列表
 参数：
 返回：
 **********************/
-(void)initAlertList
{
    
}

/**********************
 函数名：InitscrollView
 描述:初始化局站信息图片
 参数：
 返回：
 **********************/
-(void)InitscrollView
{
    int stations =[[Common DefaultCommon] getStationS];
    _scrollview.contentSize = CGSizeMake([PublicCommon GetALLScreen].size.width*stations , 0);
    _scrollview.bounces=YES;
    _scrollview.pagingEnabled=YES;
    _scrollview.showsHorizontalScrollIndicator=NO;
    _scrollview.showsVerticalScrollIndicator=NO;
    _scrollview.userInteractionEnabled=YES;
    _scrollview.delegate=self;
    _scrollview.tag=1983;
    Stationinfo *stationinfo;
    NSString *path = [FileCommon getCacheDirectory];

    for (int i = 0; i< stations; i++) {
        
        stationinfo = [[Common DefaultCommon]getStationinfo:i];
        NSString* _filename = [path stringByAppendingPathComponent:[NSString stringWithCString:stationinfo->imgpath encoding:NSUTF8StringEncoding]];
        NSData *data = [NSData dataWithContentsOfFile:_filename];
        UIImageView *img = [[UIImageView alloc] init];
        img.frame = CGRectMake(i * [PublicCommon GetALLScreen].size.width, 0, [PublicCommon GetALLScreen].size.width, scrollheight);
        img.image = [UIImage imageWithData:data];
        UILabel *lab = [[UILabel alloc] init];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor=[UIColor blackColor];
        lab.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        lab.text =[NSString stringWithCString:stationinfo->StationName encoding:NSUTF8StringEncoding];
        lab.frame = CGRectMake(0, img.frame.size.height -40, img.frame.size.width, 40);
        [img addSubview:lab];
        [_scrollview addSubview:img];
    }
    [self LoadEquTypeBase:0];
}


#pragma mark -


#pragma mark --UICollectionViewDelegateFlowLayout
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (NowEquTypeBaseArry)
        return [NowEquTypeBaseArry count];
    return 0;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *d  = [NowEquTypeBaseArry objectAtIndex:indexPath.row];
    NSString *strident =[d objectForKey:@"EquTypeName"];
    GridCell *cell;
    @try {
        cell = (GridCell *)[collectionView dequeueReusableCellWithReuseIdentifier:strident forIndexPath:indexPath];
        cell.name.text = [d objectForKey:@"EquTypeName"];
        [cell LoadPng:[d objectForKey:@"EquTypePicturePath"]];
        return cell;
        
    }
    @catch (NSException *exception) {
        [gridview registerNib:[UINib nibWithNibName:@"girdcell" bundle:nil] forCellWithReuseIdentifier:strident];
        cell = (GridCell *)[collectionView dequeueReusableCellWithReuseIdentifier:strident forIndexPath:indexPath];
        cell.img.image=nil;
        cell.name.text = [d objectForKey:@"EquTypeName"];
        [cell LoadPng:[d objectForKey:@"EquTypePicturePath"]];
        return cell;
    }



}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([PublicCommon GetALLScreen].size.width/3 -8, 120);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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


/**********************
 函数名：clickAlert
 描述:点击打开告警信息列表
 参数：
 返回：
 **********************/
- (IBAction)clickAlert:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (alertviewheight.constant==76){
        alertviewheight.constant=76*4;
        imgview1.image = [UIImage imageNamed:@"openflag"];
    }
    else{
        table.delegate=nil;
        table.dataSource=nil;
        [table removeFromSuperview];
        table=nil;
        alertviewheight.constant=76;
        imgview1.image = [UIImage imageNamed:@"closeflag"];
        
    }
    [UIView commitAnimations];
    
}
@end
