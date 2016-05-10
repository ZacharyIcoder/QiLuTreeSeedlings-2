//
//  CheckIDViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/9.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "CheckIDViewController.h"
#import "UIDefines.h"
#import "YLDNewPassWordViewController.h"
@interface CheckIDViewController ()<UITextFieldDelegate>
@property (nonatomic,copy)NSString *phoneNum;
@property (nonatomic,weak)UITextField *yanzhengTextField;
@property (nonatomic,weak)UIButton *checkBtn;
@property (nonatomic,strong)UILabel *messageLab;
@property (nonatomic,strong) NSTimer *timer2;
@property (nonatomic,assign)NSInteger codeCount2;
@end

@implementation CheckIDViewController
@synthesize timer2,codeCount2;
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
    self.yanzhengTextField=pasdTextField;
    pasdTextField.delegate=self;
    pasdTextField.tag=10002;
    [messageView addSubview:pasdTextField];
    [messageView addSubview:pwsdLab];
    UIButton *getYanzhengBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-88, 75, 75, 30)];
    self.checkBtn=getYanzhengBtn;
    [getYanzhengBtn setBackgroundColor:[UIColor orangeColor]];
    [getYanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [messageView addSubview:getYanzhengBtn];
    [getYanzhengBtn addTarget:self action:@selector(getcodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [getYanzhengBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    UILabel *messageLab=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(messageView.frame)+5, kWidth-20, 40)];
    [messageLab setTextColor:detialLabColor];
    [self.view addSubview:messageLab];
    messageLab.text=@"验证码将发送到您填写的手机号上";
    self.messageLab=messageLab;
    messageLab.numberOfLines=0;
    [messageLab setFont:[UIFont systemFontOfSize:14]];
    
    UIButton *nexetBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(messageView.frame)+60, kWidth-80, 40)];
    [self.view addSubview:nexetBtn];
    [nexetBtn setBackgroundColor:NavColor];
    [nexetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nexetBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nexetBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)nextBtnAction
{

    if (self.yanzhengTextField.text.length==0) {
        [ToastView showTopToast:@"验证码不正确"];
        return;
    }
    [HTTPCLIENT checkChongzhiPassWorldWihtPhone:self.phoneNum WithCode:self.yanzhengTextField.text Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            YLDNewPassWordViewController *yldNewPassWordVC=[[YLDNewPassWordViewController alloc]initWithPhone:self.phoneNum];
            [self.navigationController pushViewController:yldNewPassWordVC animated:YES];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)getcodeAction:(UIButton *)sender
{
   
    codeCount2=60;
    ShowActionV();
    [HTTPCLIENT getCodeShotMessageWtihPhone:self.phoneNum andType:@"forget" Success:^(id responseObject) {
        RemoveActionV();
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            sender.userInteractionEnabled=NO;
            [sender setBackgroundColor:titleLabColor];
            [self changBackTime];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
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
          [self.messageLab setText:@"验证码将发送到您填写的手机号上"];
        if (timer2) {
            [timer2 invalidate];
            timer2 = nil;
            self.checkBtn.userInteractionEnabled=YES;
            [self.checkBtn setBackgroundColor:yellowButtonColor];
            return;
        }
    }
    codeCount2--;
    NSString *numStr=[NSString stringWithFormat:@"%ld",(long)codeCount2];
    NSString *contentStr =[NSString stringWithFormat:@"验证码即将发送到您绑定的%@手机上，%@秒后可充新获取",self.phoneNum,numStr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
    //设置：在0-3个单位长度内的内容显示成红色
    [str addAttribute:NSForegroundColorAttributeName value:yellowButtonColor range:NSMakeRange(27
                                                                                               , numStr.length)];
    [self.messageLab setAttributedText:str];
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
