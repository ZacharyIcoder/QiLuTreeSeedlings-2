//
//  YLDGCGSBianJiViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/6.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDGCGSBianJiViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "BWTextView.h"
@interface YLDGCGSBianJiViewController ()
@property (nonatomic)NSInteger type;
@property (nonatomic,copy) NSString *str;
@property (nonatomic,weak)UITextField *textField;
@property (nonatomic,weak)BWTextView *textView;
@end

@implementation YLDGCGSBianJiViewController
-(id)initWithType:(NSInteger)type
{
    self=[super init];
    if (self) {
        self.type=type;
        
    }
    return self;
}
-(id)initWithType:(NSInteger)type andStr:(NSString *)str
{
    self=[super init];
    if (self) {
        self.type=type;
        self.str=str;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(0, 70, kWidth, 44)];
    [textField setBackgroundColor:[UIColor whiteColor]];
    self.textField=textField;
    [self.view addSubview:textField];
   
    if (self.type==1||self.type==11) {
        self.vcTitle=@"联系人";
        if (self.str.length>0) {
            textField.text=self.str;
        }
        textField.placeholder=@"请输入姓名";
    }
    if (self.type==2) {
        self.vcTitle=@"电话";
        textField.placeholder=@"请输入电话";
        textField.keyboardType=UIKeyboardTypeNumberPad;
    }
    if (self.type==3) {
        self.vcTitle=@"公司地址";
        textField.placeholder=@"请输入公司地址";
    }
    if (self.type==4) {
        self.vcTitle=@"公司简介";
//        textField.placeholder=@"";
        [self.textField removeFromSuperview];
        BWTextView *textView=[[BWTextView alloc]initWithFrame:CGRectMake(0, 70, kWidth, 100)];
        [textView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:textView];
        textView.placeholder=@"请输入公司简介";
        if (self.str.length>0) {
            textView.text=self.str;
        }
        [textView setFont:[UIFont systemFontOfSize:16]];
        self.textView=textView;

    }
    if (self.type==13) {
        self.vcTitle=@"自我介绍";
//
        [self.textField removeFromSuperview];
        BWTextView *textView=[[BWTextView alloc]initWithFrame:CGRectMake(0, 70, kWidth, 100)];
        [textView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:textView];
        textView.placeholder=@"请输入自我介绍";
        if (self.str.length>0) {
            textView.text=self.str;
        }
        [textView setFont:[UIFont systemFontOfSize:16]];
        self.textView=textView;
    }
    CGFloat yyy=140;
    if (self.type==13||self.type==4) {
        yyy=240;
    }
    UIButton *sureBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, yyy, kWidth-80, 50)];
    [sureBtn setBackgroundColor:NavColor];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    // Do any additional setup after loading the view.
}
-(void)sureBtnAction
{
    if (self.type==13||self.type==4) {
        if (self.textView.text.length<=0) {
            [ToastView showTopToast:@"请输入信息"];
            return;
        }
    }else{
        if (self.textField.text.length<=0) {
            [ToastView showTopToast:@"请输入信息"];
            return;
        }
    }
   
    
    if(self.type==1)
    {
        [self companyName:nil andlegalPerson:self.textField.text andphone:nil Withbrief:nil Withprovince:nil WithCity:nil Withcounty:nil WithAddress:nil];
    }
    if(self.type==2)
    {
        [self companyName:nil andlegalPerson:nil andphone:self.textField.text Withbrief:nil Withprovince:nil WithCity:nil Withcounty:nil WithAddress:nil];
    }
    if(self.type==3)
    {
         [self companyName:nil andlegalPerson:nil andphone:nil Withbrief:nil Withprovince:nil WithCity:nil Withcounty:nil WithAddress:self.textField.text];
        
    }
    if(self.type==4)
    {
         [self companyName:nil andlegalPerson:nil andphone:nil Withbrief:self.textView.text Withprovince:nil WithCity:nil Withcounty:nil WithAddress:nil];
    }
    if (self.type==11) {
        ShowActionV();
        [HTTPCLIENT changeUserInfoWithToken:nil WithAccessID:nil
    WithClientID:nil WithClientSecret:nil WithDeviceID:nil withName:self.textField.text Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [APPDELEGATE reloadUserInfoSuccess:^(id responseObject) {
                RemoveActionV();
                [ToastView showTopToast:@"编辑成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
               RemoveActionV();
            }];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    }
    if(self.type==13)
    {
        [HTTPCLIENT goldSupplierUpdatebrief:self.textView.text Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                
                APPDELEGATE.userModel.brief=self.textView.text;
                [ToastView showTopToast:@"编辑成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}
-(void)companyName:(NSString *)companyName andlegalPerson:(NSString *)legalPerson andphone:(NSString *)phone Withbrief:(NSString *)brief Withprovince:(NSString *)province WithCity:(NSString *)city Withcounty:(NSString *)county WithAddress:(NSString *)address
{
    ShowActionV();
    [HTTPCLIENT gongchengZhongXinInfoEditWithUid:APPDELEGATE.GCGSModel.uid WithcompanyName:companyName WithlegalPerson:legalPerson Withphone:phone Withbrief:brief Withprovince:province WithCity:city Withcounty:county WithAddress:address Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [HTTPCLIENT gongchengZhongXinInfoSuccess:^(id responseObject) {
                if ([[responseObject objectForKey:@"success"] integerValue]) {
                    [ToastView showTopToast:@"编辑成功"];
                    
                    APPDELEGATE.GCGSModel=[YLDGCGSModel yldGCGSModelWithDic:[[responseObject objectForKey:@"result"] objectForKey:@"companyInfo"]];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                RemoveActionV();
            } failure:^(NSError *error) {
                RemoveActionV();
            }];

        }else{
            RemoveActionV();
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
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
