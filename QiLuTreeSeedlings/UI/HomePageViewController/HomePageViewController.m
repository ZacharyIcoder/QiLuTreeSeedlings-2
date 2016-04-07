//
//  HomePageViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/1/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "HomePageViewController.h"
#import "UIDefines.h"
#import "AdvertView.h"
#import "CircleViews.h"
#import "YouLickView.h"
#import "HotBuyView.h"
#import "HotSellView.h"
#import "HttpClient.h"
#import "SearchViewController.h"
#import "HotSellModel.h"
#import "GusseYourLikeModel.h"
#import "HotBuyModel.h"
#import "DataCache.h"
#import "LoginViewController.h"
#import "FaBuViewController.h"
#import "MyCollectViewController.h"
#import "BuyDetialInfoViewController.h"
#import "SellDetialViewController.h"
#import "MJRefresh.h"
#import "ZIKMyCustomizedInfoViewController.h"
//#import "ViewController.h"
@interface HomePageViewController ()<AdvertDelegate,HotBuyViewsDelegate,HotSellViewDelegate,CircleViewsDelegate,YouLickViewDelegate>
@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong)NSArray *productDataAry;//猜你习惯
@property (nonatomic,strong)NSArray *supplyDataAry;//热门供应
@property (nonatomic,strong)NSArray *BuyDataAry;//热门求购
@property (nonatomic,strong)CircleViews *circleViews;
@property (nonatomic,strong)UIButton *loginBtn;
@property (nonatomic,strong) HotSellView *hotSellView;
@property (nonatomic,strong) HotBuyView *hotBuyView;
@end

@implementation HomePageViewController
@synthesize backScrollView;
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (APPDELEGATE.isNeedLogin) {
        self.loginBtn.hidden=YES;
    }else
    {
        self.loginBtn.hidden=NO;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showTabBar" object:nil];
}

-(void)login
{
        self.loginBtn.hidden=YES;
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:@"login" object:nil];
  
    HttpClient *httpClient=[HttpClient sharedClient];
    [httpClient getHomePageInfoSuccess:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            self.productDataAry=[GusseYourLikeModel creatGusseLikeAryByAry:[dic objectForKey:@"productList"]];
            self.supplyDataAry=[HotSellModel hotSellAryByAry:[dic objectForKey:@"supplyList"]];
            self.BuyDataAry=[HotBuyModel creathotBuyModelAryByAry:[dic objectForKey:@"newBuyList"]];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:dic forKey:@"homePageCache"];
            [userDefaults synchronize];
            if (!_hotSellView) {
                [self creatViewByNetInfo];
            }else
            {
                _hotSellView.dataAry=self.supplyDataAry;
                _hotBuyView.dataAry=self.BuyDataAry;
            }
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fabuBtnAction) name:@"fabuBtnAction" object:nil];
    backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, kWidth, kHeight-44)];
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.backScrollView addHeaderWithCallback:^{
        [weakSelf reloadSlefMessage];
    }];

    [backScrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [backScrollView setBackgroundColor:BGColor];
    [self.view addSubview:backScrollView];
     self.navigationController.navigationBarHidden=YES;
    [self.view setBackgroundColor:[UIColor yellowColor]];
    UIView *selfNavView=[self makeSelfNavigationView];
    [self.view addSubview:selfNavView];
    CGRect tempFrame=CGRectMake(0, 0, kWidth,160/568.f*kHeight);
    AdvertView *advertView=[[AdvertView alloc]initWithFrame:tempFrame];
    advertView.delegate=self;
    [advertView setAdInfo];
    [advertView adStart];
    [self.backScrollView addSubview:advertView];
    tempFrame.origin.y+= 160/568.f*kHeight;
    tempFrame.size.height=100;
    CircleViews *circleView=[[CircleViews alloc]initWithFrame:tempFrame];
    self.circleViews=circleView;
    circleView.delegate=self;
    [self.backScrollView addSubview:circleView];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefaults objectForKey:@"homePageCache"];
    if (dic) {
        self.productDataAry=[GusseYourLikeModel creatGusseLikeAryByAry:[dic objectForKey:@"productList"]];
        self.supplyDataAry=[HotSellModel hotSellAryByAry:[dic objectForKey:@"supplyList"]];
        self.BuyDataAry=[HotBuyModel creathotBuyModelAryByAry:[dic objectForKey:@"newBuyList"]];
        [self creatViewByNetInfo];
    }
   // [self creatViewByNetInfo];
}
-(void)reloadSlefMessage
{
    HttpClient *httpClient=[HttpClient sharedClient];
    [httpClient getHomePageInfoSuccess:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            self.productDataAry=[GusseYourLikeModel creatGusseLikeAryByAry:[dic objectForKey:@"productList"]];
            self.supplyDataAry=[HotSellModel hotSellAryByAry:[dic objectForKey:@"supplyList"]];
            self.BuyDataAry=[HotBuyModel creathotBuyModelAryByAry:[dic objectForKey:@"newBuyList"]];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:dic forKey:@"homePageCache"];
            [userDefaults synchronize];
            if (!_hotSellView) {
                [self creatViewByNetInfo];
            }else
            {
                _hotSellView.dataAry=self.supplyDataAry;
                _hotBuyView.dataAry=self.BuyDataAry;
            }
            
        }
        
    } failure:^(NSError *error) {
        
    }];

    [self.backScrollView headerEndRefreshing];
