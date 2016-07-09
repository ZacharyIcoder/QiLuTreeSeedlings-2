//
//  YLDZZsuppleyListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/8.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDZZsuppleyListViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "MJRefresh.h"
#import "HotSellModel.h"
#import "SellSearchTableViewCell.h"
#import "ScreeningView.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#import "SellDetialViewController.h"
@interface YLDZZsuppleyListViewController ()<ScreeningViewDelegate,UITableViewDelegate,UITableViewDataSource>
//creeingActionWithAry:(NSArray *)ary WithProvince:(NSString *)province WihtCity:(NSString *)city WithCounty:(NSString *)county WithGoldsupplier:(NSString *)goldsupplier WithProductUid:(NSString *)productUid withProductName:(NSString *)productName
@property (nonatomic)NSInteger pageNum;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,weak) ScreeningView *screeningView;
@property (nonatomic,weak)UITextField *searchMessageField;
@property (nonatomic,strong)NSArray *guigeAry;
@property (nonatomic,copy)NSString *AreaProvince;
@property (nonatomic,copy)NSString *AreaCity;
@property (nonatomic,copy)NSString *AreaCounty;
@property (nonatomic,copy)NSString *goldsupplier;
@property (nonatomic,copy)NSString *productUid;
@property (nonatomic,copy)NSString *productName;
@end

@implementation YLDZZsuppleyListViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"站长供应";
    self.pageNum=1;
    self.dataAry=[NSMutableArray array];
    [self creatVVVVVV];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    __weak typeof(self) weakSlef=self;
    [tableView addHeaderWithCallback:^{
        weakSlef.pageNum=1;
        ShowActionV();
        if (self.searchMessageField.text.length==0) {
            [self getSuppleyLsitWithPage:weakSlef.pageNum];
        }else{
             [weakSlef getdatalistWithpageNumber:weakSlef.pageNum pageSize:@"15" goldsupplier:self.goldsupplier productUid:self.productUid productName:self.productName province:self.AreaProvince city:self.AreaCity county:self.AreaCounty WithAry:self.guigeAry];
        }
    }];
    [tableView addFooterWithCallback:^{
        weakSlef.pageNum+=1;
         ShowActionV();
        if (self.searchMessageField.text.length==0) {
            [self getSuppleyLsitWithPage:weakSlef.pageNum];
        }else{
            [weakSlef getdatalistWithpageNumber:weakSlef.pageNum pageSize:@"15" goldsupplier:self.goldsupplier productUid:self.productUid productName:self.productName province:self.AreaProvince city:self.AreaCity county:self.AreaCounty WithAry:self.guigeAry];
        }
    }];
    [self.tableView headerBeginRefreshing];
    // Do any additional setup after loading the view.
}
-(void)getSuppleyLsitWithPage:(NSInteger)pagenum
{
    
    [HTTPCLIENT zhanzhanggongyingListWithPageNum:[NSString stringWithFormat:@"%ld",pagenum] WithPageSize:@"15" Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            if (self.pageNum==1) {
                [self.dataAry removeAllObjects];
            }
            NSDictionary *result=[responseObject objectForKey:@"result"];
            NSArray *supplyList=result[@"supplyList"];
            if (supplyList.count==0) {
                [ToastView showTopToast:@"已无更多信息"];
                self.pageNum--;
            }else{
                NSArray *dataAry=[HotSellModel hotSellAryByAry:supplyList];
                [self.dataAry addObjectsFromArray:dataAry];
            }
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        RemoveActionV();
    } failure:^(NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
       RemoveActionV();
    }];
}
-(void)getdatalistWithpageNumber:(NSInteger)pageNumber  pageSize:(NSString *)pageSize goldsupplier:(NSString *)goldsupplier productUid:(NSString *)productUid productName:(NSString *)productName province:(NSString *)province city:(NSString *)city
                          county:(NSString *)county WithAry:(NSArray *)ary
{
    [HTTPCLIENT ZhanZhanggongyingListWithPage:[NSString stringWithFormat:@"%ld",pageNumber] WithPageSize:pageSize Withgoldsupplier:goldsupplier WithProductUid:productUid WithProductName:productName WithProvince:province WithCity:city WithCounty:county WithAry:ary Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            if (self.pageNum==1) {
                [self.dataAry removeAllObjects];
            }
            NSDictionary *result=[responseObject objectForKey:@"result"];
            NSArray *supplyList=result[@"supplyList"];
            if (supplyList.count==0) {
                [ToastView showTopToast:@"已无更多信息"];
                self.pageNum--;
            }else{
                NSArray *dataAry=[HotSellModel hotSellAryByAry:supplyList];
                [self.dataAry addObjectsFromArray:dataAry];
            }

        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        RemoveActionV();
    } failure:^(NSError *error) {
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        RemoveActionV();
    }];
}

