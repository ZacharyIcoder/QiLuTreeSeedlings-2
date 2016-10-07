//
//  YLDNewPassWordViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/9.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "YLDNewPassWordViewController.h"
#import "YLDLoginViewController.h"
@interface YLDNewPassWordViewController ()
@property (nonatomic,strong)UITextField *passWordTextField;
@property (nonatomic,strong)UITextField *rePassWordTextField;
@property (nonatomic,strong) NSString *phone;
@end

@implementation YLDNewPassWordViewController
-(id)initWithPhone:(NSString *)phone
{
    self=[super init];
    if (self) {
        self.phone=phone;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"修改密码";
    
    UIView *messageView=[[UIView alloc]initWithFrame:CGRectMake(0, 84, kWidth, 120)];
    [messageView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:messageView];
    UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 60, kWidth-30, 0.5)];
    [lineView setBackgroundColor:kLineColor];
    [messageView addSubview:lineView];
    UITextField *phoneTextField=[[UITextField alloc]initWithFrame:CGRectMake(20/320.f*kWidth,  lineView.frame.origin.y-45, 230/320.f*kWidth, 30)];
    self.passWordTextField=phoneTextField;
    phoneTextField.tag=10001;
    phoneTextField.placeholder=@"请输入您的密码";
    phoneTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    phoneTextField.secureTextEntry=YES;
    [messageView addSubview:phoneTextField];
    UITextField *pasdTextField=[[UITextField alloc]initWithFrame:CGRectMake(20/320.f*kWidth,  lineView.frame.origin.y+15, 230/320.f*kWidth, 30)];
    pasdTextField.placeholder=@"请再输入一次";
    self.rePassWordTextField=pasdTextField;
    pasdTextField.tag=10002;
    pasdTextField.secureTextEntry=YES;
    [messageView addSubview:pasdTextField];
     pasdTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    UIButton *nexetBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(messageView.frame)+20, kWidth-80, 40)];
    [self.view addSubview:nexetBtn];
    [nexetBtn setBackgroundColor:NavColor];
    [nexetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nexetBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nexetBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    //[messageView addSubview:pwsdLab];
    // Do any additional setup after loading the view.
}
-(void)nextBtnAction
{
    
    if (self.passWordTextField.text.length==0||self.rePassWordTextField.text.length==0) {
        [ToastView showTopToast:@"请输入新密码"];
        return;
    }
    if (self.passWordTextField.text.length<6||self.passWordTextField.text.length>20) {
        [ToastView showTopToast:@"密码不得小于6位或大于20位"];
        return;
    }
    if(![self.passWordTextField.text isEqualToString:self.rePassWordTextField.text])
    {
        [ToastView showTopToast:@"两次输入的密码不一致"];
        return;
    }
    if ([self bijiaoWeiCWithStr:self.passWordTextField.text]) {
        
    }else{
        [ToastView showTopToast:@"密码只能包含数字，字母和下划线"];
        return;
    }
    [HTTPCLIENT setNewPassWordWithPhone:self.phone WithPassWord:[NSString stringWithFormat:@"%@",self.passWordTextField.text] Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"重置密码成功！"];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[YLDLoginViewController class]]) {
                     YLDLoginViewController *owr = (YLDLoginViewController *)controller;
                    [self.navigationController popToViewController:owr animated:YES];
                }
            }
        }else{
           [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
