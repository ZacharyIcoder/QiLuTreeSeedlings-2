//
//  ZIKStationChangeInfoViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/1.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationChangeInfoViewController.h"

@interface ZIKStationChangeInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ZIKStationChangeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = self.titleString;
    self.textField.placeholder = self.placeholderString;
}

- (IBAction)sureButtonClick:(UIButton *)sender {
    [self changeRequest];
}

- (void)changeRequest {
    NSString *chargePerson = nil;
    NSString *phone = nil;
    NSString *brief = nil;
    if ([self.titleString isEqualToString:@"姓名"]) {
        chargePerson = self.textField.text;
    } else if ([self.titleString isEqualToString:@"电话"]) {
        phone = self.textField.text;
    } else {
        brief = self.textField.text;
    }
    [HTTPCLIENT stationMasterUpdateWithChargePerson:chargePerson phone:phone brief:brief Success:^(id responseObject) {
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