//    _hotSellView.dataAry=self.supplyDataAry;
//    _hotBuyView.dataAry=self.BuyDataAry;
}
-(UIView *)makeTitleViewWithTitle:(NSString *)title AndColor:(UIColor *)color andY:(CGFloat )y
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(10, y, kWidth, 36)];
     [view setBackgroundColor:[UIColor clearColor]];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 7, 5, 22)];
    [imageV setBackgroundColor:color];
  
    [view addSubview:imageV];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 36)];
    titleLab.text=title;
    [titleLab setTextColor:color];
    [titleLab setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:titleLab];
    [self.backScrollView addSubview:view];
    return view;
    
}

//构建导航栏
-(UIView *)makeSelfNavigationView
{
    UIView *selfNavC=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    [selfNavC setBackgroundColor:NavColor];
    UIButton *loginBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 22, 40, 32)];
    [loginBtn setBackgroundColor:[UIColor clearColor]];
    [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn = loginBtn;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [selfNavC addSubview:loginBtn];
    
    UIButton *searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(52, 24, kWidth-100, 32)];
//    [searchBtn setBackgroundColor:[UIColor colorWithRed:199/255.f green:199/255.f blue:199/255.f alpha:1]];
    [searchBtn setBackgroundColor:[UIColor whiteColor]];
    searchBtn.layer.masksToBounds=YES;
    searchBtn.layer.cornerRadius=4;
    UILabel *searchLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, searchBtn.bounds.size.width-10, searchBtn.bounds.size.height)];
    [searchLab setFont:[UIFont systemFontOfSize:15]];
    [searchLab setTextColor:[UIColor grayColor]];
    [searchBtn addSubview:searchLab];
    [searchLab setText:@"请输入苗木关键词"];
    UIImageView *searchImageV=[[UIImageView alloc]initWithFrame:CGRectMake(searchBtn.frame.size.width-36, 4, 27, 27)];
    [searchImageV setImage:[UIImage imageNamed:@"searchBtnAction"]];
    [searchBtn addSubview:searchImageV];
    [searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [selfNavC addSubview:searchBtn];
    return selfNavC;
}

