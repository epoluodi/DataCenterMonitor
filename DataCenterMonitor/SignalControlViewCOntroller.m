//
//  SignalControlViewCOntroller.m
//  DataCenterMonitor
//
//  Created by 程嘉雯 on 16/3/26.
//  Copyright © 2016年 pxzdh. All rights reserved.
//

#import "SignalControlViewCOntroller.h"

@interface SignalControlViewCOntroller ()

@end

@implementation SignalControlViewCOntroller
@synthesize table,strtitle,signaldata;
- (void)viewDidLoad {
    [super viewDidLoad];
    table.backgroundColor = [UIColor clearColor];
    table.delegate=self;
    table.dataSource=self;
    
    if([[signaldata objectForKey:@"SignalType"] isEqualToString:@"A"])
        signaltype=1;//模拟量
    if([[signaldata objectForKey:@"SignalType"] isEqualToString:@"S"])
        signaltype=2;//开关量
    
    [self loadSignalInfo];
    // Do any additional setup after loading the view.
}



/**********************
 函数名：loadSignalInfo
 描述:加载信号信息
 参数：
 返回：
 **********************/
-(void)loadSignalInfo
{
    loadview= [[LoadingView alloc] init];
    [loadview setImages:[Common initLoadingImages]];
    [self.view addSubview:loadview];
    [loadview StartAnimation];
    
    
    dispatch_async([Common getThreadQueue], ^{
        
        HttpClass *httpclass = [[HttpClass alloc] init:[Common HttpString:GetControlableSignal]];
        [httpclass addParamsString:@"stationID" values:[signaldata objectForKey:@"StationID"]];
        [httpclass addParamsString:@"equipmentID" values:[signaldata objectForKey:@"EquipmentID"]];
        [httpclass addParamsString:@"signalID" values:[signaldata objectForKey:@"SignalID"]];


        
        NSData *data = [httpclass httprequest:[httpclass getDataForArrary]];
        NSString *result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        if (!result)
        {
            dispatch_async([Common getThreadMainQueue], ^{
                
                if (loadview){
                    [loadview StopAnimation];
                    [loadview removeFromSuperview];
                    loadview = nil;
                }
                [self clickreturn:nil];
            });
            [Common NetErrorAlert:@"信息获取失败"];
            return ;
        }
        signalcontrolinfo = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        if (!signalcontrolinfo)
        {
            dispatch_async([Common getThreadMainQueue], ^{
              
                if (loadview){
                    [loadview StopAnimation];
                    [loadview removeFromSuperview];
                    loadview = nil;
                }
                [self clickreturn:nil];
            });
            [Common NetErrorAlert:@"信息获取失败"];
        }

        
        dispatch_async([Common getThreadMainQueue], ^{
          
            if (loadview){
                [loadview StopAnimation];
                [loadview removeFromSuperview];
                loadview = nil;
            }
       
        });
        
        
    });
    
}


#pragma mark table委托
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            
            return 2;
        case 1:
            return 1;

    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lab = [[UILabel alloc] init];
    switch (section) {
        case 0:
            lab.text= @"   操作员验证";
            break;
        case 1:
            if(signaltype==1)
                lab.text= @"   模拟量控制";
            if(signaltype==2)
                lab.text= @"   开关量控制";
            break;

    }
    
    lab.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.85];
    lab.frame =CGRectMake(0, 10, 200, 40);
    return lab;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell = [[UITableViewCell alloc] init];
                    cell.textLabel.text=@"用户名";
                    username = [[UITextField alloc] init];
                    username.frame=CGRectMake([PublicCommon GetALLScreen].size.width - 10 -150, 10, 150, 30);
                    username.placeholder=@"操作账号";
                    username.clearButtonMode = UITextFieldViewModeWhileEditing;
                    username.textAlignment=NSTextAlignmentRight;
                    username.borderStyle = UITextBorderStyleRoundedRect;
                    username.autocorrectionType = UITextAutocorrectionTypeNo;
                 
                    username.keyboardType = UIKeyboardTypeDefault;
                    username.returnKeyType=UIReturnKeyDone;
                    username.inputAccessoryView = [PublicCommon getInputToolbar:self sel:@selector(closeinput)];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    [cell.contentView addSubview:username];
                    break;
                case 1:
                    cell = [[UITableViewCell alloc] init];
                    cell.textLabel.text=@"密码";
                    pwd = [[UITextField alloc] init];
                    pwd.frame=CGRectMake([PublicCommon GetALLScreen].size.width - 10 -150, 10, 150, 30);
                    pwd.placeholder=@"操作密码";
                    pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
                    pwd.textAlignment=NSTextAlignmentRight;
                    pwd.borderStyle = UITextBorderStyleRoundedRect;
                    pwd.autocorrectionType = UITextAutocorrectionTypeNo;
                    pwd.secureTextEntry = YES; //密码
                    pwd.keyboardType = UIKeyboardTypeNumberPad;
                    pwd.returnKeyType=UIReturnKeyDone;
                    pwd.inputAccessoryView = [PublicCommon getInputToolbar:self sel:@selector(closeinput)];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    [cell.contentView addSubview:pwd];
                    
                    
                    
                    break;
            }
            
            break;
       case 1:
            
            if (signaltype ==1)
            {
                cell = [[UITableViewCell alloc] init];
                cell.textLabel.text=@"输入控制值";
                simvalue = [[UITextField alloc] init];
                simvalue.frame=CGRectMake([PublicCommon GetALLScreen].size.width - 10 -150, 10, 150, 30);
                simvalue.placeholder=@"";
                simvalue.clearButtonMode = UITextFieldViewModeWhileEditing;
                simvalue.textAlignment=NSTextAlignmentRight;
                simvalue.borderStyle = UITextBorderStyleRoundedRect;
                simvalue.autocorrectionType = UITextAutocorrectionTypeNo;
                
                simvalue.keyboardType = UIKeyboardTypeDecimalPad;
                simvalue.returnKeyType=UIReturnKeyDone;
                simvalue.inputAccessoryView = [PublicCommon getInputToolbar:self sel:@selector(closeinput)];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:simvalue];
                
            }
            if (signaltype ==2)
            {
                cell = [[UITableViewCell alloc] init];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text=@"操作方式";
                
                controlvalue = [[UILabel alloc] init];
                controlvalue.frame=CGRectMake([PublicCommon GetALLScreen].size.width - 10 -150, 10, 120, 30);
                controlvalue.textAlignment=NSTextAlignmentRight;
              
                controlvalue.textColor=[[UIColor grayColor]colorWithAlphaComponent:0.9];
                [cell.contentView addSubview:controlvalue];
                UIView *v = [[UIView alloc] init];
                v.frame = cell.contentView.frame;
                v.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.15];
                cell.selectedBackgroundView=v;
                
            }
   
            break;

    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (signaltype==2)
    {
        
        if (indexPath.section==1)
        {
            
            NSString *StrOperation = [signalcontrolinfo objectForKey:@"StrOperation"];
            NSArray *operationlist =[StrOperation componentsSeparatedByString:@","];
            
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择操作方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action1];
            
            
            for (NSString *str in operationlist) {
                UIAlertAction *action = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    controlvalue.text = action.title;
                }];
                
                [alert addAction:action];
            }
       
           
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}


