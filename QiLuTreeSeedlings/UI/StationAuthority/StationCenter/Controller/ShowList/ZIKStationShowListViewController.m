//
//  ZIKStationShowListViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/8/29.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationShowListViewController.h"
#import "ZIKAddShowListViewController.h"//新增晒单
@interface ZIKStationShowListViewController ()

@end

@implementation ZIKStationShowListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

- (void)initUI {
   self.vcTitle = @"站长晒单";
   self.leftBarBtnImgString = @"BackBtn";
   self.rightBarBtnTitleString = @"新增晒单";
    __weak typeof(self) weakSelf  = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{
        ZIKAddShowListViewController *addShowListVC = [[ZIKAddShowListViewController alloc] initWithNibName:@"ZIKAddShowListViewController" bundle:nil];
        [weakSelf.navigationController pushViewController:addShowListVC animated:YES];
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
