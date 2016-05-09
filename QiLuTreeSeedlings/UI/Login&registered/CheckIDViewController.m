//
//  CheckIDViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/9.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "CheckIDViewController.h"
#import "UIDefines.h"
@interface CheckIDViewController ()<UITextFieldDelegate>
@property (nonatomic,copy)NSString *phoneNum;
@property (nonatomic,weak)UITextField *yanzhengTextField;
@property (nonatomic,weak)UIButton *checkBtn;
@property (nonatomic,weak)UILabel *messageLab;
@end

@implementation CheckIDViewController
-(id)initWithPhoneNum:(NSString *)phone
{
    self=[super init];
    if (self) {
        self.phoneNum=phone;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle =@"身份验证";
    
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
    phoneTextField.delegate=self;
    phoneTextField.tag=10001;
    phoneTextField.userInteractionEnabled = NO;
    phoneTextField.placeholder=@"请输入您的手机号";
    phoneTextField.text=self.phoneNum;
    [phoneTextField setTextColor:titleLabColor];
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
    UIButton *getYanzhengBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-88, 12.5, 75, 30)];
    self.checkBtn=getYanzhengBtn;
    [getYanzhengBtn setBackgroundColor:[UIColor orangeColor]];
    [getYanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [messageView addSubview:getYanzhengBtn];
    [getYanzhengBtn addTarget:self action:@selector(getcodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [getYanzhengBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
}
-(void)getcodeAction:(UIButton *)sender
{
    
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
