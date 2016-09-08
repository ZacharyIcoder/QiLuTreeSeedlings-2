//
//  ZIKMiaoQiQiuGouViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/6.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMiaoQiQiuGouViewController.h"
/*****工具******/
#import "HttpClient.h"
#import "YYModel.h"//类型转换
#import "MJRefresh.h"//MJ刷新
#import "ZIKFunction.h"
/*****工具******/

#import "HotBuyModel.h"
#import "BuySearchTableViewCell.h"
#import "BuyDetialInfoViewController.h"
@interface ZIKMiaoQiQiuGouViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *buyTableView;
@property (nonatomic, strong) NSMutableArray *buyMArr;
@property (nonatomic, assign) NSInteger      page;            //页数从1开始

@end

@implementation ZIKMiaoQiQiuGouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.buyMArr = [NSMutableArray array];
    [self initUI];
    [self requestData];//请求站长求购列表信息

}

#pragma mark - 请求数据
- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.buyTableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestMySupplyList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.buyTableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestMySupplyList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.buyTableView headerBeginRefreshing];
}

#pragma mark - 请求我的供应列表信息
- (void)requestMySupplyList:(NSString *)page {
    //我的供应列表
    NSString *searchTime;
    if (self.page > 1 && self.buyMArr.count > 0) {
        HotBuyModel *model = [self.buyMArr lastObject];
        searchTime = model.searchTime;
    }

    [self.buyTableView headerEndRefreshing];
    [HTTPCLIENT cooperationCompanyBuyWithPageSize:@"15" page:page searchTime:nil Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
            return ;
        }
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        NSArray *array = dic[@"list"];
        if (array.count == 0 && self.page == 1) {
            [ToastView showToast:@"暂无信息" withOriginY:Width/2 withSuperView:self.view];
            if (self.buyMArr.count > 0) {
                [self.buyMArr removeAllObjects];
            }
            [self.buyTableView footerEndRefreshing];
            [self.buyTableView reloadData];
            return ;
        }  else if (array.count == 0 && self.page > 1) {
            self.page--;
            [self.buyTableView footerEndRefreshing];
            //没有更多数据了
            [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
            return;
        }  else {
            if (self.page == 1) {
                [self.buyMArr removeAllObjects];
            }
            NSArray *aryzz = [HotBuyModel creathotBuyModelAryByAry:array];
            [self.buyMArr addObjectsFromArray:aryzz];
            [self.buyTableView reloadData];
            [self.buyTableView footerEndRefreshing];
        }
    } failure:^(NSError *error) {
        [self.buyTableView footerEndRefreshing];
    }];
}

- (void)initUI {
    self.leftBarBtnTitleString = @"苗信通";
    self.leftBarBtnBlock = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKMiaoQiBackHome" object:nil];
    };

    self.buyTableView.delegate = self;
    self.buyTableView.dataSource = self;
    [ZIKFunction setExtraCellLineHidden:self.buyTableView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.buyMArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BuySearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BuySearchTableViewCell IDStr]];
    if (!cell) {
        cell = [[BuySearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[BuySearchTableViewCell IDStr] WithFrame:CGRectMake(0, 0, kWidth, 60)];;
    }
    if (self.buyMArr.count>=indexPath.row+1) {
        cell.hotBuyModel=self.buyMArr[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HotBuyModel *model = self.buyMArr[indexPath.row];
    BuyDetialInfoViewController *viewC = [[BuyDetialInfoViewController alloc] initWithSaercherInfo:model.uid];
    viewC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
