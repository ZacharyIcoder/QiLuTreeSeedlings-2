//
//  KeFuViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/31.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "KeFuViewController.h"
#import "UIDefines.h"
@interface KeFuViewController ()

@end

@implementation KeFuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"客服系统";
    UIView *topview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth,110)];
    [topview setBackgroundColor:NavColor];
    // Do any additional setup after loading the view.
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
