//
//  ZIKMyTeamViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/4.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMyTeamViewController.h"
#import "HttpClient.h"
#import "ZIKWorkstationTableViewCell.h"
#import "YYModel.h"//类型转换
#import "MJRefresh.h"
#import "ZIKMyTeamModel.h"
#import "ZIKFunction.h"
#import "YLDZhanZhangMessageViewController.h"
@interface ZIKMyTeamViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *teamTableView;
@property (nonatomic, assign) NSInteger      page;            //页数从1开始
@property (nonatomic, strong) NSMutableArray *teamMarr;
@property (nonatomic, strong) NSString *keyword;
@end

@implementation ZIKMyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = @"我的团队";
    self.leftBarBtnImgString = @"BackBtn";
    self.page = 1;
    self.teamMarr = [NSMutableArray array];

    self.teamTableView.delegate   = self;
    self.teamTableView.dataSource = self;
    [ZIKFunction setExtraCellLineHidden:self.teamTableView];
    __weak typeof(self) weakSelf  = self;//解决循环引用的问题
    self.leftBarBtnBlock = ^{
        [weakSelf backBtnAction:nil];
    };

    self.searchBarView.placeHolder = @"请输入工作站关键词";
    self.searchBarView.searchBlock = ^(NSString *searchText){
        //CLog(@"%@",searchText);
        weakSelf.isSearch = !weakSelf.isSearch;
        weakSelf.keyword = searchText;
        weakSelf.page = 1;
        [weakSelf requestMyTeamList:@"1"];

    };
    self.searchBarView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.searchBarView.textField];
    [self requestData];
}

#pragma mark - 请求数据
- (void)requestData {

    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.teamTableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        if (!weakSelf.isSearch) {
            weakSelf.keyword = nil;
        }
        [weakSelf requestMyTeamList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.teamTableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestMyTeamList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.teamTableView headerBeginRefreshing];
}

- (void)requestMyTeamList:(NSString *)page {
    [self.teamTableView headerEndRefreshing];

        NSString *uid = self.uid;
        NSString *pageNumber = page;
        NSString *pageSize = @"15";
        NSString *keyword = self.keyword;
        [HTTPCLIENT stationTeamWithUid:(NSString *)uid
                            pageNumber:(NSString *)pageNumber
                              pageSize:(NSString *)pageSize
                               keyword:(NSString *)keyword
                               Success:^(id responseObject){
                                   //CLog(@"%@",responseObject);
                                   if ([responseObject[@"success"] integerValue] == 0) {
                                       [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
                                       return ;
                                   }else if ([responseObject[@"success"] integerValue] == 1) {
                                       NSArray *array  = responseObject[@"result"][@"list"];
                                       if (array.count == 0 && self.page == 1) {
                                           [ToastView showToast:@"暂无信息" withOriginY:Width/2 withSuperView:self.view];
                                           if (self.teamMarr.count > 0) {
                                               [self.teamMarr removeAllObjects];
                                           }
                                           [self.teamTableView footerEndRefreshing];
                                           [self.teamTableView reloadData];
                                           return ;
                                       }
                                       else if (array.count == 0 && self.page > 1) {
                                           self.page--;
                                           [self.teamTableView footerEndRefreshing];
                                           //没有更多数据了
                                           [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
                                           return;
                                       }
                                       else {
                                           if (self.page == 1) {
                                               [self.teamMarr removeAllObjects];
                                           }
                                           [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                               ZIKMyTeamModel *myTeamModel = [ZIKMyTeamModel yy_modelWithDictionary:dic];
                                               [self.teamMarr addObject:myTeamModel];
                                           }];
                                           [self.teamTableView reloadData];
                                           [self.teamTableView footerEndRefreshing];
                                           
                                       }
                                   }
                               } failure:^(NSError *error) {
                               }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.teamMarr.count;
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
    if (self.teamMarr.count > 0) {
        ZIKMyTeamModel *model = self.teamMarr[indexPath.section];
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
    if (self.teamMarr.count > 0) {
        ZIKMyTeamModel *model = self.teamMarr[indexPath.section];
        YLDZhanZhangMessageViewController *detailVC = [[YLDZhanZhangMessageViewController
                                                        alloc] initWithUid:model.uid];
//        if (self.navigationController.childViewControllers.count>1) {
//
//        }else{
//            detailVC.hidesBottomBarWhenPushed = YES;
//        }

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
    self.keyword = textField.text;
//    [self.teamTableView headerBeginRefreshing];
    self.page = 1;
    [self requestMyTeamList:[NSString stringWithFormat:@"%ld",(long)self.page]];
    //CLog(@"searchText:%@",searchText);
    return YES;
}

-(void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    //CLog(@"textField:%@",textField.text);
    self.keyword = textField.text;
    self.page = 1;
    [self requestMyTeamList:[NSString stringWithFormat:@"%ld",(long)self.page]];
//    [self.teamTableView headerBeginRefreshing];
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


@end
