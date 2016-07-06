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

#import "GCZZModel.h"

#import "ZIKStationShowHonorView.h"//
#import "ZIKBaseCertificateAdapter.h"
#import "ZIKCertificateAdapter.h"

NSString *kHonorCellID = @"honorcellID";

@interface ZIKMyHonorViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)    NSMutableArray     *honorData;

@property (weak, nonatomic) IBOutlet UICollectionView *honorCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *honorCollectionViewFlowLayout;

@property (nonatomic, assign) BOOL isEditState;
@property (nonatomic, assign) NSInteger      page;            //页数从1开始

@property (nonatomic, strong) ZIKStationShowHonorView *showHonorView;
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
    self.page = 1;
    if (self.type == TypeHonor) {
        self.vcTitle = @"我的荣誉";
    }
    if (self.type == TypeQualification) {
        self.vcTitle = @"我的资质";
        [self.navBackView setBackgroundColor:NavYellowColor];
    }
    self.rightBarBtnTitleString = @"添加";
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{

        if (self.type == TypeQualification) {
            YLDZiZhiAddViewController *vcss=[[YLDZiZhiAddViewController alloc] initWithType:2];
//            vcss.delegate=self;


            [weakSelf.navigationController pushViewController:vcss animated:YES];
            return ;
        }
        if (self.type == TypeHonor) {
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.isEditState = NO;
    self.page = 1;

    if (self.type ==TypeQualification)
    {
        [self requestCompanyData];
    }
    
//    [self.honorCollectionView reloadData];

    //[self.honorCollectionView headerBeginRefreshing];

    if (self.type == TypeHonor) {
        [self requestData];
    }

}

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
}
#pragma mark - 请求数据
- (void)requestCompanyData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.honorCollectionView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestCompanyZZListData:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.honorCollectionView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestCompanyZZListData:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.honorCollectionView headerBeginRefreshing];
    
    //self.honorCollectionView.mj
}
- (void)requestCompanyZZListData:(NSString *)pageNumber
{
   [self.honorCollectionView headerEndRefreshing];
    [HTTPCLIENT GCZXwodezizhiWithuid:APPDELEGATE.GCGSModel.uid WithpageNumber:pageNumber WithpageSize:@"10" Success:^(id responseObject) {
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
                    GCZZModel *ZZModel = [GCZZModel GCZZModelWithDic:dic];
                    [self.honorData addObject:ZZModel];
                  
                }];
                [self.honorCollectionView reloadData];
            
                [self.honorCollectionView footerEndRefreshing];
                
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)requestHonorListData:(NSString *)pageNumber {
    [self.honorCollectionView headerEndRefreshing];
    [HTTPCLIENT stationHonorListWithWorkstationUid:self.workstationUid pageNumber:pageNumber pageSize:@"10" Success:^(id responseObject) {
        //CLog(@"%@",responseObject);
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
                }];
                [self.honorCollectionView reloadData];
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
    ZIKMyHonorCollectionViewCell * cell = [cv dequeueReusableCellWithReuseIdentifier:kHonorCellID
                                                                        forIndexPath:indexPath];
    cell.isEditState = self.isEditState;
    cell.indexPath = indexPath;
    if (self.honorData.count > 0) {

        if (self.type==TypeHonor) {
            __block  ZIKStationHonorListModel  *model = _honorData[indexPath.row];
//            [cell configureCellWithModel:model];
            // 与输入建立联系
            ZIKBaseCertificateAdapter *modelAdapter = [[ZIKCertificateAdapter alloc] initWithData:model];
            // 与输出建立联系
            [cell loadData:modelAdapter];
            __weak typeof(self) weakSelf = self;//解决循环引用的问题
            cell.editButtonBlock = ^(NSIndexPath *indexPath) {
                ZIKAddHonorViewController *addhonorVC = [[ZIKAddHonorViewController alloc] initWithNibName:@"ZIKAddHonorViewController" bundle:nil];
                addhonorVC.workstationUid = weakSelf.workstationUid;
                addhonorVC.uid = model.uid;
                [weakSelf.navigationController pushViewController:addhonorVC animated:YES];
            };
            cell.deleteButtonBlock = ^(NSIndexPath *indexPath) {
                [weakSelf deleteRequest:model.uid];
            };

        }else{
            __block  GCZZModel  *model = _honorData[indexPath.row];
            cell.ZZmodel=model;
            __weak typeof(self) weakSelf = self;//解决循环引用的问题
            cell.editButtonBlock = ^(NSIndexPath *indexPath) {
                YLDZiZhiAddViewController *addhonorVC = [[YLDZiZhiAddViewController alloc] initWithType:2];
                [weakSelf.navigationController pushViewController:addhonorVC animated:YES];
            };
            cell.deleteButtonBlock = ^(NSIndexPath *indexPath) {
                [weakSelf deleteRequest:model.uid];
            };

        }

    }
    return cell;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的3
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.showHonorView) {
        self.showHonorView = [ZIKStationShowHonorView instanceShowHonorView];
        self.showHonorView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
    }
    ZIKStationHonorListModel  *model = _honorData[indexPath.row];
    // 与输入建立联系
    ZIKBaseCertificateAdapter *modelAdapter = [[ZIKCertificateAdapter alloc] initWithData:model];
    // 与输出建立联系
    [self.showHonorView loadData:modelAdapter];
    [self.view addSubview:self.showHonorView];
    [UIView animateWithDuration:.3 animations:^{
        self.showHonorView.frame = CGRectMake(0, 0, kWidth, kHeight);
    }];
}

- (void)deleteRequest:(NSString *)uid {

    if (self.type ==TypeHonor)
    {
        [HTTPCLIENT stationHonorDeleteWithUid:uid Success:^(id responseObject) {
            if ([responseObject[@"success"] integerValue] == 0) {
                [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
                return ;
            }
            [ToastView showTopToast:@"删除成功"];
            self.isEditState = NO;
            self.page = 1;
            [self requestHonorListData:[NSString stringWithFormat:@"%ld",(long)self.page]];
            //        [self.honorCollectionView reloadData];
        } failure:^(NSError *error) {
            ;
        }];

        
    }else{
        [HTTPCLIENT GCZXDeleteRongYuWithuid:uid Success:^(id responseObject) {
            if ([responseObject[@"success"] integerValue] == 0) {
                [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
                return ;
            }
            [ToastView showTopToast:@"删除成功"];
            self.isEditState = NO;
            self.page = 1;
            [self requestCompanyZZListData:[NSString stringWithFormat:@"%ld",(long)self.page]];
        } failure:^(NSError *error) {
            
        }];
    }

}
@end
