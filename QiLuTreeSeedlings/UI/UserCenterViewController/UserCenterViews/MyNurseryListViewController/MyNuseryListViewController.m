//
//  MyNuseryListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/22.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "MyNuseryListViewController.h"
#import "UIDefines.h"
#import "PullTableView.h"
#import "HttpClient.h"
#import "NurseryModel.h"
#import "NuserNullTableViewCell.h"
#import "NuseryListTableViewCell.h"
#import "NuseryDetialViewController.h"
@interface MyNuseryListViewController ()<UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate>
@property (nonatomic,strong) PullTableView *pullTableView;
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic)NSInteger pageCount;
@end

@implementation MyNuseryListViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.pageCount=1;
    [self.dataAry removeAllObjects];
    [self getDataList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAry=[NSMutableArray array];
    self.pageCount=1;
    UIView *navView=[self makeNavView];
    [self.view addSubview:navView];
    PullTableView *pullTableView=[[PullTableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    [pullTableView setBackgroundColor:BGColor];
    [self.view addSubview:pullTableView];
    pullTableView.delegate=self;
    pullTableView.dataSource=self;
    pullTableView.pullDelegate=self;
    pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pullTableView=pullTableView;
    UILongPressGestureRecognizer *longPressGr=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction)];
    longPressGr.minimumPressDuration=1.0;
    [pullTableView addGestureRecognizer:longPressGr];
    // Do any additional setup after loading the view.
}
-(void)longPressAction
{
    [self.pullTableView setEditing:YES animated:YES];
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
   
    if (self.dataAry.count==0) {
        NuserNullTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[NuserNullTableViewCell IdStr]];
        if (!cell) {
            cell =[[NuserNullTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 250)];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else
    {
        NuseryListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[NuseryListTableViewCell IdStr]];
        if (!cell) {
            cell =[[NuseryListTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 120)];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        NurseryModel *model=self.dataAry[indexPath.row];
        cell.model=model;
        return cell;
    }
//     UITableViewCell *cell;
//    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataAry.count==0) {
        return 250;
    }else
    {
        return 120;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NurseryModel *model=self.dataAry[indexPath.row];
    NuseryDetialViewController *nuseryDetialVC=[[NuseryDetialViewController alloc]initWuid:model.nrseryId];
    [self.navigationController pushViewController:nuseryDetialVC animated:YES];
}
-(void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self.dataAry removeAllObjects];
    _pageCount=1;
    [self getDataList];
}
-(void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    _pageCount+=1;
    [self getDataList];
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
    [titleLab setText:@"我的苗圃"];
    [titleLab setFont:[UIFont systemFontOfSize:17]];
    [view addSubview:titleLab];
    UIButton *collectionBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-40, 26, 30, 30)];
   // self.collectionBtn = collectionBtn;
    [collectionBtn setImage:[UIImage imageNamed:@"myNuserAdd"] forState:UIControlStateNormal];
    [collectionBtn addTarget:self action:@selector(tianjiaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:collectionBtn];

    return view;
}
-(void)tianjiaBtnAction:(UIButton *)sender
{
    NuseryDetialViewController *nuseryDetialViewController=[[NuseryDetialViewController alloc]init];
    [self.navigationController pushViewController:nuseryDetialViewController animated:YES];
}
-(void)getDataList
{
    [HTTPCLIENT getNurseryListWithPage:[NSString stringWithFormat:@"%ld",(long)self.pageCount] WithPageSize:@"15" Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSArray *ary=[responseObject objectForKey:@"result"];
            NSArray *aryzz=[NurseryModel creatNursweryListByAry:ary];
            NurseryModel *model1 = [self.dataAry lastObject];
            NurseryModel *model2=[aryzz lastObject];
            if (ary.count==0) {
                [ToastView showTopToast:@"已无更多信息"];
                _pageCount--;
                if (_pageCount<1) {
                    _pageCount=1;
                }
                
            }
            if ([model1.nrseryId isEqualToString:model2.nrseryId]) {
                [ToastView showTopToast:@"已无更多信息"];
                _pageCount--;
                if (_pageCount<1) {
                    _pageCount=1;
                }
            }else
            {
                [self.dataAry addObjectsFromArray:aryzz];
                [self.pullTableView reloadData];
               
            }
            self.pullTableView.pullTableIsRefreshing=NO;
            self.pullTableView.pullTableIsLoadingMore=NO;
        }
    } failure:^(NSError *error) {
        self.pullTableView.pullTableIsRefreshing=NO;
        self.pullTableView.pullTableIsLoadingMore=NO;
    }];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

-(void)backBtnAction:(UIButton *)sender
{
    if (self.pullTableView.editing==YES) {
        [self setEditing:NO animated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
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
