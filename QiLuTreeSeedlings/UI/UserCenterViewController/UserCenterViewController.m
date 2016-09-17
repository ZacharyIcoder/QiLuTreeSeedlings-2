//
//  UserCenterViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/1/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "UserCenterViewController.h"
#import "CompanyViewController.h"
#import "UserBigInfoTableViewCell.h"
#import "UIDefines.h"
#import "UserInfoNomerTableViewCell.h"
#import "HttpClient.h"
#import "MyCollectViewController.h"
#import "LoginViewController.h"
#import "MyNuseryListViewController.h"
#import "UINavController.h"
#import "YLDMyBuyListViewController.h"
#import "FaBuViewController.h"
#import "ZIKUserInfoSetViewController.h"
#import "MyIntegralViewController.h"
#import "ZIKMyBalanceViewController.h"
#import "ZIKMyCustomizedInfoViewController.h"
#import "SettingViewController.h"
#import "UserBigInfoView.h"
//友盟分享
#import "UMSocialControllerService.h"
#import "UMSocial.h"
//end 友盟分享
#import "BaseTabBarController.h"
#import "ZIKStationAgentViewController.h"//站长通
#import "ZIKMySupplyVC.h"//我的供应列表
#import "ZIKPurchaseRecordsViewController.h"//购买记录
#import "MyMessageViewController.h"
#import "KeFuViewController.h"
#import "YLDShengJiViewViewController.h"
#import "YLDGCGSZiZhiTiJiaoViewController.h"
#import "ZIKMyShopViewController.h"//我的店铺
#import "ZIKStationTabBarViewController.h"//站长助手
#import "YLDGongChengGongSiViewController.h"//工程助手
#import "LYDGCGSTiShiViewController.h"
#import "ZIKHelpfulHintsViewController.h"
#import "YLDShopMessageViewController.h"//我的店铺第二版
@interface UserCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UserBigInfoViewDelegate,UMSocialUIDelegate>
@property (nonatomic,strong)UserBigInfoView *userBigInfoV;
@property (nonatomic,strong)UIView *logoutView;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong) NSString       *shareText; //分享文字
@property (nonatomic, strong) NSString       *shareTitle;//分享标题
@property (nonatomic, strong) UIImage        *shareImage;//分享图片
@property (nonatomic, strong) NSString       *shareUrl;  //分享url

@end

@implementation UserCenterViewController
-(void)dealloc
{
       [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.userBigInfoV.model=APPDELEGATE.userModel;
    [self.tableView reloadData];
    [APPDELEGATE reloadUserInfoSuccess:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"success"]integerValue]) {
            [self.tableView reloadData];
            self.userBigInfoV.model=APPDELEGATE.userModel;
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showTabBar" object:nil];
}

