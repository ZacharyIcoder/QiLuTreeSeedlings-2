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
#import "ZIKStationOrderQuoteViewController.h"
#import "ZIKStationOrderDemandTableViewCell.h"//订单要求cell
#import "ZIKStationOrderDemandModel.h"//订单要求Model

#import "ZIKTestAddImageViewController.h"
/**
 *  cell类型
 */
typedef NS_ENUM(NSInteger, TypeStyle) {
    /**
     *  产品报价
     */
    TypeStyleOffer   = 0,
    /**
     *  订单要求
     */
    TypeStyleRequire = 1
};

@interface ZIKStationOrderDetailViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ZIKStationOrderDemandTableViewCellDelegate>
@property (nonatomic, assign) TypeStyle                  typeStyle;
@property (nonatomic, strong) UITableView                *orderTableView;
@property (nonatomic, strong) NSMutableArray             *quoteMArr;
@property (nonatomic, strong) NSString                   *keyword;
@property (nonatomic, strong) ZIKStationOrderDemandModel *demandModel;
@end

@implementation ZIKStationOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];

     __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.searchBarView.placeHolder = @"请输入苗木名称";
    self.searchBarView.searchBlock = ^(NSString *searchText){
        //CLog(@"%@",searchText);
        weakSelf.isSearch = !weakSelf.isSearch;
        weakSelf.keyword = searchText;
//        weakSelf.page = 1;
        [weakSelf requestOrderDetail];
    };
    self.searchBarView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.searchBarView.textField];
    [self initUI];
    //[self requestOrderDetail];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self requestOrderDetail];
}

- (void)initData {
    self.vcTitle = @"订单详情";
    self.leftBarBtnImgString = @"BackBtn";
    self.typeStyle = TypeStyleOffer;
    self.quoteMArr = [[NSMutableArray alloc] init];
}

- (void)initUI {
    NSArray *titleArray = [NSArray arrayWithObjects:@"产品报价",@"订单要求", nil];
    ZIKSelectMenuView *selectMenuView = [[ZIKSelectMenuView alloc] initWithFrame:CGRectMake(0, 64, kWidth, 43) dataArray:titleArray];
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    selectMenuView.menuBtnBlock = ^(NSInteger menuBtnTag){
        menuBtnTag == 0 ? (weakSelf.typeStyle = TypeStyleOffer , self.isSearch = YES) : (weakSelf.typeStyle = TypeStyleRequire , self.isSearch = NO, self.isRightBtnHidden = YES);
        [weakSelf.orderTableView reloadData];
    };
    [self.view addSubview:selectMenuView];

    UITableView *orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(selectMenuView.frame)+2, kWidth, kHeight-64-2-selectMenuView.frame.size.height) style:UITableViewStylePlain];
    orderTableView.dataSource = self;
    orderTableView.delegate = self;
    orderTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:orderTableView];
    [ZIKFunction setExtraCellLineHidden:orderTableView];
    self.orderTableView = orderTableView;
}

