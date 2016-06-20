//
//  YLDDingDanDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/16.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDDingDanDetialViewController.h"
#import "YLDDingDanJianJieView.h"
#import "YLDEditDingDanViewController.h"
#import "YLDMiaoMuUnTableViewCell.h"
#import "YLDDingDanDetialModel.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "YLDSearchNavView.h"
@interface YLDDingDanDetialViewController ()<UITableViewDelegate,UITableViewDataSource,YLDSearchNavViewDelegate>
@property (nonatomic,weak)UIView *moveView;
@property (nonatomic,weak)UIButton *nowBtn;
@property (nonatomic,weak)YLDDingDanJianJieView *jianjieView;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,copy)NSString *Uid;
@property (nonatomic,strong)YLDDingDanDetialModel *model;
@property (nonatomic,weak) UIButton *editingBtn;
@property (nonatomic,weak) YLDSearchNavView *searchV;
@property (nonatomic,strong) UIButton *saerchBtn;
@end

@implementation YLDDingDanDetialViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengshowTabBar" object:nil];
}
-(id)initWithUid:(NSString *)uid
{
    self=[super init];
    if (self) {
        self.Uid=uid;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"订单详情";
    [self topActionView];
    YLDDingDanJianJieView *jianjieView=[YLDDingDanJianJieView yldDingDanJianJieView];
    CGRect tempFrame=jianjieView.frame;
    tempFrame.origin.y=115;
    jianjieView.frame=tempFrame;
    self.jianjieView=jianjieView;
    [self.view addSubview:jianjieView];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 115, kWidth, kHeight-115)];
    tableView.hidden=YES;
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView=tableView;
    [self.view addSubview:tableView];
    UIButton *editingBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-46, 24, 30, 30)];
    [editingBtn setEnlargeEdgeWithTop:5 right:10 bottom:10 left:20];
    [self.navBackView addSubview:editingBtn];
    [editingBtn setImage:[UIImage imageNamed:@"edintBtn"] forState:UIControlStateNormal];
    [editingBtn addTarget: self action:@selector(editingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.editingBtn=editingBtn;
    
 
    UIButton *searchShowBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-50, 24, 30, 30)];
    [searchShowBtn setEnlargeEdgeWithTop:5 right:10 bottom:10 left:20];
    [searchShowBtn setImage:[UIImage imageNamed:@"ico_顶部搜索"] forState:UIControlStateNormal];
    [searchShowBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.saerchBtn=searchShowBtn;
    //[self.navBackView addSubview:searchShowBtn];
    YLDSearchNavView *searchV =[[YLDSearchNavView alloc]init];
    self.searchV=searchV;
    searchV.delegate=self;
    searchV.hidden=YES;
    [self.navBackView addSubview:searchV];
    [self getdataAction];
}
-(void)getdataAction
{
    ShowActionV();
    [HTTPCLIENT myDingDanDetialWithUid:self.Uid Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *dic=[[responseObject objectForKey:@"result"] objectForKey:@"orderDetail"];
            YLDDingDanDetialModel *model=[YLDDingDanDetialModel yldDingDanDetialModelWithDic:dic];
            self.model=model;
            self.jianjieView.model=model;
            //[self.tableView reloadData];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"success"]];
        }
        RemoveActionV();
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
}
-(void)editingBtnAction:(UIButton *)sender
{
    YLDEditDingDanViewController *EditVC=[[YLDEditDingDanViewController alloc]init];
    [self.navigationController pushViewController:EditVC animated:YES];
}
-(void)searchBtnAction:(UIButton *)sender
{
    sender.selected=YES;
    [sender removeFromSuperview];
    self.searchV.hidden=NO;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.itemList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLDMiaoMuUnTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDMiaoMuUnTableViewCell"];
    if (!cell) {
        cell=[YLDMiaoMuUnTableViewCell yldMiaoMuUnTableViewCell];
    }
    NSDictionary *DIC=self.model.itemList[indexPath.row];
    cell.messageDic=DIC;
    cell.bianhaoLab.text=[NSString stringWithFormat:@"%ld",indexPath.row+1];
    //NSDictionary *DIC=self.miaomuAry[indexPath.row];
//    cell.messageDic=DIC;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)topActionView {
    NSArray *ary=@[@"订单简介",@"苗木详情"];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 50)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.shadowColor   = [UIColor blackColor].CGColor;///shadowColor阴影颜色
    view.layer.shadowOpacity = 0.2;////阴影透明度，默认0
    view.layer.shadowOffset  = CGSizeMake(0, 3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移1，默认(0, -3),这个跟shadowRadius配合使用
    
    view.layer.shadowRadius  = 3;//阴影半径，默认3
    CGFloat btnWith=kWidth/ary.count;
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
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
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
    if (sender.tag==0) {
        self.jianjieView.hidden=NO;
        self.editingBtn.hidden=NO;
        self.tableView.hidden=YES;
        self.searchV.hidden=YES;
        [self.saerchBtn removeFromSuperview];
    }
    if (sender.tag==1) {
        self.jianjieView.hidden=YES;
        self.tableView.hidden=NO;
         self.editingBtn.hidden=YES;
        if (self.saerchBtn.selected) {
             self.searchV.hidden=NO;
        }else{
          [self.navBackView addSubview:self.saerchBtn];  
        }
       
        [self.tableView reloadData];
    }
    CGRect frame=_moveView.frame;
    frame.origin.x=kWidth/2*(sender.tag);
    [UIView animateWithDuration:0.3 animations:^{
        _moveView.frame=frame;
    }];
}
-(void)hidingAction
{
    [self.navBackView addSubview:self.saerchBtn];
    self.saerchBtn.selected=NO;
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