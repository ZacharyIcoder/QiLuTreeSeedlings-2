//
//  ZIKStationShowListViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/8/29.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationShowListViewController.h"
#import "ZIKAddShowListViewController.h"//新增晒单
#import "ZIKSelectMenuView.h"

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

    NSArray *titleArray = [NSArray arrayWithObjects:@"全部晒单",@"我的晒单", nil];
    ZIKSelectMenuView *selectMenuView = [[ZIKSelectMenuView alloc] initWithFrame:CGRectMake(0, 64, kWidth, 43) dataArray:titleArray];
    selectMenuView.menuBtnBlock = ^(NSInteger menuBtnTag){
          if (menuBtnTag == 0) {
              CLog(@"全部晒单");
        } else {
            CLog(@"我的晒单");
        }
    };
    [self.view addSubview:selectMenuView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
