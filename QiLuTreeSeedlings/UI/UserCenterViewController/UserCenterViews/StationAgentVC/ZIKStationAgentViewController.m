//
//  ZIKStationAgentViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/13.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKStationAgentViewController.h"
#import "PickerLocation.h"
#import "ZIKStationAgentTableViewCell.h"
#import "ZIKStationAgentModel.h"
#import "YYModel.h"
#import "MJRefresh.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#import "ZIKFunction.h"
#import "HttpClient.h"
#define titleFont [UIFont systemFontOfSize:21]
@interface ZIKStationAgentViewController ()<PickerLocationDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UILabel *areaLabel;
    UILabel *titleLab;
}
/**
 *  视图标题
 */
@property (nonatomic, strong) NSString *vcTitle;
@property (nonatomic,copy   ) NSString       *areaCode;
@property (nonatomic, assign) NSInteger      page;//页数从1开始
@property (nonatomic, strong) NSMutableArray *stationInfoMArr;//站长信息数组
@property (nonatomic, strong) UITableView    *stationTableView;//站长TV
@property (nonatomic,strong ) PickerLocation *pickerLocation;
@end

@implementation ZIKStationAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"站长通";
    [self.view addSubview:[self makeNavView]];
    [self initData];
    [self initUI];
    [self requestData];
    //[self requestSellList:nil];


}

-(UIView *)makeNavView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:0 right:15 bottom:0 left:3];
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width-45, 27, 30, 30)];
    [rightBtn setImage:[UIImage imageNamed:@"screenBtnAction"] forState:UIControlStateNormal];
    [rightBtn setEnlargeEdgeWithTop:0 right:15 bottom:0 left:3];
    [view addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(pickLocationAction) forControlEvents:UIControlEventTouchUpInside];


    titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80,26, 160, 30)];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    //[titleLab setText:self.vcTitle];
    titleLab.text = self.vcTitle;
    [titleLab setFont:titleFont];
    [view addSubview:titleLab];
    return view;
}

-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData {
    [self requestSellList:[NSString stringWithFormat:@"%ld",(long)self.page]];
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.stationTableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.stationTableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];

}

- (void)initUI {//
    UIView *areaView = [[UIView alloc] init];
    areaView.frame = CGRectMake(0, 64, Width, 44);
    [self.view addSubview:areaView];
    areaView.userInteractionEnabled = YES;
    areaView.backgroundColor = [UIColor whiteColor];

    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickLocationAction)];
    [areaView addGestureRecognizer:tapGR];


    UILabel *hintlabel = [[UILabel alloc] init];
    hintlabel.frame = CGRectMake(15, 12, 95, 20);
    hintlabel.text = @"您选择的地区:";
    hintlabel.textColor = titleLabColor;
    hintlabel.font = [UIFont systemFontOfSize:15.0f];
    [areaView addSubview:hintlabel];

    areaLabel = [[UILabel alloc] init];
    areaLabel.frame = CGRectMake(105+15+5, 12, Width-125, 20);
    areaLabel.text = @"全国";
    areaLabel.textColor = titleLabColor;
    [areaView addSubview:areaLabel];

    self.stationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(areaView.frame)+1, Width, Height-64-44-1) style:UITableViewStylePlain];
    self.stationTableView.delegate   = self;
    self.stationTableView.dataSource = self;
    [self.view addSubview:self.stationTableView];
    [ZIKFunction setExtraCellLineHidden:self.stationTableView];

}

- (void)requestSellList:(NSString *)page {
    //我的供应列表
    [self.stationTableView headerEndRefreshing];
    [HTTPCLIENT getWrokStationListWithToken:nil WithAccessID:nil WithClientID:nil WithClientSecret:nil WithDeviceID:nil WithWorkstationUId:nil WithAreaCode:self.areaCode WithPage:page WithPageSize:@"15" Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
            return ;
        }
        NSArray *array = [responseObject objectForKey:@"result"];
        if (array.count == 0 && self.page == 1) {
            [self.stationInfoMArr removeAllObjects];
            [self.stationTableView footerEndRefreshing];
            [self.stationTableView reloadData];
            [ToastView showToast:@"暂无数据" withOriginY:200 withSuperView:self.view];
            return ;
        }
        else if (array.count == 0 && self.page > 1) {
            self.page--;
            [self.stationTableView footerEndRefreshing];
            //没有更多数据了
            [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
            return;
        }
        else {
            if (self.page == 1) {
                [self.stationInfoMArr removeAllObjects];
            }
            [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKStationAgentModel *model = [ZIKStationAgentModel yy_modelWithDictionary:dic];
                [self.stationInfoMArr addObject:model];
            }];
            [self.stationTableView reloadData];
            [self.stationTableView footerEndRefreshing];
        }

    } failure:^(NSError *error) {

    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 186;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.stationInfoMArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKStationAgentTableViewCell *cell = [ZIKStationAgentTableViewCell cellWithTableView:tableView];
    if (self.stationInfoMArr.count > 0) {
        ZIKStationAgentModel *model = self.stationInfoMArr[indexPath.section];
        [cell configureCell:model];
        cell.section = indexPath.section;
        __weak typeof(self) weakSelf = self;
        cell.phoneBlock = ^(NSInteger section){
           // NSLog(@"拨打电话");
            NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",model.phone];
            //NSLog(@"%@",str);
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [weakSelf.view addSubview:callWebview];
            
        };
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pickLocationAction
{
    if (!self.pickerLocation) {
        self.pickerLocation = [[PickerLocation alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.pickerLocation.locationDelegate = self;
    }
    [self.pickerLocation showInView];
}

-(void)selectedLocationInfo:(Province *)location
{
    NSMutableString *namestr=[NSMutableString new];
    if (location.code) {
        [namestr appendString:location.provinceName];
        self.areaCode=location.code;
    }
    else {
        self.areaCode = nil;
        areaLabel.text = @"全国";
    }

    if (location.selectedCity.code) {
        [namestr appendString:location.selectedCity.cityName];
        self.areaCode=location.selectedCity.code;
    }
    if (location.selectedCity.selectedTowns.code) {
        [namestr appendString:location.selectedCity.selectedTowns.TownName];
        self.areaCode=location.selectedCity.selectedTowns.code;
    }
    if (namestr.length>0) {
        areaLabel.text = namestr;
    }

    [self.stationTableView headerBeginRefreshing];

}

- (void)initData {
    self.page = 1;
    self.stationInfoMArr = [NSMutableArray array];
}

@end
