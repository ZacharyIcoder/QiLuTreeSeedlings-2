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
@interface YLDHeZuoDetialViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UIButton *nowBtn;
@property (nonatomic,weak) UIView *moveView;
@property (nonatomic,weak)YLDDingDanJianJieView *jianjieView;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,copy)NSString *Uid;
@property (nonatomic,copy)NSString *itemUid;
@end

@implementation YLDHeZuoDetialViewController
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
    [HTTPCLIENT hezuoDetialWithorderUid:self.Uid withitemUid:self.itemUid Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
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
//        self.editingBtn.hidden=NO;
        self.tableView.hidden=YES;
//        self.searchV.hidden=YES;
//        [self.saerchBtn removeFromSuperview];
    }
    if (sender.tag==1) {
        self.jianjieView.hidden=YES;
        self.tableView.hidden=NO;
//        self.editingBtn.hidden=YES;
//        if (self.saerchBtn.selected) {
//            self.searchV.hidden=NO;
//        }else{
//            [self.navBackView addSubview:self.saerchBtn];
//        }
//        
//        [self.tableView reloadData];
    }
    CGRect frame=_moveView.frame;
    frame.origin.x=kWidth/2*(sender.tag);
    [UIView animateWithDuration:0.3 animations:^{
        _moveView.frame=frame;
    }];
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
