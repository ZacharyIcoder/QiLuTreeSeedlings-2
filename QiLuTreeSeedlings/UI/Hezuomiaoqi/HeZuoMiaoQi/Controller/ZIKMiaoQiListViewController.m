//
//  ZIKMiaoQiListViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMiaoQiListViewController.h"
#import "CityModel.h"
#import "ZIKHeZuoMiaoQiListSelectAddressView.h"
#import "GetCityDao.h"
#import "HttpClient.h"
#import "YLDSearchNavView.h"
#import "MJRefresh.h"
#import "YYModel.h"//类型转换
#import "ZIKFunction.h"
#import "ZIKHeZuoMiaoQiModel.h"
#import "ZIKHeZuoMiaoQiTableViewCell.h"
#import "ZIKMiaoQiDetailTableViewController.h"
@interface ZIKMiaoQiListViewController ()<UITableViewDelegate,UITableViewDataSource,YLDSearchNavViewDelegate>
@property (nonatomic, strong) NSString *province;//省
@property (nonatomic, strong) NSString *city;    //市
@property (nonatomic, strong) NSString *county;  //县
@property (nonatomic, strong) NSString *level;
@property (nonatomic, weak)   UIButton *shengBtn;
@property (nonatomic, weak)   UIButton *shiBtn;
@property (nonatomic, weak)   UIButton *xianBtn;
@property (nonatomic, weak)   UIButton *startBtn;
@property (nonatomic,strong)CityModel *shengModel;
@property (nonatomic,strong)CityModel *shiModel;
@property (nonatomic,strong)CityModel *xianModel;
@property (nonatomic,strong)UITableView *cityTalbView;
@property (nonatomic,strong)UITableView *qiTalbView;
@property (nonatomic,copy)NSArray *cityAry;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,strong)YLDSearchNavView *searchV;
@property (nonatomic)NSInteger pageNum;
@property (nonatomic,copy) NSString *searchStr;
@property (nonatomic, strong) ZIKHeZuoMiaoQiListSelectAddressView *selectAreaView;

@end

@implementation ZIKMiaoQiListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAry=[NSMutableArray array];
    self.pageNum=1;
    // Do any additional setup after loading the view from its nib.

    [self initUI];
    [self getData];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag>=10) {
        if (tableView.tag==40) {
            return self.cityAry.count;
        }
        return self.cityAry.count+1;
    }
    if (tableView.tag==8) {
        return self.dataAry.count;
    }
    return 0;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag>=10) {
        return 44;
    }else{
        return 88;
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
    if (tableView.tag==40) {
        UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"ssssss"];
        if (!Cell) {
            Cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ssssss"];
        }
            Cell.textLabel.text=self.cityAry[indexPath.row];
        
        
        return Cell;

    }
    if (tableView.tag==8) {
        ZIKHeZuoMiaoQiTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ZIKHeZuoMiaoQiTableViewCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"ZIKHeZuoMiaoQiTableViewCell" owner:self options:nil] lastObject];
        }
        ZIKHeZuoMiaoQiModel *model=self.dataAry[indexPath.row];
        cell.starNum =model.starLevel;
        [cell configureCell:model];
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
            self.xianBtn.enabled=YES;
           
        }
        
    }
    if (tableView.tag==40) {
        if (indexPath.row==0) {
            [self.startBtn setSelected:NO];
            [self.startBtn setTitle:@"星级" forState:UIControlStateSelected];
            self.level=nil;
        }else{
            switch (indexPath.row) {
                case 1:
                    [self.startBtn setTitle:@"三星级" forState:UIControlStateSelected];
                    break;
                case 2:
                    [self.startBtn setTitle:@"四星级" forState:UIControlStateSelected];
                    break;
                case 3:
                    [self.startBtn setTitle:@"五星级" forState:UIControlStateSelected];
                    break;
                default:
                    break;
            }
            self.startBtn.selected=YES;
            self.level=[NSString stringWithFormat:@"%ld",indexPath.row+2];
        }
    }
    if (tableView.tag>=10) {
        [self.qiTalbView headerBeginRefreshing];
    }
    if (tableView.tag==8) {
        ZIKHeZuoMiaoQiModel *model = self.dataAry[indexPath.row];
        ZIKMiaoQiDetailTableViewController *mqdVC = [[ZIKMiaoQiDetailTableViewController alloc]initWithNibName:@"ZIKMiaoQiDetailTableViewController" bundle:nil];
        mqdVC.uid = model.uid;
        mqdVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mqdVC animated:YES];
    }
}

