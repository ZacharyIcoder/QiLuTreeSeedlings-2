
//
//  LoginView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/9.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "LoginView.h"
#import "UIDefines.h"
#import "NSString+Phone.h"
#import "ToastView.h"

@interface LoginView ()<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UITextField *paswdTextField;
@end
@implementation LoginView
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:BGColor];
        UIView *messageView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, kWidth, 120)];
        [messageView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:messageView];
        UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 60, kWidth-30, 0.5)];
        [lineView setBackgroundColor:kLineColor];
        [messageView addSubview:lineView];
        UIImageView *phoneImageV =[[UIImageView alloc]initWithFrame:CGRectMake(15, lineView.frame.origin.y-43, 25,25)];
        [phoneImageV setImage:[UIImage imageNamed:@"phoneLiteImage"]];
        [messageView addSubview:phoneImageV];
        UILabel *phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(45/320.f*kWidth, lineView.frame.origin.y-45, 70, 30)];
        [phoneLab setTextColor:[UIColor blackColor]];
        [phoneLab setText:@"手机号"];
        [messageView addSubview:phoneLab];
        UITextField *phoneTextField=[[UITextField alloc]initWithFrame:CGRectMake(120/320.f*kWidth,  lineView.frame.origin.y-45, 180, 30)];
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
        [pwsdLab setTextColor:[UIColor blackColor]];
        [pwsdLab setText:@"密码"];
        UITextField *pasdTextField=[[UITextField alloc]initWithFrame:CGRectMake(120/320.f*kWidth,  lineView.frame.origin.y+15, 180, 30)];
        pasdTextField.placeholder=@"请输入您的密码";
        //pasdTextField.keyboardType = UIKeyboardTypeNumberPad;
        pasdTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
        self.paswdTextField=pasdTextField;
        pasdTextField.delegate=self;
        pasdTextField.tag=10002;
        [messageView addSubview:pasdTextField];
        pasdTextField.secureTextEntry=YES;
        [messageView addSubview:pwsdLab];
        UIButton *loginBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(messageView.frame)+20, kWidth-80, 40)];
        [self addSubview:loginBtn];
        [loginBtn setBackgroundColor:NavColor];
        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
        UIButton *reginBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(loginBtn.frame)+20, kWidth-80, 40)];
        [self addSubview:reginBtn];
        [reginBtn setBackgroundColor:[UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1]];
        [reginBtn setTitleColor:yellowButtonColor forState:UIControlStateNormal];
        [reginBtn setTitle:@"快速注册" forState:UIControlStateNormal];
        [reginBtn addTarget:self action:@selector(reginBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
-(void)reginBtnAction
{
    if (self.delegate) {
        [self.delegate reginSSSAction];
    }
}
-(void)loginBtnAction
{
    
    if (!self.phoneTextField.text) {
        [ToastView showTopToast:@"手机号不能为空"];
        return;
    }
    if (!self.paswdTextField.text) {
        [ToastView showTopToast:@"密码不能为空"];
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
    if (self.paswdTextField.text.length<6) {
        [ToastView showTopToast:@"密码格式不正确"];
        return;
    }
    if (self.delegate) {
        [self.delegate LoginbtnAction:self.phoneTextField.text andPassword:self.paswdTextField.text];
    }

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneTextField resignFirstResponder];
    [self.paswdTextField resignFirstResponder];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
