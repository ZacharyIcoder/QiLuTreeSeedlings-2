//
//  ZIKOrderViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKOrderViewController.h"

/*****工具******/
#import "HttpClient.h"
#import "YYModel.h"//类型转换
#import "MJRefresh.h"//MJ刷新
#import "UIDefines.h"
#import "JSONKit.h"
/*****工具******/

/*****Model******/
/*****Model******/

/*****View******/
#import "AdvertView.h"//广告页 section（0）
#import "BigImageViewShowView.h"//点击显示大图
#import "ZIKOrderSecondTableViewCell.h"//筛选cell section（1）
#import "ZIKStationOrderScreeningView.h"//筛选页面
#import "ZIKStationOrderTableViewCell.h"//工程订单cell  section（2）

#import "ZIKCityListViewController.h"
#import "GetCityDao.h"
#import "CityModel.h"
#import "ZIKCityModel.h"


/*****View******/

/*****Controller******/
#import "ZIKStationOrderDetailViewController.h"//订单详情界面
/*****Controller******/

/*****宏定义******/

@interface ZIKOrderViewController ()<UITableViewDataSource,UITableViewDelegate,AdvertDelegate,ZIKCityListViewControllerDelegate,ZIKStationOrderScreeningViewDelegate>
@property (nonatomic, weak)  UITableView     *orderTV;//工程订单Tableview
@property (nonatomic, assign) NSInteger      page;            //页数从1开始
@property (nonatomic, strong) NSMutableArray *orderMArr;//我的订单数组
@property (nonatomic, strong) BigImageViewShowView         *bigImageViewShowView;
@property (nonatomic, strong) ZIKStationOrderScreeningView *screenView;

@property (nonatomic, strong) NSMutableArray *citys;
@property (nonatomic, strong) NSString       *citysStr;//地址的code string “，，”
@property (nonatomic) SelectStyle selectStyle;
//*  @param orderBy      排序，发布时间：orderDate,截止日期：endDate,默认orderDate
//*  @param orderSort    排序，升序：asc,降序：desc,默认desc
//*  @param status       0:已结束，1：报价中，2：已报价
//*  @param orderTypeUid 订单类型ID
//*  @param area         用苗地，Json格式， [{"provinceCode":"11", "cityCode":"110101"},{"provinceCode":"11", "cityCode":"110102"}]

@property (nonatomic, strong) NSString *orderBy;
@property (nonatomic, strong) NSString *orderSort;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *ordetTypeUid;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSMutableArray *areaMArr;
@end

@implementation ZIKOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    //[self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (self.screenView) {
        self.screenView.hidden = NO;
    }
}

- (void)initData {
    self.page           = 1;//页面page从1开始
    self.bigImageViewShowView = [[BigImageViewShowView alloc] initWithNomalImageAry:@[@"bangde1.jpg",@"bangde2.jpg",@"bangde3.jpg",@"bangde4.jpg"]];
    self.areaMArr = [NSMutableArray arrayWithCapacity:5];
}

- (void)initUI {
    self.leftBarBtnTitleString = @"苗信通";
    self.leftBarBtnBlock = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKBackHome" object:nil];
    };
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-44) style:UITableViewStylePlain];
    tableView.delegate   = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.orderTV = tableView;
}

#pragma mark - 请求数据
- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.orderTV addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestMyOrderList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.orderTV addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestMyOrderList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.orderTV headerBeginRefreshing];


}

#pragma mark - 请求我的供应列表信息
- (void)requestMyOrderList:(NSString *)page {
    //我的供应列表
    [self.orderTV headerEndRefreshing];
    [HTTPCLIENT stationGetOrderSearchWithOrderBy:@"order_date" orderSort:@"desc" status:self.status orderTypeUid:self.ordetTypeUid area:self.area pageNumber:page pageSize:@"15" Success:^(id responseObject) {
        CLog(@"result:%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
        }

        ;
    } failure:^(NSError *error) {
        CLog(@"%@",error);
    }];

};

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 160.f/320.f*kWidth;
    } else if (indexPath.section == 1) {
        return 35;
    }
    return 180;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    }
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AdvertView *adView = [[AdvertView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 160.f/320.f*kWidth)];
        adView.delegate = self;
        [adView setAdInfo];
        [adView adStart];
        return adView;
    } else if (indexPath.section == 1) {
        ZIKOrderSecondTableViewCell *cell = [ZIKOrderSecondTableViewCell cellWithTableView:tableView];
        [cell.screeningButton addTarget:self action:@selector(screeningBtnClick) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    ZIKStationOrderTableViewCell *cell = [ZIKStationOrderTableViewCell cellWithTableView:tableView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKStationOrderDetailViewController *orderDetailVC = [[ZIKStationOrderDetailViewController alloc] init];
    orderDetailVC.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)screeningBtnClick {
    [self showSideView];
}

- (void)showSideView {

    [HTTPCLIENT stationGetOrderTypeSuccess:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        } else {
            // CLog(@"%@",responseObject[@"orderType"]);
            NSDictionary *orderTypeDic = responseObject[@"result"];
            CLog(@"%@",orderTypeDic);

            NSString *typeName = [orderTypeDic[@"orderType"] objectForKey:@"lxName"];
            NSArray *typeArr = [orderTypeDic[@"orderType"] objectForKey:@"zidianList"];
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            if (!self.screenView) {
                self.screenView = [[ZIKStationOrderScreeningView alloc] init];//WithFrame:CGRectMake(Width, 0, Width, Height)];
                self.screenView.orderTypeName = typeName;
                self.screenView.orderTypeArr = typeArr;
                self.screenView.delegate = self;
            }
            [UIView animateWithDuration:.3 animations:^{
                self.screenView.frame = CGRectMake(0, 0, Width, Height);
            }];
            [[[UIApplication sharedApplication] keyWindow] addSubview:_screenView];
        }
    } failure:^(NSError *error) {
        ;
    }];


//    [self.view addSubview:self.screenView];
}

