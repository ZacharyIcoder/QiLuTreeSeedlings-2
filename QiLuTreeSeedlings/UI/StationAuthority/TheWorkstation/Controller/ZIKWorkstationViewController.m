//
//  ZIKWorkstationViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKWorkstationViewController.h"
#import "ZIKSelectMenuView.h"
#import "ZIKWorkstationTableViewCell.h"
#import "ZIKWorkstationSelectView.h"
#import "ZIKWorkstationSelectListView.h"
#import "GetCityDao.h"
#import "YYModel.h"//类型转换
#import "MJRefresh.h"//MJ刷新
#import "UIDefines.h"
#import "HttpClient.h"
#import "ZIKMyTeamModel.h"
#import "YLDZhanZhangMessageViewController.h"//工作站详情
@interface ZIKWorkstationViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,ZIKWorkstationSelectViewDelegate>
@property (nonatomic, strong) UITableView *orderTableView;

@property (nonatomic, strong) ZIKWorkstationSelectView *selectAreaView;
@property (nonatomic, strong) NSString *province;//省
@property (nonatomic, strong) NSString *city;    //市
@property (nonatomic, strong) NSString *county;  //县

@property (nonatomic, strong) ZIKWorkstationSelectListView *selectListView;

@property (nonatomic, assign) NSInteger      page;            //页数从1开始
@property (nonatomic, strong) NSMutableArray *stationMArr;//我的订单数组


@end

@implementation ZIKWorkstationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //    self.leftBarBtnImgString = @"BackBtn";
    if (self.navigationController.childViewControllers.count>1) {
        self.vcTitle = @"工作站";
        self.leftBarBtnImgString = @"BackBtn";
    }else{
      self.leftBarBtnTitleString = @"苗信通";
    }
    self.stationMArr = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.leftBarBtnBlock = ^{
        [weakSelf backBtnAction:nil];
    };

    self.searchBarView.placeHolder = @"请输入工作站名称、电话、联系人";
    self.searchBarView.searchBlock = ^(NSString *searchText){
        CLog(@"%@",searchText);
        weakSelf.isSearch = !weakSelf.isSearch;
    };
    self.searchBarView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.searchBarView.textField];

    [self initUI];
    [self requestData];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.orderTableView headerBeginRefreshing];
}

- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.orderTableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestMyOrderList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.orderTableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestMyOrderList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.orderTableView headerBeginRefreshing];
}

#pragma mark - 请求工程订单列表信息
- (void)requestMyOrderList:(NSString *)page {
    //我的供应列表
    [self.orderTableView headerEndRefreshing];
    [HTTPCLIENT stationListWithProvince:nil city:nil county:nil keyword:nil pageNumber:page pageSize:@"15" Success:^(id responseObject) {
        CLog(@"result:%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        } else {
            NSDictionary *resultDic = responseObject[@"result"];
            NSArray *orderListArr   = resultDic[@"list"];
            if (self.page == 1 && orderListArr.count == 0) {
                [ToastView showTopToast:@"已无更多信息"];
                [self.orderTableView footerEndRefreshing];
                if(self.stationMArr.count > 0 ) {
                    [self.stationMArr removeAllObjects];
                }
                return ;
            } else if (orderListArr.count == 0 && self.page > 1) {
                [ToastView showTopToast:@"已无更多信息"];
                self.page--;
                [self.orderTableView footerEndRefreshing];
                return;
            } else {
                if (self.page == 1) {
                    [self.stationMArr removeAllObjects];
                }

                [orderListArr enumerateObjectsUsingBlock:^(NSDictionary *orderDic, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZIKMyTeamModel *model = [ZIKMyTeamModel yy_modelWithDictionary:orderDic];
//                    [model initStatusType];
                    [self.stationMArr addObject:model];
                }];
                //                //一个section刷新
                //                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
                //                [self.orderTV reloadSections:indexSet withRowAnimation:UITableViewRowAnimationBottom];
                [self.orderTableView reloadData];

                [self.orderTableView footerEndRefreshing];

            }
        }
        
    } failure:^(NSError *error) {
        //CLog(@"%@",error);
    }];
    
};

