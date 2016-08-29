//
//  ZIKAddShowListViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/8/29.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKAddShowListViewController.h"

@interface ZIKAddShowListViewController ()

@end

@implementation ZIKAddShowListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

- (void)initUI {
    self.vcTitle = @"新增晒单";
    self.leftBarBtnImgString = @"BackBtn";
    self.rightBarBtnTitleString = @"发布";
//    __weak typeof(self) weakSelf  = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{
        NSLog(@"发布");
    };

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
