//
//  GridCell.m
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/12.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "GridCell.h"
#import <Common/FileCommon.h>

@implementation GridCell
@synthesize img,name;
@synthesize EquTypeID;
@synthesize indview;
// 系统方法
-(void)awakeFromNib
{

    backview = [[UIView alloc] init];
    backview.frame=self.frame;
    self.selectedBackgroundView=backview;
    img.image=nil;
    
    
}


-(void)LoadPng:(NSString *)EquTypePicturePath
{
    [indview startAnimating];
    indview.hidden=NO;
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",[Common DefaultCommon].webMainUrl,EquTypePicturePath];
    NSArray *str = [urlstr componentsSeparatedByString:@"/"];
    NSString *filename = str[[str count]-1];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [FileCommon getCacheDirectory];
    NSString* _filename = [path stringByAppendingPathComponent:filename];
    NSURL *pngpath = [[NSURL alloc] initWithString:[urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    dispatch_async([Common getThreadQueue], ^{
    if ([fm fileExistsAtPath:_filename])
    {
        NSData *pngdata = [NSData dataWithContentsOfURL:pngpath];
        if (pngdata)
        {
            dispatch_async([Common getThreadMainQueue], ^{
            [indview stopAnimating];
            indview.hidden=YES;
            img.image= [UIImage imageWithData:pngdata];
            return;
            });
        }
    }
  
    
        NSData *data = [NSData dataWithContentsOfURL:pngpath ];
        if (data)
        {
            [fm createFileAtPath:_filename contents:data attributes:nil];
        }
        
        dispatch_async([Common getThreadMainQueue], ^{
            
            [indview stopAnimating];
            indview.hidden=YES;
            if (!data)
                return ;
            img.image= [UIImage imageWithData:data];

            
            
        });
        

  
        
        
        
        
    });
    

    
    
    
}


//系统方法
-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted)
    {
        backview.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.2] ;
    }
    else
    {
        backview.backgroundColor =[UIColor clearColor] ;
    }

}





@end
