//
//  ZIKUserNameSetViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKUserNameSetViewController.h"
#define kMaxLength 20
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
    [nameTextField resignFirstResponder];
    if ([ZIKFunction xfunc_check_strEmpty:nameTextField.text]) {
       [ToastView showTopToast:@"姓名为空!!!"];
        return;
    }
    else {
        if([nameTextField.text rangeOfString:@" "].location !=NSNotFound)//_roaldSearchText
        {
            [ToastView showTopToast:@"姓名不能包含空格!!!"];
            return;
        }
        
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

- (void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;

    NSString *toBeString = textField.text;
    //NSString *mylant = [UITextInputMode activeInputModes];
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                NSLog(@"最多%d个字符!!!",kMaxLength);
                //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] view:nil];
                textField.text = [toBeString substringToIndex:kMaxLength];
                return;
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{

        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%ld个字符",(long)kMaxLength] view:nil];
            NSLog(@"最多%d个字符!!!",kMaxLength);
            textField.text = [toBeString substringToIndex:kMaxLength];
            return;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
