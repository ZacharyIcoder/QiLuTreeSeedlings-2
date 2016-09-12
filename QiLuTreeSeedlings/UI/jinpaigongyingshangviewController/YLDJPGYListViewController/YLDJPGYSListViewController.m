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
@end

@implementation YLDJPGYSListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAry=[NSMutableArray array];
    self.pageNum=1;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.vcTitle=@"金牌供应商";
    [self cityView];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 110, kWidth, kHeight-64-46-44-30)];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.cityTalbView=tableView;
    UITableView *shangTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 115, kWidth, kHeight-64-51-44-30)];
    shangTableView.delegate=self;
    shangTableView.dataSource=self;
    self.shangTalbView=shangTableView;
    [self.view addSubview:shangTableView];
    __weak typeof(self) weakSelf=self;
    [shangTableView addHeaderWithCallback:^{
        
    }];
    [shangTableView addFooterWithCallback:^{
        
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
    searchV.textfield.placeholder=@"请输入项目名称、苗木名称";
    [self.navBackView addSubview:searchV];
    

    
    // Do any additional setup after loading the view.
}
-(void)getdata
{
//    HTTPCLIENT 
}
-(UIView *)cityView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 51)];
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
    
    UIButton *shiBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/3, 0, kWidth/3, 46)];
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
    UIButton *xianBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/3*2, 0, kWidth/3, 46)];
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
    [self.view addSubview:view];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag>=10) {
      return self.cityAry.count+1;
    }else{
        return 20;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag>=10) {
        return 44;
    }else{
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
    }else{
        UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"ssssss"];
        if (!Cell) {
            Cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ssssss"];
        }
        return Cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.cityTalbView removeFromSuperview];
    if (tableView.tag==10) {
        [self.shengBtn setSelected:YES];
        if (indexPath.row==0) {
          [self.shengBtn setTitle:@"全国" forState:UIControlStateSelected];
            self.shiBtn.selected=NO;
            self.shiBtn.enabled=NO;
            self.xianBtn.selected=NO;
            self.xianBtn.enabled=NO;
            self.shengModel=nil;
            self.shiModel=nil;
            self.xianModel=nil;
        }else{
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
        [self.shiBtn setSelected:YES];
        if (indexPath.row==0) {
            [self.shiBtn setTitle:@"所有市" forState:UIControlStateSelected];
            self.xianBtn.selected=NO;
            self.xianBtn.enabled=NO;
            self.xianModel=nil;
            self.shiModel=nil;
        }else{
            CityModel *model=self.cityAry[indexPath.row-1];
            [self.shiBtn setTitle:model.cityName forState:UIControlStateSelected];
            self.xianBtn.selected=NO;
            self.xianBtn.enabled=YES;
            self.xianModel=nil;
        }
       
    }
    if (tableView.tag==30) {
        [self.xianBtn setSelected:YES];
        if (indexPath.row==0) {
            [self.xianBtn setTitle:@"所有县(区)" forState:UIControlStateSelected];
            self.xianModel=nil;
        }else{
            CityModel *model=self.cityAry[indexPath.row-1];
            [self.shiBtn setTitle:model.cityName forState:UIControlStateSelected];
            self.xianBtn.selected=NO;
            self.xianBtn.enabled=YES;
            self.xianModel=nil;
        }
        
    }
}
-(void)searchBtnAction:(UIButton *)sender
{
    self.searchV.hidden=NO;
}
-(void)textFieldChangeVVWithStr:(NSString *)textStr
{
//    if (self.tableView.editing) {
//        self.tableView.editing = NO;
//        bottomcell.hidden = YES;
//        self.tableView.frame = CGRectMake(0, 64+53, kWidth, kHeight-115-50);
//        [_removeArray removeAllObjects];
//        __weak typeof(self)weakSelf=self;
//        
//        [self.tableView addHeaderWithCallback:^{
//            weakSelf.pageNum=1;
//            ShowActionV();
//            [weakSelf getDataWithSearchWord:weakSelf.searchStr andPageNum:[NSString stringWithFormat:@"%ld",(long)weakSelf.pageNum] andStatus:[NSString stringWithFormat:@"%ld",(long)weakSelf.Status]];
//        }];
//        
//        
//    }
//    
//    self.pageNum=1;
//    self.searchStr=textStr;
   
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