#pragma mark -


-(void)closeinput
{
    [username resignFirstResponder];
    [pwd resignFirstResponder];
    [simvalue resignFirstResponder];
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

//返回
- (IBAction)clickreturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//保存
- (IBAction)clicksave:(id)sender {
    
    if ([username.text isEqualToString:@""] || [pwd.text isEqualToString:@""])
    {
        [Common NetErrorAlert:@"请输入操作人员验证信息"];
        return;
    }
    
    if (signaltype ==2)
    {
        if (controlvalue.text==nil)
        {
            [Common NetErrorAlert:@"请输入操作方式"];
            return;
        }
    }
    
    loadview= [[LoadingView alloc] init];
    [loadview setImages:[Common initLoadingImages]];
    [self.view addSubview:loadview];
    [loadview StartAnimation];
    
    
    dispatch_async([Common getThreadQueue], ^{
        
        HttpClass *httpclass = [[HttpClass alloc] init:[Common HttpString:ControlEquipment]];
        [httpclass addParamsString:@"ctrlUserName" values:username.text];
        [httpclass addParamsString:@"ctrlUserPwd" values:pwd.text];
        [httpclass addParamsString:@"clerkID" values:[Common DefaultCommon].ClerkID];
        [httpclass addParamsString:@"clerkStationID" values:[Common DefaultCommon].ClerkStationID];
        [httpclass addParamsString:@"stationID" values:[signalcontrolinfo objectForKey:@"StationID"]];
        [httpclass addParamsString:@"equipmentID" values:[signalcontrolinfo objectForKey:@"EquipmentID"]];
        [httpclass addParamsString:@"signalID" values:[signalcontrolinfo objectForKey:@"SignalID"]];
        [httpclass addParamsString:@"preSpUnitID" values:[signalcontrolinfo objectForKey:@"preSpUnitID"]];
        [httpclass addParamsString:@"spUnitID" values:[signalcontrolinfo objectForKey:@"SpUnitID"]];
        [httpclass addParamsString:@"cmdToken" values:[signalcontrolinfo objectForKey:@"CmdToken"]];
        if (signaltype ==1)
            [httpclass addParamsString:@"controlValue" values:simvalue.text];
        else{
            NSArray *arry = [controlvalue.text componentsSeparatedByString:@"-"];
            
            [httpclass addParamsString:@"controlValue" values:arry[0]];
//            if ([controlvalue.text isEqualToString:@"开机手动"])
//                [httpclass addParamsString:@"controlValue" values:@"34"];
//            else if ([controlvalue.text isEqualToString:@"开机自动"])
//                [httpclass addParamsString:@"controlValue" values:@"17"];
//            else if ([controlvalue.text isEqualToString:@"开机制热"])
//                [httpclass addParamsString:@"controlValue" values:@"51"];
        }
        
        
        
        NSData *data = [httpclass httprequest:[httpclass getDataForArrary]];
        NSString *result = [httpclass getXmlString:data];
        NSLog(@"结果 %@",result);
        if (!result)
        {
            dispatch_async([Common getThreadMainQueue], ^{
                if (loadview){
                    [loadview StopAnimation];
                    [loadview removeFromSuperview];
                    loadview = nil;
                }
            });
            [Common NetErrorAlert:@"控制失败"];
            return ;
        }
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        if (!resultDict)
        {
            dispatch_async([Common getThreadMainQueue], ^{
                
                if (loadview){
                    [loadview StopAnimation];
                    [loadview removeFromSuperview];
                    loadview = nil;
                }
            });
            [Common NetErrorAlert:@"控制失败"];
        }
        
        
        dispatch_async([Common getThreadMainQueue], ^{
            
            if (loadview){
                [loadview StopAnimation];
                [loadview removeFromSuperview];
                loadview = nil;
            }
            
            
            if ([[resultDict objectForKey:@"success"] isEqualToString:@"true"])
            {
                [self clickreturn:nil];
                [Common NetOKAlert:@"操作成功"];
                return ;
            }
            else
            {
                [Common NetErrorAlert:[[resultDict objectForKey:@"data"] objectForKey:@"runMsg"]];
            }
            
        });
        
        
    });
    
    
}
@end