-(void)screeningBtnClickSendOrderStateInfo:(NSString *)orderState orderTypeInfo:(NSString *)orderType orderAddressInfo:(NSString *)orderAddress {
    CLog(@"orderState:%@,orderType:%@,orderAddress:%@",orderState,orderType,orderAddress);
    self.status = orderState;
    self.ordetTypeUid = orderType;
    self.area = [self.areaMArr JSONString];
    [self requestMyOrderList:@"1"];

}
-(void)StationOrderScreeningbackBtnAction {

}
#pragma mark ----- AdvertDelegate广告页面点击
//广告页面点击
-(void)advertPush:(NSInteger)index
{
    [self.bigImageViewShowView showInKeyWindowWithIndex:index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addressSelectLabelAction {
    ZIKCityListViewController *cityVC = [[ZIKCityListViewController alloc] init];
    cityVC.hidesBottomBarWhenPushed = YES;
    self.screenView.hidden = YES;
    cityVC.selectStyle = SelectStyleMultiSelect;
    self.selectStyle = SelectStyleMultiSelect;
    cityVC.delegate = self;
    [self.navigationController pushViewController:cityVC animated:YES];
//    [self presentViewController:cityVC animated:YES completion:^{
//
//    }];
    cityVC.citys = self.citys;
}

#pragma mark - 确定返回后，传回地址执行协议
- (void)selectCitysInfo:(NSString *)citysStr {
    self.screenView.hidden = NO;
    _citysStr = citysStr;
    if (self.areaMArr.count > 0) {
        [self.areaMArr removeAllObjects];
    }
    GetCityDao *citydao = [GetCityDao new];
    [citydao openDataBase];
    __block NSString *str = @"";
    NSArray *cityArray = [_citysStr componentsSeparatedByString:@","];
    [cityArray enumerateObjectsUsingBlock:^(NSString *cityCode, NSUInteger idx, BOOL * _Nonnull stop) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[citydao getCityNameByCityUid:cityCode]]];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
        //{"provinceCode":"11", "cityCode":"110101"}
        dic[@"provinceCode"] = [citydao getCityParentCode:cityCode];
        dic[@"cityCode"]     = cityCode;
        [self.areaMArr addObject:dic];
    }];
    [citydao closeDataBase];
    CLog(@"%@",self.areaMArr);
    self.screenView.orderAddressSelectLabel.text = [str substringToIndex:str.length-1];
}

- (IBAction)selectBtnClick:(id)sender {
    //self.citys = nil;
    ZIKCityListViewController *cityVC = [[ZIKCityListViewController alloc] init];
    cityVC.selectStyle = SelectStyleMultiSelect;
    self.selectStyle = SelectStyleMultiSelect;
    cityVC.delegate = self;
    //    [self.navigationController pushViewController:cityVC animated:YES];
    cityVC.citys = self.citys;
}

- (NSArray *)citys {
    //if (_citys == nil) {
    _citys = [[NSMutableArray alloc] init];
    GetCityDao *dao = [[GetCityDao alloc] init];
    [dao openDataBase];
    NSArray *allProvince = [dao getCityByLeve:@"1"];
    [allProvince enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        ZIKCityModel *cityModel = [ZIKCityModel initCityModelWithDic:dic];
        //             cityModel.province.citys = [dao getCityByLeve:@"2" andParent_code:cityModel.province.code];
        NSMutableArray *cityMArr = [dao getCityByLeve:@"2" andParent_code:cityModel.province.code];


        NSMutableDictionary *dicionary = [NSMutableDictionary dictionary];
        [dicionary setObject:cityModel.province.provinceID forKey:@"id"];
        [dicionary setObject:cityModel.province.code forKey:@"code"];
        [dicionary setObject:cityModel.province.parent_code forKey:@"parent_code"];
        [dicionary setObject:@"全省" forKey:@"name"];
        [dicionary setObject:cityModel.province.level forKey:@"level"];
        [cityMArr insertObject:dicionary atIndex:0];
        cityModel.province.citys = cityMArr;

        [_citys addObject:cityModel];

    }];
    //self.dataAry = [CityModel creatCityAryByAry:allTown];
    [dao closeDataBase];
    if (![self.screenView.orderAddress isEqualToString:@"请选择地址"]) {
        NSArray *cityArray = [_citysStr componentsSeparatedByString:@","];
        __block NSInteger numcount = 0;
        [_citys enumerateObjectsUsingBlock:^(ZIKCityModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            [model.province.citys enumerateObjectsUsingBlock:^(NSMutableDictionary *cityDic, NSUInteger idx, BOOL * _Nonnull stop) {
                [cityArray enumerateObjectsUsingBlock:^(NSString *cityCode, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([cityDic[@"code"] isEqualToString:cityCode]) {
                        cityDic[@"select"] = @"1";
                        if (++numcount == cityArray.count) {
                            *stop = YES;
                        }
                    }
                }];
            }];
        }];
    }
    
    //}
    return _citys;
}

@end
