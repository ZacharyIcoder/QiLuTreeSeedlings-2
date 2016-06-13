//
//  ZIKOrderViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKOrderViewController.h"

/*****工具******/
#import "HttpClient.h"
#import "YYModel.h"//类型转换
#import "MJRefresh.h"//MJ刷新
/*****工具******/

/*****Model******/
/*****Model******/

/*****View******/
#import "AdvertView.h"//广告页 section（0）
#import "BigImageViewShowView.h"//点击显示大图
#import "ZIKOrderSecondTableViewCell.h"//筛选cell section（1）
#import "ZIKStationOrderTableViewCell.h"//工程订单cell  section（2）
/*****View******/

/*****Controller******/
/*****Controller******/

/*****宏定义******/

@interface ZIKOrderViewController ()<UITableViewDataSource,UITableViewDelegate,AdvertDelegate>
@property (nonatomic, weak) UITableView   *orderTV;//工程订单Tableview
@property (nonatomic, assign) NSInteger      page;            //页数从1开始
@property (nonatomic, strong) NSMutableArray *orderMArr;//我的订单数组
@property (nonatomic,strong) BigImageViewShowView *bigImageViewShowView;

@end

@implementation ZIKOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self requestData];
}

- (void)initData {
    self.page           = 1;//页面page从1开始
    self.bigImageViewShowView = [[BigImageViewShowView alloc] initWithNomalImageAry:@[@"bangde1.jpg",@"bangde2.jpg",@"bangde3.jpg",@"bangde4.jpg"]];
}

- (void)initUI {
    self.leftBarBtnTitleString = @"苗信通";
    self.leftBarBtnBlock = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKBackHome" object:nil];
    };
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-44) style:UITableViewStylePlain];
    tableView.delegate   = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.orderTV = tableView;
}

#pragma mark - 请求数据
- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.orderTV addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestMyOrderList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.orderTV addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestMyOrderList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.orderTV headerBeginRefreshing];

}

#pragma mark - 请求我的供应列表信息
- (void)requestMyOrderList:(NSString *)page {
    //我的供应列表
    [self.orderTV headerEndRefreshing];
    [HTTPCLIENT stationGetOrderSearchWithOrderBy:@"orderDate" orderSort:@"desc" status:@"0" orderTypeUid:nil area:nil pageNumber:@"1" pageSize:@"15" Success:^(id responseObject) {
        CLog(@"result:%@",responseObject);
        ;
    } failure:^(NSError *error) {
        CLog(@"%@",error);
    }];

};

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 160.f/320.f*kWidth;
    } else if (indexPath.section == 1) {
        return 35;
    }
    return 180;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    }
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AdvertView *adView = [[AdvertView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 160.f/320.f*kWidth)];
        adView.delegate = self;
        [adView setAdInfo];
        [adView adStart];
        return adView;
    } else if (indexPath.section == 1) {
        ZIKOrderSecondTableViewCell *cell = [ZIKOrderSecondTableViewCell cellWithTableView:tableView];
        return cell;
    }

    ZIKStationOrderTableViewCell *cell = [ZIKStationOrderTableViewCell cellWithTableView:tableView];
    return cell;
}

#pragma mark ----- AdvertDelegate广告页面点击
//广告页面点击
-(void)advertPush:(NSInteger)index
{
    [self.bigImageViewShowView showInKeyWindowWithIndex:index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
