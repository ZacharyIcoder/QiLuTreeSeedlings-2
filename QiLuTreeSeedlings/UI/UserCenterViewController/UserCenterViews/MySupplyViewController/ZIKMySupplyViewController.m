//
//  ZIKMySupplyViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/22.
//  Copyright © 2016年 中亿信息技术. All rights reserved.
//
#import "ZIKMySupplyViewController.h"
#import "HttpClient.h"
#import "YYModel.h"
#import "ZIKSupplyModel.h"
#import "ZIKMySupplyTableViewCell.h"
#import "MJRefresh.h"
#import "ZIKSupplyPublishViewController.h"
#import "ZIKSupplyPublishVC.h"
#import "ZIKMySupplyDetailViewController.h"
@interface ZIKMySupplyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *emptyUI;
}
@property (nonatomic, assign) NSInteger      page;//页数从1开始
@property (nonatomic, strong) NSMutableArray *supplyInfoMArr;//供应信息数组
@property (nonatomic, strong) UITableView    *mySupplyTableView;//我的供应列表
@property (nonatomic, assign) BOOL           isCanPublish;//是否能够发布
@end

@implementation ZIKMySupplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNav];
    //[self initData];
    [self initUI];
    //[self requestData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self initData];
    [self requestData];
}

- (void)requestData {
    [self requestSupplyRestrict];
    [self requestSellList:[NSString stringWithFormat:@"%ld",self.page]];
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.mySupplyTableView addHeaderWithCallback:^{
        [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",weakSelf.page]];
    }];
    [self.mySupplyTableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",weakSelf.page]];
    }];

}

- (void)initUI {
    self.mySupplyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Height-64) style:UITableViewStylePlain];
    self.mySupplyTableView.delegate =self;
    self.mySupplyTableView.dataSource = self;
    [self.view addSubview:self.mySupplyTableView];
    [ZIKFunction setExtraCellLineHidden:self.mySupplyTableView];
    //self.mySupplyTableView.backgroundColor = [UIColor yellowColor];
}

- (void)requestSellList:(NSString *)page {
    //我的供应列表
     [self.mySupplyTableView headerEndRefreshing];
    HttpClient *httpClient = [HttpClient sharedClient];
    [httpClient getMysupplyListWithToken:nil withAccessId:nil withClientId:nil withClientSecret:nil withDeviewId:nil withPage:page withPageSize:@"15" success:^(id responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        //NSLog(@"%@",[responseObject objectForKey:@"msg"]);
        NSArray *array = dic[@"list"];
        if (array.count == 0 && self.page == 1) {
            [self.supplyInfoMArr removeAllObjects];
            [self.mySupplyTableView footerEndRefreshing];
            self.mySupplyTableView.hidden = YES;
            [self createEmptyUI];
            return ;
        }
        else if (array.count == 0 && self.page > 1) {
            self.mySupplyTableView.hidden = NO;
            emptyUI.hidden = YES;
            self.page--;
            [self.mySupplyTableView footerEndRefreshing];
            //没有更多数据了
            [ToastView showToast:@"没有更多数据了" withOriginY:Width/2 withSuperView:self.view];
            return;
        }
        else {
            self.mySupplyTableView.hidden = NO;
            emptyUI.hidden = YES;
            if (self.page == 1) {
                [self.supplyInfoMArr removeAllObjects];
            }
            [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKSupplyModel *model = [ZIKSupplyModel yy_modelWithDictionary:dic];
                [self.supplyInfoMArr addObject:model];
            }];
            [self.mySupplyTableView reloadData];
            [self.mySupplyTableView footerEndRefreshing];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.supplyInfoMArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//self.supplyInfoMArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kZIKMySupplyTableViewCellID = @"kZIKMySupplyTableViewCellID";
    ZIKMySupplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKMySupplyTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKMySupplyTableViewCell" owner:self options:nil] lastObject];
    }
    [cell configureCell:self.supplyInfoMArr[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKSupplyModel *model = self.supplyInfoMArr[indexPath.row];
    ZIKMySupplyDetailViewController *detailVC = [[ZIKMySupplyDetailViewController alloc] initMySupplyDetialWithUid:model];
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)requestSupplyRestrict {
    HttpClient *httpClient=[HttpClient sharedClient];
    //供求发布限制
    [httpClient getSupplyRestrictWithToken:APPDELEGATE.userModel.access_token  withId:APPDELEGATE.userModel.access_id withClientId:nil withClientSecret:nil withDeviceId:nil withType:@"2" success:^(id responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        if ( [dic[@"count"] integerValue] == 0 ) {// “count”: 1	--当数量大于0时，表示可发布；等于0时，不可发布
            self.isCanPublish = NO;
            //NSLog(@"不可发布");
        }
        else if (APPDELEGATE.isNeedCompany == NO) {
            self.isCanPublish = NO;
        }
        else {
            //NSLog(@"可发布");
            self.isCanPublish = YES;
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)createEmptyUI {
    if (!emptyUI) {
        emptyUI  = [[UIView alloc] init];
        emptyUI.frame = CGRectMake(0, 64, Width, Height/2);
        emptyUI.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:emptyUI];
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(Width/2-50, 30, 100, 100);
    imageView.image = [UIImage imageNamed:@"我的供应（空）"];
    [emptyUI addSubview:imageView];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, Width, 25);
    label1.text = @"您还没有发布任何的供应信息";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor lightGrayColor];
    [emptyUI addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(0, CGRectGetMaxY(label1.frame), Width, label1.frame.size.height);
    label2.text = @"点击按钮发布";
    label2.textColor = [UIColor lightGrayColor];
    label2.textAlignment = NSTextAlignmentCenter;
    [emptyUI addSubview:label2];
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(Width/2-40, CGRectGetMaxY(label2.frame)+10, 80, 30);
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 6.0f;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [button setTitle:@"发布供应" forState:UIControlStateNormal];
    [emptyUI addSubview:button];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick {
    if (self.isCanPublish) {
        //NSLog(@"可发布");
        ZIKSupplyPublishVC *spVC = [[ZIKSupplyPublishVC alloc] init];
        [self.navigationController pushViewController:spVC animated:YES];
    }
    else {
       // NSLog(@"不可发布");
        //[ToastView showTopToast:@"请先完善苗圃信息"];
        [ToastView showToast:@"请您先完善苗圃信息或者企业信息" withOriginY:Width/3 withSuperView:self.view];

        return;
    }
}

- (void)configNav {
    self.vcTitle = @"我的供应";
    self.rightBarBtnTitleString = @"发布";
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{
        //NSLog(@"发布");
        if (weakSelf.isCanPublish) {
            ZIKSupplyPublishVC *spVC = [[ZIKSupplyPublishVC alloc] init];
            [weakSelf.navigationController pushViewController:spVC animated:YES];

        }
        else {
            //NSLog(@"不可发布");
            [ToastView showToast:@"请您先完善苗圃信息或者企业信息" withOriginY:Width/3 withSuperView:weakSelf.view];
        }
        
    };
}

- (void)initData {
    self.page = 1;
    self.supplyInfoMArr = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
