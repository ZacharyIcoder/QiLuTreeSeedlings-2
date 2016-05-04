//
//  ZIKPaySuccessViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/5.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKPaySuccessViewController.h"
#import "ZIKMyBalanceViewController.h"
#import "BuyDetialInfoViewController.h"
#define Recharge @"Is top-up for the first time"
@interface ZIKPaySuccessViewController ()

@end

@implementation ZIKPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = @"支付订单";
    self.priceLabel.text = [NSString stringWithFormat:@"充值金额(元) : %@",self.price];
    [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:Recharge];
//#define Recharge @"Is top-up for the first time"*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishButton:(id)sender {
    for(UIViewController *controller in self.navigationController.viewControllers) {
        if([controller isKindOfClass:[ZIKMyBalanceViewController class]]||[controller isKindOfClass:[BuyDetialInfoViewController class]]){
            ZIKMyBalanceViewController *owr = (ZIKMyBalanceViewController *)controller;
            [self.navigationController popToViewController:owr animated:YES];
        }
    }
}
@end
