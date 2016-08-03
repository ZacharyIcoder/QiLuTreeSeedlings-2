//
//  ZIKQiugouEditWeihuViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/29.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKQiugouEditWeihuViewController.h"
#import "YYModel.h"//类型转换
#import "MJRefresh.h"//MJ刷新
#import "ZIKShopBuyModel.h"
#import "ZIKShopBuyTableViewCell.h"
#import "ZIKFunction.h"
@interface ZIKQiugouEditWeihuViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *editBuyTableView;
@property (nonatomic, strong) NSMutableArray *buyInfoMArr; //求购信息数组
@property (nonatomic, assign) NSInteger      page;            //页数从1开始

@end

@implementation ZIKQiugouEditWeihuViewController
{
    NSMutableArray *_refreshMarr;   //保存选中行数据
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = @"选择求购";
//    self.editBuyTableView.backgroundColor = [UIColor yellowColor];
    [self initData];
    [self initUI];
    //[self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self requestData];
}

- (void)initData {
    self.page = 1;
    self.buyInfoMArr = [NSMutableArray array];
    _refreshMarr = [NSMutableArray array];
    self.editBuyTableView.editing = YES;
}

- (void)initUI {
    //    self.buyTableView.backgroundColor = [UIColor yellowColor];
    self.editBuyTableView.delegate = self;
    self.editBuyTableView.dataSource = self;
    [ZIKFunction setExtraCellLineHidden:self.editBuyTableView];
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
    [HTTPCLIENT shopBuyList:memberUid page:page pageSize:@"1500" selfrecommend:nil  Success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
            //            [self.buyTableView footerEndRefreshing];

            return ;
        }
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        NSArray *array = dic[@"list"];
        if (array.count == 0 && self.page == 1) {
            [ToastView showToast:@"你还没有发布通过的推荐信息" withOriginY:Width/2 withSuperView:self.view];
            if (self.buyInfoMArr.count > 0) {
                [self.buyInfoMArr removeAllObjects];
            }
            //            [self.buyTableView footerEndRefreshing];
            [self.editBuyTableView reloadData];
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
            [self.editBuyTableView reloadData];
            //            [self.buyTableView footerEndRefreshing];

        }
        [self.buyInfoMArr enumerateObjectsUsingBlock:^(ZIKShopBuyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.selfrecommend isEqualToString:@"1"]) {
                [self.editBuyTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                [_refreshMarr addObject:model];
            }
         }];


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
    //    if (self.buyInfoMArr.count > 0) {
    //        ZIKMyTeamModel *model = self.stationMArr[indexPath.section];
    //        YLDZhanZhangMessageViewController *detailVC = [[YLDZhanZhangMessageViewController
    //                                                        alloc] initWithUid:model.uid];
    //        if (self.navigationController.childViewControllers.count>1) {
    //
    //        }else{
    //            detailVC.hidesBottomBarWhenPushed = YES;
    //        }
    //
    //        [self.navigationController pushViewController:detailVC animated:YES];
    //
    //    }
    ZIKShopBuyModel *model = self.buyInfoMArr[indexPath.row];
    if (_refreshMarr.count >= 10) {
        [self.editBuyTableView deselectRowAtIndexPath:indexPath animated:YES];
        [ToastView showTopToast:@"一次最多推荐10条"];
        return;
    } else {
        [_refreshMarr addObject:model];
    }



//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKShopBuyModel *model = self.buyInfoMArr[indexPath.row];
    // 删除反选数据
    if ([_refreshMarr containsObject:model])
    {
        [_refreshMarr removeObject:model];
    }
}

- (IBAction)sureButtonClick:(UIButton *)sender {
    __block NSString *buyUidString = @"";
    if (_refreshMarr.count == 0) {
//        [ToastView showTopToast:@"请选择要维护的内容"];
//        return;
    } else {
        [_refreshMarr enumerateObjectsUsingBlock:^(ZIKShopBuyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            buyUidString = [buyUidString stringByAppendingString:[NSString stringWithFormat:@",%@",model.uid]];
        }];
        buyUidString = [buyUidString substringFromIndex:1];
    }

    [HTTPCLIENT shopAddBuy:buyUidString Success:^(id responseObject) {
        CLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
            return ;
        } else {
            [ToastView showTopToast:@"维护成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }

    } failure:^(NSError *error) {
        ;
    }];
}

#pragma mark - 可选方法实现
#pragma mark - 设置删除按钮标题
// 设置删除按钮标题
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}

#pragma mark - 设置行是否可编辑
// 设置行是否可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.supplyTableView.editing && self.state == SupplyStateThrough) {
//        ZIKSupplyModel *model = self.supplyInfoMArr[indexPath.section];
//        if (!model.isCanRefresh) {
//            return NO;
//        }
//    }
    return YES;
}

#pragma mark -  删除数据风格
// 删除数据风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"commitEditingStyle");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
