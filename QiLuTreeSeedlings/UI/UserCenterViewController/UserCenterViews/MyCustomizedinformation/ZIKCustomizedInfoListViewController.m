//
//  ZIKCustomizedInfoListViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKCustomizedInfoListViewController.h"
#import "ZIKCustomizedSetViewController.h"
@interface ZIKCustomizedInfoListViewController ()

@end

@implementation ZIKCustomizedInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNav];
}

- (void)configNav {
    self.vcTitle = @"已定制信息";
    self.rightBarBtnTitleString = @"添加";
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{
        //NSLog(@"添加");
        ZIKCustomizedSetViewController *setVC = [[ZIKCustomizedSetViewController alloc] init];
        [weakSelf.navigationController pushViewController:setVC animated:YES];
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
