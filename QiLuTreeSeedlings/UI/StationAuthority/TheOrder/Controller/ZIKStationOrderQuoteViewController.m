//
//  ZIKStationOrderQuoteViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/25.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationOrderQuoteViewController.h"

@interface ZIKStationOrderQuoteViewController ()
@property (weak, nonatomic) IBOutlet UITableView *quoteTableView;

@end

@implementation ZIKStationOrderQuoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = @"报价";
}

- (IBAction)sureButtonClick:(UIButton *)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