-(void)pushMessageForDingzhiXinXi:(NSNotification *)notification
{
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
//    BaseTabBarController *baseB=(BaseTabBarController *)self.tabBarController;
//    baseB.homePageBtn.selected=NO;
//    baseB.userInfoBtn.selected=YES;
//    [baseB.homePageLab setTextColor:[UIColor lightGrayColor]];
//    [baseB.userLab setTextColor:NavColor];
    if (self.tabBarController.selectedIndex!=1) {
        return;
    }
    ZIKMyCustomizedInfoViewController *zikMyCustomInfoVC=[[ZIKMyCustomizedInfoViewController alloc]init];
    if ([notification.object isEqualToString:@"1"]) {
        
       [self.navigationController pushViewController:zikMyCustomInfoVC animated:YES];
    }else if([notification.object isEqualToString:@"2"])
    {
        ZIKMyCustomizedInfoViewController *civc = [[ZIKMyCustomizedInfoViewController alloc] init];
        civc.infoType = InfoTypeStation;
//        civc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:civc animated:YES];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMessageForDingzhiXinXi:) name:@"dingzhixinxituisong" object:nil];
    // Do any additional setup after loading the view.
    UserBigInfoView *userbigInfoV=[[UserBigInfoView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 200)];
    userbigInfoV.userDelegate=self;
    
    [self.view addSubview:userbigInfoV];
    self.userBigInfoV=userbigInfoV;
    [userbigInfoV.setingBtn addTarget:self action:@selector(setBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBarHidden=YES;
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fabuBtnAction) name:@"fabuBtnAction" object:nil];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 200, kWidth, kHeight-244) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    if ([APPDELEGATE isNeedLogin]) {
        self.userBigInfoV.model=APPDELEGATE.userModel;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0||section==3||section==4||section==5) {
        return 1;
    }
    if (section==1) {
        return 4;
    }
    if(section==2)
    {

        return 5;

    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 80;
    }
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
    if (section==5) {
        return 70;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view;
    if (section==5) {
        
        view=[[UIView alloc]init];
        UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(40, 10, kWidth-80, 44)];
        [view addSubview:backView];
        [backView setBackgroundColor:NavColor];
       
        UIImageView *iamgeV=[[UIImageView alloc]initWithFrame:CGRectMake(backView.frame.size.width/2-60, 10, 24, 24)];
        iamgeV.image=[UIImage imageNamed:@"loginoutimage"];
        [backView addSubview:iamgeV];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(backView.frame.size.width/2-20, 0, 100, 44)];
        [titleLab setText:@"退出登录"];
        self.logoutView=backView;
        [backView addSubview:titleLab];
        [titleLab setTextColor:[UIColor whiteColor]];
        UIButton *lgoutBtn=[[UIButton alloc]initWithFrame:backView.bounds];
        if ([APPDELEGATE isNeedLogin]) {
            backView.hidden=NO;
        }else{
            backView.hidden=YES;
        }
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
            cell=[[UserBigInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 80)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.collectBtn addTarget:self action:@selector(mycollectBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.interBtn addTarget:self action:@selector(myJifenBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.messageBtn addTarget:self action:@selector(myMessageBtnAciotn) forControlEvents:UIControlEventTouchUpInside];
            [cell.shengJiBtn addTarget:self action:@selector(shengjiBtnAction) forControlEvents:UIControlEventTouchUpInside];

        }

        if (APPDELEGATE.userModel.name) {
            cell.model=APPDELEGATE.userModel;
        }
       
        return cell;
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"mySellImageV" andTitle:@"我的供应"];
            UILabel *shareLabel = [[UILabel alloc] init];
            shareLabel.frame = CGRectMake(Width-35-180, 12, 180, 20);
            shareLabel.text = @"供应信息可分享到微信、QQ";
            shareLabel.font = [UIFont systemFontOfSize:12.0f];
            shareLabel.textColor = detialLabColor;
            shareLabel.textAlignment = NSTextAlignmentRight;
            [cell addSubview:shareLabel];
            return cell;

        }
        if (indexPath.row==1) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"myBuyV" andTitle:@"我的求购"];
            return cell;
        }
        if (indexPath.row==2) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"myReadMessage" andTitle:@"我的订制信息"];
            UILabel *priceLabel = [[UILabel alloc] init];
            priceLabel.frame = CGRectMake(Width-35-180, 12, 180, 20);
            if (APPDELEGATE.userModel.noReadCount.integerValue != 0) {
                priceLabel.text = [NSString stringWithFormat:@"未读:%ld",(long)APPDELEGATE.userModel.noReadCount.integerValue];
            }
            priceLabel.font = [UIFont systemFontOfSize:12.0f];
            priceLabel.textColor = yellowButtonColor;
            priceLabel.textAlignment = NSTextAlignmentRight;
            [cell addSubview:priceLabel];
            return cell;
        }
        if (indexPath.row == 3) {
            UserInfoNomerTableViewCell *cell = [[UserInfoNomerTableViewCell alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"个人中心-购买记录" andTitle:@"购买记录"];
            return cell;
        }
    }
    if (indexPath.section==2) {
        if (indexPath.row == 0) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"1个人中心-我的店铺" andTitle:@"我的店铺"];
            return cell;
        }
        if (indexPath.row==1) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"mycompany" andTitle:@"我的企业"];
            return cell;
        }
        if (indexPath.row==2) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"myMiaoPu" andTitle:@"我的苗圃"];
