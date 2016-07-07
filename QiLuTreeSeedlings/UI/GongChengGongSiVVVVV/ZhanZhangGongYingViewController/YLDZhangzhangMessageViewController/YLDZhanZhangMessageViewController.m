//
//  YLDZhanZhangMessageViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDZhanZhangMessageViewController.h"
#import "ZIKMyHonorViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "YLDGongZuoZhanMessageCell.h"
#import "YLDZhanZhangMessageCell.h"
#import "YLDGongZuoZhanJianJieCell.h"
#import "yYLDGZZRongYaoTableCell.h"
#import "MJRefresh.h"
#import "YLDZhanZhangDetialModel.h"
#import "HotSellModel.h"
#import "SellSearchTableViewCell.h"
#import "ZIKStationHonorListModel.h"
#import "YYModel.h"
@interface YLDZhanZhangMessageViewController ()<UITableViewDelegate,UITableViewDataSource,YLDZhanZhangMessageCellDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic)NSInteger pageNum;
@property (nonatomic,strong)YLDZhanZhangDetialModel *model;
@property (nonatomic,strong)NSMutableArray *supplyAry;
@property (nonatomic,strong)NSMutableArray *honorAry;
@property (nonatomic)BOOL isShow;
@end

@implementation YLDZhanZhangMessageViewController
-(id)initWithUid:(NSString *)uid
{
    self=[super init];
    if (self) {
        self.uid=uid;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.supplyAry=[NSMutableArray array];
    self.honorAry=[NSMutableArray array];
    self.isShow=NO;
     self.edgesForExtendedLayout = UIRectEdgeNone;
    UITableView *talbeView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    talbeView.delegate=self;
    talbeView.dataSource=self;
    talbeView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView=talbeView;
    [self.view addSubview:talbeView];
    [self getDatListWithPageNum:self.pageNum];
    // Do any additional setup after loading the view.
}
-(void)getDatListWithPageNum:(NSInteger)pageNum
{
    [HTTPCLIENT workstationdetialWithuid:self.uid WithpageNumber:[NSString stringWithFormat:@"%ld",pageNum] WithpageSize:@"15" Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *result=[responseObject objectForKey:@"result"];
            if (self.pageNum==1) {
                self.model=[YLDZhanZhangDetialModel yldZhanZhangDetialModelWithDic:[result objectForKey:@"masterInfo"]];
                [self.supplyAry removeAllObjects];
                [self.honorAry removeAllObjects];
//                ZIKStationHonorListModel *honorListModel = [ZIKStationHonorListModel yy_modelWithDictionary:nil];
                NSArray *honorList=[result objectForKey:@"honorList"];
                [honorList enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZIKStationHonorListModel *honorListModel = [ZIKStationHonorListModel yy_modelWithDictionary:dic];
                    [self.honorAry addObject:honorListModel];
                }];

            }
            NSArray *supplyList=[result objectForKey:@"supplyList"];
            if (supplyList.count<=0) {
                [ToastView showTopToast:@"已无更多数据"];
                self.pageNum--;
            }else{
                NSArray *supplyary=[HotSellModel hotSellAryByAry:supplyList];
                [self.supplyAry addObjectsFromArray:supplyary];
            }
            [self.tableView reloadData];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 200;
    }
    if (indexPath.section==1) {
        return 80;
    }
    if (indexPath.section==2) {
        return 120;
    }
    if (indexPath.section==3) {
        return 150;
    }
    if (indexPath.section==4) {
        return 100;
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1||section==0) {
        return 0.01;
    }else
    {
        return 10;
    }
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        
        YLDZhanZhangMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDZhanZhangMessageCell"];
        if (!cell) {
            cell=[YLDZhanZhangMessageCell yldZhanZhangMessageCell];
            cell.delegate=self;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
//        cell.model=self.
        return cell;
        
    }
    if (indexPath.section==1) {
        
        YLDGongZuoZhanJianJieCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGongZuoZhanJianJieCell"];
        if (!cell) {
            cell=[YLDGongZuoZhanJianJieCell yldGongZuoZhanJianJieCell];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        return cell;
        
    }
    if (indexPath.section==2) {
        
        YLDGongZuoZhanMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGongZuoZhanMessageCell"];
        if (!cell) {
            cell=[YLDGongZuoZhanMessageCell yldGongZuoZhanMessageCell];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        return cell;
        
    }
    if(indexPath.section==3)
    {
        yYLDGZZRongYaoTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"yYLDGZZRongYaoTableCell"];
        if (!cell) {
           cell =[yYLDGZZRongYaoTableCell yldGZZRongYaoTableCell];
           cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell.allBtn addTarget:self action:@selector(allRongYuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)allRongYuBtnAction:(UIButton *)sender
{
    ZIKMyHonorViewController *zsdasda=[[ZIKMyHonorViewController alloc]init];
    zsdasda.type = TypeQualification;
    [self.navigationController pushViewController:zsdasda animated:YES];
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
