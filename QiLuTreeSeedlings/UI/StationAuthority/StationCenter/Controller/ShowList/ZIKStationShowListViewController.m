//
//  ZIKStationShowListViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/8/29.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationShowListViewController.h"

/*****工具******/
#import "HttpClient.h"
#import "YYModel.h"//类型转换
#import "MJRefresh.h"//MJ刷新
#import "ZIKFunction.h"
/*****工具******/

#import "ZIKAddShowListViewController.h"//新增晒单
#import "ZIKAddShaiDanViewController.h"//新增晒单
#import "ZIKSelectMenuView.h"

#import "ZIKShaiDanTableViewCell.h"
#import "ZIKShaiDanModel.h"

#import "ZIKStationShowListDetailViewController.h"//晒单详情
@interface ZIKStationShowListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *showListTableView;
@property (nonatomic, assign) NSInteger      page;            //页数从1开始
@property (nonatomic, strong) NSMutableArray *shaiData;

@property (nonatomic, assign) NSInteger shaiType;//0全部，1我的
@end

@implementation ZIKStationShowListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initUI];
    [self requestData];
}

#pragma  mark - 初始化数据
- (void)initData {
    self.page           = 1;//页面page从1开始
    self.shaiData = [NSMutableArray array];
//    _refreshMarr        = [[NSMutableArray alloc] init];
//    _removeArray        = [[NSMutableArray alloc] init];
}

- (void)initUI {
   self.vcTitle = @"站长晒单";
   self.leftBarBtnImgString = @"BackBtn";
   self.rightBarBtnTitleString = @"新增晒单";
    __weak typeof(self) weakSelf  = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{
        ZIKAddShaiDanViewController *addShowListVC = [[ZIKAddShaiDanViewController alloc] initWithNibName:@"ZIKAddShaiDanViewController" bundle:nil];
        [weakSelf.navigationController pushViewController:addShowListVC animated:YES];

//        ZIKAddShowListViewController *addShowListVC = [[ZIKAddShowListViewController alloc] initWithNibName:@"ZIKAddShowListViewController" bundle:nil];
//        [weakSelf.navigationController pushViewController:addShowListVC animated:YES];

    };

    NSArray *titleArray = [NSArray arrayWithObjects:@"全部晒单",@"我的晒单", nil];
    ZIKSelectMenuView *selectMenuView = [[ZIKSelectMenuView alloc] initWithFrame:CGRectMake(0, 64, kWidth, 43) dataArray:titleArray];
    selectMenuView.menuBtnBlock = ^(NSInteger menuBtnTag){
//          if (menuBtnTag == 0) {
//              CLog(@"全部晒单");
//        } else {
//            CLog(@"我的晒单");
//        }
        weakSelf.shaiType = menuBtnTag;
        weakSelf.page = 1;
        [weakSelf.showListTableView headerBeginRefreshing];
    };
    [self.view addSubview:selectMenuView];

    self.showListTableView.delegate = self;
    self.showListTableView.dataSource = self;
    [ZIKFunction setExtraCellLineHidden:self.showListTableView];
}


#pragma mark - 请求数据
- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.showListTableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestMyQuoteList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.showListTableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestMyQuoteList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.showListTableView headerBeginRefreshing];
}

- (void)requestMyQuoteList:(NSString *)page {
    [self.showListTableView headerEndRefreshing];
    [HTTPCLIENT workstationAllShaiDanWithThpe:_shaiType PageNumber:page pageSize:@"15" Success:^(id responseObject) {
        //CLog(@"%@",responseObject) ;
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        }
        NSDictionary *resultDic = responseObject[@"result"];
        NSArray *quoteListArray = resultDic[@"list"];
        if (self.page == 1 && quoteListArray.count == 0) {
            [ToastView showTopToast:@"暂无数据"];
            [self.showListTableView footerEndRefreshing];
            if(self.shaiData.count > 0 ) {
                [self.shaiData removeAllObjects];
            }
            [self.showListTableView reloadData];
            return ;
        } else if (quoteListArray.count == 0 && self.page > 1) {
            [ToastView showTopToast:@"已无更多信息"];
            self.page--;
            [self.showListTableView footerEndRefreshing];
            return;
        } else {
            if (self.page == 1) {
                [self.shaiData removeAllObjects];
            }

            [quoteListArray enumerateObjectsUsingBlock:^(NSDictionary *orderDic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKShaiDanModel *model = [ZIKShaiDanModel yy_modelWithDictionary:orderDic];
                [self.shaiData addObject:model];
            }];

            [self.showListTableView reloadData];

            [self.showListTableView footerEndRefreshing];

        }

        
    } failure:^(NSError *error) {
        ;
    }];
}

#pragma mark - tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shaiData.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *kZIKMySupplyTableViewCellID = @"kZIKMySupplyTableViewCellID";
//
//    ZIKShaiDanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKMySupplyTableViewCellID];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKShaiDanTableViewCell" owner:self options:nil] lastObject];
//    }
    ZIKShaiDanTableViewCell *cell = [ZIKShaiDanTableViewCell cellWithTableView:tableView];
    if (self.shaiData.count > 0) {
        [cell configureCell:self.shaiData[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKShaiDanModel *model = self.shaiData[indexPath.row];
    ZIKStationShowListDetailViewController *detailVC = [[ZIKStationShowListDetailViewController alloc] initWithNibName:@"ZIKStationShowListDetailViewController" bundle:nil];
    detailVC.uid = model.uid;
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
