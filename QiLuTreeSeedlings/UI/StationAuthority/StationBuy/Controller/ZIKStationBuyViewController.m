//
//  ZIKStationBuyViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/8/25.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationBuyViewController.h"
/*****工具******/
#import "HttpClient.h"
#import "YYModel.h"//类型转换
#import "MJRefresh.h"//MJ刷新
/*****工具******/

@interface ZIKStationBuyViewController ()

@property (weak, nonatomic) IBOutlet UITableView *buyTableView;
@property (nonatomic, strong) NSMutableArray *buyMArr;
@property (nonatomic, assign) NSInteger      page;            //页数从1开始

@end

@implementation ZIKStationBuyViewController
#pragma mark - 视图cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
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
//    if (self.page > 1 && self.supplyInfoMArr.count > 0) {
//        ZIKSupplyModel *model = [self.supplyInfoMArr lastObject];
//        searchTime = model.searchTime;
//    }

    [self.buyTableView headerEndRefreshing];
      [HTTPCLIENT workstationBuyWithPageSize:@"15" page:page searchTime:nil Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
            return ;
        }
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        NSArray *array = dic[@"list"];
//        if (array.count == 0 && self.page == 1) {
//            [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
//            if (self.state == SupplyStateAll) {
//                self.menuView.hidden = YES;
//                self.supplyTableView.hidden = YES;
//                [self createEmptyUI];
//                _emptyUI.hidden = NO;
//            }
//            if (self.supplyInfoMArr.count > 0) {
//                [self.supplyInfoMArr removeAllObjects];
//            }
            [self.buyTableView footerEndRefreshing];
//            [self.buyTableView reloadData];
//            return ;
//        }
//        else if (array.count == 0 && self.page > 1) {
//            _emptyUI.hidden = YES;
//            self.menuView.hidden = NO;
//            self.buyTableView.hidden = NO;
//
//            self.page--;
//            [self.buyTableView footerEndRefreshing];
//            //没有更多数据了
//            [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
//            return;
//        }
//        else {
//            _emptyUI.hidden = YES;
//            self.menuView.hidden = NO;
//            self.buyTableView.hidden = NO;
//
//            if (self.page == 1) {
//                [self.supplyInfoMArr removeAllObjects];
//            }
//            [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
//                ZIKSupplyModel *model = [ZIKSupplyModel yy_modelWithDictionary:dic];
//                if (self.state == SupplyStateThrough && [model.shuaxin isEqualToString:@"1"]) {
//                    model.isCanRefresh = NO;
//                } else {
//                    model.isCanRefresh = YES;
//                }
//                [self.supplyInfoMArr addObject:model];
//            }];
//            [self.buyTableView reloadData];
////            //已通过状态并且可编辑状态
////            if (self.supplyTableView.editing && self.state == SupplyStateThrough) {
////                if (_throughSelectIndexArr.count > 0) {
////                    [_throughSelectIndexArr enumerateObjectsUsingBlock:^(NSIndexPath *selectIndex, NSUInteger idx, BOOL * _Nonnull stop) {
////                        [self.supplyTableView selectRowAtIndexPath:selectIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
////                    }];
////                }
////            }
////            //已过期并且可编辑状态
////            else if (self.supplyTableView.editing && self.state == SupplyStateNoThrough) {
////                if (_deleteIndexArr.count > 0) {
////                    [_deleteIndexArr enumerateObjectsUsingBlock:^(NSIndexPath *selectDeleteIndex, NSUInteger idx, BOOL * _Nonnull stop) {
////                        [self.supplyTableView selectRowAtIndexPath:selectDeleteIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
////                    }];
////                }
////                [self updateBottomDeleteCellView];
////            }
//            [self.supplyTableView footerEndRefreshing];
//
//        }

    } failure:^(NSError *error) {
        
    }];
}


- (void)initUI {
    self.leftBarBtnTitleString = @"苗信通";
    self.leftBarBtnBlock = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKBackHome" object:nil];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