- (void)initUI {
    self.selectAreaView = [ZIKWorkstationSelectView instanceSelectAreaView];
    self.selectAreaView.delegate = self;
    [self.view addSubview:self.selectAreaView];
    self.selectAreaView.frame = CGRectMake(0, 64, kWidth, 44);
    CGRect frame;
    if (self.navigationController.childViewControllers.count>1) {
        frame=CGRectMake(0, 64+44, kWidth, kHeight-64-44);
    }else{
        frame=CGRectMake(0, 64+44, kWidth, kHeight-64-44-44);
    }
    UITableView *orderTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    orderTableView.dataSource = self;
    orderTableView.delegate = self;
    [self.view addSubview:orderTableView];
    self.orderTableView = orderTableView;
}

-(void)didSelector:(NSString *)selectId title:(NSString *)selectTitle {
    if (!self.selectListView) {
        self.selectListView = [ZIKWorkstationSelectListView instanceSelectListView];
    }
    [self.view addSubview:self.selectListView];
    self.selectListView.frame = CGRectMake(0, 64+44+4, kWidth, kHeight-64-44-4);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.stationMArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    self.orderTableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
//    self.orderTableView.estimatedRowHeight = 90;////必须设置好预估值
//    return tableView.rowHeight;
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKWorkstationTableViewCell *cell = [ZIKWorkstationTableViewCell cellWithTableView:tableView];
    if (self.stationMArr.count > 0) {
        ZIKMyTeamModel *model = self.stationMArr[indexPath.section];
        [cell configureCell:model];
    }
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.stationMArr.count > 0) {
        ZIKMyTeamModel *model = self.stationMArr[indexPath.section];
        YLDZhanZhangMessageViewController *detailVC = [[YLDZhanZhangMessageViewController
                                                        alloc] initWithUid:model.uid];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ------textField delegate --------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.isSearch = NO;//搜索栏隐藏
    //NSString *searchText = textField.text;
    //CLog(@"searchText:%@",searchText);
    return YES;
}

-(void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    CLog(@"textField:%@",textField.text);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnAction:(UIButton *)sender
{
    if (self.navigationController.childViewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKBackHome" object:nil];
    }

}

//获取到 第一个分类数据下拉菜单的模型数组
- (NSArray *)getData{
    GetCityDao *dao = [[GetCityDao alloc] init];
    [dao openDataBase];
    NSArray *allProvince = [dao getCityByLeve:@"1"];
    [dao closeDataBase];
    return allProvince;
}

//- (NSArray *)citys {
//    //if (_citys == nil) {
//    _citys = [[NSMutableArray alloc] init];
//    GetCityDao *dao = [[GetCityDao alloc] init];
//    [dao openDataBase];
//    NSArray *allProvince = [dao getCityByLeve:@"1"];
//    [allProvince enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
//        ZIKCityModel *cityModel = [ZIKCityModel initCityModelWithDic:dic];
//        //             cityModel.province.citys = [dao getCityByLeve:@"2" andParent_code:cityModel.province.code];
//        NSMutableArray *cityMArr = [dao getCityByLeve:@"2" andParent_code:cityModel.province.code];
//
//
//        NSMutableDictionary *dicionary = [NSMutableDictionary dictionary];
//        [dicionary setObject:cityModel.province.provinceID forKey:@"id"];
//        [dicionary setObject:cityModel.province.code forKey:@"code"];
//        [dicionary setObject:cityModel.province.parent_code forKey:@"parent_code"];
//        [dicionary setObject:@"全省" forKey:@"name"];
//        [dicionary setObject:cityModel.province.level forKey:@"level"];
//        [cityMArr insertObject:dicionary atIndex:0];
//        cityModel.province.citys = cityMArr;
//
//        [_citys addObject:cityModel];
//
//    }];
//    //self.dataAry = [CityModel creatCityAryByAry:allTown];
//    [dao closeDataBase];
//    if (![[self.selectBtn currentTitle] isEqualToString:@"选择地址"]) {
//        NSArray *cityArray = [_citysStr componentsSeparatedByString:@","];
//        __block NSInteger numcount = 0;
//        [_citys enumerateObjectsUsingBlock:^(ZIKCityModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
//            [model.province.citys enumerateObjectsUsingBlock:^(NSMutableDictionary *cityDic, NSUInteger idx, BOOL * _Nonnull stop) {
//                [cityArray enumerateObjectsUsingBlock:^(NSString *cityCode, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if ([cityDic[@"code"] isEqualToString:cityCode]) {
//                        cityDic[@"select"] = @"1";
//                        if (++numcount == cityArray.count) {
//                            *stop = YES;
//                        }
//                    }
//                }];
//            }];
//        }];
//    }
//
//    //}
//    return _citys;
//}
//


@end
