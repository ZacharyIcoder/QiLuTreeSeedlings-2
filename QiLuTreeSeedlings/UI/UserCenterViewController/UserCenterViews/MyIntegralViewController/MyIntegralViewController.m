//
//  MyIntegralViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/4/6.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "MyIntegralViewController.h"
#import "MJRefresh.h"
#import "YYModel.h"
#import "ZIKIntegraModel.h"
#import "ZIKIntegraTableViewCell.h"
@interface MyIntegralViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong ) UILabel        *zongjifenLab;
@property (nonatomic,strong ) UITableView    *integralTableView;
@property (nonatomic,assign ) NSInteger      pamgeNum;
@property (nonatomic,strong ) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger      page;//页数从1开始

@end

@implementation MyIntegralViewController
@synthesize pamgeNum;

-(void)viewWillAppear:(BOOL)animated
{

    //[self getDataList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"我的积分";
    [self initData];
    [self initUI];
    [self requestData];
}

- (void)initData {
    self.page = 1;
    self.dataArray = [NSMutableArray array];
}

- (void)initUI {
    UIView *zongjifenView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 100)];
    [zongjifenView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:zongjifenView];
    UILabel *labxx = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, kWidth, 20)];
    [labxx setTextAlignment:NSTextAlignmentCenter];
    [labxx setTextColor:titleLabColor];
    [labxx setFont:[UIFont systemFontOfSize:18]];
    [labxx setText:@"总积分"];
    labxx.textColor = titleLabColor;
    [zongjifenView addSubview:labxx];
    UILabel *zongjifenLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, kWidth, 30)];
    [zongjifenLab setFont:[UIFont systemFontOfSize:30]];
    [zongjifenLab setTextColor:yellowButtonColor];
    [zongjifenLab setText:@"0"];
    [zongjifenLab setTextAlignment:NSTextAlignmentCenter];
    [zongjifenView addSubview:zongjifenLab];
    self.zongjifenLab      = zongjifenLab;
    UITableView *tableView = [[ UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(zongjifenView.frame), kWidth, kHeight-64-100) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.delegate     = self;
    tableView.dataSource   = self;
    self.integralTableView = tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKIntegraTableViewCell *cell = [ZIKIntegraTableViewCell cellWithTableView:tableView];
    [cell configureCell:self.dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {
    [self requestSellList:[NSString stringWithFormat:@"%ld",(long)self.page]];
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.integralTableView addHeaderWithCallback:^{
        [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.integralTableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
}

- (void)requestSellList:(NSString *)page {
    NSLog(@"page:%@",page);
    //我的消费列表
    [self.integralTableView headerEndRefreshing];
    HttpClient *httpClient = [HttpClient sharedClient];
    [httpClient getMyIntegralListWithPageNumber:page Success:^(id responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        [self.zongjifenLab setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"sumscore"]]];
        NSArray *array = [dic objectForKey:@"record"];
        if (array.count == 0 && self.page == 1) {
            [self.dataArray removeAllObjects];
            [self.integralTableView footerEndRefreshing];
            return ;
        }
        else if (array.count == 0 && self.page > 1) {
            self.page--;
            [self.integralTableView footerEndRefreshing];
            //没有更多数据了
            [ToastView showToast:@"没有更多数据了" withOriginY:Width/2 withSuperView:self.view];
            return;
        }
        else {
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKIntegraModel *model = [ZIKIntegraModel yy_modelWithDictionary:dic];
                [self.dataArray addObject:model];
            }];
            [self.integralTableView reloadData];
            [self.integralTableView footerEndRefreshing];
        }

    } failure:^(NSError *error) {

    }];
}

@end
