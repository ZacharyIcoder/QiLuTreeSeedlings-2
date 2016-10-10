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
#import "KMJRefresh.h"//MJ刷新
#import "UIDefines.h"
#import "HttpClient.h"
#import "ZIKMyTeamModel.h"
#import "YLDZhanZhangMessageViewController.h"//工作站详情
#import "ZIKFunction.h"

#import "AdvertView.h"
#import "BigImageViewShowView.h"

@interface ZIKWorkstationViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,ZIKWorkstationSelectViewDelegate,ZIKWorkstationSelectListViewDataSource,ZIKWorkstationSelectListViewDelegate,AdvertDelegate>
@property (nonatomic, strong) UITableView *orderTableView;

@property (nonatomic, strong) ZIKWorkstationSelectView *selectAreaView;
@property (nonatomic, strong) NSString *province;//省
@property (nonatomic, strong) NSString *city;    //市
@property (nonatomic, strong) NSString *county;  //县
@property (nonatomic, strong) NSString *level;

@property (nonatomic, strong) ZIKWorkstationSelectListView *selectListView;

@property (nonatomic, assign) NSInteger      page;            //页数从1开始
@property (nonatomic, strong) NSMutableArray *stationMArr;//我的订单数组

@property (nonatomic, strong) NSString *keyword;

@property (nonatomic,strong) BigImageViewShowView *bigImageViewShowView;
@end

@implementation ZIKWorkstationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //    self.leftBarBtnImgString = @"BackBtn";
    self.level = @"1";
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
    if (self.type==2) {
        [self.navView setBackgroundColor:NavYellowColor];
    }

    self.searchBarView.placeHolder = @"请输入工作站名称、电话、联系人";
    self.searchBarView.searchBlock = ^(NSString *searchText){
        CLog(@"%@",searchText);
        weakSelf.isSearch = !weakSelf.isSearch;
        weakSelf.keyword = searchText;
        weakSelf.page = 1;
        [weakSelf requestMyOrderList:@"1"];
    };
    self.searchBarView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.searchBarView.textField];

    self.bigImageViewShowView = [[BigImageViewShowView alloc]initWithNomalImageAry:@[@"bangde1.jpg",@"bangde2.jpg",@"bangde3.jpg",@"bangde4.jpg",@"bangde5.png"]];


    [self initUI];
    [self requestData];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.orderTableView headerBeginRefreshing];
}

- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
//    if (!weakSelf.isSearch) {
//        weakSelf.keyword = nil;
//    }
    [self.orderTableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        if (!weakSelf.isSearch) {
            weakSelf.keyword = nil;
        }
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
    //请求工程订单列表信息
    [self.orderTableView headerEndRefreshing];
    [HTTPCLIENT stationListWithProvince:_selectAreaView.provinceCode city:_selectAreaView.cityCode county:_selectAreaView.countryCode keyword:_keyword pageNumber:page pageSize:@"15" Success:^(id responseObject) {
        //CLog(@"result:%@",responseObject);
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
                [self.orderTableView reloadData];
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
                    [self.stationMArr addObject:model];
                }];
                 [self.orderTableView reloadData];

                [self.orderTableView footerEndRefreshing];

            }
        }
        
    } failure:^(NSError *error) {
        //CLog(@"%@",error);
    }];
    
};

- (void)initUI {
//    self.selectAreaView = [ZIKWorkstationSelectView instanceSelectAreaView];
//    self.selectAreaView.delegate = self;
//    [self.view addSubview:self.selectAreaView];
//    self.selectAreaView.frame = CGRectMake(0, 64, kWidth, 46);
    CGRect frame;
    if (self.navigationController.childViewControllers.count>1) {
        frame=CGRectMake(0, 64, kWidth, kHeight-64);
    }else{
        frame=CGRectMake(0, 64, kWidth, kHeight-64-44);
    }
    UITableView *orderTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    orderTableView.dataSource = self;
    orderTableView.delegate = self;
    [self.view addSubview:orderTableView];
    self.orderTableView = orderTableView;
    [ZIKFunction setExtraCellLineHidden:orderTableView];
}

