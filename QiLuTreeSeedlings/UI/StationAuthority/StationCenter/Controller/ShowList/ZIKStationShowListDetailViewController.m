 //
//  ZIKStationShowListDetailViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/13.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationShowListDetailViewController.h"
/*****工具******/
#import "HttpClient.h"
#import "YYModel.h"//类型转换
#import "MJRefresh.h"//MJ刷新
#import "ZIKFunction.h"
#import "UIDefines.h"
/*****工具******/

#import "ZIKShaiDanDetailModel.h"
#import "ZIKShaiDanDetailPingLunModel.h"
#import "ZIKShaiDanDetailFirstTableViewCell.h"
#import "ZIKShaidanDetailPingZanTableViewCell.h"
#import "ZIKShaiDanDetailPinglunHeadFooterView.h"
#import "ZIKShaiDanDetaiPingLunTableViewCell.h"

#import "ZIKAddShaiDanViewController.h"//编辑页面
static NSString *SectionHeaderViewIdentifier = @"MiaoQiCenterSectionHeaderViewIdentifier";

@interface ZIKStationShowListDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (nonatomic, assign) NSInteger      page;            //页数从1开始
@property (nonatomic, strong) NSMutableArray *pingData;
@property (nonatomic, strong) ZIKShaiDanDetailModel *shaiModel;
@end

@implementation ZIKStationShowListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self requestData];
}

- (void)initData {
    self.page = 1;
    self.pingData = [NSMutableArray array];
}

- (void)initUI {
    self.vcTitle = @"晒单详情";
    self.leftBarBtnImgString = @"BackBtn";
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    self.detailTableView.separatorStyle = UITableViewCellSelectionStyleNone;

    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ZIKShaiDanDetailPinglunHeadFooterView" bundle:nil];
    [self.detailTableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
}


- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.detailTableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestMyQuoteList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.detailTableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestMyQuoteList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.detailTableView headerBeginRefreshing];
}

- (void)requestMyQuoteList:(NSString *)page {
    [self.detailTableView headerEndRefreshing];
    [HTTPCLIENT workstationShaiDanDetailWithUid:_uid pageNumber:page pageSize:@"15" Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        }
        NSDictionary *result = responseObject[@"result"];
        NSDictionary *shaiDanDic = result[@"shaidan"];
        NSArray *pingLunListArray = result[@"pingLunList"];
        ZIKShaiDanDetailModel  *shaiModel = [ZIKShaiDanDetailModel yy_modelWithDictionary:shaiDanDic];
        shaiModel.num = 0;
        self.shaiModel = shaiModel;
        if ([shaiModel.memberUid isEqualToString:APPDELEGATE.userModel.access_id]) {
            self.rightBarBtnTitleString = @"编辑";
            __weak typeof(self) weakSelf = self;//解决循环引用的问题

            self.rightBarBtnBlock = ^{
                ZIKAddShaiDanViewController *shaidanVC = [[ZIKAddShaiDanViewController alloc] initWithNibName:@"ZIKAddShaiDanViewController" bundle:nil];
                [weakSelf.navigationController pushViewController:shaidanVC animated:YES];
            };
        }

        if (self.page == 1 && pingLunListArray.count == 0) {
//            [ToastView showTopToast:@"暂无评论"];
            [self.detailTableView footerEndRefreshing];
            if(self.pingData.count > 0 ) {
                [self.pingData removeAllObjects];
            }
            [self.detailTableView reloadData];
            return ;
        } else if (pingLunListArray.count == 0 && self.page > 1) {
            [ToastView showTopToast:@"已无更多信息"];
            self.page--;
            [self.detailTableView footerEndRefreshing];
            return;
        } else {
            if (self.page == 1) {
                [self.pingData removeAllObjects];
            }
            [pingLunListArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKShaiDanDetailPingLunModel *pingModel = [ZIKShaiDanDetailPingLunModel yy_modelWithDictionary:dic];
                [self.pingData addObject:pingModel];
            }];
            if (self.page == 1) {
                [self.detailTableView reloadData];
            } else {

            }
            [self.detailTableView footerEndRefreshing];
        }

//        if (self.page == 1 && self.pingData.count > 0) {
//            [self.pingData removeAllObjects];
//        } else if (self.page > 0 && self.pingData.count == 0 ) {
//            [ToastView showTopToast:@"已无更多数据"];
//        }

    } failure:^(NSError *error) {
        ;
    }];
}


#pragma mark - tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.detailTableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
        self.detailTableView.estimatedRowHeight = 160;
        return tableView.rowHeight;
    }
    if (indexPath.section == 1) {
        return 40;
    }
    if (indexPath.section == 2) {
        self.detailTableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
        self.detailTableView.estimatedRowHeight = 90;
        return tableView.rowHeight;

    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        if (self.pingData.count > 0) {
            return 30;
        }
        return 0;
    }
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return self.pingData.count;
    }
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZIKShaiDanDetailFirstTableViewCell *cell = [ZIKShaiDanDetailFirstTableViewCell cellWithTableView:tableView];
        [cell configureCell:_shaiModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 1) {
        ZIKShaidanDetailPingZanTableViewCell *cell = [ZIKShaidanDetailPingZanTableViewCell cellWithTableView:tableView];
        [cell configureCell:_shaiModel];
        __weak typeof(self) weakSelf = self;//解决循环引用的问题
        cell.zanButtonBlock = ^{
//            if ([ZIKFunction xfunc_check_strEmpty:weakSelf.shaiModel.dianZanUid]) {
//                CLog(@"取消点赞");
//            } else {
//                CLog(@"点赞");
//            }
            [weakSelf dianzan:weakSelf.shaiModel.dianZanUid];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 2) {
        ZIKShaiDanDetaiPingLunTableViewCell *cell = [ZIKShaiDanDetaiPingLunTableViewCell cellWithTableView: tableView];
        if (self.pingData.count > 0) {
            ZIKShaiDanDetailPingLunModel *pingModel = self.pingData[indexPath.row];
            [cell configureCell:pingModel];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
////    ZIKShaiDanModel *model = self.shaiData[indexPath.row];
////    ZIKStationShowListDetailViewController *detailVC = [[ZIKStationShowListDetailViewController alloc] initWithNibName:@"ZIKStationShowListDetailViewController" bundle:nil];
////    detailVC.uid = model.uid;
////    [self.navigationController pushViewController:detailVC animated:YES];
////    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        ZIKShaiDanDetailPinglunHeadFooterView *sectionHeaderView = [self.detailTableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
//        if (self.miaoModel) {
//            [sectionHeaderView configWithModel:self.miaoModel];
//        }
        return sectionHeaderView;
    }
    return nil;
}


#pragma mark -点赞-取消点赞
- (void)dianzan:(NSString *)dianZanUid {
  //点赞ID，不传时，表示点赞，传入时，表示取消点赞
  [HTTPCLIENT workStationShaiDaDianzanWithShaiDanUid:_uid dianZanUid:dianZanUid Success:^(id responseObject) {
      if ([responseObject[@"success"] integerValue] == 0) {
          [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
          return ;
      }
      NSDictionary *result = responseObject[@"result"];
      NSString *uid = result[@"uid"];
      if (dianZanUid) {
          [ToastView showTopToast:@"取消成功"];
          self.shaiModel.dianZanUid = nil;
          self.shaiModel.num = 2;
      } else {
          [ToastView showTopToast:@"点赞成功"];
          self.shaiModel.dianZanUid = uid;
          self.shaiModel.num = 1;
      }
      //一个section刷新
      NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
      [self.detailTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
  } failure:^(NSError *error) {
      ;
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
