//
//  ZIKMiaoQiListViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMiaoQiListViewController.h"

#import "ZIKHeZuoMiaoQiListSelectAddressView.h"

@interface ZIKMiaoQiListViewController ()
@property (nonatomic, strong) NSString *province;//省
@property (nonatomic, strong) NSString *city;    //市
@property (nonatomic, strong) NSString *county;  //县
@property (nonatomic, strong) NSString *level;


@property (nonatomic, strong) ZIKHeZuoMiaoQiListSelectAddressView *selectAreaView;

@end

@implementation ZIKMiaoQiListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    __weak typeof(self) weakSelf = self;//解决循环引用的问题

    self.searchBarView.placeHolder = @"请输入苗企名称、电话、联系人";
    self.searchBarView.searchBlock = ^(NSString *searchText){
        CLog(@"%@",searchText);
        weakSelf.isSearch = !weakSelf.isSearch;
//        weakSelf.keyword = searchText;
//        weakSelf.page = 1;
//        [weakSelf requestMyOrderList:@"1"];
    };
//    self.searchBarView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.searchBarView.textField];

    [self initUI];
//    [self requestData];

}


- (void)initUI {
    self.vcTitle = @"合作苗企";
    self.leftBarBtnImgString = @"BackBtn";

    self.selectAreaView = [[ZIKHeZuoMiaoQiListSelectAddressView alloc] initWithFrame:CGRectMake(0, 64, kWidth, 46)];
//    self.selectAreaView.delegate = self;
    [self.view addSubview:self.selectAreaView];
    self.selectAreaView.backgroundColor = [UIColor yellowColor];
//    self.selectAreaView.frame = CGRectMake(0, 64+46, kHeight, 26);
//    CGRect frame;
//    if (self.navigationController.childViewControllers.count>1) {
//        frame=CGRectMake(0, 64+46, kWidth, kHeight-64-46);
//    }else{
//        frame=CGRectMake(0, 64+46, kWidth, kHeight-64-46-44);
//    }
    CLog(@"%@",self.selectAreaView.description);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
