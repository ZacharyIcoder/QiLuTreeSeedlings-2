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

@interface ZIKMyTeamViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *teamTableView;

@end

@implementation ZIKMyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = @"我的团队";
    self.leftBarBtnImgString = @"BackBtn";

    self.teamTableView.delegate = self;
    self.teamTableView.dataSource = self;

    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.leftBarBtnBlock = ^{
        [weakSelf backBtnAction:nil];
    };

    self.searchBarView.placeHolder = @"请输入工作站名称、电话、联系人";
    self.searchBarView.searchBlock = ^(NSString *searchText){
        CLog(@"%@",searchText);
        weakSelf.isSearch = !weakSelf.isSearch;
    };
    self.searchBarView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.searchBarView.textField];


}

- (void)requestData {
    NSString *uid = nil;
    NSString *pageNumber = nil;
    NSString *pageSize = nil;
//    [HTTPCLIENT stationTeamWithUid:(NSString *)uid
//                        pageNumber:(NSString *)pageNumber
//                          pageSize:(NSString *)pageSize
//                           Success:^(id responseObject){
//
//                           }
//                           failure:^(NSError *error) {
//
//                           }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
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
    return cell;
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

-(void)backBtnAction:(UIButton *)sender
{
    if (self.navigationController.childViewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKBackHome" object:nil];
    }
}


@end
