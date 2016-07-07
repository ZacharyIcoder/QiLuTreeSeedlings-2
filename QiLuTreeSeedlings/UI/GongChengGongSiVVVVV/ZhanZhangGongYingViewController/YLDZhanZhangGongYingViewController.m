//
//  YLDZhanZhangGongYingViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDZhanZhangGongYingViewController.h"
#import "YLDFaBuGongChengDingDanViewController.h"
#import "YLDZhanZhangMessageViewController.h"
#import "AdvertView.h"
#import "UIDefines.h"
#import "YLDTuiJianGongZuoZhanCell.h"
#import "SellSearchTableViewCell.h"
#import "ZIKWorkstationViewController.h"
#import "MJRefresh.h"
#import "HttpClient.h"
#import "YLDWorkstationlistModel.h"
#import "HotSellModel.h"
#import "SellDetialViewController.h"
@interface YLDZhanZhangGongYingViewController ()<AdvertDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic)NSInteger pageNum;
@property (nonatomic,strong)NSArray *workStationAry;
@property (nonatomic,strong)NSMutableArray *supplyAry;
@property (nonatomic,weak)UITableView *tableView;
@end

@implementation YLDZhanZhangGongYingViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
      [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengshowTabBar" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum=1;
    self.supplyAry=[NSMutableArray array];
    self.backBtn.frame=CGRectMake(13, 26, 60, 30);
    self.vcTitle=@"站长供应";
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-50) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    __weak typeof(self) weakSelf=self;
    self.tableView=tableView;
    [tableView addHeaderWithCallback:^{
        weakSelf.pageNum=1;
        [weakSelf getDataListWithPageNum:weakSelf.pageNum];
    }];
    [tableView addFooterWithCallback:^{
        weakSelf.pageNum+=1;
        [weakSelf getDataListWithPageNum:weakSelf.pageNum];
    }];
    [tableView headerBeginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fabubtnAction) name:@"YLDGONGChengFabuAction" object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)getDataListWithPageNum:(NSInteger )pageNum
{
    [HTTPCLIENT GCGSshouyeWithPageSize:@"3" WithsupplyCount:@"10"
        WithsupplyNumber:[NSString stringWithFormat:@"%ld",pageNum]                       Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            if (self.pageNum==1) {
                [self.supplyAry removeAllObjects];
                NSArray *workStationList=dic[@"workStationList"];
                self.workStationAry=[YLDWorkstationlistModel YLDWorkstationlistModelWithAry:workStationList];
            }
            
            NSArray *supplyList=dic[@"supplyList"];
            if (supplyList.count<=0) {
                [ToastView showTopToast:@"已无更多信息"];
                self.pageNum--;
            }else{
                NSArray *dataAry=[HotSellModel hotSellAryByAry:supplyList];
              [self.supplyAry addObjectsFromArray:dataAry];
            }
            
            [self.tableView reloadData];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } failure:^(NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 160.f/320.f*kWidth;
    }
    if (indexPath.section==1) {
        return 125;
    }
    if (indexPath.section==2) {
        return 100;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.001;
    }
    return 36;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    if (section==1)
    {
        return self.workStationAry.count;
    }
    if (section==2) {
        return self.supplyAry.count;
    }
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0)
    {
        if (indexPath.row==0) {
            AdvertView *adView=[[AdvertView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 160.f/320.f*kWidth)];
            adView.delegate=self;
            [adView setAdInfo];
            [adView adStart];
            return adView;
        }
    }
    if (indexPath.section==1) {
        YLDTuiJianGongZuoZhanCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDTuiJianGongZuoZhanCell"];
        if(!cell)
        {
            cell=[YLDTuiJianGongZuoZhanCell yldTuiJianGongZuoZhanCell];
        }
        cell.model=self.workStationAry[indexPath.row];
        return cell;
    }
    if (indexPath.section==2) {
        SellSearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SellSearchTableViewCell1"];
        if(!cell)
        {
            cell=[[SellSearchTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 100)];
        }
        cell.hotSellModel=self.supplyAry[indexPath.row];
        return cell;
    }
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    return cell;
}
- (void)advertPush:(NSInteger)index
{
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section==1) {
         [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
        YLDWorkstationlistModel *model = self.workStationAry[indexPath.row];
        YLDZhanZhangMessageViewController *vccc=[[YLDZhanZhangMessageViewController alloc]initWithUid:model.uid];
        
        [self.navigationController pushViewController:vccc animated:YES];
    }
    if (indexPath.section==2) {
        HotSellModel *model=self.supplyAry[indexPath.row];
        
        SellDetialViewController *sellDetialViewC=[[SellDetialViewController alloc]initWithUid:model];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
        [self.navigationController pushViewController:sellDetialViewC animated:YES];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView *view=[self makeTitleViewWithTitle:@"推荐工作站" AndColor:kRedHintColor andY:0];
       UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, 0, 40, 36)];
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:kRedHintColor forState:UIControlStateNormal];
        UIImageView *hotMoreRowImgV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-35, 10.5, 15, 15)];
        [hotMoreRowImgV setImage:[UIImage imageNamed:@"moreRow"]];
        [view addSubview:hotMoreRowImgV];
        [moreBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [moreBtn addTarget:self action:@selector(moreWorkstationAcion) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:moreBtn];
        return view;
    }
    if (section==2) {
        UIView *view=[self makeTitleViewWithTitle:@"工作站供应" AndColor:NavColor andY:0];
        return view;
    }
    UIView *view=[[UIView alloc]init];
    
    return view;
}
-(void)moreWorkstationAcion
{
     [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
    ZIKWorkstationViewController *vc=[[ZIKWorkstationViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
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
//    if ([title isEqualToString:@"猜你喜欢"]) {
//        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-160, 0, 150,36)];
//        [lab setFont:[UIFont systemFontOfSize:12]];
//        [lab setTextColor:titleLabColor];
//        lab.text=@"供应信息可分享到微信,QQ";
//        [lab setTextAlignment:NSTextAlignmentCenter];
//        [view addSubview:lab];
//    }
//    if ([title isEqualToString:@"热门求购"]) {
//        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-60, 0, 120,36)];
//        [lab setFont:[UIFont systemFontOfSize:14]];
//        [lab setTextColor:titleLabColor];
//        [lab setTextAlignment:NSTextAlignmentCenter];
//        lab.text=@"下拉刷新";
//        [view addSubview:lab];
//    }
    return view;
    
}
-(void)fabubtnAction
{
    if(self.tabBarController.selectedIndex==0)
    {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
        YLDFaBuGongChengDingDanViewController *fabuVC=[[YLDFaBuGongChengDingDanViewController alloc]init];
        [self.navigationController pushViewController:fabuVC animated:YES];
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
