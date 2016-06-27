//
//  ZIKPayViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/30.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKPayViewController.h"
#import "ZIKVoucherCenterViewController.h"
@interface ZIKPayViewController ()
{
    UITextField *nameTextField;
}
@property (nonatomic, strong) NSString *limitPrice;
@end

@implementation ZIKPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestLimit];
    self.vcTitle = @"充值";


    UIView *backView         = [[UIView alloc] init];
    backView.frame           = CGRectMake(0, 64+8, kWidth, 44);
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];

    UILabel *label              = [[UILabel alloc] init];
    label.frame                 = CGRectMake(15, 10, 80, 24);
    label.text                  = @"金额(元)";
    [backView addSubview:label];

    nameTextField               = [[UITextField alloc] init];
    nameTextField.frame         = CGRectMake(100, 7, kWidth-30, 30);
    nameTextField.textAlignment = NSTextAlignmentLeft;
    nameTextField.placeholder   = @"请输入充值金额";
    nameTextField.keyboardType = UIKeyboardTypeDecimalPad;
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(textFieldChanged:)
//                                                 name:UITextFieldTextDidChangeNotification
//                                               object:nameTextField];

    [backView addSubview:nameTextField];

    UIButton *button = [[UIButton alloc] init];
    button.frame     = CGRectMake(40, CGRectGetMaxY(backView.frame)+15, kWidth-80, 40);
    button.backgroundColor = yellowButtonColor;
    [button setTitle:@"充值" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)btnClick {
    [nameTextField resignFirstResponder];
    if ([ZIKFunction xfunc_check_strEmpty:nameTextField.text]) {
        [ToastView showTopToast:@"请输入充值金额"];
        return;
    }
    if (![ZIKFunction xfunc_isAmount:nameTextField.text]) {
        [ToastView showToast:@"充值金额非法,请重新输入" withOriginY:250 withSuperView:self.view];
        return;
    }
    if (nameTextField.text.floatValue <= 0) {
        [ToastView showToast:@"充值金额不能小于零" withOriginY:250 withSuperView:self.view];
        return;
    }
//    if (nameTextField.text.floatValue>2000) {
//        [ToastView showToast:@"单次充值金额不能大于2000" withOriginY:250 withSuperView:self.view];
//        return;
//    }
    [self requestIsFirstRecharge];
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:Recharge] && nameTextField.text.integerValue<100)/*[[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:BB_XCONST_ISAUTO_LOGIN])#define Recharge @"Is top-up for the first time"*/
//    {
////        [ToastView showTopToast:@"第一次充值金额不能低于100元"];
////        return;
//    }
//
//    ZIKVoucherCenterViewController *voucherVC = [[ZIKVoucherCenterViewController alloc] init];
//    voucherVC.price = [NSString stringWithFormat:@"%.2f",nameTextField.text.floatValue];
//    [self.navigationController pushViewController:voucherVC animated:YES];
}

- (void)requestIsFirstRecharge {
    [HTTPCLIENT isFirstRecharge:nil Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 1) {
            if ([responseObject[@"result"]  integerValue] == 1 && nameTextField.text.floatValue<self.limitPrice.floatValue) {
                [ToastView showTopToast:[NSString stringWithFormat:@"第一次充值金额不能低于%.2f元",self.limitPrice.floatValue]];
                return;
            }
            else {
                ZIKVoucherCenterViewController *voucherVC = [[ZIKVoucherCenterViewController alloc] init];
                voucherVC.price = [NSString stringWithFormat:@"%.2f",nameTextField.text.floatValue];
                [self.navigationController pushViewController:voucherVC animated:YES];

            }
        }
        else if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:250 withSuperView:self.view];
        }

    } failure:^(NSError *error) {

    }];
}

- (void)textFieldChanged:(NSNotification *)obj {
}

- (void)requestLimit {
    [HTTPCLIENT getLimitChargeSuccess:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 1) {
            self.limitPrice = responseObject[@"result"];
        } else {
            self.limitPrice = [NSString stringWithFormat:@"%.2f",0.01f];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
