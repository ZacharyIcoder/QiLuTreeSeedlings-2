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

typedef NS_ENUM(NSInteger, TypeStyle) {
    TypeStyleOffer   = 0,   //产品报价
    TypeStyleRequire = 1    //订单要求
};

@interface ZIKStationOrderDetailViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) TypeStyle typeStyle;
@property (nonatomic, strong) UITableView *orderTableView;
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
//    orderTableView.rowHeight =  UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
//    orderTableView.estimatedRowHeight = 110;//必须设置好预估值
    self.orderTableView = orderTableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.orderTableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
    self.orderTableView.estimatedRowHeight = 110;////必须设置好预估值
    return tableView.rowHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKStationOrderOfferTableViewCell *cell = [ZIKStationOrderOfferTableViewCell cellWithTableView:tableView];
    if (indexPath.row == 2) {
        cell.contentLabel.text = @"fewifjeiwjaiefjwajeifjwajefjwajefijwajefjwajefjwaijefijwajfiwajifejwajefjwajfejiwajfijwaifjwjaifejiwajfijwaiefjiwajfijawifejajweifjwaiejfijawewa";
    }
    return cell;
}


#pragma mark ------textField delegate --------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.isSearch = NO;//搜索栏隐藏
    NSString *searchText = textField.text;
//    NSLog(@"searchText is %@",searchText);
//    if ([XtomFunction xfunc_check_strEmpty:searchText]) {
//        [XtomFunction openIntervalHUD:@"请您输入关键词进行搜索" view:self.view];
//    }
//    else {
//        [self requestCity:searchText];
//    }
    CLog(@"searchText:%@",searchText);
    return YES;
}
-(void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    CLog(@"textField:%@",textField);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
