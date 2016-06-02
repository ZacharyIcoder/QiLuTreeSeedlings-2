//
//  HomePageTViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/4/13.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "HomePageTViewController.h"
#import "MJRefresh.h"
#import "HttpClient.h"
#import "UIDefines.h"
#import "SearchViewController.h"
#import "LoginViewController.h"
#import "FaBuViewController.h"
#import "MyCollectViewController.h"
#import "BuyDetialInfoViewController.h"
#import "SellDetialViewController.h"
#import "ZIKMyCustomizedInfoViewController.h"
#import "AdvertView.h"
#import "CircleViews.h"
#import "YouLickView.h"
#import "GusseYourLikeModel.h"
#import "HotBuyModel.h"
#import "HotSellModel.h"
#import "BuySearchTableViewCell.h"
#import "SellSearchTableViewCell.h"
#import "SellDetialViewController.h"
#import "BigImageViewShowView.h"
#import "YLDGongChengGongSiViewController.h"
@interface HomePageTViewController ()<UITableViewDelegate,UITableViewDataSource,AdvertDelegate,CircleViewsDelegate,YouLickViewDelegate>
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong)NSArray *productDataAry;//猜你习惯
@property (nonatomic,strong)NSMutableArray *supplyDataAry;//热门供应
@property (nonatomic,strong)NSArray *BuyDataAry;//热门求购
@property (nonatomic)NSInteger PageCount;
@property (nonatomic,strong) BigImageViewShowView *bigImageViewShowView;
@property (nonatomic,strong) UIView *NavView;
@property (nonatomic,strong) UIButton *searchBtn;
@property (nonatomic,strong) UIImageView *sreachiamgeV;
@end

