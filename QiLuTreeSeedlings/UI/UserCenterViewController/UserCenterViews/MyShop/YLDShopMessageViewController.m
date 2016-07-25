//
//  YLDShopMessageViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/25.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDShopMessageViewController.h"
#import "HttpClient.h"
#import "UIDefines.h"
#import "YLDShopIndexinfoCell.h"
#import "YLDShopIndexModel.h"
@interface YLDShopMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *talbeView;
@property (nonatomic,strong)YLDShopIndexModel *indexModel;
@end

@implementation YLDShopMessageViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    ShowActionV();
    [HTTPCLIENT getMyShopHomePageMessageSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *result=[responseObject objectForKey:@"result"];
            self.indexModel=[YLDShopIndexModel yldShopIndexModelByDic:result];
            [self.talbeView reloadData];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        RemoveActionV();
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"我的店铺";
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.talbeView=tableView;
    [self.view addSubview:tableView];
   
    // Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 230;
    }else{
        return 44;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        YLDShopIndexinfoCell *cell=[YLDShopIndexinfoCell yldShopIndexinfoCell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.model=self.indexModel;
        return cell;
    }
    UITableViewCell *cell=[UITableViewCell  new];
    return cell;
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