//            if (APPDELEGATE.userModel.isworkstation) {
//                cell.lineImage.hidden=NO;
//            }else
//            {
//                cell.lineImage.hidden=YES;
//            }
            return cell;
        }
        if (indexPath.row == 3) {
            UserInfoNomerTableViewCell *cell = [[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"站长通" andTitle:@"站长助手"];
            return  cell;
        }
        if (indexPath.row == 4) {
            UserInfoNomerTableViewCell *cell = [[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"个人中心-列表-工程公司" andTitle:@"工程助手"];
            return  cell;
        }


//        if (indexPath.row==2) {
//            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"zhanzhangtong" andTitle:@"站长通"];
//            return cell;
//        }
//        if (indexPath.row==3) {
//            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"个人中心-列表-工程公司" andTitle:@"工程公司"];
//            return cell;
//        }

     
    }
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"myPalyInfo" andTitle:@"我的余额"];
            UILabel *priceLabel = [[UILabel alloc] init];
            priceLabel.frame = CGRectMake(Width-35-180, 12, 180, 20);
            if (APPDELEGATE.userModel.balance) {
                priceLabel.text = [NSString stringWithFormat:@"账户余额:¥%.2f",APPDELEGATE.userModel.balance.floatValue];
            }
            priceLabel.font = [UIFont systemFontOfSize:12.0f];
            priceLabel.textColor = detialLabColor;
            priceLabel.textAlignment = NSTextAlignmentRight;
            [cell addSubview:priceLabel];
            return cell;
        }
        
    }
    
    
    if (indexPath.section==4 ) {
        if (indexPath.row==0) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"myShareImage" andTitle:@"我的分享"];
            return cell;
        }
    }
    if (indexPath.section==5) {
        if (indexPath.row==0) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"kefuxitong" andTitle:@"客服系统"];
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
    if([APPDELEGATE isNeedLogin]==NO)
    {
        [self hiddingSelfTabBar];
        LoginViewController *loginViewController=[[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginViewController animated:YES];
        [ToastView showTopToast:@"请先登录"];
        
        return;
    }
    [self hiddingSelfTabBar];
    FaBuViewController *fbVC=[[FaBuViewController alloc]init];
    [self.navigationController pushViewController:fbVC animated:YES];
}

#pragma mark - 设置
- (void)setBtnAction {
    SettingViewController *setVC =  [[SettingViewController alloc] init];
    [self hiddingSelfTabBar];
    [self.navigationController pushViewController:setVC animated:YES];
}

