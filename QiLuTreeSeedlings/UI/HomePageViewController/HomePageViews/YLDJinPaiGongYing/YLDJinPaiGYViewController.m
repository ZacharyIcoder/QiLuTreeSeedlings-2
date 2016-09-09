//
//  YLDJinPaiGYViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/30.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDJinPaiGYViewController.h"
#import "SellSearchTableViewCell.h"
#import "SellDetialViewController.h"
#import "HotSellModel.h"
#import "HttpClient.h"
#import "MJRefresh.h"
@interface YLDJinPaiGYViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UIView *moveView;
@property (nonatomic,weak)UIButton *nowBtn;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic)NSInteger pageNum;
@property (nonatomic)NSInteger goldsupplier;
@end

@implementation YLDJinPaiGYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"金牌供应";
    self.dataAry=[NSMutableArray array];
    self.pageNum=1;
    self.goldsupplier=0;
    [self.navBackView setBackgroundColor:NavYellowColor];
    [self topActionView];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 120, kWidth, kHeight-120)];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    __weak typeof(self) weakSelf=self;
    [tableView addHeaderWithCallback:^{
        ShowActionV();
        weakSelf.pageNum=1;
        [weakSelf getDataLists];
    }];
    [tableView addFooterWithCallback:^{
        ShowActionV();
        weakSelf.pageNum+=1;
        [weakSelf getDataLists];
    }];
    [tableView headerBeginRefreshing];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
-(void)getDataLists
{
    [HTTPCLIENT GoldSupplrWithPageSize:@"15" WithPage:[NSString stringWithFormat:@"%ld",(long)(self.pageNum)] Withgoldsupplier:[NSString stringWithFormat:@"%ld",(long)(self.goldsupplier)]  Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSArray *ary=[[responseObject objectForKey:@"result"] objectForKey:@"list"];
            if (self.pageNum==1) {
                [self.dataAry removeAllObjects];
            }
            if (ary.count<=0) {
                self.pageNum--;
                [ToastView showTopToast:@"已无更多数据"];
            }else
            {
                NSArray *dataAAA=[HotSellModel hotSellAryByAry:ary];
                [self.dataAry addObjectsFromArray:dataAAA];
                
            }
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        RemoveActionV();
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    } failure:^(NSError *error) {
        RemoveActionV();
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    }];
}
- (void)topActionView {
    NSArray *ary=@[@"全部",@"金牌",@"银牌",@"铜牌"];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 50)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.shadowColor   = [UIColor blackColor].CGColor;///shadowColor阴影颜色
    view.layer.shadowOpacity = 0.2;////阴影透明度，默认0
    view.layer.shadowOffset  = CGSizeMake(0, 3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移1，默认(0, -3),这个跟shadowRadius配合使用
    
    view.layer.shadowRadius  = 3;//阴影半径，默认3
    CGFloat btnWith=kWidth/4;
    UIView *moveView=[[UIView alloc]initWithFrame:CGRectMake(0, 47, btnWith, 3)];
    [moveView setBackgroundColor:NavColor];
    self.moveView=moveView;
    [view addSubview:moveView];
    for (int i=0; i<ary.count; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(btnWith*i, 0, btnWith, 47)];
        [btn setTitle:ary[i] forState:UIControlStateNormal];
        [btn setTitle:ary[i] forState:UIControlStateSelected];
        [btn setTitleColor:titleLabColor forState:UIControlStateNormal];
        [btn setTitleColor:NavColor forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        btn.tag=i;
        if (i==0) {
            btn.selected=YES;
            _nowBtn=btn;
        }
        [btn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
    }
    [self.view addSubview:view];
}
-(void)topBtnAction:(UIButton *)sender
{
    if (sender==_nowBtn) {
        return;
    }
    
    sender.selected=YES;
    _nowBtn.selected=NO;
    _nowBtn=sender;
    
    self.goldsupplier=sender.tag;
    self.pageNum=1;
    [self.tableView headerBeginRefreshing];
    
    CGRect frame=_moveView.frame;
    frame.origin.x=kWidth/4*(sender.tag);
    [UIView animateWithDuration:0.3 animations:^{
        _moveView.frame=frame;
    }];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HotSellModel *model=self.dataAry[indexPath.row];
    
    SellDetialViewController *sellDetialViewC=[[SellDetialViewController alloc]initWithUid:model];
    [self.navigationController pushViewController:sellDetialViewC animated:YES];
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
