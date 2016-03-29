//
//  MyBuyListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/17.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "MyBuyListViewController.h"
#import "BuySearchTableViewCell.h"
#import "HotBuyModel.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "ToastView.h"
#import "PullTableView.h"
#import "BuySearchTableViewCell.h"
#import "BuyDetialInfoViewController.h"
#import "buyFabuViewController.h"
@interface MyBuyListViewController ()<UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate>
@property (nonatomic) NSInteger PageCount;
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic,strong) PullTableView *pullTableView;
@end

@implementation MyBuyListViewController
@synthesize PageCount,dataAry;
-(id)init
{
    self=[super init];
    if (self) {
        PageCount=1;
        dataAry =[NSMutableArray array];
        [self getDataList];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavView];
    PullTableView *tableView=[[PullTableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.pullDelegate=self;
    [self.view addSubview:tableView];
    self.pullTableView=tableView;
}


-(void)editingBtnAction:(UIButton *)sender
{
    buyFabuViewController *buyFaBuVC=[[buyFabuViewController alloc]init];
    [self.navigationController pushViewController:buyFaBuVC animated:YES];       
}
-(void)getDataList
{
    [HTTPCLIENT myBuyInfoListWtihPage:[NSString stringWithFormat:@"%ld",PageCount] Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSArray *ary=[[responseObject objectForKey:@"result"] objectForKey:@"list"];
            NSArray *aryzz=[HotBuyModel creathotBuyModelAryByAry:ary];
            HotBuyModel *model1 = [self.dataAry lastObject];
            HotBuyModel *model2=[aryzz lastObject];
            if (ary.count==0) {
                [ToastView showTopToast:@"已无更多信息"];
                PageCount--;
                if (PageCount<1) {
                    PageCount=1;
                }
                
            }
            if ([model1.uid isEqualToString:model2.uid]) {
                [ToastView showTopToast:@"已无更多信息"];
                PageCount--;
                if (PageCount<1) {
                    PageCount=1;
                }
            }else
            {
                [self.dataAry addObjectsFromArray:aryzz];
                [self.pullTableView reloadData];
                
            }

        }
    } failure:^(NSError *error) {
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataAry.count==0) {
        return 1;
    }else
    {
        return self.dataAry.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataAry.count==0)
    {
        if (indexPath.row==0) {
            UITableViewCell *cell=[[UITableViewCell alloc]init];
            return cell;
        }
    }else
    {
        BuySearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[BuySearchTableViewCell IDStr]];
        if (!cell) {
            cell=[[BuySearchTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 60)];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        HotBuyModel *model=self.dataAry[indexPath.row];
        cell.hotBuyModel=model;
        
        return cell;
    }
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataAry.count>0) {
        HotBuyModel *model=self.dataAry[indexPath.row];
        //NSLog(@"%@",model.uid);
        BuyDetialInfoViewController *buyDetialVC=[[BuyDetialInfoViewController alloc]initMyDetialWithSaercherInfo:model.uid];
        [self.navigationController pushViewController:buyDetialVC animated:YES];
    }
    
}
-(void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
}
-(void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)makeNavView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80,26, 160, 30)];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setText:@"我的求购"];
    [titleLab setFont:[UIFont systemFontOfSize:20]];
    
    UIButton *editingBtnz=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, 26, 50, 30)];
    [editingBtnz setTitle:@"发布" forState:UIControlStateNormal];
    //[editingBtnz setTitle:@"取消" forState:UIControlStateSelected];
    [editingBtnz addTarget:self action:@selector(editingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //editingBtn=editingBtnz;
    [view addSubview:editingBtnz];
    [view addSubview:titleLab];
    [self.view addSubview:view];
    return view;
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
