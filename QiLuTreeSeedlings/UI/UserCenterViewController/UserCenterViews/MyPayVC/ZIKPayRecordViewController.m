//
//  ZIKPayRecordViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/30.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKPayRecordViewController.h"
#import "ZIKPayRecordTableViewCell.h"
#import "ZIKConsumeRecordModel.h"
#import "MJRefresh.h"
#import "YYModel.h"
@interface ZIKPayRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *emptyUI;
}
@property (nonatomic, assign) NSInteger      page;//页数从1开始
@property (nonatomic, strong) NSMutableArray *customizedInfoMArr;//定制信息数组
@property (nonatomic, strong) UITableView    *myCustomizedInfoTableView;//我的定制信息列表

@end

@implementation ZIKPayRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"消费记录";
    [self initData];
    [self initUI];
    [self requestData];
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
    NSLog(@"page:%@",page);
    //我的消费列表
    [self.myCustomizedInfoTableView headerEndRefreshing];
    HttpClient *httpClient = [HttpClient sharedClient];
    [httpClient getConsumeRecordInfoWithPageNumber:page pageSize:@"15" Success:^(id responseObject) {
       NSArray *array = [responseObject objectForKey:@"result"];
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
                ZIKConsumeRecordModel *model = [ZIKConsumeRecordModel yy_modelWithDictionary:dic];
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
    ZIKPayRecordTableViewCell *cell = [ZIKPayRecordTableViewCell cellWithTableView:tableView];
    [cell configureCell:self.customizedInfoMArr[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)createEmptyUI {
    if (!emptyUI) {
        emptyUI                 = [[UIView alloc] init];
        emptyUI.frame           = CGRectMake(0, 64, Width, Height/2);
        emptyUI.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:emptyUI];
    }

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame        = CGRectMake(Width/2-50, 30, 100, 100);
    imageView.image        = [UIImage imageNamed:@"图片1"];
    [emptyUI addSubview:imageView];

    UILabel *label1        = [[UILabel alloc] init];
    label1.frame           = CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, Width, 25);
    label1.text            = @"空空如也~~";
    label1.textAlignment   = NSTextAlignmentCenter;
    label1.textColor       = detialLabColor;
    [emptyUI addSubview:label1];

    UILabel *label2        = [[UILabel alloc] init];
    label2.frame           = CGRectMake(0, CGRectGetMaxY(label1.frame), Width, label1.frame.size.height);
    label2.text            = @"还没有任何消费记录";
    label2.textColor       = detialLabColor;
    label2.textAlignment   = NSTextAlignmentCenter;
    [emptyUI addSubview:label2];
}

- (void)initData {
    self.page = 1;
    self.customizedInfoMArr = [NSMutableArray array];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
