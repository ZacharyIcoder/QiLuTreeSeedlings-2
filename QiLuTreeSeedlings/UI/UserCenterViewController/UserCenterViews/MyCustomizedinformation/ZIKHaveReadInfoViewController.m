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

#pragma mark - 请求数据
- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.readVC addHeaderWithCallback:^{
        weakSelf.page = 1;
        //[weakSelf requestHaveReadList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.readVC addFooterWithCallback:^{
        weakSelf.page++;
        //[weakSelf requestHaveReadList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.readVC headerBeginRefreshing];
}

#pragma mark - 初始化数据
- (void)initData {
    self.page         = 1;
    self.readDataMArr = [[NSMutableArray alloc] init];
}

#pragma mark - 初始化UI
- (void)initUI {

}

//#pragma mark - 请求我的供应列表信息
//- (void)requestHaveReadList:(NSString *)page {
//    //我的供应列表
//    [self.readVC headerEndRefreshing];
//    HttpClient *httpClient = [HttpClient sharedClient];
//    [httpClient recordByProductWithProductUid:self.uidStr pageSize:page success:^(id responseObject) {
//        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
//            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
//            return ;
//        }
//        NSDictionary *dic = [responseObject objectForKey:@"result"];
//        NSArray *array = dic[@"list"];
//        if (array.count == 0 && self.page == 1) {
//            [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
//            if (self.state == SupplyStateAll) {
//                self.menuView.hidden = YES;
//                self.supplyTableView.hidden = YES;
//                [self createEmptyUI];
//                emptyUI.hidden = NO;
//            }
//            if (self.supplyInfoMArr.count > 0) {
//                [self.supplyInfoMArr removeAllObjects];
//            }
//            [self.supplyTableView footerEndRefreshing];
//            [self.supplyTableView reloadData];
//            return ;
//        }
//        else if (array.count == 0 && self.page > 1) {
//            emptyUI.hidden = YES;
//            self.menuView.hidden = NO;
//            self.supplyTableView.hidden = NO;
//
//            self.page--;
//            [self.supplyTableView footerEndRefreshing];
//            //没有更多数据了
//            [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
//            return;
//        }
//        else {
//            emptyUI.hidden = YES;
//            self.menuView.hidden = NO;
//            self.supplyTableView.hidden = NO;
//
//            if (self.page == 1) {
//                [self.supplyInfoMArr removeAllObjects];
//            }
//            [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
//                ZIKSupplyModel *model = [ZIKSupplyModel yy_modelWithDictionary:dic];
//                if (self.state == SupplyStateThrough && [model.shuaxin isEqualToString:@"1"]) {
//                    model.isCanRefresh = NO;
//                }
//                else {
//                    model.isCanRefresh = YES;
//                }
//                [self.supplyInfoMArr addObject:model];
//            }];
//            [self.supplyTableView reloadData];
//            //已通过状态并且可编辑状态
//            if (self.supplyTableView.editing && self.state == SupplyStateThrough) {
//                if (_throughSelectIndexArr.count > 0) {
//                    [_throughSelectIndexArr enumerateObjectsUsingBlock:^(NSIndexPath *selectIndex, NSUInteger idx, BOOL * _Nonnull stop) {
//                        [self.supplyTableView selectRowAtIndexPath:selectIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
//                    }];
//                }
//            }
//            //已过期并且可编辑状态
//            else if (self.supplyTableView.editing && self.state == SupplyStateNoThrough) {
//                if (_deleteIndexArr.count > 0) {
//                    [_deleteIndexArr enumerateObjectsUsingBlock:^(NSIndexPath *selectDeleteIndex, NSUInteger idx, BOOL * _Nonnull stop) {
//                        [self.supplyTableView selectRowAtIndexPath:selectDeleteIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
//                    }];
//                }
//                [self updateBottomDeleteCellView];
//            }
//            [self.supplyTableView footerEndRefreshing];
//
//        }
//
//    } failure:^(NSError *error) {
//        
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