-(void)didSelector:(NSString *)selectId title:(NSString *)selectTitle level:(NSString *)level {
    self.level = level;
    if (!self.selectListView) {
        self.selectListView = [ZIKWorkstationSelectListView instanceSelectListView];
    }
    self.selectListView.dataSource = self;
    self.selectListView.listdelegate = self;
    self.selectListView.isShow = !self.selectListView.isShow;
    [self.selectListView.selectAraeTableView reloadData];
    [self.view addSubview:self.selectListView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.stationMArr.count+2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.type==2) {
            return 0.01;
        }else
        {
          return 160.f/320.f*kWidth;  
        }
        
    }
    if (indexPath.section == 1) {
        return 46;
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 0.01f;
    }
    return 10.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0)
    {
        if (indexPath.row==0) {
            if (self.type==2) {
                UITableViewCell *cell=[[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 0.01, 0.01)];
                return cell;
            }else{
                AdvertView *adView=[[AdvertView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 160.f/320.f*kWidth)];
                adView.delegate=self;
                [adView setAdInfo];
                [adView adStart];
                return adView;
            }
           

        }
    }
    if (indexPath.section == 1) {
        static NSString *kSelectTableViewCellID = @"kSelectTableViewCellID";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectTableViewCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSelectTableViewCellID];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            if (!self.selectAreaView) {
                self.selectAreaView = [ZIKWorkstationSelectView instanceSelectAreaView];
                self.selectAreaView.delegate = self;
            }
        }
        [cell.contentView addSubview:self.selectAreaView];
        self.selectAreaView.frame = CGRectMake(0, 0, kWidth, 46);
        return cell;
    }

    ZIKWorkstationTableViewCell *cell = [ZIKWorkstationTableViewCell cellWithTableView:tableView];
    if (self.stationMArr.count > 0) {
        ZIKMyTeamModel *model = self.stationMArr[indexPath.section-2];
        [cell configureCell:model];
        cell.indexPath = indexPath;
        __weak typeof(self) weakSelf = self;
        cell.phoneButtonBlock = ^(NSIndexPath *indexPath){
            // NSLog(@"拨打电话");
            NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",model.phone];
            //NSLog(@"%@",str);
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [weakSelf.view addSubview:callWebview];

        };
    }
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return;
    }
    if (self.stationMArr.count > 0 && indexPath.section >1) {
        ZIKMyTeamModel *model = self.stationMArr[indexPath.section-2];
        YLDZhanZhangMessageViewController *detailVC = [[YLDZhanZhangMessageViewController
                                                        alloc] initWithUid:model.uid];
        if (self.navigationController.childViewControllers.count>1) {
            
        }else{
          detailVC.hidesBottomBarWhenPushed = YES;
        }
        
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
    self.keyword = textField.text;
//    - (void)requestMyOrderList:(NSString *)page
    self.page = 1;
    [self requestMyOrderList:@"1"];
    return YES;
}

-(void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    CLog(@"textField:%@",textField.text);
    self.keyword = textField.text;
    self.page = 1;
    [self requestMyOrderList:@"1"];
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
- (NSArray *)getDataWithLevel:(NSString *)level{
    GetCityDao *dao = [[GetCityDao alloc] init];
    [dao openDataBase];
    NSArray *allProvince = nil;
    if ([_level isEqualToString:@"1"]) {
        allProvince   = [dao getCityByLeve:@"1"];
    } else if ([_level isEqualToString:@"2"]) {
        allProvince = [dao getCityByLeve:@"2" andParent_code:_selectAreaView.provinceCode];
    } else if ([_level isEqualToString:@"3"]) {
        allProvince = [dao getCityByLeve:@"3" andParent_code:_selectAreaView.cityCode];
    }
    [dao closeDataBase];

    NSMutableArray *provinceMarr = [NSMutableArray arrayWithArray:allProvince];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"" forKey:@"id"];
    [dic setObject:@"" forKey:@"code"];
    [dic setObject:@"" forKey:@"parent_code"];
    if ([_level isEqualToString:@"1"]) {
        [dic setObject:@"全国" forKey:@"name"];
    } else if ([_level isEqualToString:@"2"]) {
         [dic setObject:@"所有市" forKey:@"name"];
    } else if ([_level isEqualToString:@"3"]) {
         [dic setObject:@"所有县(区)" forKey:@"name"];
    }
    [dic setObject:@"1" forKey:@"level"];
    if (provinceMarr.count>0) {
        [provinceMarr insertObject:dic atIndex:0];
    } else {
        [provinceMarr addObject:dic];
    }
    return provinceMarr;
}

-(NSInteger)numberOfRowsInfTable:(ZIKWorkstationSelectListView *)selectListView {
    return [self getDataWithLevel:_level].count;
}

- (NSString*)selectListView:(ZIKWorkstationSelectListView *)selectListView titleForRow:(NSInteger)row {
    return [[self getDataWithLevel:_level][row] objectForKey:@"name"];
}

- (NSString*)selectListView:(ZIKWorkstationSelectListView *)selectListView codeForRow:(NSInteger)row {
    return [[self getDataWithLevel:_level][row] objectForKey:@"code"];
}

- (void)didSelectRowAtIndexPath:(ZIKWorkstationSelectListView *)selectListView title:(NSString *)title coel:(NSString *)code{
    if ([_level isEqualToString:@"1"]) {
        self.selectAreaView.provinceName = title;
        self.selectAreaView.provinceCode = code;
    } else if ([_level isEqualToString:@"2"]) {
        self.selectAreaView.cityName = title;
        self.selectAreaView.cityCode = code;
    } else if ([_level isEqualToString:@"3"]) {
        self.selectAreaView.countryName = title;
        self.selectAreaView.countryCode = code;
    }

    self.page = 1;
    [self requestMyOrderList:[NSString stringWithFormat:@"%ld",(long)self.page]];

}

//广告页面点击
-(void)advertPush:(NSInteger)index
{
    [self.bigImageViewShowView showInKeyWindowWithIndex:index];
}


@end
