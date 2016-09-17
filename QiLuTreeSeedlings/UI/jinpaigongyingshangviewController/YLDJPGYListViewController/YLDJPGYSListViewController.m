//
//  YLDJPGYSListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/8.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDJPGYSListViewController.h"
#import "HttpClient.h"
#import "CityModel.h"
#import "YLDSearchNavView.h"
#import "GetCityDao.h"
#import "YLDJPGYListCell.h"
#import "MJRefresh.h"
#import "YLDJPGYSListModel.h"
#import "YLDJPGYSDetialViewController.h"
#import "AdvertView.h"
@interface YLDJPGYSListViewController ()<UITableViewDelegate,UITableViewDataSource,YLDSearchNavViewDelegate>
@property (nonatomic,strong)UIButton *shengBtn;
@property (nonatomic,strong)UIButton *shiBtn;
@property (nonatomic,strong)UIButton *xianBtn;
@property (nonatomic,strong)UITableView *cityTalbView;
@property (nonatomic,strong)UITableView *shangTalbView;
@property (nonatomic,copy)NSArray *cityAry;
@property (nonatomic,strong)CityModel *shengModel;
@property (nonatomic,strong)CityModel *shiModel;
@property (nonatomic,strong)CityModel *xianModel;
@property (nonatomic,weak) YLDSearchNavView *searchV;
@property (nonatomic,strong) NSString *searchStr;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic,strong) UIView *cityView;
@end

