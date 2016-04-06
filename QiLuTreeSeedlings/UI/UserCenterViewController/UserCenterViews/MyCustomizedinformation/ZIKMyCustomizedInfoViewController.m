//
//  ZIKMyCustomizedInfoViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKMyCustomizedInfoViewController.h"
#import "ZIKCustomizedInfoListViewController.h"
#import "MJRefresh.h"
#import "ZIKCustomizedInfoListModel.h"
#import "YYModel.h"
#import "ZIKCustomizedInfoListTableViewCell.h"
#import "BuyDetialInfoViewController.h"
@interface ZIKMyCustomizedInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *emptyUI;
}
@property (nonatomic, assign) NSInteger      page;//页数从1开始
@property (nonatomic, strong) NSMutableArray *customizedInfoMArr;//定制信息数组
@property (nonatomic, strong) UITableView    *myCustomizedInfoTableView;//我的定制信息列表
@end

@implementation ZIKMyCustomizedInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNav];
    [self initData];
    [self initUI];
    [self requestData];
}

- (void)configNav {
    self.vcTitle = @"定制信息";
    self.rightBarBtnTitleString = @"设置";
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{
        ZIKCustomizedInfoListViewController *listVC = [[ZIKCustomizedInfoListViewController alloc] init];
        [weakSelf.navigationController pushViewController:listVC animated:YES];
    };
}

- (void)requestData {
    [self requestSellList:[NSString stringWithFormat:@"%ld",self.page]];
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.myCustomizedInfoTableView addHeaderWithCallback:^{
        [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",weakSelf.page]];
    }];
    [self.myCustomizedInfoTableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",weakSelf.page]];
    }];
}

- (void)initUI {
    self.myCustomizedInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Height-64) style:UITableViewStylePlain];
    self.myCustomizedInfoTableView.delegate   = self;
    self.myCustomizedInfoTableView.dataSource = self;
    [self.view addSubview:self.myCustomizedInfoTableView];
    [ZIKFunction setExtraCellLineHidden:self.myCustomizedInfoTableView];
}

- (void)requestSellList:(NSString *)page {
    //我的供应列表
    [self.myCustomizedInfoTableView headerEndRefreshing];
    HttpClient *httpClient = [HttpClient sharedClient];
    [httpClient getMyCustomizedListInfoWithPageNumber:page pageSize:@"15" Success:^(id responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        NSArray *array = dic[@"recordList"];
        if (array.count == 0 && self.page == 1) {
            [self.customizedInfoMArr removeAllObjects];
            [self.myCustomizedInfoTableView footerEndRefreshing];
            self.myCustomizedInfoTableView.hidden = YES;
            [self createEmptyUI];
            return ;
        }
        else if (array.count == 0 && self.page > 1) {
            self.myCustomizedInfoTableView.hidden = NO;
            emptyUI.hidden = YES;
            self.page--;
            [self.myCustomizedInfoTableView footerEndRefreshing];
            //没有更多数据了
            [ToastView showToast:@"没有更多数据了" withOriginY:Width/2 withSuperView:self.view];
            return;
        }
        else {
            self.myCustomizedInfoTableView.hidden = NO;
            emptyUI.hidden = YES;
            if (self.page == 1) {
                [self.customizedInfoMArr removeAllObjects];
            }
            [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKCustomizedInfoListModel *model = [ZIKCustomizedInfoListModel yy_modelWithDictionary:dic];
                [self.customizedInfoMArr addObject:model];
            }];
            [self.myCustomizedInfoTableView reloadData];
            [self.myCustomizedInfoTableView footerEndRefreshing];
        }

    } failure:^(NSError *error) {

    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.customizedInfoMArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//self.supplyInfoMArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kZIKCustomizedInfoListTableViewCellID = @"kZIKCustomizedInfoListTableViewCellID";
    ZIKCustomizedInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKCustomizedInfoListTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKCustomizedInfoListTableViewCell" owner:self options:nil] lastObject];
    }
    [cell configureCell:self.customizedInfoMArr[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKCustomizedInfoListModel *model = self.customizedInfoMArr[indexPath.row];
    BuyDetialInfoViewController *viewC = [[BuyDetialInfoViewController alloc] initWithSaercherInfo:model.uid];
    [self.navigationController pushViewController:viewC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)createEmptyUI {
    if (!emptyUI) {
    emptyUI                 = [[UIView alloc] init];
    emptyUI.frame           = CGRectMake(0, 64, Width, Height/2);
    emptyUI.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:emptyUI];
    }

    UIImageView *imageView  = [[UIImageView alloc] init];
    imageView.frame         = CGRectMake(Width/2-50, 30, 100, 100);
    imageView.image         = [UIImage imageNamed:@"图片1"];
    [emptyUI addSubview:imageView];

    UILabel *label1         = [[UILabel alloc] init];
    label1.frame            = CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, Width, 25);
    label1.text             = @"空空如也~~";
    label1.textAlignment    = NSTextAlignmentCenter;
    label1.textColor        = [UIColor lightGrayColor];
    [emptyUI addSubview:label1];

    UILabel *label2         = [[UILabel alloc] init];
    label2.frame            = CGRectMake(0, CGRectGetMaxY(label1.frame), Width, label1.frame.size.height);
    label2.text             = @"还没有收到任何定制信息";
    label2.textColor        = [UIColor lightGrayColor];
    label2.textAlignment    = NSTextAlignmentCenter;
    [emptyUI addSubview:label2];
}

- (void)initData {
    self.page               = 1;
    self.customizedInfoMArr = [NSMutableArray array];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