- (void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    self.goldsupplier=nil;
    self.productUid=nil;
    self.productName=textField.text;
    self.AreaProvince=nil;
    self.AreaCity=nil;
    self.AreaCounty=nil;
    self.guigeAry=nil;
    if (textField.text.length == 0) {
        [self.tableView headerBeginRefreshing];
        self.productName=nil;
    }
  
}
-(void)creeingActionWithAry:(NSArray *)ary WithProvince:(NSString *)province WihtCity:(NSString *)city WithCounty:(NSString *)county WithGoldsupplier:(NSString *)goldsupplier WithProductUid:(NSString *)productUid withProductName:(NSString *)productName
{
    self.guigeAry=ary;
    self.productName=productName;
    self.productUid=productUid;
    self.AreaProvince=province;
    self.AreaCity=city;
    self.AreaCounty=county;
    self.goldsupplier=goldsupplier;
    self.searchMessageField.text=productName;
    [self.tableView headerBeginRefreshing];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SellSearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[SellSearchTableViewCell IDStr]];
    if (!cell) {
        cell=[[SellSearchTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 100)];
    }
    HotSellModel *model=self.dataAry[indexPath.row];
    cell.hotSellModel=model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotSellModel *model=self.dataAry[indexPath.row];
    SellDetialViewController *sellDetialViewC=[[SellDetialViewController alloc]initWithUid:model];
    [self.navigationController pushViewController:sellDetialViewC animated:YES];
}
-(void)creatVVVVVV
{
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(60, 25, kWidth-120, 44-10)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    backView.layer.masksToBounds=YES;
    backView.layer.cornerRadius=3;
    [self.navBackView addSubview:backView];
    UITextField * searchMessageField=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, backView.frame.size.width-100, 34)];
    self.searchMessageField=searchMessageField;
    searchMessageField.placeholder=@"请输入树种名称";
    [searchMessageField setTextColor:titleLabColor];
    
    searchMessageField.tag=1001;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:searchMessageField];
    [searchMessageField setFont:[UIFont systemFontOfSize:14]];
    searchMessageField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [backView addSubview:searchMessageField];
    UIButton *searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(backView.frame.size.width-45, 0, 34,34)];
    [searchBtn setImage:[UIImage imageNamed:@"searchOrange"] forState:UIControlStateNormal];
    [searchBtn setEnlargeEdgeWithTop:10 right:0 bottom:0 left:20];
    [searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:searchBtn];
    
    
    UIButton *screenBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-25, 30, 20, 20)];
    [screenBtn setEnlargeEdgeWithTop:15 right:10 bottom:10 left:30];
    [screenBtn setImage:[UIImage imageNamed:@"screenBtnAction"] forState:UIControlStateNormal];
    UILabel *labee=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-53, 30, 30, 20)];
    [labee setFont:[UIFont systemFontOfSize:14]];
    [labee setTextColor:[UIColor whiteColor]];
    labee.text=@"筛选";
    [self.navBackView addSubview:labee];
    [screenBtn addTarget:self action:@selector(screeingBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBackView addSubview:screenBtn];
}
-(void)screeingBtnAction
{
    if (self.screeningView) {
        [self.screeningView setSearchStr:self.searchMessageField.text];
        if (self.screeningView.superview==nil) {
            [self.view addSubview:self.screeningView];
        }
    }else{
        ScreeningView *screeningV=[[ScreeningView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight) andSearch:self.searchMessageField.text andSerachType:1];
        self.screeningView=screeningV;
        screeningV.delegate=self;
        [self.view addSubview:screeningV];
    }
    [self.screeningView showViewAction];
}
-(void)searchBtnAction:(UIButton *)sender
{
    if (self.searchMessageField.text.length==0) {
        [ToastView showTopToast:@"请输入搜索内容"];
        [self.searchMessageField becomeFirstResponder];
        return;
    }
  
    [self.searchMessageField resignFirstResponder];
    [self.tableView headerBeginRefreshing];
 
}
-(void)ScreeningbackBtnAction
{
    self.screeningView=nil;
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
