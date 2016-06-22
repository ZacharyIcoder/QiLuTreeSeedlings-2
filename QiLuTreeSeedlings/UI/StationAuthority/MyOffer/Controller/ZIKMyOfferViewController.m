//
//  ZIKMyOfferViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMyOfferViewController.h"
#import "ZIKSelectMenuView.h"
#import "ZIKMyofferTableViewCell.h"
#import "HttpClient.h"
#import "YYModel.h"//类型转换
#import "MJRefresh.h"//MJ刷新
#import "ZIKFunction.h"
#import "ZIKMyOfferQuoteListModel.h"
@interface ZIKMyOfferViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *quoteTableView;
@property (nonatomic, strong) NSMutableArray *quoteMArr;
@property (nonatomic, assign) NSInteger      page;            //页数从1开始
@property (nonatomic, strong) NSString *status;//状态1：已报价；2：已合作；3:已过期；默认所有
@property (nonatomic, strong) NSString *keyword;//检索词
@end

@implementation ZIKMyOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.leftBarBtnImgString = @"BackBtn";
    self.leftBarBtnTitleString = @"苗信通";
     __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.leftBarBtnBlock = ^{
        [weakSelf backBtnAction:nil];
    };

    self.searchBarView.placeHolder = @"请输入苗木名称,工程公司名称";
    self.searchBarView.searchBlock = ^(NSString *searchText){
        //CLog(@"%@",searchText);
        weakSelf.isSearch = !weakSelf.isSearch;
        if (!weakSelf.isSearch) {
            weakSelf.keyword = nil;
        }
    };
    self.searchBarView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.searchBarView.textField];

    [self initUI];
    [self requestData];

}

- (void)initUI {
    self.quoteMArr = [NSMutableArray array];
    NSArray *titleArray = [NSArray arrayWithObjects:@"全部",@"已报价",@"已合作",@"已过期", nil];
    ZIKSelectMenuView *selectMenuView = [[ZIKSelectMenuView alloc] initWithFrame:CGRectMake(0, 64, kWidth, 43) dataArray:titleArray];
   __weak typeof(self) weakSelf = self;//解决循环引用的问题
    selectMenuView.menuBtnBlock = ^(NSInteger menuBtnTag){
//        menuBtnTag == 0 ? (weakSelf.typeStyle = TypeStyleOffer) : (weakSelf.typeStyle = TypeStyleRequire);
        //CLog(@"menuBtnTag:%ld",menuBtnTag);
        if (menuBtnTag == 0) {
            weakSelf.status = nil;
        } else {
            weakSelf.status = [NSString stringWithFormat:@"%d",(int)menuBtnTag];
        }
        weakSelf.page = 1;
        [weakSelf.quoteTableView headerBeginRefreshing];
        //[weakSelf requestMyQuoteList:[NSString stringWithFormat:@"%ld",weakSelf.page]];
    };
    [self.view addSubview:selectMenuView];

    UITableView *orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(selectMenuView.frame)+2, kWidth, kHeight-64-2-selectMenuView.frame.size.height) style:UITableViewStylePlain];
    orderTableView.dataSource = self;
    orderTableView.delegate   = self;
    [self.view addSubview:orderTableView];
    [ZIKFunction setExtraCellLineHidden:orderTableView];
     self.quoteTableView = orderTableView;
}

#pragma mark - 请求数据
- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.quoteTableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestMyQuoteList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.quoteTableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestMyQuoteList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.quoteTableView headerBeginRefreshing];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.quoteMArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    self.orderTableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
//    self.orderTableView.estimatedRowHeight = 220;////必须设置好预估值
    return 180;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKMyofferTableViewCell *cell = [ZIKMyofferTableViewCell cellWithTableView:tableView];
    if (self.quoteMArr.count > 0) {
        ZIKMyOfferQuoteListModel *model = self.quoteMArr[indexPath.section];
        [cell configureCell:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ------textField delegate --------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.isSearch = NO;//搜索栏隐藏
//    NSString *searchText = textField.text;
    //CLog(@"searchText:%@",searchText);
    self.keyword = textField.text;
    self.page = 1;
    [self requestMyQuoteList:[NSString stringWithFormat:@"%ld",self.page]];
    return YES;
}

-(void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    //CLog(@"textField:%@",textField.text);
    self.keyword = textField.text;
    self.page = 1;
    [self requestMyQuoteList:[NSString stringWithFormat:@"%ld",self.page]];
}

- (void)requestMyQuoteList:(NSString *)page {
    [self.quoteTableView headerEndRefreshing];
    [HTTPCLIENT stationMyQuoteListWithStatus:_status Withkeyword:_keyword WithpageNumber:page WithpageSize:@"15" Success:^(id responseObject) {
       //CLog(@"%@",responseObject) ;
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        }
        NSDictionary *resultDic = responseObject[@"result"];
        NSArray *quoteListArray = resultDic[@"quoteList"];
        if (self.page == 1 && quoteListArray.count == 0) {
            if (self.keyword != nil || [self.keyword isEqualToString:@""]) {
                [ToastView showTopToast:@"暂无数据"];
                if(self.quoteMArr.count > 0 ) {
                    [self.quoteMArr removeAllObjects];
                }
                [self.quoteTableView reloadData];
                return;
            }
            [ToastView showTopToast:@"暂无数据"];
            [self.quoteTableView footerEndRefreshing];
            if(self.quoteMArr.count > 0 ) {
                [self.quoteMArr removeAllObjects];
            }
            [self.quoteTableView reloadData];
            return ;
        } else if (quoteListArray.count == 0 && self.page > 1) {
            [ToastView showTopToast:@"已无更多信息"];
            self.page--;
            [self.quoteTableView footerEndRefreshing];
            return;
        } else {
            if (self.page == 1) {
                [self.quoteMArr removeAllObjects];
            }

            [quoteListArray enumerateObjectsUsingBlock:^(NSDictionary *orderDic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKMyOfferQuoteListModel *model = [ZIKMyOfferQuoteListModel yy_modelWithDictionary:orderDic];
                [self.quoteMArr addObject:model];
            }];

            [self.quoteTableView reloadData];

            [self.quoteTableView footerEndRefreshing];

        }


    } failure:^(NSError *error) {
        ;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKBackHome" object:nil];
}


@end
