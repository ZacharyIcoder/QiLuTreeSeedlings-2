//
//  YLDHeZuoDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/18.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDHeZuoDetialViewController.h"
#import "UIDefines.h"
#import "YLDDingDanJianJieView.h"
#import "HttpClient.h"
#import "YLDHeZuoDetial.h"
#import "YLDHeZuoDEMessageCell.h"
#import "MJRefresh.h"
#import "YLDSearchNavView.h"
@interface YLDHeZuoDetialViewController ()<UITableViewDelegate,UITableViewDataSource,YLDSearchNavViewDelegate>
@property (nonatomic,strong) UIButton *nowBtn;
@property (nonatomic,strong) UIView *moveView;
@property (nonatomic,strong)YLDDingDanJianJieView *jianjieView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSString *Uid;
@property (nonatomic,copy)NSString *itemUid;
@property (nonatomic,strong)YLDHeZuoDetial *model;
@property (nonatomic)NSInteger pageNum;
@property (nonatomic)NSMutableArray *dataAry;
@property (nonatomic,strong)NSString *keyWord;
@property (nonatomic,strong) YLDSearchNavView *searchV;
@property (nonatomic,strong) UIButton *searchBtn;
@end

@implementation YLDHeZuoDetialViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(id)initWithOrderUid:(NSString *)orderUid WithitemUid:(NSString *)itemUid
{
    self=[self init];
    if (self) {
        self.Uid=orderUid;
        self.itemUid=itemUid;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"合作详情";
    self.pageNum=1;
    self.dataAry=[NSMutableArray array];
    [self topActionView];
    YLDDingDanJianJieView *jianjieView=[YLDDingDanJianJieView yldDingDanJianJieView];
    CGRect tempFrame=jianjieView.frame;
    tempFrame.origin.y=115;
    jianjieView.frame=tempFrame;
    self.jianjieView=jianjieView;
    [self.view addSubview:jianjieView];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 115, kWidth, kHeight-115)];
    
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    __weak typeof(self) weakSelf=self;
    [tableView addHeaderWithCallback:^{
        weakSelf.pageNum=1;
        [weakSelf getDataList];
    }];
    [tableView addFooterWithCallback:^{
        weakSelf.pageNum+=1;
        [weakSelf getDataList];
    }];
    self.tableView=tableView;
    [self.view addSubview:tableView];
    tableView.hidden=YES;
    [self getDataList];
    UIButton *searchShowBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-55, 23, 30, 30)];
    [searchShowBtn setEnlargeEdgeWithTop:5 right:10 bottom:10 left:20];
    [searchShowBtn setImage:[UIImage imageNamed:@"ico_顶部搜索"] forState:UIControlStateNormal];
    self.searchBtn=searchShowBtn;
    [searchShowBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBackView addSubview:searchShowBtn];
        self.searchBtn=searchShowBtn;
    YLDSearchNavView *searchV =[[YLDSearchNavView alloc]init];
    self.searchV=searchV;
    searchV.delegate=self;
    searchV.hidden=YES;
    
    [self.navBackView addSubview:searchV];

    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicc=self.dataAry[indexPath.row];
    NSArray *gongzuozhanAry=[dicc objectForKey:@"cooperateQuoteList"];
    NSString *shuomingStr=[dicc objectForKey:@"description"];
    if (shuomingStr.length>0) {
        CGFloat height=[self getHeightWithContent:[NSString stringWithFormat:@"规格要求：%@",shuomingStr] width:kWidth-41 font:15];
        //self.shuomingH.constant=height;
        return 65+height+gongzuozhanAry.count*85;
    }else{
       return 80+gongzuozhanAry.count*85;
    }

    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLDHeZuoDEMessageCell *cell=[tableView  dequeueReusableCellWithIdentifier:@"YLDHeZuoDEMessageCell"];
    if (!cell) {
        cell=[YLDHeZuoDEMessageCell yldHeZuoDEMessageCell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.numLab.text=[NSString stringWithFormat:@"%ld",(long)(indexPath.row+1)];
    cell.dic=self.dataAry[indexPath.row];
    return cell;
}
-(void)searchBtnAction:(UIButton *)sender
{
    self.searchV.hidden=NO;
}
-(void)textFieldChangeVVWithStr:(NSString *)textStr
{
    self.pageNum=1;
    self.keyWord=textStr;
    [self getDataList];
}

- (void)topActionView {
    NSArray *ary=@[@"订单信息",@"合作信息"];
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
        self.searchBtn.hidden=YES;
        self.tableView.hidden=YES;
        self.searchV.hidden=YES;

    }
    if (sender.tag==1) {
        self.jianjieView.hidden=YES;
        self.tableView.hidden=NO;
        self.searchBtn.hidden=NO;
//        self.editingBtn.hidden=YES;
//        if (self.searchBtn.selected) {
//            self.searchV.hidden=NO;
//        }else{
//            [self.navBackView addSubview:self.searchBtn];
//        }
//
        [self.tableView reloadData];
    }
    CGRect frame=_moveView.frame;
    frame.origin.x=kWidth/2*(sender.tag);
    [UIView animateWithDuration:0.3 animations:^{
        _moveView.frame=frame;
    }];
}
- (void)getDataList {
    [HTTPCLIENT hezuoDetialWithorderUid:self.Uid withitemUid:self.itemUid WithPageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] WithPageSize:@"10" WithKeyWord:self.keyWord Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *dic=[[responseObject objectForKey:@"result"] objectForKey:@"detail"];
            if (self.pageNum==1) {
                YLDHeZuoDetial *model=[YLDHeZuoDetial creatYLDHeZuoDetialWithDic:dic];
                self.model=model;
                self.jianjieView.hezuomodel=model;
                [self.dataAry removeAllObjects];
            }
            NSArray *hezuoAry=[dic objectForKey:@"cooperateList"];
            
            if (hezuoAry.count==0) {
                self.pageNum--;
                [ToastView showTopToast:@"已无更多数据"];
            }else{
                [self.dataAry addObjectsFromArray:hezuoAry];
            }
            if (self.pageNum<1) {
                self.pageNum=1;
            }
            
            [self.tableView reloadData];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    } failure:^(NSError *error) {
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获取字符串的高度
-(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
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
