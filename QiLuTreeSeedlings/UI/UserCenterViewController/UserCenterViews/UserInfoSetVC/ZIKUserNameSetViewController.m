//
//  ZIKUserNameSetViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKUserNameSetViewController.h"

@interface ZIKUserNameSetViewController ()
{
    UITextField *nameTextField;
}
@end

@implementation ZIKUserNameSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle  = @"姓名设置";

    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 64+8, kWidth, 44);
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];

    nameTextField = [[UITextField alloc] init];
    nameTextField.frame = CGRectMake(15, 7, kWidth-30, 30);
    nameTextField.textAlignment = NSTextAlignmentLeft;
    nameTextField.text = APPDELEGATE.userModel.name;
    [backView addSubview:nameTextField];

    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(40, CGRectGetMaxY(backView.frame)+15, kWidth-80, 40);
    button.backgroundColor = NavColor;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)btnClick {
    if ([ZIKFunction xfunc_check_strEmpty:nameTextField.text]) {
       [ToastView showTopToast:@"姓名为空!!!"];
        return;
    }
    else {
        [HTTPCLIENT changeUserInfoWithToken:nil WithAccessID:nil WithClientID:nil WithClientSecret:nil WithDeviceID:nil withName:nameTextField.text
        Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
                APPDELEGATE.userModel.name = nameTextField.text;
                [ToastView showTopToast:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [ToastView showTopToast:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) {

        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
