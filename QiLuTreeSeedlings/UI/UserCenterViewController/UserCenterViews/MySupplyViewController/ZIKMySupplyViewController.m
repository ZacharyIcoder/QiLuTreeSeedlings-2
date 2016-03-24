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
    [self initData];
    [self initUI];
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
    [self setExtraCellLineHidden:self.mySupplyTableView];
    //self.mySupplyTableView.backgroundColor = [UIColor yellowColor];
}

- (void)requestSellList:(NSString *)page {
    //我的供应列表
     [self.mySupplyTableView headerEndRefreshing];
    HttpClient *httpClient = [HttpClient sharedClient];
    [httpClient getMysupplyListWithToken:nil withAccessId:nil withClientId:nil withClientSecret:nil withDeviewId:nil withPage:page withPageSize:@"15" success:^(id responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        NSLog(@"%@",dic);
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
//    ZIKWineCultureListModel *model = self.wineArray[indexPath.section];
//    ZIKWineCultureDetailViewController *detailVC = [[ZIKWineCultureDetailViewController alloc] init];
//    detailVC.wineCultureId = [NSString stringWithFormat:@"%ld",(long)model.id];
//    detailVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)requestSupplyRestrict {
    HttpClient *httpClient=[HttpClient sharedClient];
    //供求发布限制
    [httpClient getSupplyRestrictWithToken:APPDELEGATE.userModel.access_token  withId:APPDELEGATE.userModel.access_id withClientId:nil withClientSecret:nil withDeviceId:nil withType:@"2" success:^(id responseObject) {
        NSDictionary *dic=[responseObject objectForKey:@"result"];
        NSLog(@"%@",dic);
        NSLog(@"%@",dic[@"count"]);
        if ( [dic[@"count"] integerValue] == 0) {// “count”: 1	--当数量大于0时，表示可发布；等于0时，不可发布
            self.isCanPublish = NO;
            NSLog(@"不可发布");
        }
        else {
            NSLog(@"可发布");
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
    button.layer.borderWidth = 0.8;
    button.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [button setTitle:@"发布供应" forState:UIControlStateNormal];
    [emptyUI addSubview:button];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick {
    ZIKSupplyPublishViewController *spVC = [[ZIKSupplyPublishViewController alloc] init];
    [self.navigationController pushViewController:spVC animated:YES];
//
//    if (self.isCanPublish) {
//        NSLog(@"可发布");
//        ZIKSupplyPublishViewController *spVC = [[ZIKSupplyPublishViewController alloc] init];
//        [self.navigationController pushViewController:spVC animated:YES];
//
//    }
//    else {
//        NSLog(@"不可发布");
//        
//    }
}

- (void)configNav {
    self.vcTitle = @"我的供应";
    self.rightBarBtnTitleString = @"发布";
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{
        NSLog(@"发布");
        if (weakSelf.isCanPublish) {
            ZIKSupplyPublishViewController *spVC = [[ZIKSupplyPublishViewController alloc] init];
            [weakSelf.navigationController pushViewController:spVC animated:YES];

        }
        else {
            NSLog(@"不可发布");
        }
        
    };
}

- (void)initData {
    self.page = 1;
    self.supplyInfoMArr = [NSMutableArray array];
}

#pragma mark - 设置TableView空行分割线隐藏
// 设置TableView空行分割线隐藏
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