- (void)requestOrderDetail {
    [HTTPCLIENT stationGetOrderDetailWithOrderUid:self.orderUid keyword:self.keyword Success:^(id responseObject) {
       //CLog(@"%@",responseObject) ;
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        }
        NSDictionary *resultDic = responseObject[@"result"];
        NSDictionary *orderDetailDic = resultDic[@"orderDetail"];
        self.demandModel = [ZIKStationOrderDemandModel yy_modelWithDictionary:orderDetailDic];
        NSArray *itemListArray = orderDetailDic[@"itemList"];
        if (self.quoteMArr.count != 0) {
            [self.quoteMArr removeAllObjects];
        }

        if (itemListArray.count == 0) {
            [ToastView showTopToast:@"暂无数据"];

        } else {
         [itemListArray enumerateObjectsUsingBlock:^(NSDictionary *itemDic, NSUInteger idx, BOOL * _Nonnull stop) {
            ZIKStationOrderDetailQuoteModel *model = [ZIKStationOrderDetailQuoteModel yy_modelWithDictionary:itemDic];
            [self.quoteMArr addObject:model];
        }];
        }
        [self.orderTableView reloadData];
    } failure:^(NSError *error) {
        ;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.typeStyle == TypeStyleRequire) {
        return 0.0f;
    }
    return 10.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.typeStyle == TypeStyleRequire) {
        return 1;
    }
    return self.quoteMArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.typeStyle == TypeStyleOffer) {
        self.orderTableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
        self.orderTableView.estimatedRowHeight = 110;////必须设置好预估值
        return tableView.rowHeight;
    } else if (self.typeStyle == TypeStyleRequire) {
        return 300.0f;
    }
    return 44.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.typeStyle == TypeStyleOffer) {
        ZIKStationOrderOfferTableViewCell *cell = [ZIKStationOrderOfferTableViewCell cellWithTableView:tableView];
        if (APPDELEGATE.userModel.goldsupplierStatus==1||APPDELEGATE.userModel.goldsupplierStatus==2||APPDELEGATE.userModel.goldsupplierStatus==3||APPDELEGATE.userModel.goldsupplierStatus==5||APPDELEGATE.userModel.goldsupplierStatus==6) {
            if ([self.demandModel.quote isEqualToString:@"1"]) {
                cell.isCanQuote = YES;
            } else {
                cell.isCanQuote = NO;
            }
        }else{
            cell.isCanQuote = NO;
        }
        
        if (_statusType == StationOrderStatusTypeOutOfDate) {
            cell.isCanQuote = NO;
        }
        if (self.quoteMArr.count > 0) {
            ZIKStationOrderDetailQuoteModel *model = self.quoteMArr[indexPath.section];
            cell.section = indexPath.section;
            [cell configureCell:model];
        }
        __weak typeof(self) weakSelf = self;//解决循环引用的问题

        cell.quoteBtnBlock = ^(NSInteger section ) {
           // NSLog(@"报价:%ld",indexPath.section);
//            ZIKTestAddImageViewController *vc = [[ZIKTestAddImageViewController alloc] init];
//            [weakSelf.navigationController pushViewController:vc animated:YES];
            ZIKStationOrderQuoteViewController *quoteVC = [[ZIKStationOrderQuoteViewController alloc] initWithNibName:@"ZIKStationOrderQuoteViewController" bundle:nil];
//            quoteVC.hidesBottomBarWhenPushed = YES;
            ZIKStationOrderDetailQuoteModel *model = weakSelf.quoteMArr[indexPath.section];
            quoteVC.name     = model.name;
            quoteVC.count    = model.quantity;
            quoteVC.uid      = model.uid;
            quoteVC.orderUid = _demandModel.uid;
            quoteVC.quoteRequirement = _demandModel.quotationRequired;
            quoteVC.standardRequirement = _demandModel.demandDescription;
            [weakSelf.navigationController pushViewController:quoteVC animated:YES];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    } else if (self.typeStyle == TypeStyleRequire) {
        ZIKStationOrderDemandTableViewCell *demandCell = [ZIKStationOrderDemandTableViewCell cellWithTableView:tableView];
        demandCell.delegate = self;
        if (_demandModel) {
            [demandCell configureCell:_demandModel];
        }
        demandCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return demandCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark ------textField delegate --------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.isSearch = NO;//搜索栏隐藏
   // NSString *searchText = textField.text;
    //CLog(@"searchText:%@",searchText);
    self.keyword = textField.text;
    [self requestOrderDetail];
    return YES;
}

-(void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    self.keyword = textField.text;
    [self requestOrderDetail];
    //CLog(@"textField:%@",textField.text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendPhoneInfo:(NSString *)phoneString {
    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",phoneString];
    //NSLog(@"%@",str);
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];

}
@end
