//
//  YLDMyBuyListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/4.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "YLDMyBuyListViewController.h"
#import "buyFabuViewController.h"
#import "MJRefresh.h"
#import "MybuyListTableViewCell.h"
#import "HotBuyModel.h"
#import "ZIKMySupplyCellBackButton.h"
#import "ZIKBottomDeleteTableViewCell.h"
#import "BuyDetialInfoViewController.h"
#import "BuyMessageAlertView.h"
#import "BuyDetialModel.h"
#import "NuseryDetialViewController.h"
@interface YLDMyBuyListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    ZIKBottomDeleteTableViewCell *bottomcell;
    NSMutableArray *_removeArray;
    UILongPressGestureRecognizer *tapDeleteGR;
}
@property (nonatomic,weak) UIScrollView *topScrollerView;
@property (nonatomic,weak) UIButton *nowBtn;
@property (nonatomic,weak) UIView *moveView;
@property (nonatomic) NSInteger pageCount;
@property (nonatomic) NSInteger MessageState;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataAry;
@end

@implementation YLDMyBuyListViewController
-(void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"editing"];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    _pageCount = 1;
    //    dataAry = [NSMutableArray array];
    [self.tableView headerBeginRefreshing];
    self.tableView.editing = NO;
    bottomcell.hidden = YES;
    self.tableView.frame = CGRectMake(0, 64+53, kWidth, kHeight-64-53);
    [APPDELEGATE requestBuyRestrict];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAry=[NSMutableArray array];
    _pageCount=1;
    _MessageState=0;
    [self configNav];
    [self creatScrollerViewBtn];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+53, kWidth, kHeight-64-53) style:UITableViewStyleGrouped];
      tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.delegate=self;
    tableView.dataSource=self;
    
    _removeArray=[NSMutableArray array];
    tapDeleteGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteCell)];
    [tableView addGestureRecognizer:tapDeleteGR];
    [tableView addObserver:self forKeyPath:@"editing" options:NSKeyValueObservingOptionNew context:NULL];
    self.tableView=tableView;
    [self.view addSubview:tableView];
    //底部结算
    bottomcell = [ZIKBottomDeleteTableViewCell cellWithTableView:nil];
    bottomcell.frame = CGRectMake(0, Height-44, Width, 44);
    [self.view addSubview:bottomcell];
    [bottomcell.seleteImageButton addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    bottomcell.hidden = YES;
    [bottomcell.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomcell];
    __weak typeof(self) weakSelf=self;
    [tableView addHeaderWithCallback:^{
        weakSelf.pageCount=1;
        [weakSelf getDataList];
    }];
    [tableView addFooterWithCallback:^{
        weakSelf.pageCount+=1;
        [weakSelf getDataList];
    }];
    [tableView setBackgroundColor:BGColor];
  
}
// 隐藏删除按钮
- (void)deleteCell {
    if (self.MessageState!=5) {
        return;
    }
    if(self.dataAry.count==0)
    {
        return;
    }
    if (!self.tableView.editing)
    {
        // barButtonItem.title = @"Remove";
        self.tableView.editing = YES;
        bottomcell.hidden = NO;
        self.tableView.frame = CGRectMake(0, 64+53, kWidth, kHeight-64-44-53);
        [self.tableView removeHeader];//编辑状态取消下拉刷新
        bottomcell.isAllSelect = NO;
        if (_removeArray.count > 0) {
            [_removeArray enumerateObjectsUsingBlock:^(HotBuyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                model.isSelect = NO;
            }];
            [_removeArray removeAllObjects];
        }
        [self totalCount];
    }
    
}
//删除按钮action
- (void)deleteButtonClick {
    
    if (_removeArray.count<=0) {
        [ToastView showTopToast:@"您未选择删除数据"];
        return;
    }
    __weak typeof(_removeArray) removeArr = _removeArray;
    __weak __typeof(self) blockSelf = self;
    
    __block NSString *uidString = @"";
    [_removeArray enumerateObjectsUsingBlock:^(HotBuyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        uidString = [uidString stringByAppendingString:[NSString stringWithFormat:@",%@",model.uid]];
    }];
    NSString *uids = [uidString substringFromIndex:1];
    ShowActionV();
    [HTTPCLIENT deleteMyBuyInfo:uids Success:^(id responseObject) {
        RemoveActionV();
        if ([responseObject[@"success"] integerValue] == 1) {
            [ToastView showTopToast:@"删除成功"];
            
            [removeArr enumerateObjectsUsingBlock:^(HotBuyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([blockSelf.dataAry containsObject:model]) {
                    [blockSelf.dataAry removeObject:model];
                }
            }];
            [blockSelf.tableView reloadData];
            [blockSelf.tableView deleteRowsAtIndexPaths:blockSelf.tableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
            
                self.pageCount=1;
                [self getDataList];
                bottomcell.hidden = YES;
                self.tableView.editing = NO;
                self.tableView.frame = CGRectMake(0, 64+53, kWidth, kHeight-64-53);
                __weak typeof(self) weakSelf=self;
                [self.tableView addHeaderWithCallback:^{
                    weakSelf.pageCount=1;
                    [weakSelf getDataList];
                }];
            [_removeArray removeAllObjects];
            [self totalCount];
        }
        else {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
    
}
-(void)backBtnAction:(UIButton *)sender
{
    if (self.tableView.editing) {
        self.tableView.editing = NO;
        bottomcell.hidden = YES;
        self.tableView.frame = CGRectMake(0, 64+53, Width, Height-64-53);
        [_removeArray removeAllObjects];
        __weak typeof(self) weakSelf = self;//解决循环引用的问题
        [self.tableView addHeaderWithCallback:^{//添加刷新控件
            _pageCount=1;
            [weakSelf getDataList];
        }];
        
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//全选按钮
- (void)selectBtnClick {
    bottomcell.isAllSelect ? (bottomcell.isAllSelect = NO) : (bottomcell.isAllSelect = YES);
    if (bottomcell.isAllSelect) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        [self.dataAry enumerateObjectsUsingBlock:^(HotBuyModel *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if(myModel.state==5)
            {
                myModel.isSelect = YES;
                [_removeArray addObject:myModel];
            }
            
        }];
        //[self.mySupplyTableView deselectRowAtIndexPath:[self.mySupplyTableView indexPathForSelectedRow] animated:YES];
    }
    else if (bottomcell.isAllSelect == NO) {
        [self.dataAry enumerateObjectsUsingBlock:^(HotBuyModel *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
            myModel.isSelect = NO;
        }];
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        
    }
    [self totalCount];
    [self.tableView reloadData];
}
- (void)totalCount {
    //    NSString *countString = [NSString stringWithFormat:@"合计:%d条",(int)_removeArray.count];
    //    bottomcell.countLabel.text = countString;
    bottomcell.count = _removeArray.count;
    bottomcell.isAllSelect = YES;
    [self.dataAry enumerateObjectsUsingBlock:^(HotBuyModel *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (myModel.state==5&&myModel.isSelect == NO) {
            bottomcell.isAllSelect = NO;
        }
        
    }];
}


-(void)getDataList
{
    NSString *searchTime;
    if (self.pageCount>1) {
        BuyDetialModel *model=[self.dataAry lastObject];
        searchTime=model.searchTime;
    }
    [HTTPCLIENT myBuyInfoListWtihPage:[NSString stringWithFormat:@"%ld",(long)_pageCount]
                            WithState:[NSString stringWithFormat:@"%ld",(long)_MessageState] WithsearchTime:searchTime  Success:^(id responseObject) {
                                [self.tableView headerEndRefreshing];
                                [self.tableView footerEndRefreshing];
                                if ([[responseObject objectForKey:@"success"] integerValue]) {
                                    if (_pageCount==1) {
                                        [self.dataAry removeAllObjects];
                                    }
                                    NSArray *ary=[[responseObject objectForKey:@"result"] objectForKey:@"list"];
                                    NSArray *aryzz=[HotBuyModel creathotBuyModelAryByAry:ary];
                                    HotBuyModel *model1 = [self.dataAry lastObject];
                                    HotBuyModel *model2=[aryzz lastObject];
                                    if (ary.count==0&&self.dataAry.count>0) {
                                        [ToastView showTopToast:@"已无更多信息"];
                                        _pageCount--;
                                        if (_pageCount<1) {
                                            _pageCount=1;
                                        }
                                        
                                    }
                                    if ([model1.uid isEqualToString:model2.uid]) {
                                        [ToastView showTopToast:@"已无更多信息"];
                                        _pageCount--;
                                        if (_pageCount<1) {
                                            _pageCount=1;
                                        }
                                    }else
                                    {
                                        [self.dataAry addObjectsFromArray:aryzz];
                                        [self.tableView reloadData];
                                        
                                    }
                                    
                                }
                                
                                
                            } failure:^(NSError *error) {
                                [self.tableView headerEndRefreshing];
                                [self.tableView footerEndRefreshing];
                            }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MybuyListTableViewCell *cell = [MybuyListTableViewCell cellWithTableView:tableView];
    if (self.dataAry.count > 0) {
        HotBuyModel *model = self.dataAry[indexPath.section];
        cell.hotBuyModel = model;
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataAry.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.01;
    }else
    {
      return 8;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    HotBuyModel *model=self.dataAry[section];
    
    if (model.state==3) {
        return 35;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[UIView new];
    HotBuyModel *model=self.dataAry[section];
    
    if (model.state==3) {
        view.frame=CGRectMake(0, 0, kWidth, 35);
        ZIKMySupplyCellBackButton *btn=[[ZIKMySupplyCellBackButton alloc]initWithFrame:CGRectMake(0, 0, kWidth, 35)];
        btn.tag=section;
        btn.backgroundColor = [UIColor whiteColor];
        //[button setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 5)];
        [btn setImage:[UIImage imageNamed:@"注意"] forState:UIControlStateNormal];
        [btn setTitle:@"查看退回原因" forState:UIControlStateNormal];
         [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];

    }
    return view;
}
-(void)btnClick:(UIButton *)sender
{
    HotBuyModel *model=self.dataAry[sender.tag];
    if (model.state!=3) {
        return;
    }
    [HTTPCLIENT MyBuyMessageReturnReasonWihtUid:model.uid Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
          BuyMessageAlertView *alertView = [BuyMessageAlertView addActionVieWithReturnReason:[[responseObject objectForKey:@"result"] objectForKey:@"reason"]];
            alertView.rightBtn.tag=sender.tag;
            [alertView.rightBtn addTarget:self action:@selector(tuihuibianjiAction:) forControlEvents:UIControlEventTouchUpInside];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)tuihuibianjiAction:(UIButton *)sender
{
    HotBuyModel *model=self.dataAry[sender.tag];
    if (model.state!=3) {
        return;
    }
    
    [HTTPCLIENT buyDetailWithUid:model.uid WithAccessID:APPDELEGATE.userModel.access_id WithType:@"0" WithmemberCustomUid:@"" Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            
            BuyDetialModel *buyDetialModel=[BuyDetialModel  creatBuyDetialModelByDic:[[responseObject objectForKey:@"result"] objectForKey:@"detail"]];
            buyDetialModel.uid=model.uid;
            buyFabuViewController *buyFabuVC=[[buyFabuViewController alloc]initWithModel:buyDetialModel];
            [self.navigationController pushViewController:buyFabuVC animated:YES];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
    [BuyMessageAlertView removeActionView];
    
}
-(void)creatScrollerViewBtn
{
    NSArray *ary=@[@"全部",@"审核中",@"已通过",@"未通过",@"已关闭",@"已过期"];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 50)];
    UIScrollView *topScrollView=[[UIScrollView alloc]initWithFrame:view.bounds];
    [view addSubview:topScrollView];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.shadowColor   = [UIColor blackColor].CGColor;///shadowColor阴影颜色
    view.layer.shadowOpacity = 0.2;////阴影透明度，默认0
    view.layer.shadowOffset  = CGSizeMake(0, 3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移1，默认(0, -3),这个跟shadowRadius配合使用
    
    view.layer.shadowRadius  = 3;//阴影半径，默认3
    topScrollView.tag=111;
    topScrollView.contentSize=CGSizeMake(kWidth*1.5, 0);
    
    CGFloat btnWith=kWidth/4;
    UIView *moveView=[[UIView alloc]initWithFrame:CGRectMake(0, 47, btnWith, 3)];
    [moveView setBackgroundColor:NavColor];
    self.moveView=moveView;
    [topScrollView addSubview:moveView];
    self.topScrollerView=topScrollView;
    topScrollView.showsVerticalScrollIndicator=NO;
    topScrollView.showsHorizontalScrollIndicator=NO;
    for (int i=0; i<ary.count; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(btnWith*i, 0, btnWith, 47)];
        [btn setTitle:ary[i] forState:UIControlStateNormal];
        [btn setTitle:ary[i] forState:UIControlStateSelected];
        [btn setTitleColor:titleLabColor forState:UIControlStateNormal];
        [btn setTitleColor:NavColor forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        btn.tag=i;
        if (i==0) {
            btn.selected=YES;
            _nowBtn=btn;
        }
        [btn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [topScrollView addSubview:btn];
        
    }
    [self.view addSubview:view];
}
-(void)topBtnAction:(UIButton *)sender
{
    if (sender==_nowBtn) {
        return;
    }
    if (self.tableView.editing&&_nowBtn.tag==5) {
        self.tableView.editing = NO;
        bottomcell.hidden = YES;
        self.tableView.frame = CGRectMake(0, 64+53, Width, Height-64-53);
        __weak typeof(self) weakSelf = self;//解决循环引用的问题
        [self.tableView addHeaderWithCallback:^{//添加刷新控件
            weakSelf.pageCount=1;
            [weakSelf getDataList];
        }];
        
    }

    sender.selected=YES;
    _nowBtn.selected=NO;
    _nowBtn=sender;
    if (sender.tag>=3&&self.topScrollerView.contentOffset.x!=kWidth/2) {
        [self.topScrollerView setContentOffset:CGPointMake(kWidth/2, 0)];
    }
    if (sender.tag<=2&&self.topScrollerView.contentOffset.x!=0) {
        [self.topScrollerView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    CGRect frame=_moveView.frame;
    frame.origin.x=kWidth/4*sender.tag;
    [UIView animateWithDuration:0.3 animations:^{
        _moveView.frame=frame;
    }];
    _MessageState=sender.tag;
    _pageCount=1;
    [self.tableView headerBeginRefreshing];
}
- (void)configNav {
    self.vcTitle = @"我的求购";
    self.rightBarBtnTitleString = @"发布";
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{
        if (APPDELEGATE.isCanPublishBuy==NO)
        {
            [ToastView showTopToast:@"您没有求购发布权限,请先完善苗圃信息"];
            NuseryDetialViewController *nuseVC=[[NuseryDetialViewController alloc]init];
            [weakSelf.navigationController pushViewController:nuseVC animated:YES];
            
            return;
        }
        buyFabuViewController *buyFaBuVC=[[buyFabuViewController alloc]init];
        [weakSelf.navigationController pushViewController:buyFaBuVC animated:YES];
    };
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(self.dataAry.count<=0)
    {
        return;
    }
    HotBuyModel *model = self.dataAry[indexPath.section];
    MybuyListTableViewCell *cell = (MybuyListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!self.tableView.editing) {
        cell.backgroundColor = [UIColor lightGrayColor];
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            cell.backgroundColor = [UIColor whiteColor];
        });
    }
    
    // 判断编辑状态,必须要写
    if (self.tableView.editing)
    {
        
        if (model.state!=5) {
            [ToastView showTopToast:@"该条在有效期内"];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            return;
        }
        if (model.isSelect == YES) {
            model.isSelect = NO;
            cell.isSelect = NO;
            cell.selected = NO;
            // 删除反选数据
            if ([_removeArray containsObject:model])
            {
                [_removeArray removeObject:model];
            }
            [self totalCount];
            return;
        }
        
        // 添加到我们的删除数据源里面
        model.isSelect = YES;
        [_removeArray addObject:model];
        [self totalCount];
        return;
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.dataAry.count>0) {
        HotBuyModel *model=self.dataAry[indexPath.section];
        //NSLog(@"%@",model.uid);
        BuyDetialInfoViewController *buyDetialVC=[[BuyDetialInfoViewController alloc]initMyDetialWithSaercherInfo:model.uid];
        [self.navigationController pushViewController:buyDetialVC animated:YES];
    }
    
}
// 反选方法
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataAry.count<=0)
    {
        return;
    }
    // 判断编辑状态,必须要写
    if (self.tableView.editing)
    {
        //NSLog(@"didDeselectRowAtIndexPath");
        // 获取当前反选显示数据
        HotBuyModel *tempModel = [self.dataAry objectAtIndex:indexPath.section];
        tempModel.isSelect = NO;
        // 删除反选数据
        if ([_removeArray containsObject:tempModel])
        {
            [_removeArray removeObject:tempModel];
        }
        [self totalCount];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - 可选方法实现
// 设置删除按钮标题
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}
// 设置行是否可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 删除数据风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:YES animated:animated];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"editing"]) {
        if ([[change valueForKey:NSKeyValueChangeNewKey] integerValue] == 1) {
            [self.tableView removeGestureRecognizer:tapDeleteGR];
        }
        else {
            [self.tableView addGestureRecognizer:tapDeleteGR];
        }
        // NSLog(@"Height is changed! new=%@", [change valueForKey:NSKeyValueChangeNewKey]);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
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
