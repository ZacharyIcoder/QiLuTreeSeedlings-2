//
//  ZIKQiugouWeihuViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/26.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKQiugouWeihuViewController.h"
#import "YYModel.h"//类型转换
#import "MJRefresh.h"//MJ刷新
#import "ZIKShopBuyModel.h"
#import "ZIKShopBuyTableViewCell.h"
#import "ZIKFunction.h"
#import "ZIKQiugouEditWeihuViewController.h"
#import "BuyDetialInfoViewController.h"

@interface ZIKQiugouWeihuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) NSInteger      page;            //页数从1开始
@property (nonatomic, strong) NSMutableArray *buyInfoMArr; //求购信息数组
@property (weak, nonatomic) IBOutlet UITableView *buyTableView;
@end

@implementation ZIKQiugouWeihuViewController

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
            self.count = [dic objectForKey:@"buyCount"];
            self.vcTitle = [NSString stringWithFormat:@"推荐求购%@/10",self.count];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {

    }];

}

- (void)initData {
    self.vcTitle = [NSString stringWithFormat:@"推荐求购%@/10",self.count];
    self.rightBarBtnTitleString = @"维护";
    __weak typeof(self) weakSelf = self;//解决循环引用的问题

    self.rightBarBtnBlock = ^{
        ZIKQiugouEditWeihuViewController *editWeihuVC = [[ZIKQiugouEditWeihuViewController alloc] initWithNibName:@"ZIKQiugouEditWeihuViewController" bundle:nil];
        [weakSelf.navigationController pushViewController:editWeihuVC animated:NO];
    };
    self.page = 1;
    self.buyInfoMArr = [NSMutableArray array];
}

- (void)initUI {
//    self.buyTableView.backgroundColor = [UIColor yellowColor];
    self.buyTableView.delegate = self;
    self.buyTableView.dataSource = self;
    [ZIKFunction setExtraCellLineHidden:self.buyTableView];
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
    [self requestBuyList:[NSString stringWithFormat:@"%ld",(long)self.page]];

}


- (void)requestBuyList:(NSString *)page {
//    [self.buyTableView headerEndRefreshing];
    NSString *memberUid = APPDELEGATE.userModel.access_id;
    [HTTPCLIENT shopBuyList:memberUid page:page pageSize:@"1500" selfrecommend:@"1"  Success:^(id responseObject) {
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
            if (self.buyInfoMArr.count > 0) {
                [self.buyInfoMArr removeAllObjects];
            }
//            [self.buyTableView footerEndRefreshing];
            [self.buyTableView reloadData];
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
                [self.buyInfoMArr removeAllObjects];
            }
            [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKShopBuyModel *model = [ZIKShopBuyModel yy_modelWithDictionary:dic];
                 [self.buyInfoMArr addObject:model];
            }];
            [self.buyTableView reloadData];
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
    return self.buyInfoMArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKShopBuyTableViewCell *cell = [ZIKShopBuyTableViewCell cellWithTableView:tableView];
    if (self.buyInfoMArr.count > 0) {
        ZIKShopBuyModel *model = self.buyInfoMArr[indexPath.row];
        [cell configureCell:model];
     }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKShopBuyModel *model = self.buyInfoMArr[indexPath.row];
    BuyDetialInfoViewController *buyDetialVC = [[BuyDetialInfoViewController alloc] initMyDetialWithSaercherInfo:model.uid];
    [self.navigationController pushViewController:buyDetialVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
