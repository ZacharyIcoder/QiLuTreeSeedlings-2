//
//  ZIKStationOrderDetailViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationOrderDetailViewController.h"
#import "ZIKSelectMenuView.h"
#import "ZIKStationOrderOfferTableViewCell.h"
#import "HttpClient.h"
#import "ZIKStationOrderDetailQuoteModel.h"
#import "YYModel.h"
#import "ZIKFunction.h"
typedef NS_ENUM(NSInteger, TypeStyle) {
    TypeStyleOffer   = 0,   //产品报价
    TypeStyleRequire = 1    //订单要求
};

@interface ZIKStationOrderDetailViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) TypeStyle   typeStyle;
@property (nonatomic, strong) UITableView *orderTableView;
@property (nonatomic, strong) NSMutableArray *quoteMArr;
@property (nonatomic, strong) NSString    *keyword;
@end

@implementation ZIKStationOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"订单详情";
    self.leftBarBtnImgString = @"BackBtn";
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.searchBarView.placeHolder = @"请输入苗木名称";
    self.searchBarView.searchBlock = ^(NSString *searchText){
        CLog(@"%@",searchText);
        weakSelf.isSearch = !weakSelf.isSearch;
    };
    self.searchBarView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.searchBarView.textField];

    [self initUI];
    self.quoteMArr = [[NSMutableArray alloc] init];
    [self requestOrderDetail];

}

- (void)initUI {
    NSArray *titleArray = [NSArray arrayWithObjects:@"产品报价",@"订单要求", nil];
    ZIKSelectMenuView *selectMenuView = [[ZIKSelectMenuView alloc] initWithFrame:CGRectMake(0, 64, kWidth, 43) dataArray:titleArray];
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    selectMenuView.menuBtnBlock = ^(NSInteger menuBtnTag){
        menuBtnTag == 0 ? (weakSelf.typeStyle = TypeStyleOffer) : (weakSelf.typeStyle = TypeStyleRequire);
    };
    [self.view addSubview:selectMenuView];

    UITableView *orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(selectMenuView.frame)+2, kWidth, kHeight-64-2-selectMenuView.frame.size.height) style:UITableViewStylePlain];
    orderTableView.dataSource = self;
    orderTableView.delegate = self;
    [self.view addSubview:orderTableView];
    [ZIKFunction setExtraCellLineHidden:orderTableView];
    self.orderTableView = orderTableView;
}

#pragma mark - 请求数据
- (void)requestData {
    //__weak typeof(self) weakSelf = self;//解决循环引用的问题
//    [self.orderTV addHeaderWithCallback:^{
//        weakSelf.page = 1;
//        [weakSelf requestMyOrderList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
//    }];
//    [self.orderTV addFooterWithCallback:^{
//        weakSelf.page++;
//        [weakSelf requestMyOrderList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
//    }];
//    [self.orderTV headerBeginRefreshing];
}

- (void)requestOrderDetail {
    [HTTPCLIENT stationGetOrderDetailWithOrderUid:self.orderUid keyword:nil Success:^(id responseObject) {
       CLog(@"%@",responseObject) ;
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        }
        NSDictionary *resultDic = responseObject[@"result"];
        NSDictionary *orderDetailDic = resultDic[@"orderDetail"];
        NSArray *itemListArray = orderDetailDic[@"itemList"];
        [itemListArray enumerateObjectsUsingBlock:^(NSDictionary *itemDic, NSUInteger idx, BOOL * _Nonnull stop) {
            ZIKStationOrderDetailQuoteModel *model = [ZIKStationOrderDetailQuoteModel yy_modelWithDictionary:itemDic];
            [self.quoteMArr addObject:model];
        }];
        [self.orderTableView reloadData];
    } failure:^(NSError *error) {
        ;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.quoteMArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.orderTableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
    self.orderTableView.estimatedRowHeight = 110;////必须设置好预估值
    return tableView.rowHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKStationOrderOfferTableViewCell *cell = [ZIKStationOrderOfferTableViewCell cellWithTableView:tableView];
    if (self.quoteMArr.count > 0) {
        ZIKStationOrderDetailQuoteModel *model = self.quoteMArr[indexPath.section];
        cell.section = indexPath.section;
        [cell configureCell:model];
    }
    cell.quoteBtnBlock = ^(NSInteger section ) {
        NSLog(@"报价:%ld",indexPath.section);
    };
//    if (indexPath.row == 2) {
//        cell.contentLabel.text = @"fewifjeiwjaiefjwajeifjwajefjwajefijwajefjwajefjwaijefijwajfiwajifejwajefjwajfejiwajfijwaifjwjaifejiwajfijwaiefjiwajfijawifejajweifjwaiejfijawewwefwefaefweqfweqfwqefwqefwqefwfwefwqefqwefwqefwqewqefwqefwqefwqewqea";
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    NSString *searchText = textField.text;
    CLog(@"searchText:%@",searchText);
    return YES;
}

-(void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    CLog(@"textField:%@",textField.text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
