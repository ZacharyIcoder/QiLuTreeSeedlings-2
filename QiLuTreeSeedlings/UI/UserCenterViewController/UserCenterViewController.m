//
//  UserCenterViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/1/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "UserCenterViewController.h"
//#import "ViewController.h"
#import "CompanyViewController.h"
#import "UserBigInfoTableViewCell.h"
#import "UIDefines.h"
#import "UserInfoNomerTableViewCell.h"
#import "HttpClient.h"
#import "MyCollectViewController.h"
#import "ZIKMySupplyViewController.h"
#import "MyNuseryListViewController.h"
#import "MyBuyListViewController.h"
#import "FaBuViewController.h"
@interface UserCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation UserCenterViewController
-(void)dealloc
{
       [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [APPDELEGATE reloadUserInfoSuccess:^(id responseObject) {
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showTabBar" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=YES;
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fabuBtnAction) name:@"fabuBtnAction" object:nil];
//    [self.view setBackgroundColor:[UIColor redColor]];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-3) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[self.tableView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.tableView];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0||section==3||section==4) {
        return 1;
    }
    if (section==1||section==2) {
        return 3;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 280;
    }else
        return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.01;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==4) {
        return 70;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view;
    if (section==4) {
        
        view=[[UIView alloc]init];
        UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(40, 10, kWidth-80, 44)];
        [view addSubview:backView];
        [backView setBackgroundColor:NavColor];
       
        UIImageView *iamgeV=[[UIImageView alloc]initWithFrame:CGRectMake(backView.frame.size.width/2-60, 10, 24, 24)];
        iamgeV.image=[UIImage imageNamed:@"loginoutimage"];
        [backView addSubview:iamgeV];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(backView.frame.size.width/2-20, 0, 100, 44)];
        [titleLab setText:@"退出登录"];
        [backView addSubview:titleLab];
        [titleLab setTextColor:[UIColor whiteColor]];
        UIButton *lgoutBtn=[[UIButton alloc]initWithFrame:backView.bounds];
        [lgoutBtn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:lgoutBtn];
    }
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UserBigInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[UserBigInfoTableViewCell IDstr]];
        
        if (!cell) {
            cell=[[UserBigInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 280)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.collectBtn addTarget:self action:@selector(mycollectBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.interBtn addTarget:self action:@selector(myJifenBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.setingBtn addTarget:self action:@selector(setingBtn) forControlEvents:UIControlEventTouchUpInside];

        }
        if (APPDELEGATE.userModel.name) {
            cell.model=APPDELEGATE.userModel;
        }
       
        return cell;
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"mySellImageV" andTitle:@"我的供应"];
            return cell;
        }
        if (indexPath.row==1) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"myBuyV" andTitle:@"我的求购"];
            return cell;
        }
        if (indexPath.row==2) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"myReadMessage" andTitle:@"我的订制信息"];
            return cell;
        }
    }
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"mycompany" andTitle:@"我的企业"];
            return cell;
        }
        if (indexPath.row==1) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"myMiaoPu" andTitle:@"我的苗圃"];
            return cell;
        }
        if (indexPath.row==2) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"zhanzhangtong" andTitle:@"站长通"];
            return cell;
        }
     
    }
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"myPalyInfo" andTitle:@"支付信息"];
            return cell;
        }
        
    }
    
    
    if (indexPath.section==4 ) {
        if (indexPath.row==0) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"myShareImage" andTitle:@"我的分享"];
            return cell;
        }
        
    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}

-(void)fabuBtnAction
{
    if (self.tabBarController.selectedIndex==0) {
        return;
    }
    
    [self hiddingSelfTabBar];
    FaBuViewController *fbVC=[[FaBuViewController alloc]init];
    [self.navigationController pushViewController:fbVC animated:YES];
//    ViewController *viewCCC=[[ViewController alloc]init];
//    [self.navigationController pushViewController:viewCCC animated:YES];
}
#pragma mark-我的设置
-(void)settingUserInfo
{
     NSLog(@"设置");
}
#pragma mark-我的收藏
-(void)mycollectBtnAction
{
    MyCollectViewController *myCollectVC=[MyCollectViewController new];
    [self hiddingSelfTabBar];
    [self.navigationController pushViewController:myCollectVC animated:YES];
}
#pragma mark-我的积分
-(void)myJifenBtnAction
{
    NSLog(@"积分");
}
#pragma mark-退出登录
-(void)logoutAction
{
   [HTTPCLIENT logoutInfoByToken:APPDELEGATE.userModel.access_token byAccessId:APPDELEGATE.userModel.access_id Success:^(id responseObject) {
       
       if ([[responseObject objectForKey:@"success"] integerValue]) {
           self.tabBarController.selectedIndex=0;
           [APPDELEGATE logoutAction];
       }
   } failure:^(NSError *error) {
       
   }];
    
}
-(void)hiddingSelfTabBar
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HidenTabBar" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            NSLog(@"企业信息");
            [self hiddingSelfTabBar];
            CompanyViewController *companyVC=[[CompanyViewController alloc]init];
            [self.navigationController pushViewController:companyVC animated:YES];
            return;
        }
        if (indexPath.row==1) {
            [self hiddingSelfTabBar];
            MyNuseryListViewController *nuserListVC=[[MyNuseryListViewController alloc]init];
            [self.navigationController pushViewController:nuserListVC animated:YES];
            return;
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSLog(@"我的供应");
            [self hiddingSelfTabBar];
            ZIKMySupplyViewController *mySupplyVC = [[ZIKMySupplyViewController alloc] init];
            [self.navigationController pushViewController:mySupplyVC animated:YES];
        }
        if (indexPath.row==1) {
            [self hiddingSelfTabBar];
            //我的求购
            MyBuyListViewController *myBuyListVC=[[MyBuyListViewController alloc]init];
            [self.navigationController pushViewController:myBuyListVC animated:YES];
            return ;
        }

    }


}
@end
