//
//  ZIKWorkstationViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKWorkstationViewController.h"

@interface ZIKWorkstationViewController ()

@end

@implementation ZIKWorkstationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKBackHome" object:nil];
}

@end