//
//  ZIKHaveReadInfoViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/14.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKHaveReadInfoViewController.h"

#import "MJRefresh.h"
#import "YYModel.h"
#import "ZIKHaveReadTableViewCell.h"
#import "ZIKHaveReadModel.h"
@interface ZIKHaveReadInfoViewController ()
@property (nonatomic, strong) UITableView    *readVC;      //已读信息列表
@property (nonatomic, strong) NSMutableArray *readDataMArr;//已读信息数据Marr
@property (nonatomic, assign) NSInteger      page;         //页数从1开始
@end

@implementation ZIKHaveReadInfoViewController
{
    NSMutableArray *_removeArray;
    NSArray *_deleteIndexArr;//选中的删除index
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"定制:";
    [self initData];
    [self initUI];
}

#pragma mark - 初始化数据
- (void)initData {
    self.readDataMArr = [[NSMutableArray alloc] init];
}

#pragma mark - 初始化UI
- (void)initUI {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
