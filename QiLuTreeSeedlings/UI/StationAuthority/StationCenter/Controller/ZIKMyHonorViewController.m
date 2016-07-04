//
//  ZIKMyHonorViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMyHonorViewController.h"
#import "ZIKMyHonorCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "YLDZiZhiAddViewController.h"
#import "YYModel.h"//类型转换
#import "MJRefresh.h"//MJ刷新
#import "ZIKStationHonorListModel.h"
#import "ZIKAddHonorViewController.h"
NSString *kHonorCellID = @"honorcellID";

@interface ZIKMyHonorViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)    NSMutableArray     *honorData;

@property (weak, nonatomic) IBOutlet UICollectionView *honorCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *honorCollectionViewFlowLayout;

@property (nonatomic, assign) BOOL isEditState;
@property (nonatomic, assign) NSInteger      page;            //页数从1开始

@end

@implementation ZIKMyHonorViewController
{
    UILongPressGestureRecognizer *_tapDeleteGR;//长按手势
}

-(void)backBtnAction:(UIButton *)sender
{
    if (self.isEditState) {
        self.isEditState = NO;
        [self.honorCollectionView reloadData];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = BGColor;
    self.vcTitle = self.vctitle;
    self.page = 1;
    if ([self.vctitle isEqualToString:@"公司资质"]) {
        [self.navBackView setBackgroundColor:NavYellowColor];
    }
    self.rightBarBtnTitleString = @"添加";
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{
        if ([weakSelf.vctitle isEqualToString:@"公司资质"]) {
            YLDZiZhiAddViewController *vcss=[[YLDZiZhiAddViewController alloc] init];
            [weakSelf.navigationController pushViewController:vcss animated:YES];
            return ;
        }
        if ([weakSelf.vctitle isEqualToString:@"我的荣誉"]) {
            ZIKAddHonorViewController *addVC = [[ZIKAddHonorViewController alloc] initWithNibName:@"ZIKAddHonorViewController" bundle:nil];
            addVC.workstationUid = weakSelf.workstationUid;
            [weakSelf.navigationController pushViewController:addVC animated:YES];
        }
    };
    self.honorCollectionView.delegate   = self;
    self.honorCollectionView.dataSource = self;
    self.honorCollectionView.alwaysBounceVertical = YES;
    //self.honorCollectionView.backgroundColor = [UIColor yellowColor];
    self.isEditState = NO;
    //添加长按手势
    _tapDeleteGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR)];
    [self.honorCollectionView addGestureRecognizer:_tapDeleteGR];

    self.honorData = [NSMutableArray array];
    //[self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.page = 1;
    [self requestData];
    //[self.honorCollectionView headerBeginRefreshing];
}

///**
// *  懒加载获取plist中对应的数据源
// *
// */
//- (NSMutableArray *)honorData
//{
//    if (_honorData == nil) {
//
//        NSString * honorPath = [[NSBundle mainBundle] pathForResource:@"honor" ofType:@"plist"];
//        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:honorPath];
//        NSMutableArray *array = [dic objectForKey:@"honorList"];
////        NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:honorPath];
//
//        _honorData = array;
//    }
//
//    return _honorData;
//}

#pragma mark - 请求数据
- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.honorCollectionView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestHonorListData:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.honorCollectionView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestHonorListData:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.honorCollectionView headerBeginRefreshing];

    //self.honorCollectionView.mj

}

- (void)requestHonorListData:(NSString *)pageNumber {
    [self.honorCollectionView headerEndRefreshing];
    [HTTPCLIENT stationHonorListWithWorkstationUid:self.workstationUid pageNumber:pageNumber pageSize:@"10" Success:^(id responseObject) {
        CLog(@"%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        } else if ([responseObject[@"success"] integerValue] == 1) {
            NSArray *array  = responseObject[@"result"][@"list"];
            if (array.count == 0 && self.page == 1) {
                [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
                 if (self.honorData.count > 0) {
                    [self.honorData removeAllObjects];
                }
                [self.honorCollectionView footerEndRefreshing];
                [self.honorCollectionView reloadData];
                return ;
            }
            else if (array.count == 0 && self.page > 1) {
                 self.page--;
                [self.honorCollectionView footerEndRefreshing];
                //没有更多数据了
                [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
                return;
            }
            else {
                 if (self.page == 1) {
                    [self.honorData removeAllObjects];
                }
                [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZIKStationHonorListModel *honorListModel = [ZIKStationHonorListModel yy_modelWithDictionary:dic];
                    [self.honorData addObject:honorListModel];
//                    ZIKSupplyModel *model = [ZIKSupplyModel yy_modelWithDictionary:dic];
//                    if (self.state == SupplyStateThrough && [model.shuaxin isEqualToString:@"1"]) {
//                        model.isCanRefresh = NO;
//                    } else {
//                        model.isCanRefresh = YES;
//                    }
//                    [self.supplyInfoMArr addObject:model];
                }];
                [self.honorCollectionView reloadData];
//                //已通过状态并且可编辑状态
//                if (self.honorCollectionView.editing && self.state == SupplyStateThrough) {
//                    if (_throughSelectIndexArr.count > 0) {
//                        [_throughSelectIndexArr enumerateObjectsUsingBlock:^(NSIndexPath *selectIndex, NSUInteger idx, BOOL * _Nonnull stop) {
//                            [self.supplyTableView selectRowAtIndexPath:selectIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
//                        }];
//                    }
//                }
//                //已过期并且可编辑状态
//                else if (self.supplyTableView.editing && self.state == SupplyStateNoThrough) {
//                    if (_deleteIndexArr.count > 0) {
//                        [_deleteIndexArr enumerateObjectsUsingBlock:^(NSIndexPath *selectDeleteIndex, NSUInteger idx, BOOL * _Nonnull stop) {
//                            [self.supplyTableView selectRowAtIndexPath:selectDeleteIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
//                        }];
//                    }
//                    [self updateBottomDeleteCellView];
//                }
                [self.honorCollectionView footerEndRefreshing];
                
            }
        }
    } failure:^(NSError *error) {
    }];
}

- (void)tapGR {
    self.isEditState = YES;
    [self.honorCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return self.honorData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UINib *nib = [UINib nibWithNibName:@"ZIKMyHonorCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [cv registerNib:nib forCellWithReuseIdentifier:kHonorCellID];
    //ZIKIntegralCollectionViewCell *cell = [[ZIKIntegralCollectionViewCell alloc] init];
    ZIKMyHonorCollectionViewCell * cell = [cv dequeueReusableCellWithReuseIdentifier:kHonorCellID
                                                                        forIndexPath:indexPath];
    cell.isEditState = self.isEditState;
    if (self.honorData.count > 0) {
//       // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.honorData[indexPath.row] objectForKey:@"url"]]];
//        NSString *myurlstr = [NSString stringWithFormat:@"%@",[self.honorData[indexPath.row] objectForKey:@"url"]];
//        NSURL *honorUrl = [NSURL URLWithString:myurlstr];
//        NSURL *myurl    = [[NSURL alloc] initWithString:myurlstr];
//        NSLog(@"%@",myurl);
//        [cell.honorImageView setImageWithURL:honorUrl placeholderImage:[UIImage imageNamed:@"MoRentu"]];
//        cell.honorTitleLabel.text = [self.honorData[indexPath.row] objectForKey:@"title"];
//        cell.honorTimeLabel.text  = [self.honorData[indexPath.row] objectForKey:@"time"];
        [cell configureCellWithModel:_honorData[indexPath.row]];
    }
    return cell;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
      
}

@end
