//
//  ZIKStationShowListDetailViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/13.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationShowListDetailViewController.h"

@interface ZIKStationShowListDetailViewController ()

@end

@implementation ZIKStationShowListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

- (void)initUI {
    self.vcTitle = @"晒单详情";
    self.leftBarBtnImgString = @"BackBtn";
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