@implementation YLDJPGYSListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAry=[NSMutableArray array];
    self.pageNum=1;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.vcTitle=@"金牌供应商";
    UIView *view =[self cityView];
    self.cityView=view;

    [self cityView];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-44-30)];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.cityTalbView=tableView;
    UITableView *shangTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-46) style:UITableViewStyleGrouped];
    shangTableView.delegate=self;
    shangTableView.dataSource=self;
    shangTableView.tag=8;
    shangTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.shangTalbView=shangTableView;
    [self.view addSubview:shangTableView];
    __weak typeof(self) weakSelf=self;
    [shangTableView addHeaderWithCallback:^{
        ShowActionV();
        weakSelf.pageNum=1;
        [weakSelf getdata];
    }];
    [shangTableView addFooterWithCallback:^{
        ShowActionV();
        weakSelf.pageNum+=1;
        [weakSelf getdata];
    }];
    UIButton *searchShowBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-55, 23, 30, 30)];
    [searchShowBtn setEnlargeEdgeWithTop:5 right:10 bottom:10 left:20];
    [searchShowBtn setImage:[UIImage imageNamed:@"ico_顶部搜索"] forState:UIControlStateNormal];
    [searchShowBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBackView addSubview:searchShowBtn];
    //    self.saerchBtn=searchShowBtn;
    YLDSearchNavView *searchV =[[YLDSearchNavView alloc]init];
    self.searchV=searchV;
    searchV.delegate=self;
    searchV.hidden=YES;
    searchV.textfield.placeholder=@"请输入供应商名称、电话、联系人";
    [self.navBackView addSubview:searchV];
    
    [self.shangTalbView headerBeginRefreshing];
    
    // Do any additional setup after loading the view.
}
-(void)getdata
{
    [HTTPCLIENT goldSupplyListWithprovince:self.shengModel.code withcity:self.shiModel.code withcounty:self.xianModel.code WithKeyWord:self.searchStr withPage:[NSString stringWithFormat:@"%ld",self.pageNum] withPageSize:@"15" Success:^(id responseObject) {
        RemoveActionV();
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            if (self.pageNum==1) {
                [self.dataAry removeAllObjects];
            }
            NSArray *ary1=[responseObject objectForKey:@"result"];
            NSArray *ary2=[YLDJPGYSListModel aryByAry:ary1];
            if (ary2.count==0) {
                [ToastView showTopToast:@"已无更多数据"];
            }else
            {
                [self.dataAry addObjectsFromArray:ary2];
                
            }
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [self.shangTalbView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//            [self.shangTalbView reloadData];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        [self.shangTalbView headerEndRefreshing];
        [self.shangTalbView footerEndRefreshing];
    } failure:^(NSError *error) {
        RemoveActionV();
        [self.shangTalbView headerEndRefreshing];
        [self.shangTalbView footerEndRefreshing];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView.tag==8) {
        if (section==0) {
            return 50;
        }
    }
    
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView.tag==8) {
    if (section==0) {
    return self.cityView;
    }
    }
    UIView *view;
    return view;
}
-(UIView *)cityView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 64+160.f/320.f*kWidth, kWidth, 51)];
    [view setBackgroundColor:BGColor];
    UIButton *shengBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth/3, 46)];
    [shengBtn setTitle:@"全国" forState:UIControlStateNormal];
    [shengBtn setBackgroundColor:[UIColor whiteColor]];
    [shengBtn addTarget:self action:@selector(shengBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [shengBtn setTitleColor:DarkTitleColor forState:UIControlStateNormal];
    [shengBtn setImage:[UIImage imageNamed:@"工程订单_排序off"] forState:UIControlStateNormal];
    [shengBtn setTitleColor:NavYellowColor forState:UIControlStateSelected];
    [shengBtn setImage:[UIImage imageNamed:@"paixuOn"] forState:UIControlStateSelected];
    self.shengBtn=shengBtn;
    [view addSubview:shengBtn];
    UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/3, 8, 0.5, 30)];
    [line1 setBackgroundColor:kLineColor];
    [view addSubview:line1];
    
    UIButton *shiBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/3+1, 0, kWidth/3, 46)];
    [shiBtn setTitle:@"所有市" forState:UIControlStateNormal];
    [shiBtn setBackgroundColor:[UIColor whiteColor]];
    [shiBtn addTarget:self action:@selector(shiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [shiBtn setTitleColor:DarkTitleColor forState:UIControlStateNormal];
    [shiBtn setImage:[UIImage imageNamed:@"工程订单_排序off"] forState:UIControlStateNormal];
    [shiBtn setTitleColor:NavYellowColor forState:UIControlStateSelected];
    [shiBtn setImage:[UIImage imageNamed:@"paixuOn"] forState:UIControlStateSelected];
    self.shiBtn=shiBtn;
    [view addSubview:shiBtn];
    shiBtn.enabled=NO;
    UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/3*2, 8, 0.5, 30)];
    [line2 setBackgroundColor:kLineColor];
    [view addSubview:line2];
    UIButton *xianBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/3*2+2, 0, kWidth/3, 46)];
    [xianBtn setTitle:@"所有县(区)" forState:UIControlStateNormal];
    [xianBtn setBackgroundColor:[UIColor whiteColor]];
    [xianBtn addTarget:self action:@selector(xianBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [xianBtn setTitleColor:DarkTitleColor forState:UIControlStateNormal];
    [xianBtn setImage:[UIImage imageNamed:@"工程订单_排序off"] forState:UIControlStateNormal];
    [xianBtn setTitleColor:NavYellowColor forState:UIControlStateSelected];
    [xianBtn setImage:[UIImage imageNamed:@"paixuOn"] forState:UIControlStateSelected];
    self.xianBtn=xianBtn;
    [view addSubview:xianBtn];
    xianBtn.enabled=NO;
//    [self.view addSubview:view];
    return view;
}
-(void)shengBtnAction:(UIButton *)sender
{
    if ([self.cityTalbView superview]) {
        [self.cityTalbView removeFromSuperview];
        return;
    }
    [self.view addSubview:self.cityTalbView];
    self.cityTalbView.tag=10;
    
    GetCityDao *dao=[GetCityDao new];
    [dao openDataBase];

    NSArray *shengAry =[dao getCityByLeve:@"1"];
    
    NSArray *shengModelAry=[CityModel creatCityAryByAry:shengAry];
    self.cityAry=shengModelAry;
    [self.cityTalbView reloadData];
    
    [dao closeDataBase];
}
-(void)shiBtnAction:(UIButton *)sender
{
    if ([self.cityTalbView superview]) {
        [self.cityTalbView removeFromSuperview];
        return;
    }
    [self.view addSubview:self.cityTalbView];
    self.cityTalbView.tag=20;
    GetCityDao *dao=[GetCityDao new];
    [dao openDataBase];
    
    NSArray *shiAry = [dao getCityByLeve:nil andParent_code:self.shengModel.code];
    
    NSArray *shiModelAry=[CityModel creatCityAryByAry:shiAry];
    self.cityAry=shiModelAry;
    [self.cityTalbView reloadData];
    
    [dao closeDataBase];
}
-(void)xianBtnAction:(UIButton *)sender
{
    if ([self.cityTalbView superview]) {
        [self.cityTalbView removeFromSuperview];
        return;
    }
    [self.view addSubview:self.cityTalbView];
    self.cityTalbView.tag=30;
    GetCityDao *dao=[GetCityDao new];
    [dao openDataBase];
    
    NSArray *xianAry = [dao getCityByLeve:nil andParent_code:self.shiModel.code];
    
    NSArray *xianModelAry=[CityModel creatCityAryByAry:xianAry];
    self.cityAry=xianModelAry;
    [self.cityTalbView reloadData];
    
    [dao closeDataBase];

    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag==8) {
        return 2;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (tableView.tag>=10) {
      return self.cityAry.count+1;
    }
    if (tableView.tag==8) {
        if (section==0) {
            return 1;
        }
        return self.dataAry.count;
    }
        return 0;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag>=10) {
        return 44;
    }else{
        if (indexPath.section==0) {
            return 160.f/320.f*kWidth;
        }
        return 130;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView.tag==10||tableView.tag==20||tableView.tag==30) {
        UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"ssssss"];
        if (!Cell) {
            Cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ssssss"];
        }
        if (indexPath.row==0) {
            if (tableView.tag==10) {
                Cell.textLabel.text=@"全国";
            }
            if (tableView.tag==20) {
                Cell.textLabel.text=@"所有市";
            }
            if (tableView.tag==30) {
                Cell.textLabel.text=@"所有县(区)";
            }
        }else{
            CityModel *model=self.cityAry[indexPath.row-1];
            Cell.textLabel.text=model.cityName;
        }
       
        return Cell;
    }
    
    if (tableView.tag==8) {
        if(indexPath.section==0)
        {
            if (indexPath.row==0) {
                AdvertView *adView=[[AdvertView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 160.f/320.f*kWidth)];
                //            adView.delegate=self;
                [adView setAdInfo];
                [adView adStart];
                return adView;
                
            }
        }
        YLDJPGYListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDJPGYListCell"];
        if (!cell) {
            cell=[YLDJPGYListCell yldJPGYListCell];
        }
        YLDJPGYSListModel *model=self.dataAry[indexPath.row];
        cell.model=model;
        return cell;
    }
    
    UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"ssssss"];
        if (!Cell) {
            Cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ssssss"];
        }
        return Cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.cityTalbView removeFromSuperview];
    if (tableView.tag==10) {
        
        if (indexPath.row==0) {
            [self.shengBtn setSelected:NO];
          [self.shengBtn setTitle:@"全国" forState:UIControlStateSelected];
            self.shiBtn.selected=NO;
            self.shiBtn.enabled=NO;
            self.xianBtn.selected=NO;
            self.xianBtn.enabled=NO;
            self.shengModel=nil;
            self.shiModel=nil;
            self.xianModel=nil;
        }else{
            [self.shengBtn setSelected:YES];
            CityModel *model=self.cityAry[indexPath.row-1];
            self.shengModel=model;
            [self.shengBtn setTitle:model.cityName forState:UIControlStateSelected];
            self.shiBtn.selected=NO;
            self.shiBtn.enabled=YES;
            self.xianBtn.selected=NO;
            self.xianBtn.enabled=NO;
            self.shiModel=nil;
            self.xianModel=nil;
        }
 
        
    }
    if (tableView.tag==20) {
        
        if (indexPath.row==0) {
            [self.shiBtn setSelected:NO];
            [self.shiBtn setTitle:@"所有市" forState:UIControlStateSelected];
            self.xianBtn.selected=NO;
            self.xianBtn.enabled=NO;
            self.xianModel=nil;
            self.shiModel=nil;
        }else{
            [self.shiBtn setSelected:YES];
            CityModel *model=self.cityAry[indexPath.row-1];
            self.shiModel=model;
            [self.shiBtn setTitle:model.cityName forState:UIControlStateSelected];
            self.xianBtn.selected=NO;
            self.xianBtn.enabled=YES;
            self.xianModel=nil;
        }
        
    }
    if (tableView.tag==30) {
        
        if (indexPath.row==0) {
            [self.xianBtn setSelected:NO];
            [self.xianBtn setTitle:@"所有县(区)" forState:UIControlStateSelected];
            self.xianModel=nil;
        }else{
            [self.xianBtn setSelected:YES];
            
            CityModel *model=self.cityAry[indexPath.row-1];
            self.xianModel=model;
            [self.xianBtn setTitle:model.cityName forState:UIControlStateSelected];
            self.xianBtn.selected=YES;
            
        }
        
    }
    if (tableView.tag>=10) {
        [self.shangTalbView headerBeginRefreshing];
    }
    if (tableView.tag==8) {
        if (indexPath.section==1) {
            YLDJPGYSListModel *model=self.dataAry[indexPath.row];
            YLDJPGYSDetialViewController *yldJPGYSDetialVC=[[YLDJPGYSDetialViewController alloc]initWithUid:model.uid];
            yldJPGYSDetialVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:yldJPGYSDetialVC animated:YES];
        }
       
    }
}
-(void)searchBtnAction:(UIButton *)sender
{
    self.searchV.hidden=NO;
   
}
-(void)textFieldChangeVVWithStr:(NSString *)textStr
{

    self.pageNum=1;
    self.searchStr=textStr;
    [self getdata];
   
}
-(void)hidingAction
{
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