#pragma mark - 我的设置
-(void)clickedHeadImage
{
    if (![APPDELEGATE isNeedLogin]) {
        LoginViewController *loginViewController=[[LoginViewController alloc]init];
         [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
    ZIKUserInfoSetViewController *setVC = [[ZIKUserInfoSetViewController alloc] init];
    [self hiddingSelfTabBar];
    [self.navigationController pushViewController:setVC animated:YES];
}

#pragma mark-我的收藏
-(void)mycollectBtnAction
{
    if (![APPDELEGATE isNeedLogin]) {
        LoginViewController *loginViewController=[[LoginViewController alloc]init];
         [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
    MyCollectViewController *myCollectVC=[MyCollectViewController new];
    [self hiddingSelfTabBar];
    [self.navigationController pushViewController:myCollectVC animated:YES];
}
#pragma mark-我的消息
-(void)myMessageBtnAciotn
{
    if (![APPDELEGATE isNeedLogin]) {
        LoginViewController *loginViewController=[[LoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }

    MyMessageViewController *myMessageVieController=[[MyMessageViewController alloc]init];
    [self hiddingSelfTabBar];
    [self.navigationController pushViewController:myMessageVieController animated:YES];
}
#pragma mark-我的积分
-(void)myJifenBtnAction
{
    if (![APPDELEGATE isNeedLogin]) {
        LoginViewController *loginViewController=[[LoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
     MyIntegralViewController *myCollectVC=[MyIntegralViewController new];
    [self hiddingSelfTabBar];
    [self.navigationController pushViewController:myCollectVC animated:YES];
}
#pragma mark-退出登录
-(void)logoutAction
{
   [HTTPCLIENT logoutInfoByToken:APPDELEGATE.userModel.access_token byAccessId:APPDELEGATE.userModel.access_id Success:^(id responseObject) {
       
       if ([[responseObject objectForKey:@"success"] integerValue]) {
          
           self.logoutView.hidden=NO;
           [APPDELEGATE logoutAction];
           self.userBigInfoV.model=APPDELEGATE.userModel;
           [self.tableView reloadData];
            
       }else{
           [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
       }
   } failure:^(NSError *error) {
       
   }];
    
}
-(void)hiddingSelfTabBar
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HidenTabBar" object:nil];
}
#pragma mark-身份升级
-(void)shengjiBtnAction
{
    if (![APPDELEGATE isNeedLogin]) {
        LoginViewController *loginViewController=[[LoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
    CLog(@"%ld",APPDELEGATE.userModel.projectCompanyStatus);
    if (APPDELEGATE.userModel.goldsupplierStatus!=0) {
        [ToastView showTopToast:@"您已具备身份，不需升级"];
        return;
    }
    ShowActionV();
    [HTTPCLIENT projectCompanyStatusSuccess:^(id responseObject) {
        if([[responseObject objectForKey:@"success"] integerValue])
        {
            APPDELEGATE.userModel.projectCompanyStatus=[[[responseObject objectForKey:@"result"] objectForKey:@"projectCompanyStatus"] integerValue];
            if (APPDELEGATE.userModel.projectCompanyStatus==-1) {
                [ToastView showTopToast:@"暂未审核，请耐心等待"];
                return;
            }
            
            if (APPDELEGATE.userModel.projectCompanyStatus==0) {
                [ToastView showTopToast:@"审核未通过"];
                YLDGCGSZiZhiTiJiaoViewController *yldsda=[[YLDGCGSZiZhiTiJiaoViewController alloc]initWithUid:@"xxxxxx"];
                
                [self hiddingSelfTabBar];
                [self.navigationController pushViewController:yldsda animated:YES];
                return;
            }
            YLDShengJiViewViewController *yldsda=[YLDShengJiViewViewController new];
            
            [self hiddingSelfTabBar];
            [self.navigationController pushViewController:yldsda animated:YES];
        }
        else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        RemoveActionV();
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
      if (indexPath.section==5) {
          if (indexPath.row==0) {
            KeFuViewController *kefuViewC=[[KeFuViewController alloc]init];
            
            [self hiddingSelfTabBar];
            [self.navigationController pushViewController:kefuViewC animated:YES];
            
            return;
          }
      }

            if (![APPDELEGATE isNeedLogin]) {
                LoginViewController *loginViewController=[[LoginViewController alloc]init];
                [ToastView showTopToast:@"请先登录"];
                UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
    
                [self presentViewController:navVC animated:YES completion:^{
    
                }];
                return;
     }
    if (indexPath.section==2) {
        if (indexPath.row == 0) {
            [self hiddingSelfTabBar];
//            ZIKMyShopViewController *shopVC = [[ZIKMyShopViewController alloc] init];
//            shopVC.memberUid = APPDELEGATE.userModel.access_id;
//            shopVC.type = 0;
//            [self.navigationController pushViewController:shopVC animated:YES];
            YLDShopMessageViewController *shopVC = [[YLDShopMessageViewController alloc]init];
            [self.navigationController pushViewController:shopVC animated:YES];
            return;
        }
        if (indexPath.row==1) {
            //NSLog(@"企业信息");
            [self hiddingSelfTabBar];
            CompanyViewController *companyVC=[[CompanyViewController alloc]init];
            [self.navigationController pushViewController:companyVC animated:YES];
            return;
        }
        if (indexPath.row==2) {
            [self hiddingSelfTabBar];
            MyNuseryListViewController *nuserListVC=[[MyNuseryListViewController alloc]init];
            [self.navigationController pushViewController:nuserListVC animated:YES];
            return;
        }
        if (indexPath.row==3) {
//            NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"myphone"];
//            if (APPDELEGATE.userModel.goldsupplierStatus == 5 || APPDELEGATE.userModel.goldsupplierStatus  == 6 || [phone isEqualToString:@"15953523812"]) {
                [self hiddingSelfTabBar];

                ZIKStationTabBarViewController *stationtab = [[ZIKStationTabBarViewController alloc] init];
                [self.navigationController pushViewController:stationtab animated:YES];

//            } else {
//                if (APPDELEGATE.userModel.goldsupplierStatus!=0) {
//                    [ToastView showTopToast:[NSString stringWithFormat:@"您已具备%@身份",APPDELEGATE.userModel.goldsupplier]];
//                    return;
//                }
//                [self hiddingSelfTabBar];
//
//                ZIKHelpfulHintsViewController *helpfulVC = [[ZIKHelpfulHintsViewController alloc] initWithNibName:@"ZIKHelpfulHintsViewController" bundle:nil];
//                [self.navigationController pushViewController:helpfulVC animated:YES];
//            }
            return;

        }
        if (indexPath.row==4) {
//            if (APPDELEGATE.userModel.goldsupplierStatus==7||[APPDELEGATE.userModel.access_id isEqualToString:@"0F14ED77-78E2-4441-9F1A-8FE080C9A6C1"]) {
                [self hiddingSelfTabBar];
                YLDGongChengGongSiViewController *tab=[[YLDGongChengGongSiViewController alloc]init];
                [self.navigationController pushViewController:tab animated:YES];
//            }else{
//
//                if (APPDELEGATE.userModel.projectCompanyStatus==-1) {
//                    [ToastView showTopToast:@"暂未审核，请耐心等待"];
//                    return;
//                }
//
//                if (APPDELEGATE.userModel.projectCompanyStatus==0) {
//                    [ToastView showTopToast:@"审核未通过"];
//                    YLDGCGSZiZhiTiJiaoViewController *yldsda=[[YLDGCGSZiZhiTiJiaoViewController alloc]initWithUid:@"xxxxxx"];
//                    
//                    [self hiddingSelfTabBar];
//                    [self.navigationController pushViewController:yldsda animated:YES];
//                    return;
//                }
//
//                [self hiddingSelfTabBar];
//                LYDGCGSTiShiViewController *view=[[ LYDGCGSTiShiViewController  alloc]init];
//                [self.navigationController pushViewController:view animated:YES];
            }

//            [self hiddingSelfTabBar];
//            YLDGongChengGongSiViewController *nuserListVC=[[YLDGongChengGongSiViewController alloc]init];
//            [self.navigationController pushViewController:nuserListVC animated:YES];
//            return;
//        }

        /*         if (APPDELEGATE.userModel.goldsupplierStatus==7||[APPDELEGATE.userModel.access_id isEqualToString:@"0F14ED77-78E2-4441-9F1A-8FE080C9A6C1"]) {
         [self hiddingSelfTabBar];
         YLDGongChengGongSiViewController *tab=[[YLDGongChengGongSiViewController alloc]init];
         [self.navigationController pushViewController:tab animated:YES];
         }else{

         if (APPDELEGATE.userModel.projectCompanyStatus==-1) {
         [ToastView showTopToast:@"暂未审核，请耐心等待"];
         return;
         }

         if (APPDELEGATE.userModel.projectCompanyStatus==0) {
         [ToastView showTopToast:@"审核未通过"];
         return;
         }

         [self hiddingSelfTabBar];
         LYDGCGSTiShiViewController *view=[[ LYDGCGSTiShiViewController  alloc]init];
         [self.navigationController pushViewController:view animated:YES];
         }
*/

//        if (indexPath.row == 3) {
//            [self hiddingSelfTabBar];
//            ZIKStationAgentViewController *stationVC = [[ZIKStationAgentViewController alloc] init];
//            [self.navigationController pushViewController:stationVC animated:YES];
//            return;
//        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //NSLog(@"我的供应");
            [self hiddingSelfTabBar];
            //ZIKMySupplyViewController *mySupplyVC = [[ZIKMySupplyViewController alloc] init];
            ZIKMySupplyVC *mySupplyVC = [[ZIKMySupplyVC alloc] init];
            [self.navigationController pushViewController:mySupplyVC animated:YES];
        }
        if (indexPath.row==1) {
            [self hiddingSelfTabBar];
            //我的求购
            YLDMyBuyListViewController *myBuyListVC=[[YLDMyBuyListViewController alloc]init];
            [self.navigationController pushViewController:myBuyListVC animated:YES];
            return ;
        }
        if (indexPath.row == 2) {
            [self hiddingSelfTabBar];
            ZIKMyCustomizedInfoViewController *customInfoVC = [[ZIKMyCustomizedInfoViewController alloc] init];
            [self.navigationController pushViewController:customInfoVC animated:YES];
            return;
        }
        if (indexPath.row == 3) {
            [self hiddingSelfTabBar];
            //购买记录
            ZIKPurchaseRecordsViewController *prvc = [[ZIKPurchaseRecordsViewController alloc] init];
            [self.navigationController pushViewController:prvc animated:YES];
            return;
        }

    }
    else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            ZIKMyBalanceViewController *balanceVC = [[ZIKMyBalanceViewController alloc] init];
            [self hiddingSelfTabBar];
            [self.navigationController pushViewController:balanceVC animated:YES];
        }
    }
    else if (indexPath.section == 4) {
        //[self umengShare];
        ShowActionV();
        [HTTPCLIENT getMyShareSuccess:^(id responseObject) {
            if ([responseObject[@"success"] integerValue] == 0) {
                RemoveActionV();
                [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:kWidth/2 withSuperView:self.view];
                return ;
            }
            NSDictionary *shareDic = responseObject[@"result"];
            self.shareText   = shareDic[@"description"];
            self.shareTitle  = shareDic[@"title"];
            NSString *urlStr = shareDic[@"pic"];
            NSData * data    = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr]];
            self.shareImage  = [[UIImage alloc] initWithData:data];
            self.shareUrl    = shareDic[@"url"];
            RemoveActionV();
            [self umengShare];

        } failure:^(NSError *error) {
            RemoveActionV();
        }];
    }
}

- (void)umengShare {

//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         //appKey:@"569c3c37e0f55a8e3b001658"
//                                         appKey:@"56fde8aae0f55a1cd300047c"
//                                      shareText:@"定制精准信息，轻松买卖苗木，没有效果不花钱，下载注册即可赠送积分。"
//                                     shareImage:[UIImage imageNamed:@"logV@2x.png"]
//                                shareToSnsNames:@[UMShareToWechatTimeline,UMShareToQzone,UMShareToWechatSession,UMShareToQQ]
//                                       delegate:self];
    [UMSocialSnsService presentSnsIconSheetView:self
     //appKey:@"569c3c37e0f55a8e3b001658"
                                         appKey:@"56fde8aae0f55a1cd300047c"
                                      shareText:self.shareText
                                     shareImage:self.shareImage
                                shareToSnsNames:@[UMShareToWechatTimeline,UMShareToQzone,UMShareToWechatSession,UMShareToQQ]
                                       delegate:self];

    //[NSArray arrayWithObjects:UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,nil]
    //    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"sharTestQQ分享文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
    //        if (response.responseCode == UMSResponseCodeSuccess) {
    //            NSLog(@"分享成功！");
    //        }
    //    }];
    //当分享消息类型为图文时，点击分享内容会跳转到预设的链接，设置方法如下
    //NSString *urlString = @"https://itunes.apple.com/cn/app/miao-xin-tong/id1104131374?mt=8";
   // NSString *urlString = [NSString stringWithFormat:@"http://www.miaoxintong.cn:8081/qlmm/invitation/create?muid=%@",APPDELEGATE.userModel.access_id];
    NSString *urlString = self.shareUrl;


    [UMSocialData defaultData].extConfig.wechatSessionData.url = urlString;

    //如果是朋友圈，则替换平台参数名即可

    [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlString;

    [UMSocialData defaultData].extConfig.qqData.url    = urlString;
    [UMSocialData defaultData].extConfig.qzoneData.url = urlString;
    //设置微信好友title方法为
//    NSString *titleString = @"苗信通-苗木买卖神器";
    NSString *titleString = self.shareTitle;

    [UMSocialData defaultData].extConfig.wechatSessionData.title = titleString;

    //设置微信朋友圈title方法替换平台参数名即可

    [UMSocialData defaultData].extConfig.wechatTimelineData.title = titleString;

    //QQ设置title方法为

    [UMSocialData defaultData].extConfig.qqData.title = titleString;

    //Qzone设置title方法将平台参数名替换即可

    [UMSocialData defaultData].extConfig.qzoneData.title = titleString;

}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    //NSLog(@"didClose is %d",fromViewControllerType);
}

//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //NSLog(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        //NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

-(void)didFinishShareInShakeView:(UMSocialResponseEntity *)response
{
    //NSLog(@"finish share with response is %@",response);
}

@end
