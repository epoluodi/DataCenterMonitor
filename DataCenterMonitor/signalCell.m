//
//  signalCell.m
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/21.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "signalCell.h"
#import "Common.h"

@implementation signalCell
@synthesize signalimg;
@synthesize signalname,signalstate,signalunit,signalvalue;
@synthesize signalimgpath,signalimgpathalert;


//下载图片
//flag 0  正常图片 1 报警图片
-(void)downloadimg:(int)flag
{
    NSString *urlstr;
    if (flag==0)
    {
        urlstr = [NSString stringWithFormat:@"%@%@",[Common DefaultCommon].webMainUrl,signalimgpath];
    }
    else
    {
        urlstr = [NSString stringWithFormat:@"%@%@",[Common DefaultCommon].webMainUrl,signalimgpathalert];
    }
    

    NSArray *str = [urlstr componentsSeparatedByString:@"/"];
    NSString *filename = str[[str count]-1];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [FileCommon getCacheDirectory];
    NSString* _filename = [path stringByAppendingPathComponent:filename];
    NSURL *pngpath = [[NSURL alloc] initWithString:[urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    dispatch_async([Common getThreadQueue], ^{
        if ([fm fileExistsAtPath:_filename])
        {
            NSData *pngdata = [NSData dataWithContentsOfFile:_filename];
            if (pngdata)
            {
                dispatch_async([Common getThreadMainQueue], ^{
             
                    signalimg.image= [UIImage imageWithData:pngdata];
                    return;
                });
            }
        }
        dispatch_async([Common getThreadMainQueue], ^{
            indview = [[UIActivityIndicatorView alloc] init];
            indview.frame = signalimg.frame;
            [signalimg addSubview:indview];
            [indview startAnimating];
        });
        
        NSData *data = [NSData dataWithContentsOfURL:pngpath ];
        if (data)
        {
            [fm createFileAtPath:_filename contents:data attributes:nil];
        }
        dispatch_async([Common getThreadMainQueue], ^{
            [indview stopAnimating];
            [indview removeFromSuperview];
            indview=nil;
            if (!data)
                return ;
            signalimg.image= [UIImage imageWithData:data];

        });
    });
   
}
@end
