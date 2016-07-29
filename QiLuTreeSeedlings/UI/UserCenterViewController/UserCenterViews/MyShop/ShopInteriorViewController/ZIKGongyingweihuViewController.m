//
//  ZIKGongyingWeihuViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/26.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKGongyingWeihuViewController.h"

@interface ZIKGongyingWeihuViewController ()

@end

@implementation ZIKGongyingWeihuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = [NSString stringWithFormat:@"推荐供应%@/10",self.count];
    self.rightBarBtnTitleString = @"维护";
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
