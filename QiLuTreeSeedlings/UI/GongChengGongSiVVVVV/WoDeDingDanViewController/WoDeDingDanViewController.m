//
//  WoDeDingDanViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "WoDeDingDanViewController.h"
#import "YLDMyDingdanTableViewCell.h"
#import "UIDefines.h"
#import "MJRefresh.h"
#import "HttpClient.h"
@interface WoDeDingDanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,weak) UIView *moveView;
@property (nonatomic,weak) UIButton *nowBtn;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger Status;
@property (nonatomic,strong) NSMutableArray *dataAry;
@end

@implementation WoDeDingDanViewController
@synthesize pageNum,Status;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"我的订单";
    pageNum=1;
    Status=-1;
    self.dataAry=[NSMutableArray array];
    [self topActionView];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 118, kWidth, kHeight-115-50)];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    __weak typeof(self)weakSelf=self;
    
    [tableView addHeaderWithCallback:^{
        weakSelf.pageNum=1;
        ShowActionV();
        [weakSelf getDataWithSearchWord:@"" andPageNum:[NSString stringWithFormat:@"%ld",weakSelf.pageNum] andStatus:[NSString stringWithFormat:@"%ld",weakSelf.Status]];
    }];
    [tableView addFooterWithCallback:^{
        weakSelf.pageNum+=1;
        ShowActionV();
        [weakSelf getDataWithSearchWord:@"" andPageNum:[NSString stringWithFormat:@"%ld",weakSelf.pageNum] andStatus:[NSString stringWithFormat:@"%ld",weakSelf.Status]];
    }];
    
    [tableView headerBeginRefreshing];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLDMyDingdanTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDMyDingdanTableViewCell"];
    if (!cell) {
        cell=[YLDMyDingdanTableViewCell yldMyDingdanTableViewCell];
    }
    YLDDingDanModel *model=self.dataAry[indexPath.row];
    cell.model=model;
    return cell;
}
-(void)getDataWithSearchWord:(NSString *)keywords andPageNum:(NSString *)pageNumZ andStatus:(NSString *)status
{
    if ([status integerValue]==-1) {
        status=nil;
    }
     [HTTPCLIENT projectGetMyOrderListWithStatus:status keywords:keywords pageNumber:pageNumZ pageSize:@"15" Success:^(id responseObject) {
         if ([[responseObject objectForKey:@"success"] integerValue]) {
             if (pageNum==1) {
                 [self.dataAry removeAllObjects];
             }
             NSArray *orderList=[[responseObject objectForKey:@"result"] objectForKey:@"orderList"];
             if (orderList.count==0) {
                 pageNum--;
                 [ToastView showTopToast:@"已无更多信息"];
             }else{
                 NSArray *dataSSary=[YLDDingDanModel YLDDingDanModelAryWithAry:orderList];
                 YLDDingDanModel *model1=[dataSSary lastObject];
                 YLDDingDanModel *model2=[self.dataAry lastObject];
                 if ([model1.uid isEqualToString:model2.uid]) {
                     pageNum--;
                     [ToastView showTopToast:@"已无更多信息"];
                 }else{
                     [self.dataAry addObjectsFromArray:dataSSary];
                     [self.tableView reloadData];
                 }
                 
             }
             if (self.pageNum<1) {
                 self.pageNum=1;
             }
           
         }else{
             [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
         }
        RemoveActionV();
         [self.tableView headerEndRefreshing];
         [self.tableView footerEndRefreshing];
     } failure:^(NSError *error) {
        RemoveActionV();
         [self.tableView headerEndRefreshing];
         [self.tableView footerEndRefreshing];
     }];
}
-(void)MakeCCCvIEW
{
    UIView *ssssVieWWW=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 50)];
    [self.view addSubview:ssssVieWWW];
    
}
- (void)topActionView {
    NSArray *ary=@[@"全部",@"报价中",@"已结束"];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 50)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.shadowColor   = [UIColor blackColor].CGColor;///shadowColor阴影颜色
    view.layer.shadowOpacity = 0.2;////阴影透明度，默认0
    view.layer.shadowOffset  = CGSizeMake(0, 3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移1，默认(0, -3),这个跟shadowRadius配合使用
    
    view.layer.shadowRadius  = 3;//阴影半径，默认3
    CGFloat btnWith=kWidth/3;
    UIView *moveView=[[UIView alloc]initWithFrame:CGRectMake(0, 47, btnWith, 3)];
    [moveView setBackgroundColor:NavYellowColor];
    self.moveView=moveView;
    [view addSubview:moveView];
    for (int i=0; i<ary.count; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(btnWith*i, 0, btnWith, 47)];
        [btn setTitle:ary[i] forState:UIControlStateNormal];
        [btn setTitle:ary[i] forState:UIControlStateSelected];
        [btn setTitleColor:titleLabColor forState:UIControlStateNormal];
        [btn setTitleColor:NavYellowColor forState:UIControlStateSelected];
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
    
    CGRect frame=_moveView.frame;
    frame.origin.x=kWidth/3*(sender.tag);
    [UIView animateWithDuration:0.3 animations:^{
        _moveView.frame=frame;
    }];
    if (sender.tag==0) {
        self.Status=-1;
    }
    if (sender.tag==1) {
        self.Status=1;
    }
    if (sender.tag==2) {
        self.Status=0;
    }
    [self.tableView headerBeginRefreshing];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
