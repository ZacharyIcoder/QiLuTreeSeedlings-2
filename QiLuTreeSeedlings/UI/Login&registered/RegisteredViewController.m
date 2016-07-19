//
//  RegisteredViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/9.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "RegisteredViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "ToastView.h"
#import "NSString+Phone.h"
@interface RegisteredViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *phoneTextField;
@property (nonatomic,strong)UITextField *passWordTextField;
@property (nonatomic,strong)UITextField *rePassWordTextField;
@property (nonatomic,strong)UITextField *codeTextField;
@property (nonatomic, strong) UIButton *getCodeButton;
@property (nonatomic, assign) NSInteger codeCount;
@property (nonatomic, assign) NSInteger codeCount2;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timer2;
@property (nonatomic, strong) UILabel *timel1lab;
@end

@implementation RegisteredViewController
@synthesize codeCount,timer,timer2,codeCount2;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BGColor];
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    [navView setBackgroundColor:NavColor];
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-60, 20, 120, 44)];
    [titleLab setText:@"注册"];
    [titleLab setFont:[UIFont systemFontOfSize:NavTitleSize]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setTextColor:[UIColor whiteColor]];
    [navView addSubview:titleLab];
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(17, 27, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    [self.view addSubview:navView];
    self.phoneTextField=[self viewWithY:0 andImageName:@"phoneLiteImage" andTitle:@"手机号"];
    self.phoneTextField.placeholder=@"请输入手机号";
    self.phoneTextField.delegate=self;
    self.phoneTextField.tag=10001;
    self.phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    
    self.passWordTextField=[self viewWithY:1 andImageName:@"passwordLiteImage" andTitle:@"输入密码"];
    self.passWordTextField.placeholder=@"请输入密码";
    self.passWordTextField.delegate=self;
    self.passWordTextField.tag=10002;
    self.passWordTextField.secureTextEntry = YES;
    
    self.rePassWordTextField=[self viewWithY:2 andImageName:@"passwordLiteImage" andTitle:@"确认密码"];
    self.rePassWordTextField.placeholder=@"确认密码";
    self.rePassWordTextField.delegate=self;
    self.rePassWordTextField.tag=10003;
    self.rePassWordTextField.secureTextEntry = YES;
    UIButton *sureBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, 3*50+54+20+30, kWidth-80, 40)];
    [self.view addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setBackgroundColor:NavColor];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
}
-(void)sureBtnAction
{
    [self.phoneTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    [self.rePassWordTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    if(self.phoneTextField.text.length!=11)
    {
        [ToastView showTopToast:@"手机号必须是11位"];
        return;
    }
    if (![self.phoneTextField.text checkPhoneNumInput]) {
        [ToastView showTopToast:@"手机号格式不正确"];
        return;
    }
    if (self.passWordTextField.text.length<6||self.passWordTextField.text.length>20) {
        [ToastView showTopToast:@"密码不得小于6位或大于20位"];
        return;
    }
    if ([self bijiaoWeiCWithStr:self.passWordTextField.text]) {
        
    }else{
        [ToastView showTopToast:@"密码只能包含数字，字母和下划线"];
        return;
    }
    if (!self.phoneTextField.text) {
        [ToastView showTopToast:@"手机号和密码不能为空"];
        return;
        
    }
    if (!self.passWordTextField.text) {
        [ToastView   showTopToast:@"密码不能为空"];
        return;
    }
    if(![self.passWordTextField.text isEqualToString:self.rePassWordTextField.text])
    {
        [ToastView showTopToast:@"两次输入的密码不一致"];
        return;
    }
    
    [HTTPCLIENT registeredUserWithPhone:self.phoneTextField.text withPassWord:self.passWordTextField.text withRepassWord:self.rePassWordTextField.text withCode:nil Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [self registeredSuccessAction];
        }else
        {
           [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
    //NSLog(@"注册");
}
-(void)registeredSuccessAction
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    [view setBackgroundColor:kRGB(0, 0, 0, 0.3)];
    [self.view addSubview:view];
    
    UIView *dsdsView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 190)];
    [view addSubview:dsdsView];
    [dsdsView setBackgroundColor:[UIColor whiteColor]];
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(0, 30, kWidth, 30)];
    [dsdsView addSubview:lab1];
    [lab1 setTextColor:NavColor];
    [lab1 setTextAlignment:NSTextAlignmentCenter];
    [lab1 setText:@"恭喜您注册成功!"];
    UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(0, 60, kWidth, 20)];
    [dsdsView addSubview:lab2];
    [lab2 setTextColor:NavColor];
    [lab2 setTextAlignment:NSTextAlignmentCenter];
    [lab2 setFont:[UIFont systemFontOfSize:14]];
    NSDate *nowDate=[NSDate new];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *timeStr=[dateformatter stringFromDate:nowDate];
    [lab2 setText:timeStr];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(kWidth/2-110, 90, 220, 1)];
    [lineView setBackgroundColor:NavColor];
    [dsdsView addSubview:lineView];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-110, 35, 40, 40)];
    [imageV setImage:[UIImage imageNamed:@"registeredSuccess"]];
    [dsdsView addSubview:imageV];
    UILabel *phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 101, kWidth, 20)];
    [dsdsView addSubview:phoneLab];
    [phoneLab setTextColor:titleLabColor];
    [phoneLab setTextAlignment:NSTextAlignmentCenter];
    [phoneLab setFont:[UIFont systemFontOfSize:14]];
    phoneLab.text=[NSString stringWithFormat:@"手机号：%@",self.phoneTextField.text];
    
    UILabel *timelLab1=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-74, 148, 10, 20)];
    [timelLab1 setTextColor:yellowButtonColor];
    [timelLab1 setText:@"3"];
    [timelLab1 setFont:[UIFont systemFontOfSize:17]];
    [dsdsView addSubview:timelLab1];
    self.timel1lab=timelLab1;
    UILabel *timelLab2=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-64, 150, 140, 20)];
    [timelLab2 setTextColor:detialLabColor];
    [timelLab2 setText:@"秒后跳转到登录页面"];
   
    [timelLab2 setFont:[UIFont systemFontOfSize:13]];
    [dsdsView addSubview:timelLab2];
    codeCount2=3;
    [self changBackTime];
}
-(void)changBackTime
{
    timer2 = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(changeTime2) userInfo:nil repeats:YES];
}
-(void)changeTime2
{
    if (codeCount2 <= 1) {
        if (timer2) {
            [timer2 invalidate];
            timer2 = nil;
            [self backBtnAction];
        }
    }
    codeCount2--;
    [self.timel1lab setText:[NSString stringWithFormat:@"%ld",(long)codeCount2]];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
-(UITextField *)viewWithY:(CGFloat)Y andImageName:(NSString *)iamgeName andTitle:(NSString *)title
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, Y*50+74, kWidth, 50)];
    UIImageView *phoneImageV =[[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 25, 25)];
    [phoneImageV setImage:[UIImage imageNamed:iamgeName]];
    [view addSubview:phoneImageV];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(45/320.f*kWidth,10, 70, 30)];
    [phoneLab setFont:[UIFont systemFontOfSize:16]];
    [phoneLab setTextColor:titleLabColor];
    [phoneLab setText:title];
    [view addSubview:phoneLab];
    UITextField *phoneTextField=[[UITextField alloc]initWithFrame:CGRectMake(120/320.f*kWidth, 10, 180, 30)];
    phoneTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [view addSubview:phoneTextField];
    [phoneTextField setFont:[UIFont systemFontOfSize:16]];
    UIImageView *linimageV=[[UIImageView alloc]initWithFrame:CGRectMake(15, 49.5, kWidth-30, 0.5)];
    [view addSubview:linimageV];
    if([title isEqualToString:@"验证码"])
    {
        linimageV.hidden=YES;
    }
    [linimageV setBackgroundColor:kLineColor];
    if (Y==3) {
        UIButton *getYanzhengBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-88, 12.5, 75, 30)];
        self.getCodeButton=getYanzhengBtn;
        [getYanzhengBtn setBackgroundColor:[UIColor orangeColor]];
        [getYanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [view addSubview:getYanzhengBtn];
        [getYanzhengBtn addTarget:self action:@selector(getcodeAction:) forControlEvents:UIControlEventTouchUpInside];
        [getYanzhengBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        
    }
    [self.view addSubview:view];
    return phoneTextField;
}
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getcodeAction:(UIButton *)sender
{
    [self.phoneTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    [self.rePassWordTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    
    if(self.phoneTextField.text.length!=11)
    {
        [ToastView showTopToast:@"手机号必须是11位"];
        return;
    }
    if (![self.phoneTextField.text checkPhoneNumInput]) {
        [ToastView showTopToast:@"手机号格式不正确"];
        return;
    }
    [HTTPCLIENT getCodeShotMessageWtihPhone:self.phoneTextField.text andType:@"register" Success:^(id responseObject) {
        if([[responseObject objectForKey:@"success"] integerValue])
        {
            [ToastView showTopToast:@"验证码已成功发送，请稍后"];
        }
       // NSLog(@"%@",responseObject);
    } failure:^(NSError *error) {
        
    }];
    [self setCode:@"60"];
}
-(BOOL)bijiaoWeiCWithStr:(NSString *)string
{
    // 1、准备正则式
    NSString *regex = @"^[a-zA-Z_0-9]+$"; // 只能是字母，不区分大小写
    // 2、拼接谓词
    NSPredicate *predicateRe1 = [NSPredicate predicateWithFormat:@"self matches %@", regex];
    // 3、匹配字符串
    BOOL resualt = [predicateRe1 evaluateWithObject:string];
    return resualt;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCode:(NSString *)code
{
    codeCount = 59;
    [self.getCodeButton setTitle:[NSString stringWithFormat:@"%@秒后", @(self.codeCount)] forState:UIControlStateNormal];
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(changeTime) userInfo:nil repeats:YES];
    self.getCodeButton.enabled=NO;
     [self.getCodeButton setBackgroundColor:[UIColor grayColor]];
}
//

#pragma mark -
- (void)changeTime
{
    if (codeCount <= 1) {
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        
        self.getCodeButton.enabled=YES;
        [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getCodeButton.enabled=YES;
        [self.getCodeButton setBackgroundColor:[UIColor orangeColor]];
        return ;
    }
    codeCount --;
    [self.getCodeButton setTitle:[NSString stringWithFormat:@"%@秒后", @(self.codeCount)] forState:UIControlStateNormal];

}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (kHeight<=480) {
        if (textField.tag==10003||textField.tag==10004) {
            CGRect frame=self.view.frame;
            frame.origin.y=-100;
            [UIView animateWithDuration:0.1 animations:^{
                self.view.frame=frame;
            }];
        }
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (kHeight<=480) {
        if (textField.tag==10003||textField.tag==10004) {
            CGRect frame=self.view.frame;
            frame.origin.y=0;
            [UIView animateWithDuration:0.1 animations:^{
                self.view.frame=frame;
            }];
        }
    }

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    [self.rePassWordTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
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
