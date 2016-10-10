//
//  ZIKMiaoQiGongYingViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/6.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMiaoQiGongYingViewController.h"
#import "HttpClient.h"
#import "YYModel.h"//类型转换
#import "KMJRefresh.h"//MJ刷新
#import "ZIKFunction.h"

#import "HotSellModel.h"
#import "SellSearchTableViewCell.h"
#import "SellDetialViewController.h"
@interface ZIKMiaoQiGongYingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *gyTableView;
@property (nonatomic, strong) NSMutableArray *gyMArr;
@property (nonatomic, assign) NSInteger      page;            //页数从1开始

@end

@implementation ZIKMiaoQiGongYingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initUI];
    [self requestData];
}

- (void)initData {
    self.page = 1;
    self.gyMArr = [NSMutableArray array];
}

- (void)initUI {
    self.leftBarBtnTitleString = @"苗信通";
    self.leftBarBtnBlock = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKMiaoQiBackHome" object:nil];
    };

    self.gyTableView.delegate = self;
    self.gyTableView.dataSource = self;
    [ZIKFunction setExtraCellLineHidden:self.gyTableView];
}

#pragma mark - 请求数据
- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.gyTableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestMyOrderList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.gyTableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestMyOrderList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.gyTableView headerBeginRefreshing];

}

#pragma mark - 请求工程订单列表信息
- (void)requestMyOrderList:(NSString *)page {
    NSString *searchTime;
    if (self.page > 1 && self.gyMArr.count > 0) {
        HotSellModel *model = [self.gyMArr lastObject];
        searchTime = model.searchtime;
    }

    [self.gyTableView headerEndRefreshing];

    [HTTPCLIENT cooperationCompanySupplyWithPage:page pageSize:@"15" searchTime:searchTime Success:^(id responseObject) {
        CLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
            return ;
        }
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        NSArray *array = dic[@"list"];
        if (array.count == 0 && self.page == 1) {
            [ToastView showToast:@"暂无信息" withOriginY:Width/2 withSuperView:self.view];
            if (self.gyMArr.count > 0) {
                [self.gyMArr removeAllObjects];
            }
            [self.gyTableView footerEndRefreshing];
            [self.gyTableView reloadData];
            return ;
        }  else if (array.count == 0 && self.page > 1) {
            self.page--;
            [self.gyTableView footerEndRefreshing];
            //没有更多数据了
            [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
            return;
        }  else {
            if (self.page == 1) {
                [self.gyMArr removeAllObjects];
            }
            NSArray *aryzz = [HotSellModel hotSellAryByAry:array];
            [self.gyMArr addObjectsFromArray:aryzz];
            [self.gyTableView reloadData];
            [self.gyTableView footerEndRefreshing];
        }
    } failure:^(NSError *error) {
        [self.gyTableView footerEndRefreshing];

    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gyMArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    SellSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SellSearchTableViewCell IDStr]];
//    if (!cell) {
//        cell = [[SellSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[SellSearchTableViewCell IDStr] WithFrame:CGRectMake(0, 0, kWidth, 60)];;
//    }
//    if (self.gyMArr.count>=indexPath.row+1) {
//        cell.hotBuyModel=self.gyMArr[indexPath.row];
//    }
//    return cell;

    SellSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SellSearchTableViewCell IDStr]];
    if (!cell) {
        cell=[[SellSearchTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 100)];
    }
    if (self.gyMArr.count>=indexPath.row+1) {
        cell.hotSellModel=self.gyMArr[indexPath.row];
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HotSellModel *model = self.gyMArr[indexPath.row];
    SellDetialViewController *viewC = [[SellDetialViewController alloc] initWithUid:model];
    viewC.hidesBottomBarWhenPushed = YES;
    viewC.type = 2;
    [self.navigationController pushViewController:viewC animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