@implementation HomePageTViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)pushMessageForDingzhiXinXi:(NSNotification *)notification
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BGColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMessageForDingzhiXinXi:) name:@"dingzhixinxituisong" object:nil];
    _PageCount=1;
    self.navigationController.navigationBar.hidden=YES;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:@"login" object:nil];
     _NavView =[self makeSelfNavigationView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fabuBtnAction) name:@"fabuBtnAction" object:nil];
     [self.view addSubview:_NavView];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-63.5-50) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak __typeof(self) blockSelf = self;
    [tableView addHeaderWithCallback:^{
        [blockSelf getDataList];
    }];
    [tableView addFooterWithCallback:^{
        blockSelf.PageCount++ ;
        [blockSelf getMoreSuppleyMessage];
    }];
    //缓存
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefaults objectForKey:@"homePageCache"];
    self.supplyDataAry=[NSMutableArray array];
    if (dic) {
        self.productDataAry=[GusseYourLikeModel creatGusseLikeAryByAry:[dic objectForKey:@"productList"]];
        [self.supplyDataAry addObjectsFromArray:[HotSellModel hotSellAryByAry:[dic objectForKey:@"supplyList"]]];
        self.BuyDataAry=[HotBuyModel creathotBuyModelAryByAry:[dic objectForKey:@"newBuyList"]];
        [tableView reloadData];
    }
        [self getDataList];
    
    self.bigImageViewShowView =[[BigImageViewShowView alloc]initWithNomalImageAry:@[@"bangde1.jpg",@"bangde2.jpg",@"bangde3.jpg",@"bangde4.jpg"]];

}
//获取数据
-(void)getDataList
{
    [HTTPCLIENT getHomePageInfoSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            self.productDataAry=[GusseYourLikeModel creatGusseLikeAryByAry:[dic objectForKey:@"productList"]];
            self.PageCount=1;
            [self.supplyDataAry removeAllObjects];
            [self.supplyDataAry addObjectsFromArray:[HotSellModel hotSellAryByAry:[dic objectForKey:@"supplyList"]]];
            self.BuyDataAry=[HotBuyModel creathotBuyModelAryByAry:[dic objectForKey:@"newBuyList"]];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:dic forKey:@"homePageCache"];
            [userDefaults synchronize];
            [self.tableView reloadData];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        [self.tableView  headerEndRefreshing];
    } failure:^(NSError *error) {
        [self.tableView  headerEndRefreshing];
    }];
}
//加载更多供应信息
-(void)getMoreSuppleyMessage
{
    [HTTPCLIENT SellListWithWithPageSize:@"10" WithPage:[NSString stringWithFormat:@"%ld",(long)self.PageCount] Success:^(id responseObject) {
        //NSLog(@"%@",responseObject);
        NSDictionary *dic=[responseObject objectForKey:@"result"];
        NSArray *ary=[dic objectForKey:@"list"];
        NSArray *aryzz=[HotSellModel hotSellAryByAry:ary];
        HotSellModel *aryzzLast =  [aryzz lastObject];
        HotSellModel *dataLast =  [self.supplyDataAry lastObject];
        //NSLog(@"%@---%@",dataLast.uid,aryzzLast.uid);
        if (aryzz.count > 0) {
            if ([dataLast.uid isEqualToString: aryzzLast.uid]) {
                [ToastView showTopToast:@"已无更多信息"];
                self.PageCount--;
            }else{
                
                [self.supplyDataAry addObjectsFromArray:aryzz];
            }
            
        }else{
            [ToastView showTopToast:@"已无更多信息"];
            self.PageCount--;
        }
            [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    } failure:^(NSError *error) {
        [self.tableView footerEndRefreshing];
    }];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    if (section==1) {
        return 1;
    }
    if (section==2) {
        return 1;
    }
    if (section==3) {
        return self.BuyDataAry.count;
    }
    if (section==4) {
        return self.supplyDataAry.count;
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        AdvertView *adView=[[AdvertView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 160.f/320.f*kWidth)];
        adView.delegate=self;
        [adView setAdInfo];
        [adView adStart];
        return adView;
    }
    if (indexPath.section==1) {
        CircleViews *circleViews=[[CircleViews alloc]initWithFrame:CGRectMake(0, 0, kWidth, 200)];
        circleViews.delegate=self;
        circleViews.selectionStyle=UITableViewCellSelectionStyleNone;
        return circleViews;
    }
    if (indexPath.section==2) {
        YouLickView *youlikeView=[[YouLickView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 75) WithAry:self.productDataAry];
        youlikeView.delegate=self;
       youlikeView.selectionStyle=UITableViewCellSelectionStyleNone;
        return youlikeView;
    }
    if (indexPath.section==3) {
        BuySearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[BuySearchTableViewCell IDStr]];
        if (!cell) {
            cell=[[BuySearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[BuySearchTableViewCell IDStr] WithFrame:CGRectMake(0, 0, kWidth, 65)];
            //cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        HotBuyModel  *model=self.BuyDataAry[indexPath.row];
        cell.hotBuyModel=model;
        return cell;
    }
    if (indexPath.section==4) {
        SellSearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[SellSearchTableViewCell IDStr]];
        
        if (!cell) {
            cell=[[SellSearchTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 100)];
          //  cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        HotSellModel *model=self.supplyDataAry[indexPath.row];
        cell.hotSellModel=model;
        return cell;
    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 160.f/320.f*kWidth;
    }
    if (indexPath.section==1) {
        return 200;
    }
    if (indexPath.section==2) {
        if (self.productDataAry.count>0) {
            return [YouLickView HightForCell:self.productDataAry];
        }
        return 75;
    }
    if (indexPath.section==3) {
        return 65;
    }
    if (indexPath.section==4) {
        return 100;
    }
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==3) {
        HotBuyModel *model=self.BuyDataAry[indexPath.row];
        BuyDetialInfoViewController *buydetialVC=[[BuyDetialInfoViewController alloc]
                                                  initWithSaercherInfo:model.uid];
        [self hiddingSelfTabBar];
        [self.navigationController pushViewController:buydetialVC animated:YES];
    }
    if (indexPath.section==4) {
        HotSellModel *model=self.supplyDataAry[indexPath.row];
        
        SellDetialViewController *sellDetialViewC=[[SellDetialViewController alloc]initWithUid:model];
        [self hiddingSelfTabBar];
        [self.navigationController pushViewController:sellDetialViewC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.01;
    }
    if (section==1) {
        return 0.01;
    }
    
    return 36;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
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
    self.searchBtn=searchBtn;
    [searchBtn setBackgroundColor:[UIColor whiteColor]];
    searchBtn.layer.masksToBounds=YES;
    searchBtn.layer.cornerRadius=4;
    UILabel *searchLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, searchBtn.bounds.size.width-10, searchBtn.bounds.size.height)];
    [searchLab setFont:[UIFont systemFontOfSize:15]];
    [searchLab setTextColor:[UIColor grayColor]];
    [searchBtn addSubview:searchLab];
    [searchLab setText:@"请输入苗木关键词"];
    UIImageView *searchImageV;
    searchImageV=[[UIImageView alloc]initWithFrame:CGRectMake(searchBtn.frame.size.width-36, 4, 27, 27)];
    [searchImageV setImage:[UIImage imageNamed:@"searchBtnAction"]];
    _sreachiamgeV=searchImageV;
    [searchBtn addSubview:searchImageV];
    [searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [selfNavC addSubview:searchBtn];
    return selfNavC;
}
//猜你喜欢点击效果
-(void)YouLickViewsPush:(GusseYourLikeModel *)model
{
    
    SearchViewController *searVC=[[SearchViewController alloc]initWithSearchType:model.type andSaerChStr:model.productName];
    [self hiddingSelfTabBar];
    [self.navigationController pushViewController:searVC animated:YES];
    return;
    
}
//发布按钮
-(void)fabuBtnAction
{
  
    if (self.tabBarController.selectedIndex==1) {
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
//广告页面点击
-(void)advertPush:(NSInteger)index
{
    [self.bigImageViewShowView showInKeyWindowWithIndex:index];
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
    if(index==5){
        if([APPDELEGATE isNeedLogin])
        {
            [self hiddingSelfTabBar];
            YLDGongChengGongSiViewController *tab=[[YLDGongChengGongSiViewController alloc]init];
            [self.navigationController pushViewController:tab animated:YES];
            return;
            
        }else
        {
            [ToastView showTopToast:@"请先登录"];
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        
        return [self makeTitleViewWithTitle:@"猜你喜欢" AndColor:[UIColor colorWithRed:253/255.f green:100/255.f blue:0 alpha:1] andY:0];
        
        
    }
    if (section==3) {
        UIView *xxview=[self makeTitleViewWithTitle:@"热门求购" AndColor:yellowButtonColor andY:0];
        UIButton *moreHotBuyBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, 0, 40, 36)];
        [moreHotBuyBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moreHotBuyBtn setTitleColor:kRedHintColor forState:UIControlStateNormal];
        UIImageView *hotMoreRowImgV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-35, 10.5, 15, 15)];
        [hotMoreRowImgV setImage:[UIImage imageNamed:@"moreRow"]];
        [xxview addSubview:hotMoreRowImgV];
        [moreHotBuyBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [moreHotBuyBtn addTarget:self action:@selector(moreBtnHotAction:) forControlEvents:UIControlEventTouchUpInside];
        [xxview addSubview:moreHotBuyBtn];

            return xxview;
    }
    if (section==4) {
        UIView *zzzview=[self makeTitleViewWithTitle:@"热门供应" AndColor:NavColor andY:0];
        UIButton *moreHotSellBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, 0, 40, 36)];
        [moreHotSellBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moreHotSellBtn setTitleColor:kRedHintColor forState:UIControlStateNormal];
        [moreHotSellBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [moreHotSellBtn addTarget:self action:@selector(moreBtnHotSellAction:) forControlEvents:UIControlEventTouchUpInside];
        [zzzview addSubview:moreHotSellBtn];
        UIImageView *sellMoreRowImgV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-35, 10.5, 15, 15)];
        [sellMoreRowImgV setImage:[UIImage imageNamed:@"moreRow"]];
        [zzzview addSubview:sellMoreRowImgV];

        return zzzview;
    }
    UIView *view=[UIView new];
    return view;
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
//构建小标题栏
-(UIView *)makeTitleViewWithTitle:(NSString *)title AndColor:(UIColor *)color andY:(CGFloat )y
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, y, kWidth, 36)];
    [view setBackgroundColor:[UIColor clearColor]];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 5, 22)];
    [imageV setBackgroundColor:color];
    [view addSubview:imageV];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 70, 36)];
    titleLab.text=title;
    [titleLab setTextColor:color];
    [titleLab setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:titleLab];
    if ([title isEqualToString:@"猜你喜欢"]) {
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-160, 0, 150,36)];
        [lab setFont:[UIFont systemFontOfSize:12]];
        [lab setTextColor:titleLabColor];
        lab.text=@"供应信息可分享到微信,QQ";
         [lab setTextAlignment:NSTextAlignmentCenter];
        [view addSubview:lab];
    }
    if ([title isEqualToString:@"热门求购"]) {
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-60, 0, 120,36)];
        [lab setFont:[UIFont systemFontOfSize:14]];
        [lab setTextColor:titleLabColor];
        [lab setTextAlignment:NSTextAlignmentCenter];
        lab.text=@"下拉刷新";
        [view addSubview:lab];
    }
    return view;
    
}
-(void)hiddingSelfTabBar
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HidenTabBar" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showTabBar" object:nil];
    if (APPDELEGATE.isNeedLogin) {
        if (self.loginBtn.hidden==YES) {
            return;
        }
        self.loginBtn.hidden=YES;
        if (kWidth<=320) {
           CGRect frame =  _searchBtn.frame;
            frame.origin.x=30;
            frame.size.width=kWidth-60;
            _searchBtn.frame=frame;
            _sreachiamgeV.frame=CGRectMake(_searchBtn.frame.size.width-36, 4, 27, 27);
        }
    }else
    {
        if (self.loginBtn.hidden==NO) {
            return;
        }
        self.loginBtn.hidden=NO;
        if (kWidth<=320) {
            CGRect frame =  _searchBtn.frame;
            frame.origin.x=52;
            frame.size.width=kWidth-100;
            _searchBtn.frame=frame;
             _sreachiamgeV.frame=CGRectMake(_searchBtn.frame.size.width-36, 4, 27, 27);
        }
    }
    
}
-(void)login
{
    [self getDataList];
    if (self.loginBtn.hidden==YES) {
        return;
    }
    self.loginBtn.hidden=YES;
    if (kWidth<=320) {
        CGRect frame =  _searchBtn.frame;
        frame.origin.x=40;
        frame.size.width=kWidth-80;
        _searchBtn.frame=frame;
        _sreachiamgeV.frame=CGRectMake(_searchBtn.frame.size.width-36, 4, 27, 27);
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
