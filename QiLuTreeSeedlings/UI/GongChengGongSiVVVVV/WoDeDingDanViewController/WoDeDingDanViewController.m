//
//  WoDeDingDanViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "WoDeDingDanViewController.h"
#import "YLDMyDingdanTableViewCell.h"
#import "YLDDingDanDetialViewController.h"
#import "YLDSearchNavView.h"
#import "YLDFaBuGongChengDingDanViewController.h"
#import "YLDHeZuoDetialViewController.h"
#import "UIDefines.h"
#import "KMJRefresh.h"
#import "HttpClient.h"
#import "ZIKBottomDeleteTableViewCell.h"
@interface WoDeDingDanViewController ()<UITableViewDelegate,UITableViewDataSource,YLDMyDingdanTableViewCellDelegate,YLDSearchNavViewDelegate,YLDDingDanDVCDelegate>
{
    ZIKBottomDeleteTableViewCell *bottomcell;
    NSMutableArray *_removeArray;
    UILongPressGestureRecognizer *tapDeleteGR;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,weak) UIView *moveView;
@property (nonatomic,weak) UIButton *nowBtn;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger Status;
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic,weak) YLDSearchNavView *searchV;
@property (nonatomic,strong) NSString *searchStr;
@end

@implementation WoDeDingDanViewController
@synthesize pageNum,Status;
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.tableView removeObserver:self forKeyPath:@"editing"];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengshowTabBar" object:nil];
    self.tableView.editing = NO;
    bottomcell.hidden = YES;
    self.tableView.frame = CGRectMake(0, 64+53, kWidth, kHeight-115-50);
    [self.tableView headerBeginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"我的订单";
    pageNum=1;
    Status=-1;
    self.dataAry=[NSMutableArray array];
    [self topActionView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fabubtnAction) name:@"YLDGONGChengFabuAction" object:nil];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 118, kWidth, kHeight-115-50)];
    _removeArray=[NSMutableArray array];
    tapDeleteGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteCell)];
    [tableView addGestureRecognizer:tapDeleteGR];
    [tableView addObserver:self forKeyPath:@"editing" options:NSKeyValueObservingOptionNew context:NULL];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    __weak typeof(self)weakSelf=self;
    
    [tableView addHeaderWithCallback:^{
        weakSelf.pageNum=1;
        ShowActionV();
        [weakSelf getDataWithSearchWord:weakSelf.searchStr andPageNum:[NSString stringWithFormat:@"%ld",(long)weakSelf.pageNum] andStatus:[NSString stringWithFormat:@"%ld",(long)weakSelf.Status]];
    }];
    [tableView addFooterWithCallback:^{
        weakSelf.pageNum+=1;
        ShowActionV();
        [weakSelf getDataWithSearchWord:self.searchStr andPageNum:[NSString stringWithFormat:@"%ld",(long)weakSelf.pageNum] andStatus:[NSString stringWithFormat:@"%ld",(long)weakSelf.Status]];
    }];
    
    [tableView headerBeginRefreshing];
    UIButton *searchShowBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-55, 23, 30, 30)];
    [searchShowBtn setEnlargeEdgeWithTop:5 right:10 bottom:10 left:20];
    [searchShowBtn setImage:[UIImage imageNamed:@"ico_顶部搜索"] forState:UIControlStateNormal];
    [searchShowBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBackView addSubview:searchShowBtn];