- (void)initUI {
    self.vcTitle = @"合作苗企";
//    self.leftBarBtnImgString = @"BackBtn";

    [self cityView];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 110, kWidth, kHeight-64-46-44-30)];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.cityTalbView=tableView;

    CLog(@"%@",self.selectAreaView.description);
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
    searchV.textfield.placeholder=@"请输入苗期名称、电话、联系人";
    [self.navBackView addSubview:searchV];
    
    UITableView *qiTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 115, kWidth, kHeight-118)];
    qiTableView.delegate=self;
    qiTableView.dataSource=self;
    qiTableView.tag=8;
    qiTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.qiTalbView=qiTableView;
    [self.view addSubview:qiTableView];
    __weak typeof(self) weakSelf=self;
    [qiTableView addHeaderWithCallback:^{
        ShowActionV();
        weakSelf.pageNum=1;
        [weakSelf getData];
    }];
    [qiTableView addFooterWithCallback:^{
        ShowActionV();
        weakSelf.pageNum+=1;
        [weakSelf getData];
    }];

}
-(void)searchBtnAction:(UIButton *)sender
{
    self.searchV.hidden=NO;
    
}
-(void)textFieldChangeVVWithStr:(NSString *)textStr
{
    
    self.pageNum=1;
    self.searchStr=textStr;
    [self getData];
    
}

-(UIView *)cityView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 51)];
    [view setBackgroundColor:BGColor];
    
    UIButton *startBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth/4, 46)];
    [startBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [startBtn setTitle:@"星级" forState:UIControlStateNormal];
    [startBtn setBackgroundColor:[UIColor whiteColor]];
    [startBtn addTarget:self action:@selector(startBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [startBtn setTitleColor:DarkTitleColor forState:UIControlStateNormal];
    [startBtn setImage:[UIImage imageNamed:@"工程订单_排序off"] forState:UIControlStateNormal];
    [startBtn setTitleColor:NavYellowColor forState:UIControlStateSelected];
    [startBtn setImage:[UIImage imageNamed:@"paixuOn"] forState:UIControlStateSelected];
    self.startBtn=startBtn;
    [view addSubview:startBtn];

    

    UIButton *shengBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/4, 0, kWidth/4, 46)];
    [shengBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [shengBtn setTitle:@"全国" forState:UIControlStateNormal];
    [shengBtn setBackgroundColor:[UIColor whiteColor]];
    [shengBtn addTarget:self action:@selector(shengBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [shengBtn setTitleColor:DarkTitleColor forState:UIControlStateNormal];
    [shengBtn setImage:[UIImage imageNamed:@"工程订单_排序off"] forState:UIControlStateNormal];
    [shengBtn setTitleColor:NavYellowColor forState:UIControlStateSelected];
    [shengBtn setImage:[UIImage imageNamed:@"paixuOn"] forState:UIControlStateSelected];
    self.shengBtn=shengBtn;
    [view addSubview:shengBtn];
    UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/4, 8, 0.5, 30)];
    [line1 setBackgroundColor:kLineColor];
    [view addSubview:line1];
    
    UIButton *shiBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/4*2+1, 0, kWidth/4, 46)];
    [shiBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
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
    UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/4*3, 8, 0.5, 30)];
    [line2 setBackgroundColor:kLineColor];
    [view addSubview:line2];
    UIButton *xianBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/4*3+2, 0, kWidth/4, 46)];
    [xianBtn setTitle:@"所有县(区)" forState:UIControlStateNormal];
    [xianBtn setBackgroundColor:[UIColor whiteColor]];
    [xianBtn addTarget:self action:@selector(xianBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [xianBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
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
-(void)startBtnAction:(UIButton *)sender
{
    if ([self.cityTalbView superview]) {
        [self.cityTalbView removeFromSuperview];
        return;
    }
    [self.view addSubview:self.cityTalbView];
    self.cityTalbView.tag=40;
    
   
    self.cityAry=@[@"不限",@"三星",@"四星",@"五星"];
    [self.cityTalbView reloadData];
    
    

}
-(void)getData
{
    [HTTPCLIENT  cooperationCompanyListWithSearchTime:self.searchStr starLevel:self.level province:self.shengModel.code city:self.shiModel.code county:self.xianModel.code page:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"15" Success:^(id responseObject) {
        RemoveActionV();
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            if (self.pageNum==1) {
                [self.dataAry removeAllObjects];
            }
            NSArray *ary1=[responseObject objectForKey:@"result"];
            NSMutableArray *ary2=[NSMutableArray array]
            ;
            for (int i=0; i<ary1.count; i++) {
                NSDictionary *dic=ary1[i];
             ZIKHeZuoMiaoQiModel *fiveModel = [ZIKHeZuoMiaoQiModel yy_modelWithDictionary:dic];
                [ary2 addObject:fiveModel];
            }
            
            if (ary2.count==0) {
                [ToastView showTopToast:@"已无更多数据"];
            }else
            {
                [self.dataAry addObjectsFromArray:ary2];
                
            }
            [self.qiTalbView reloadData];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        [self.qiTalbView headerEndRefreshing];
        [self.qiTalbView footerEndRefreshing];

    } failure:^(NSError *error) {
        RemoveActionV();
        [self.qiTalbView headerEndRefreshing];
        [self.qiTalbView footerEndRefreshing];
    }];
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
