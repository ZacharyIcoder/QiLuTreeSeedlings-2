//
//  ZIKExchangeViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/31.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKExchangeViewController.h"

@interface ZIKExchangeViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *IntegralCollectionView;

@end

@implementation ZIKExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = @"积分兑换";
//    self.IntegralCollectionView =
    [self requestData];

}

- (void)requestData {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
