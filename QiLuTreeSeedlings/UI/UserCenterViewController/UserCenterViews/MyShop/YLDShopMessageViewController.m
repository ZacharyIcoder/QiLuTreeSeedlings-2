//
//  YLDShopMessageViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/25.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDShopMessageViewController.h"
#import "YLDShopInteriorViewController.h"
#import "HttpClient.h"
#import "UIDefines.h"
#import "YLDShopIndexinfoCell.h"
#import "YLDShopIndexModel.h"
#import "YLDShopYuanCell.h"
#import "buyFabuViewController.h"
#import "ZIKSupplyPublishVC.h"
#import "BuyMessageAlertView.h"
#import "NuseryDetialViewController.h"
#import "CompanyViewController.h"
#import "MyNuseryListViewController.h"
#import "ZIKMyShopViewController.h"

@interface YLDShopMessageViewController ()<UITableViewDelegate,UITableViewDataSource,YLDShopYuanCellsDelegate>
@property (nonatomic,weak)UITableView *talbeView;
@property (nonatomic,strong)YLDShopIndexModel *indexModel;
@end

@implementation YLDShopMessageViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
    [HTTPCLIENT getSupplyRestrictWithToken:APPDELEGATE.userModel.access_token  withId:APPDELEGATE.userModel.access_id withClientId:nil withClientSecret:nil withDeviceId:nil withType:@"1" success:^(id responseObject) {
        NSDictionary *dic=[responseObject objectForKey:@"result"];
        if ( [dic[@"count"] integerValue] == 0) {// “count”: 1	--当数量大于0时，表示可发布；等于0时，不可发布
            APPDELEGATE.isCanPublishBuy = NO;
     
            return;
        }
        else {
            APPDELEGATE.isCanPublishBuy = YES;
        }
    } failure:^(NSError *error) {
    
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
    [tableView setBackgroundColor:BGColor];
    [self.view addSubview:tableView];
    ShowActionV();
    // Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        return 210;
    }
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
    if (indexPath.row==1) {
        YLDShopYuanCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDShopYuanCell"];
        if (!cell) {
            cell=[[YLDShopYuanCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YLDShopYuanCell"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.delegate=self;
        
        }
        return cell;
    }
    UITableViewCell *cell=[UITableViewCell  new];
    return cell;
}
-(void)YLDShopYuanCellPush:(NSInteger)index
{
    if (index==0) {
        if (APPDELEGATE.isCanPublishBuy==NO)
        {
            [ToastView showTopToast:@"您还没有供应发布权限,请先完善苗圃信息"];
            NuseryDetialViewController *nuseryDetialVC=[[NuseryDetialViewController alloc]init];
            [self.navigationController pushViewController:nuseryDetialVC animated:YES];
            return;
        }
        ZIKSupplyPublishVC *supplyLishVC=[[ZIKSupplyPublishVC alloc]init];
        [self.navigationController pushViewController:supplyLishVC animated:YES];

    }
    if (index==1) {
        if (APPDELEGATE.isCanPublishBuy==NO)
        {
            [ToastView showTopToast:@"您还没有供应发布权限,请先完善苗圃信息"];
            NuseryDetialViewController *nuseryDetialVC=[[NuseryDetialViewController alloc]init];
            [self.navigationController pushViewController:nuseryDetialVC animated:YES];
            return;
        }
        buyFabuViewController *fabuVC=[[buyFabuViewController alloc]init];
        [self.navigationController pushViewController:fabuVC animated:YES];

    }
    if (index==2) {
        CompanyViewController *companyVC=[[CompanyViewController alloc]init];
        [self.navigationController pushViewController:companyVC animated:YES];
    }
    if (index==3) {
        MyNuseryListViewController *nuserListVC=[[MyNuseryListViewController alloc]init];
        [self.navigationController pushViewController:nuserListVC animated:YES];
    }
    if (index==4) {
        YLDShopInteriorViewController *VCCCC=[[YLDShopInteriorViewController alloc]init];
        [self.navigationController pushViewController:VCCCC animated:YES];
    }
    if (index==5) {
        ZIKMyShopViewController *viewC=[[ZIKMyShopViewController alloc]init];
        viewC.type=0;
        viewC.memberUid = APPDELEGATE.userModel.access_id;
        [self.navigationController pushViewController:viewC animated:YES];
    }
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
