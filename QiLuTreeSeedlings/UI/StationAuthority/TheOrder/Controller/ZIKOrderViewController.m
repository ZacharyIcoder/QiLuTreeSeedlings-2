//
//  ZIKOrderViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKOrderViewController.h"
#import "ZIKStationOrderTableViewCell.h"
@interface ZIKOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UITableView *orderTV;
@end

@implementation ZIKOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-44) style:UITableViewStylePlain];
    tableView.delegate   = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.orderTV = tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKStationOrderTableViewCell *cell = [ZIKStationOrderTableViewCell cellWithTableView:tableView];
    return cell;
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