- (void)creatViewByNetInfo {
    CGRect tempFrame=self.circleViews.frame;
    tempFrame.origin.y+=tempFrame.size.height;
    
    [self makeTitleViewWithTitle:@"猜你喜欢" AndColor:[UIColor colorWithRed:253/255.f green:100/255.f blue:0 alpha:1] andY:tempFrame.origin.y];
    //[self.backScrollView addSubview:likeTitleV];
    tempFrame.origin.y+=36;
    tempFrame.size.height=120;
    YouLickView *lickView=[[YouLickView alloc]initWithFrame:tempFrame WithAry:self.productDataAry];
    lickView.delegate=self;
    [self.backScrollView addSubview:lickView];
    
    
    UIView *hotBuyTitleV=[self makeTitleViewWithTitle:@"热门求购" AndColor:[UIColor orangeColor] andY:CGRectGetMaxY(lickView.frame)];
   // [self.backScrollView addSubview:hotBuyTitleV];
    UIButton *moreHotBuyBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, 0, 40, 36)];
    [moreHotBuyBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreHotBuyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    UIImageView *hotMoreRowImgV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-35, 10.5, 15, 15)];
    [hotMoreRowImgV setImage:[UIImage imageNamed:@"moreRow"]];
    [hotBuyTitleV addSubview:hotMoreRowImgV];
    [moreHotBuyBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [moreHotBuyBtn addTarget:self action:@selector(moreBtnHotAction:) forControlEvents:UIControlEventTouchUpInside];
    [hotBuyTitleV addSubview:moreHotBuyBtn];
    HotBuyView *hotBView=[[HotBuyView alloc]initWithAry:self.BuyDataAry andY:CGRectGetMaxY(hotBuyTitleV.frame)];
    self.hotBuyView=hotBView;
    hotBView.delegate=self;
    [self.backScrollView addSubview:hotBView];
    // [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(hotBView.frame))];
    
    UIView *hotSellTitleV=[self makeTitleViewWithTitle:@"热门供应" AndColor:NavColor andY:CGRectGetMaxY(hotBView.frame)];
    UIButton *moreHotSellBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, 0, 40, 36)];
    [moreHotSellBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreHotSellBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [moreHotSellBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [moreHotSellBtn addTarget:self action:@selector(moreBtnHotSellAction:) forControlEvents:UIControlEventTouchUpInside];
    [hotSellTitleV addSubview:moreHotSellBtn];
    UIImageView *sellMoreRowImgV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-35, 10.5, 15, 15)];
    [sellMoreRowImgV setImage:[UIImage imageNamed:@"moreRow"]];
    [hotSellTitleV addSubview:sellMoreRowImgV];

    //[self.backScrollView addSubview:hotSellTitleV];
    // [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(hotSellTitleV.frame))];
    HotSellView *hotSellV=[[HotSellView alloc]initWith:CGRectGetMaxY(hotSellTitleV.frame) andAry:self.supplyDataAry];
     self.hotSellView=hotSellV;
    [self.backScrollView addSubview:hotSellV];
    hotSellV.delegate=self;
    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(hotSellV.frame))];
}
//更多热门求购按钮
-(void)moreBtnHotAction:(UIButton *)sender
{
    [self hiddingSelfTabBar];
    SearchViewController *searchViewController=[[SearchViewController alloc]initWithSearchType:2];
    [self.navigationController pushViewController:searchViewController animated:YES];
}
//更多热门供应按钮
-(void)moreBtnHotSellAction:(UIButton *)sender
{
    [self hiddingSelfTabBar];
    SearchViewController *searchViewController=[[SearchViewController alloc]initWithSearchType:1];
    [self.navigationController pushViewController:searchViewController animated:YES];
}
//发布按钮
-(void)fabuBtnAction
{
    if([APPDELEGATE isNeedLogin]==NO)
    {
        [self hiddingSelfTabBar];
        LoginViewController *loginViewController=[[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginViewController animated:YES];

       [ToastView showTopToast:@"请先登录"];
        return;
    }
    
    if (self.tabBarController.selectedIndex==1) {
        return;
    }
    [self hiddingSelfTabBar];
    FaBuViewController *fbVC=[[FaBuViewController alloc]init];
    [self.navigationController pushViewController:fbVC animated:YES];
}
//登录按钮
-(void)loginBtnAction
{
   // NSLog(@"登录");
    [self hiddingSelfTabBar];
    LoginViewController *loginViewController=[[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}
//搜索按钮
-(void)searchBtnAction
{
    [self hiddingSelfTabBar];
    SearchViewController *searchViewController=[[SearchViewController alloc]initWithSearchType:1 andSaerChStr:@""];
    [self.navigationController pushViewController:searchViewController animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//广告栏点击
-(void)advertPush:(NSInteger)index
{
    NSLog(@"点击了广告栏的%ld",(long)index);
}
//猜你喜欢点击效果
-(void)YouLickViewsPush:(GusseYourLikeModel *)model
{
    
        SearchViewController *searVC=[[SearchViewController alloc]initWithSearchType:model.type andSaerChStr:model.productName];
        [self hiddingSelfTabBar];
        [self.navigationController pushViewController:searVC animated:YES];
        return;
    
}
-(void)HotBuyViewsPush:(HotBuyModel *)model
{
      //NSLog(@"点击了热门求购的%ld",(long)index);
    if (!model) {
        return;
    }
    BuyDetialInfoViewController *buyDetialVC=[[BuyDetialInfoViewController alloc]initWithSaercherInfo:model.uid];
    [self hiddingSelfTabBar];
    [self.navigationController pushViewController:buyDetialVC animated:YES];

}
-(void)HotSellViewsPush:(HotSellModel *)model
{
    if (!model) {
        return;
    }
    SellDetialViewController *sellDetialVC=[[SellDetialViewController alloc]initWithUid:model];
    [self hiddingSelfTabBar];
    [self.navigationController pushViewController:sellDetialVC animated:YES];
}
//圆形按钮
-(void)circleViewsPush:(NSInteger)index
{
    if (index==0) {
        SearchViewController *searVC=[[SearchViewController alloc]initWithSearchType:1];
        [self hiddingSelfTabBar];
        [self.navigationController pushViewController:searVC animated:YES];
        return;
    }
    if(index==1)
    {
        SearchViewController *searVC=[[SearchViewController alloc]initWithSearchType:2];
        [self hiddingSelfTabBar];
        [self.navigationController pushViewController:searVC animated:YES];
        return;
    }
    
    if (index==2) {
        if([APPDELEGATE isNeedLogin])
        {
            MyCollectViewController *myCollectVC=[[MyCollectViewController alloc]init];
            [self hiddingSelfTabBar];
            [self.navigationController pushViewController:myCollectVC animated:YES];
            return;

        }else
        {
            [ToastView showTopToast:@"请先登录"];
        }
        
    }
    if(index==3){
        if([APPDELEGATE isNeedLogin])
        {
            [self hiddingSelfTabBar];
            ZIKMyCustomizedInfoViewController *customInfoVC = [[ZIKMyCustomizedInfoViewController alloc] init];
            [self.navigationController pushViewController:customInfoVC animated:YES];
            return;
            
        }else
        {
            [ToastView showTopToast:@"请先登录"];
        }

        
    }
}
-(void)hiddingSelfTabBar
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HidenTabBar" object:nil];
}

@end
