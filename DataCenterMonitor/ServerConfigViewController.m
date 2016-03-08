//
//  ServerConfigViewController.m
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/8.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "ServerConfigViewController.h"

@interface ServerConfigViewController ()

@end

@implementation ServerConfigViewController
@synthesize table;
@synthesize LC;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    table.backgroundColor=[UIColor clearColor];
    table.delegate=self;
    table.dataSource=self;
    // Do any additional setup after loading the view.
}


#pragma mark  table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v= [[UIView alloc] init];
    return v;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            
            return @"内网";
            
        case 1:
            return  @"外网";
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.contentView.backgroundColor=[UIColor clearColor];
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text=@"123";
    cell.textLabel.backgroundColor=[UIColor clearColor];
    return cell;
}
#pragma mark -


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

- (IBAction)clickreturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clicksave:(id)sender {
    
    [LC LoadUserInfo];
    [self clickreturn:nil];
}
@end
