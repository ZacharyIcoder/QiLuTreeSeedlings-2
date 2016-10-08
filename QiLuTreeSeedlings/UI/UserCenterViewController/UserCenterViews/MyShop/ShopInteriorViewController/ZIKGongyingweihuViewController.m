//
//  ZIKGongyingWeihuViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/26.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKGongyingWeihuViewController.h"
#import "YYModel.h"//类型转换
#import "KMJRefresh.h"//MJ刷新
//#import "ZIKShopBuyModel.h"
#import "ZIKSupplyModel.h"
//#import "ZIKShopBuyTableViewCell.h"
#import "ZIKMySupplyTableViewCell.h"
#import "ZIKFunction.h"
#import "ZIKGongyingEditWeihuViewController.h"
//#import "BuyDetialInfoViewController.h"
#import "ZIKMySupplyDetailViewController.h"
#import "HotSellModel.h"
#import "SellDetialViewController.h"

@interface ZIKGongyingWeihuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) NSInteger      page;            //页数从1开始
@property (nonatomic, strong) NSMutableArray *supplyInfoMArr; //求购信息数组
@property (weak, nonatomic) IBOutlet UITableView *supplyTableView;

@end

@implementation ZIKGongyingWeihuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initUI];
    //[self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self requestData];
    [HTTPCLIENT getShopInoterMessageSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *dic = [responseObject objectForKey:@"result"];
            self.count = [dic objectForKey:@"supplyCount"];
            self.vcTitle = [NSString stringWithFormat:@"推荐供应%@/10",self.count];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {

    }];

}

- (void)initData {
    self.vcTitle = [NSString stringWithFormat:@"推荐供应%@/10",self.count];
    self.rightBarBtnTitleString = @"维护";
    __weak typeof(self) weakSelf = self;//解决循环引用的问题

    self.rightBarBtnBlock = ^{
        ZIKGongyingEditWeihuViewController *editWeihuVC = [[ZIKGongyingEditWeihuViewController alloc] initWithNibName:@"ZIKGongyingEditWeihuViewController" bundle:nil];
        [weakSelf.navigationController pushViewController:editWeihuVC animated:NO];
    };
    self.page = 1;
    self.supplyInfoMArr = [NSMutableArray array];
}

- (void)initUI {
    //    self.buyTableView.backgroundColor = [UIColor yellowColor];
    self.supplyTableView.delegate = self;
    self.supplyTableView.dataSource = self;
    [ZIKFunction setExtraCellLineHidden:self.supplyTableView];
}

- (void)requestData {
    //    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    //    [self.buyTableView addHeaderWithCallback:^{
    //        weakSelf.page = 1;
    //        [weakSelf requestBuyList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    //    }];
    //    [self.buyTableView addFooterWithCallback:^{
    //        weakSelf.page++;
    //        [weakSelf requestBuyList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    //    }];
    //    [self.buyTableView headerBeginRefreshing];
    [self requestSupplyList:[NSString stringWithFormat:@"%ld",(long)self.page]];

}


- (void)requestSupplyList:(NSString *)page {
    //    [self.buyTableView headerEndRefreshing];
    NSString *memberUid = APPDELEGATE.userModel.access_id;
    [HTTPCLIENT shopSupplyList:memberUid page:page pageSize:@"1500" selfrecommend:@"1"  Success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
            //            [self.buyTableView footerEndRefreshing];

            return ;
        }
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        NSArray *array = dic[@"list"];
        if (array.count == 0 && self.page == 1) {
            [ToastView showToast:@"请设置自己的推荐" withOriginY:Width/2 withSuperView:self.view];
            if (self.supplyInfoMArr.count > 0) {
                [self.supplyInfoMArr removeAllObjects];
            }
            //            [self.buyTableView footerEndRefreshing];
            [self.supplyTableView reloadData];
            return ;
        }
        else if (array.count == 0 && self.page > 1) {

            self.page--;
            //            [self.buyTableView footerEndRefreshing];
            //没有更多数据了
            [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
            return;
        }
        else {
            if (self.page == 1) {
                [self.supplyInfoMArr removeAllObjects];
            }
            [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKSupplyModel *model = [ZIKSupplyModel yy_modelWithDictionary:dic];
                [self.supplyInfoMArr addObject:model];
            }];
            [self.supplyTableView reloadData];
            //            [self.buyTableView footerEndRefreshing];

        }

    } failure:^(NSError *error) {
        //        [self.buyTableView footerEndRefreshing];
    }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.supplyInfoMArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kZIKMySupplyTableViewCellID = @"kZIKMySupplyTableViewCellID";

    ZIKMySupplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKMySupplyTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKMySupplyTableViewCell" owner:self options:nil] lastObject];
    }
    if (self.supplyInfoMArr.count > 0) {
        [cell configureCell:self.supplyInfoMArr[indexPath.row]];
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    ZIKSupplyModel *model = self.supplyInfoMArr[indexPath.row];
//    ZIKMySupplyDetailViewController *detailVC = [[ZIKMySupplyDetailViewController alloc] initMySupplyDetialWithUid:model];
//    [self.navigationController pushViewController:detailVC animated:YES];


    HotSellModel *hotSellModel = self.supplyInfoMArr[indexPath.row];
    SellDetialViewController *sellDetialViewC = [[SellDetialViewController alloc] initWithUid:hotSellModel];
    [self.navigationController pushViewController:sellDetialViewC animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
