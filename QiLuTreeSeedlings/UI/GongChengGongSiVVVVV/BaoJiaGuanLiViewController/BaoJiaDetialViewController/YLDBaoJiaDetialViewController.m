//
//  YLDBaoJiaDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/18.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDBaoJiaDetialViewController.h"
#import "UIDefines.h"
#import "MJRefresh.h"
#import "HttpClient.h"
#import "YLDBaoJiaMiaoMuModel.h"
#import "YLDBaoJiaMiaoMuView.h"
#import "YLDBaoJiaMessageCell.h"
#import "YLDBaoJiaMessageModel.h"
#import "YLDSearchNavView.h"
#import "YLDHeZuoDetialViewController.h"
@interface YLDBaoJiaDetialViewController ()<UITableViewDelegate,UITableViewDataSource,YLDSearchNavViewDelegate,YLDBaoJiaMessageCellDelegate>
@property (nonatomic,weak)UIView *moveView;
@property (nonatomic,weak)UIButton *nowBtn;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,copy)NSString *Uid;
@property (nonatomic,weak)YLDBaoJiaMiaoMuView *miaomuDetialV;
@property (nonatomic)NSInteger pageNum;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,strong)YLDBaoJiaMiaoMuModel *detialModel;
@property (nonatomic,strong) NSString *searchStr;
@property (nonatomic,strong) UIButton *saerchBtn;
@property (nonatomic,weak) YLDSearchNavView *searchV;
@end

@implementation YLDBaoJiaDetialViewController
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
    self.vcTitle=@"报价详情";
    [self topActionView];
    self.pageNum=1;
    self.dataAry=[NSMutableArray array];
    YLDBaoJiaMiaoMuView *yldBaoJiaMiaoMuView=[YLDBaoJiaMiaoMuView yldBaoJiaMiaoMuView];
    self.miaomuDetialV=yldBaoJiaMiaoMuView;
    [self.view addSubview:yldBaoJiaMiaoMuView];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 115, kWidth, kHeight-115)];
    self.tableView=tableView;
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.hidden=YES;
    __weak typeof(self) weakSlef=self;
    [tableView addHeaderWithCallback:^{
        weakSlef.pageNum=1;
        ShowActionV();
        [weakSlef getMessageListWtihKeyWord:weakSlef.searchStr WithPageNumber:[NSString stringWithFormat:@"%ld",weakSlef.pageNum]];
    }];
    [tableView addFooterWithCallback:^{
        weakSlef.pageNum+=1;
        ShowActionV();
        [weakSlef getMessageListWtihKeyWord:weakSlef.searchStr WithPageNumber:[NSString stringWithFormat:@"%ld",weakSlef.pageNum]];
    }];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
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

    [HTTPCLIENT baojiaDetialMiaoMuWtihUid:self.Uid Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *dic=[[responseObject objectForKey:@"result"] objectForKey:@"detail"];
            YLDBaoJiaMiaoMuModel *miaomumodel=[YLDBaoJiaMiaoMuModel yldBaoModelWithDic:dic];
            self.detialModel=miaomumodel;
            self.miaomuDetialV.model=miaomumodel;
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    [weakSlef getMessageListWtihKeyWord:nil WithPageNumber:[NSString stringWithFormat:@"%ld",weakSlef.pageNum]];
    // Do any additional setup after loading the view.
}
-(void)searchBtnAction:(UIButton *)sender
{
    self.searchV.hidden=NO;
}
-(void)textFieldChangeVVWithStr:(NSString *)textStr
{
    self.pageNum=1;
    self.searchStr=textStr;
    [self getMessageListWtihKeyWord:textStr WithPageNumber:[NSString stringWithFormat:@"%ld",self.pageNum]];
}
-(void)getMessageListWtihKeyWord:(NSString *)keyWord WithPageNumber:(NSString *)pageNumber
{
    [HTTPCLIENT baojiaDetialMessageWithUid:self.Uid WithkeyWord:keyWord WithpageNumber:pageNumber WithpageSize:@"15" Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            if (self.pageNum==1) {
                [self.dataAry removeAllObjects];
            }
            NSArray *relist=[[responseObject objectForKey:@"result"]objectForKey:@"quoteList"];
            if (relist.count>0) {
                NSArray *dataarss=[YLDBaoJiaMessageModel yldBaoJiaMessageModelWithAry:relist];
                YLDBaoJiaMessageModel *model1=[dataarss lastObject];
                YLDBaoJiaMessageModel *model2=[self.dataAry lastObject];
                if ([model1.uid isEqualToString:model2.uid]) {
                    [ToastView showTopToast:@"已无更多信息"];
                    self.pageNum-=1;
                }else{
                    [self.dataAry addObjectsFromArray:dataarss];
                    [self.tableView reloadData];
                }
            }else{
               [ToastView showTopToast:@"已无更多信息"];
                self.pageNum-=1;
            }
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
       
        RemoveActionV();
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 270;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLDBaoJiaMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDBaoJiaMessageCell"];
    if (!cell) {
        cell=[YLDBaoJiaMessageCell ylBdaoJiaMessageCell];
        cell.delegate=self;
    }
    YLDBaoJiaMessageModel *model=self.dataAry[indexPath.row];
    cell.model=model;
    return cell;
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
        self.miaomuDetialV.hidden=NO;
        self.tableView.hidden=YES;
//        self.editingBtn.hidden=NO;
//        self.tableView.hidden=YES;
        self.searchV.hidden=YES;
        self.saerchBtn.hidden=YES;
//        [self.saerchBtn removeFromSuperview];
    }
    if (sender.tag==1) {
        self.miaomuDetialV.hidden=YES;
        self.tableView.hidden=NO;
        [self.tableView reloadData];
        self.saerchBtn.hidden=NO;
//        self.tableView.hidden=NO;
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
-(void)actionWithtype:(NSInteger)type andModel:(YLDBaoJiaMessageModel *)model{
    NSLog(@"%@",model.uid);
    if (type==1) {
       
        NSString *title = NSLocalizedString(@"建立合作", nil);
        NSString *message = NSLocalizedString(@"是否确定建立合作", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
        NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//            NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [HTTPCLIENT jianliHezuoWithBaoJiaID:model.uid Success:^(id responseObject) {
                if ([[responseObject objectForKey:@"success"] integerValue]) {
                    [self.tableView headerBeginRefreshing];
                }
            } failure:^(NSError *error) {
                
            }];
//            NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
        }];
        
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if (type==2) {
        YLDHeZuoDetialViewController *DAA=[[YLDHeZuoDetialViewController alloc]initWithOrderUid:nil WithitemUid:model.itemUid];
        [self.navigationController pushViewController:DAA animated:YES];
    }
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
