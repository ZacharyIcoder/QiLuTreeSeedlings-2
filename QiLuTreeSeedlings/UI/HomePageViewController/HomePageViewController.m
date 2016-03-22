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
//#import "ViewController.h"
@interface HomePageViewController ()<AdvertDelegate,HotBuyViewsDelegate,HotSellViewDelegate,CircleViewsDelegate>
@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong)NSArray *productDataAry;//猜你习惯
@property (nonatomic,strong)NSArray *supplyDataAry;//热门供应
@property (nonatomic,strong)NSArray *BuyDataAry;//热门求购
@property (nonatomic,strong)CircleViews *circleViews;
@property (nonatomic,strong)UIButton *loginBtn;
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


- (void)viewDidLoad {
    [super viewDidLoad];
   
    HttpClient *httpClient=[HttpClient sharedClient];
    [httpClient getHomePageInfoSuccess:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            self.productDataAry=[GusseYourLikeModel creatGusseLikeAryByAry:[dic objectForKey:@"productList"]];
            self.supplyDataAry=[HotSellModel hotSellAryByAry:[dic objectForKey:@"supplyList"]];
            self.BuyDataAry=[dic objectForKey:@"newBuyList"];
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//            [[DataCache shareDateCache]saveWithData:jsonData path:@"shouye"];
           // NSLog(@"%@",dic);
            [self creatViewByNetInfo];
        }
        
    } failure:^(NSError *error) {
        
    }];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fabuBtnAction) name:@"fabuBtnAction" object:nil];
    backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, kWidth, kHeight-44)];
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
   // [self creatViewByNetInfo];
}
-(UIView *)makeTitleViewWithTitle:(NSString *)title AndColor:(UIColor *)color andY:(CGFloat )y
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(10, y, 80, 30)];
     [view setBackgroundColor:[UIColor clearColor]];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 5, 20)];
    [imageV setBackgroundColor:color];
  
    [view addSubview:imageV];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 30)];
    titleLab.text=title;
    [titleLab setTextColor:color];
    [view addSubview:titleLab];
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
    
    UIButton *searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(55, 24, kWidth-110, 32)];
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
    
    UIView *likeTitleV=[self makeTitleViewWithTitle:@"猜你喜欢" AndColor:[UIColor colorWithRed:254/255.f green:172/255.f blue:0 alpha:1] andY:tempFrame.origin.y];
    [self.backScrollView addSubview:likeTitleV];
    tempFrame.origin.y+=30;
    tempFrame.size.height=120;
    YouLickView *lickView=[[YouLickView alloc]initWithFrame:tempFrame WithAry:self.productDataAry];
    [self.backScrollView addSubview:lickView];
    
    
    UIView *hotBuyTitleV=[self makeTitleViewWithTitle:@"热门求购" AndColor:[UIColor greenColor] andY:CGRectGetMaxY(lickView.frame)];
    [self.backScrollView addSubview:hotBuyTitleV];
    HotBuyView *hotBView=[[HotBuyView alloc]initWithAry:@[@"",@"",@"",@"",@""] andY:CGRectGetMaxY(hotBuyTitleV.frame)];
    hotBView.delegate=self;
    [self.backScrollView addSubview:hotBView];
    // [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(hotBView.frame))];
    
    UIView *hotSellTitleV=[self makeTitleViewWithTitle:@"热门供应" AndColor:[UIColor orangeColor] andY:CGRectGetMaxY(hotBView.frame)];
    [self.backScrollView addSubview:hotSellTitleV];
    // [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(hotSellTitleV.frame))];
    HotSellView *hotSellV=[[HotSellView alloc]initWith:CGRectGetMaxY(hotSellTitleV.frame) andAry:self.supplyDataAry];
    [self.backScrollView addSubview:hotSellV];
    hotSellV.delegate=self;
    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(hotSellV.frame))];
}
//发布按钮
-(void)fabuBtnAction
{
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
-(void)HotBuyViewsPush:(NSInteger)index
{
      NSLog(@"点击了热门求购的%ld",(long)index);
}
-(void)HotSellViewsPush:(NSInteger)index
{
    NSLog(@"点击了出售的%ld",(long)index);
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
}
-(void)hiddingSelfTabBar
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HidenTabBar" object:nil];
}

@end
