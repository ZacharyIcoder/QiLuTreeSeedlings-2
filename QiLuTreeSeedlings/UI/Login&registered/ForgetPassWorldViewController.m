//
//  ForgetPassWorldViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/9.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ForgetPassWorldViewController.h"
#import "AuthcodeView.h"
#import "UIDefines.h"
#import "NSString+Phone.h"
#import "CheckIDViewController.h"
@interface ForgetPassWorldViewController ()<UITextFieldDelegate>
{
     AuthcodeView *authCodeView;
}
@property (nonatomic,weak) UITextField *phoneTextField;
@property (nonatomic,weak) UITextField *yanzhengTextField;
@end

@implementation ForgetPassWorldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"账号验证";
    [self.view setBackgroundColor:BGColor];
    UIView *messageView=[[UIView alloc]initWithFrame:CGRectMake(0, 84, kWidth, 120)];
    [messageView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:messageView];
    UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 60, kWidth-30, 0.5)];
    [lineView setBackgroundColor:kLineColor];
    [messageView addSubview:lineView];
    UIImageView *phoneImageV =[[UIImageView alloc]initWithFrame:CGRectMake(15, lineView.frame.origin.y-43, 25,25)];
    [phoneImageV setImage:[UIImage imageNamed:@"phoneLiteImage"]];
    [messageView addSubview:phoneImageV];
    UILabel *phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(45/320.f*kWidth, lineView.frame.origin.y-45, 70, 30)];
    [phoneLab setTextColor:titleLabColor];
    [phoneLab setText:@"手机号"];
    [messageView addSubview:phoneLab];
    UITextField *phoneTextField=[[UITextField alloc]initWithFrame:CGRectMake(120/320.f*kWidth,  lineView.frame.origin.y-45, 160/320.f*kWidth, 30)];
    self.phoneTextField=phoneTextField;
    phoneTextField.delegate=self;
    phoneTextField.tag=10001;
    phoneTextField.placeholder=@"请输入您的手机号";
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [messageView addSubview:phoneTextField];
    UIImageView *pasdV =[[UIImageView alloc]initWithFrame:CGRectMake(15, lineView.frame.origin.y+17,25, 25)];
    [pasdV setImage:[UIImage imageNamed:@"passwordLiteImage"]];
    [messageView addSubview:pasdV];
    UILabel *pwsdLab=[[UILabel alloc]initWithFrame:CGRectMake(45/320.f*kWidth, lineView.frame.origin.y+15, 70, 30)];
    [pwsdLab setTextColor:titleLabColor];
    [pwsdLab setText:@"验证码"];
    UITextField *pasdTextField=[[UITextField alloc]initWithFrame:CGRectMake(120/320.f*kWidth,  lineView.frame.origin.y+15, 125/320.f*kWidth, 30)];
    pasdTextField.placeholder=@"请输入验证码";
    //pasdTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.yanzhengTextField=pasdTextField;
    pasdTextField.delegate=self;
    pasdTextField.tag=10002;
    [messageView addSubview:pasdTextField];
    [messageView addSubview:pwsdLab];
    authCodeView = [[AuthcodeView alloc] initWithFrame:CGRectMake(kWidth-80, lineView.frame.origin.y+10,70, 40)];
    [messageView addSubview:authCodeView];
    
    UIButton *nexetBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(messageView.frame)+20, kWidth-80, 40)];
    [self.view addSubview:nexetBtn];
    [nexetBtn setBackgroundColor:NavColor];
    [nexetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nexetBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nexetBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];

    // Do any additional setup after loading the view.
}
-(void)nextBtnAction
{
    [self.phoneTextField resignFirstResponder];
    [self.yanzhengTextField resignFirstResponder];
    if (!self.phoneTextField.text) {
        [ToastView showTopToast:@"手机号不能为空"];
        return;
    }
    if (!self.yanzhengTextField.text) {
        [ToastView showTopToast:@"验证码不能为空"];
        return;
    }
    
    if(self.phoneTextField.text.length!=11)
    {
        [ToastView showTopToast:@"手机号必须是11位"];
        return;
    }
    if (![self.phoneTextField.text checkPhoneNumInput]) {
        [ToastView showTopToast:@"手机号格式不正确"];
        return;
    }
    NSString *yanzhengM=self.yanzhengTextField.text;
    yanzhengM=[yanzhengM stringByReplacingOccurrencesOfString:@" " withString:@""];
    yanzhengM=[yanzhengM stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (![yanzhengM isEqualToString:authCodeView.authCodeStr]) {
        [ToastView showTopToast:@"验证码不正确"];
        return;
    }

    [HTTPCLIENT checkPhoneNum:self.phoneTextField.text Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            CheckIDViewController *checkIDVC=[[CheckIDViewController alloc]initWithPhoneNum:self.phoneTextField.text];
            
            [self.navigationController pushViewController:checkIDVC animated:YES];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
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
