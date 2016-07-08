//
//  YLDZZsuppleyListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/8.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDZZsuppleyListViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "MJRefresh.h"
#import "HotSellModel.h"
#import "SellSearchTableViewCell.h"
#import "ScreeningView.h"
@interface YLDZZsuppleyListViewController ()
@property (nonatomic)NSInteger pageNum;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataAry;
@end

@implementation YLDZZsuppleyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