//    self.saerchBtn=searchShowBtn;
    YLDSearchNavView *searchV =[[YLDSearchNavView alloc]init];
    self.searchV=searchV;
    searchV.delegate=self;
    searchV.hidden=YES;
    searchV.textfield.placeholder=@"请输入项目名称、苗木名称";
    [self.navBackView addSubview:searchV];
 
    bottomcell = [ZIKBottomDeleteTableViewCell cellWithTableView:nil];
    bottomcell.frame = CGRectMake(0, kHeight-44-50, kWidth, 44);
    [self.view addSubview:bottomcell];
    [bottomcell.seleteImageButton addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    bottomcell.hidden = YES;
    [bottomcell.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomcell];

    // Do any additional setup after loading the view from its nib.
}
// 隐藏删除按钮
- (void)deleteCell {
    if (self.Status!=2) {
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
        self.tableView.frame = CGRectMake(0, 64+53, kWidth, kHeight-115-44-50);
        [self.tableView removeHeader];//编辑状态取消下拉刷新
        bottomcell.isAllSelect = NO;
        if (_removeArray.count > 0) {
            [_removeArray enumerateObjectsUsingBlock:^(YLDDingDanModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
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
    [_removeArray enumerateObjectsUsingBlock:^(YLDDingDanModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        uidString = [uidString stringByAppendingString:[NSString stringWithFormat:@",%@",model.uid]];
    }];
    NSString *uids = [uidString substringFromIndex:1];
    ShowActionV();
    [HTTPCLIENT deleteOrderByUids:uids Success:^(id responseObject) {
        RemoveActionV();
        if ([responseObject[@"success"] integerValue] == 1) {
            [ToastView showTopToast:@"删除成功"];
            
            [removeArr enumerateObjectsUsingBlock:^(YLDDingDanModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([blockSelf.dataAry containsObject:model]) {
                    [blockSelf.dataAry removeObject:model];
                }
            }];
            [blockSelf.tableView reloadData];
            [blockSelf.tableView deleteRowsAtIndexPaths:blockSelf.tableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
            
            
            bottomcell.hidden = YES;
            self.tableView.editing = NO;
            self.tableView.frame = CGRectMake(0, 64+53, kWidth, kHeight-115-50);
            __weak typeof(self) weakSelf=self;
            [self.tableView addHeaderWithCallback:^{
                weakSelf.pageNum=1;
                ShowActionV();
                [weakSelf getDataWithSearchWord:weakSelf.searchStr andPageNum:[NSString stringWithFormat:@"%ld",(long)weakSelf.pageNum] andStatus:[NSString stringWithFormat:@"%ld",(long)weakSelf.Status]];
            }];
            self.pageNum=1;
            [self.tableView headerBeginRefreshing];
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
//全选按钮
- (void)selectBtnClick {
    bottomcell.isAllSelect ? (bottomcell.isAllSelect = NO) : (bottomcell.isAllSelect = YES);
    if (bottomcell.isAllSelect) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        [self.dataAry enumerateObjectsUsingBlock:^(YLDDingDanModel *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if(myModel.auditStatus==0)
            {
                myModel.isSelect = YES;
                [_removeArray addObject:myModel];
            }
            
        }];
        //[self.mySupplyTableView deselectRowAtIndexPath:[self.mySupplyTableView indexPathForSelectedRow] animated:YES];
    }
    else if (bottomcell.isAllSelect == NO) {
        [self.dataAry enumerateObjectsUsingBlock:^(YLDDingDanModel *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
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
    [self.dataAry enumerateObjectsUsingBlock:^(YLDDingDanModel *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (myModel.auditStatus==0&&myModel.isSelect == NO) {
            bottomcell.isAllSelect = NO;
        }
        
    }];
}

-(void)searchBtnAction:(UIButton *)sender
{
    self.searchV.hidden=NO;
}
-(void)textFieldChangeVVWithStr:(NSString *)textStr
{
    if (self.tableView.editing) {
        self.tableView.editing = NO;
        bottomcell.hidden = YES;
        self.tableView.frame = CGRectMake(0, 64+53, kWidth, kHeight-115-50);
        [_removeArray removeAllObjects];
        __weak typeof(self)weakSelf=self;
        
        [self.tableView addHeaderWithCallback:^{
            weakSelf.pageNum=1;
            ShowActionV();
            [weakSelf getDataWithSearchWord:weakSelf.searchStr andPageNum:[NSString stringWithFormat:@"%ld",(long)weakSelf.pageNum] andStatus:[NSString stringWithFormat:@"%ld",(long)weakSelf.Status]];
        }];
        
        
    }

    self.pageNum=1;
    self.searchStr=textStr;
    [self getDataWithSearchWord:textStr andPageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] andStatus:[NSString stringWithFormat:@"%ld",(long)self.Status]];
}
-(void)hidingAction
{
}
-(void)shenheTongGuoAcion
{
    [self.tableView headerBeginRefreshing];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{  YLDDingDanModel *model=self.dataAry[indexPath.row];
    if (model.isShow) {
        //NSLog(@"%ld----%lf",indexPath.row,model.showHeight);
        if ([model.status isEqualToString:@"已结束"]) {
            return model.showHeight+40;
        }
         return model.showHeight;
    }else
    {
        if ([model.status isEqualToString:@"已结束"]) {
            return 190+ 40;
        }
         return 190;
    }
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLDMyDingdanTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDMyDingdanTableViewCell"];
    if (!cell) {
        cell=[YLDMyDingdanTableViewCell yldMyDingdanTableViewCell];
        [cell.showBtn addTarget:self action:@selector(showBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.delegate=self;
    }
    cell.showBtn.tag=indexPath.row;
    YLDDingDanModel *model=self.dataAry[indexPath.row];
    cell.model=model;
    return cell;
}
-(void)showBtnAction:(UIButton *)sender
{

    YLDDingDanModel *model=self.dataAry[sender.tag];
    model.isShow=!model.isShow;
    //NSLog(@"%ld",sender.tag);
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.tag inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
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
                 [self.tableView reloadData];
             }else{
                 NSArray *dataSSary=[YLDDingDanModel YLDDingDanModelAryWithAry:orderList];
                 YLDDingDanModel *model1=[dataSSary lastObject];
                 YLDDingDanModel *model2=[self.dataAry lastObject];
                 if ([model1.uid isEqualToString:model2.uid]) {
                     pageNum--;
                     [ToastView showTopToast:@"已无更多信息"];
                     [self.tableView reloadData];
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
    NSArray *ary=@[@"全部",@"待审核",@"报价中",@"已结束"];
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
    if (self.tableView.editing&&_nowBtn.tag==1) {
        self.tableView.editing = NO;
        bottomcell.hidden = YES;
        self.tableView.frame = CGRectMake(0, 64+53, kWidth , kHeight-115-50);
        __weak typeof(self) weakSelf = self;//解决循环引用的问题
        [self.tableView addHeaderWithCallback:^{
            weakSelf.pageNum=1;
            ShowActionV();
            [weakSelf getDataWithSearchWord:weakSelf.searchStr andPageNum:[NSString stringWithFormat:@"%ld",(long)weakSelf.pageNum] andStatus:[NSString stringWithFormat:@"%ld",(long)weakSelf.Status]];
        }];
    }
    sender.selected=YES;
    _nowBtn.selected=NO;
    _nowBtn=sender;
    
    CGRect frame=_moveView.frame;
    frame.origin.x=kWidth/4*(sender.tag);
    [UIView animateWithDuration:0.3 animations:^{
        _moveView.frame=frame;
    }];
    if (sender.tag==0) {
        self.Status=-1;
    }
    if (sender.tag==1) {
        self.Status=2;
    }
    if (sender.tag==2) {
        self.Status=1;
    }
    if (sender.tag==3) {
        self.Status=0;
    }
    [self.tableView headerBeginRefreshing];
}
-(void)hezuoXiangQingActinWithMode:(YLDDingDanModel *)model
{
    //NSLog( @" %@",model.orderName);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
    YLDHeZuoDetialViewController *hezuodetialVC=[[YLDHeZuoDetialViewController alloc]initWithOrderUid:model.uid WithitemUid:nil];
    [self.navigationController pushViewController:hezuodetialVC animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataAry.count<=0)
    {
        return;
    }
       YLDDingDanModel *model=self.dataAry[indexPath.row];
    YLDMyDingdanTableViewCell *cell = (YLDMyDingdanTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
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
        
        if (model.auditStatus!=0) {
            [ToastView showTopToast:@"该条在有效期内"];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            return;
        }
        if (model.isSelect == YES) {
            model.isSelect = NO;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    NSInteger type;
    if (model.auditStatus==0) {
        type=0;
    }else
    {
        if ([model.status isEqualToString:@"已结束"]) {
            type=2;
        }else
        {
            type=1;
        }

    }
    YLDDingDanDetialViewController *vcsss=[[YLDDingDanDetialViewController alloc]initWithUid:model.uid andType:type];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
    if (type==0) {
        vcsss.delegate=self;
    }
    [self.navigationController pushViewController:vcsss animated:YES];
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
        YLDDingDanModel *tempModel = [self.dataAry objectAtIndex:indexPath.section];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fabubtnAction
{
    if(self.tabBarController.selectedIndex==1)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
        YLDFaBuGongChengDingDanViewController *fabuVC=[[YLDFaBuGongChengDingDanViewController alloc]init];
        [self.navigationController pushViewController:fabuVC animated:YES];
    }
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
-(void)backBtnAction:(UIButton *)sender
{
    if (self.tableView.editing) {
        self.tableView.editing = NO;
        bottomcell.hidden = YES;
        self.tableView.frame = CGRectMake(0, 64+53, kWidth, kHeight-115-50);
        [_removeArray removeAllObjects];
        __weak typeof(self)weakSelf=self;
        
        [self.tableView addHeaderWithCallback:^{
            weakSelf.pageNum=1;
            ShowActionV();
            [weakSelf getDataWithSearchWord:weakSelf.searchStr andPageNum:[NSString stringWithFormat:@"%ld",(long)weakSelf.pageNum] andStatus:[NSString stringWithFormat:@"%ld",(long)weakSelf.Status]];
        }];

        
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"YLDBackMiaoXinTong" object:nil];
    }
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
