//
//  ZIKChangeBriefViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKChangeBriefViewController.h"

@interface ZIKChangeBriefViewController ()

@property (weak, nonatomic) IBOutlet BWTextView *briefBWTextView;
@end

@implementation ZIKChangeBriefViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = @"自我介绍";
    if (_setString) {
        self.briefBWTextView.text = _setString;
    } else {
        self.briefBWTextView.placeholder = @"请输入自我介绍";
    }

}
- (IBAction)sureButtonClick:(UIButton *)sender {
    if ([self.type isEqualToString:@"苗企"]) {
        if ([ZIKFunction xfunc_check_strEmpty:self.briefBWTextView.text]) {
            [ToastView showTopToast:@"自我介绍内容为空"];
            return;
        }
        else {
            [HTTPCLIENT  goldSupplierUpdatebrief:self.briefBWTextView.text Success:^(id responseObject) {
                if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
                    APPDELEGATE.userModel.brief = self.briefBWTextView.text;
                    [ToastView showTopToast:@"修改成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    [ToastView showTopToast:responseObject[@"msg"]];
                }

            } failure:^(NSError *error) {
                ;
            }];
        }
    }
    else {
            [self changeRequest];
        }

}

- (void)changeRequest {
     NSString *brief = nil;
          brief = self.briefBWTextView.text;

    [HTTPCLIENT stationMasterUpdateWithChargePerson:nil phone:nil brief:brief Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        } else if ([responseObject[@"success"] integerValue] == 1) {
            [ToastView showTopToast:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }

    } failure:^(NSError *error) {
        ;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
