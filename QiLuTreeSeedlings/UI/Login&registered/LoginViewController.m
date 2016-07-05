//
//  LoginViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/9.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "LoginViewController.h"
#import "UIDefines.h"
#import "LoginView.h"
#import "HttpClient.h"
#import "RegisteredViewController.h"
#import "ForgetPassWorldViewController.h"
@interface LoginViewController ()<LoginViewDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    [navView setBackgroundColor:NavColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(17, 27, 30, 30)];
    [backBtn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    [self.view addSubview:navView];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-60, 20, 120, 44)];
    [titleLab setText:@"帐号登录"];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setTextColor:[UIColor whiteColor]];
    [navView addSubview:titleLab];
    [titleLab setFont:[UIFont systemFontOfSize:NavTitleSize]];
    UIButton *registeredBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-90, 27, 80, 30)];
    [navView addSubview:registeredBtn];
    [registeredBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [registeredBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [registeredBtn addTarget:self action:@selector(registeredBtnAction) forControlEvents:UIControlEventTouchUpInside];
    LoginView *loginView=[[LoginView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    loginView.delegate=self;
    [self.view addSubview:loginView];
    // Do any additional setup after loading the view.
}
-(void)registeredBtnAction
{
    ForgetPassWorldViewController *registVC=[[ForgetPassWorldViewController alloc]init];
    [self.navigationController pushViewController:registVC animated:YES];
}
-(void)reginSSSAction
{
    RegisteredViewController *registVC=[[RegisteredViewController alloc]init];
    [self.navigationController pushViewController:registVC animated:YES];
}
-(void)LoginbtnAction:(NSString *)phone andPassword:(NSString *)pasword
{
    [HTTPCLIENT loginInWithPhone:phone andPassWord:pasword Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
          [self loginSuccessAction];
            APPDELEGATE.userModel=[UserInfoModel userInfoCreatByDic:[responseObject objectForKey:@"result"]];
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSString *token=APPDELEGATE.userModel.access_token;
            NSString *uid=APPDELEGATE.userModel.access_id;
            [defaults setObject:token forKey:kACCESS_TOKEN];
            [defaults setObject:uid forKey:kACCESS_ID];
            [defaults synchronize];
            [APPDELEGATE  reloadUserInfoSuccess:^(id responseObject) {
                
            } failure:^(NSError *error) {
                
            }];
            [APPDELEGATE reloadCompanyInfo];
            [APPDELEGATE getGchenggongsiInfo];
            
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        //NSLog(@"%@",error);
    }];
}
-(void)loginSuccessAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backBtnAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self.navigationController popViewControllerAnimated:YES];
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
