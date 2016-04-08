//
//  ZIKCustomizedInfoListViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKCustomizedInfoListViewController.h"
#import "ZIKCustomizedSetViewController.h"
#import "MJRefresh.h"
#import "YYModel.h"
#import "ZIKCustomizedModel.h"
#import "BuyOtherInfoTableViewCell.h"
#import "ZIKCustomizedTableViewCell.h"
@interface ZIKCustomizedInfoListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *emptyUI;
}
@property (nonatomic, assign) NSInteger      page;//页数从1开始
@property (nonatomic, strong) NSMutableArray *customizedInfoMArr;//定制信息数组
@property (nonatomic, strong) UITableView    *myCustomizedInfoTableView;//我的定制信息列表
@end

@implementation ZIKCustomizedInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNav];
    //[self initData];
    [self initUI];
    //[self requestData];
    NSLog(@"%@",  [NSString stringWithUTF8String:object_getClassName(self)]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self initData];
    [self requestData];
}

- (void)configNav {
    self.vcTitle = @"已定制信息";
    self.rightBarBtnTitleString = @"定制";
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{
        //NSLog(@"添加");
        ZIKCustomizedSetViewController *setVC = [[ZIKCustomizedSetViewController alloc] init];
        [weakSelf.navigationController pushViewController:setVC animated:YES];
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
    self.myCustomizedInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Height-64) style:UITableViewStyleGrouped];
    self.myCustomizedInfoTableView.delegate   = self;
    self.myCustomizedInfoTableView.dataSource = self;
    [self.view addSubview:self.myCustomizedInfoTableView];
    [ZIKFunction setExtraCellLineHidden:self.myCustomizedInfoTableView];
}

- (void)requestSellList:(NSString *)page {
    //我的供应列表
    [self.myCustomizedInfoTableView headerEndRefreshing];
    HttpClient *httpClient = [HttpClient sharedClient];
    [httpClient getCustomSetListInfo:page pageSize:@"15" Success:^(id responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        NSArray *array = dic[@"list"];
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
                ZIKCustomizedModel *model = [ZIKCustomizedModel yy_modelWithDictionary:dic];
                [self.customizedInfoMArr addObject:model];
            }];
            [self.myCustomizedInfoTableView reloadData];
            [self.myCustomizedInfoTableView footerEndRefreshing];
        }

    } failure:^(NSError *error) {

    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //ZIKCustomizedModel *model = self.customizedInfoMArr[indexPath.section];
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    ZIKCustomizedModel *model = self.customizedInfoMArr[section];
    return  model.spec.count*30+10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;//self.customizedInfoMArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.customizedInfoMArr.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    ZIKCustomizedModel *model = self.customizedInfoMArr[section];
    backView.frame = CGRectMake(0, 0, kWidth, model.spec.count*30+10);
    BuyOtherInfoTableViewCell *cell = [[BuyOtherInfoTableViewCell alloc] initWithFrame:CGRectMake(0, 0, kWidth, backView.frame.size.height)];
    cell.ary = model.spec;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [backView addSubview:cell];
    return backView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKCustomizedTableViewCell *cell = [ZIKCustomizedTableViewCell cellWithTableView:tableView];
     ZIKCustomizedModel *model = self.customizedInfoMArr[indexPath.section];
    [cell configureCell:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKCustomizedModel *model = self.customizedInfoMArr[indexPath.row];
    ZIKCustomizedSetViewController *viewC = [[ZIKCustomizedSetViewController alloc] initWithModel:model];
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
    imageView.image         = [UIImage imageNamed:@"图片2"];
    [emptyUI addSubview:imageView];

    UILabel *label1         = [[UILabel alloc] init];
    label1.frame            = CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, Width, 25);
    label1.text             = @"您还没有定制任何信息~";
    label1.textAlignment    = NSTextAlignmentCenter;
    label1.textColor        = detialLabColor;
    [emptyUI addSubview:label1];

    UILabel *label2         = [[UILabel alloc] init];
    label2.frame            = CGRectMake(0, CGRectGetMaxY(label1.frame), Width, label1.frame.size.height);
    label2.text             = @"点击右上角开始添加吧";
    label2.textColor        = detialLabColor;
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
