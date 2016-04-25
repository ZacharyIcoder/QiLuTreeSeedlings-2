//
//  MyNuseryListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/22.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "MyNuseryListViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "NurseryModel.h"
#import "NuserNullTableViewCell.h"
#import "NuseryListTableViewCell.h"
#import "NuseryDetialViewController.h"
#import "MJRefresh.h"
#import "ZIKBottomDeleteTableViewCell.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
@interface MyNuseryListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    ZIKBottomDeleteTableViewCell *bottomcell;
    NSMutableArray *_removeArray;
}
@property (nonatomic,strong) UITableView *pullTableView;
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic)NSInteger pageCount;
@end

@implementation MyNuseryListViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.pageCount=1;
    [self.dataAry removeAllObjects];
    [self getDataList];
    [APPDELEGATE  requestBuyRestrict];
}
-(void)dealloc
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAry=[NSMutableArray array];
    _removeArray=[NSMutableArray array];
    self.pageCount=1;
    UIView *navView=[self makeNavView];
    [self.view addSubview:navView];
    UITableView *pullTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    [pullTableView setBackgroundColor:BGColor];
    
    [self.view addSubview:pullTableView];
    pullTableView.delegate=self;
    pullTableView.dataSource=self;
    pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak __typeof(self) blockSelf = self;
    [pullTableView addHeaderWithCallback:^{
        [blockSelf.dataAry removeAllObjects];
        blockSelf.pageCount=1;
        [blockSelf getDataList];
    }];
    [pullTableView addFooterWithCallback:^{
            blockSelf.pageCount+=1;
            [blockSelf getDataList];
    }];
    self.pullTableView=pullTableView;
    UILongPressGestureRecognizer *longPressGr=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleteCell)];
    longPressGr.minimumPressDuration=1.0;
    [pullTableView addGestureRecognizer:longPressGr];
    
    bottomcell = [ZIKBottomDeleteTableViewCell cellWithTableView:nil];
    bottomcell.frame = CGRectMake(0, kHeight-44, kWidth, 44);
    [self.view addSubview:bottomcell];
    [bottomcell.seleteImageButton addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    bottomcell.hidden = YES;
    [bottomcell.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
// 隐藏删除按钮
- (void)deleteCell {
    if (!self.pullTableView.editing)
    {
        // barButtonItem.title = @"Remove";
        self.pullTableView.editing = YES;
        bottomcell.hidden = NO;
        self.pullTableView.frame = CGRectMake(0, 64, kWidth, kHeight-64-44);
        [self.pullTableView removeHeader];//编辑状态取消下拉刷新
        bottomcell.isAllSelect = NO;
        if (_removeArray.count > 0) {
            [_removeArray enumerateObjectsUsingBlock:^(NurseryModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
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
    [_removeArray enumerateObjectsUsingBlock:^(NurseryModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        uidString = [uidString stringByAppendingString:[NSString stringWithFormat:@",%@",model.nrseryId]];
    }];
    NSString *uids = [uidString substringFromIndex:1];
    [HTTPCLIENT deleteMyNuseryInfo:uids Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 1) {
            [ToastView showTopToast:@"删除成功"];
            
            [removeArr enumerateObjectsUsingBlock:^(NurseryModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([blockSelf.dataAry containsObject:model]) {
                    [blockSelf.dataAry removeObject:model];
                }
            }];
            [blockSelf.pullTableView reloadData];
            [blockSelf.pullTableView deleteRowsAtIndexPaths:blockSelf.pullTableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
            if (blockSelf.dataAry.count == 0) {
                self.pageCount=1;
                [self getDataList];
                bottomcell.hidden = YES;
                self.pullTableView.editing = NO;
            }
             [_removeArray removeAllObjects];
            [self totalCount];
           
        }
        else {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
//全选按钮
- (void)selectBtnClick {
    bottomcell.isAllSelect ? (bottomcell.isAllSelect = NO) : (bottomcell.isAllSelect = YES);
    if (bottomcell.isAllSelect) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        [self.dataAry enumerateObjectsUsingBlock:^(NurseryModel *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
                myModel.isSelect = YES;
                [_removeArray addObject:myModel];
            
            
        }];
      
        //[self.mySupplyTableView deselectRowAtIndexPath:[self.mySupplyTableView indexPathForSelectedRow] animated:YES];
    }
    else if (bottomcell.isAllSelect == NO) {
        [self.dataAry enumerateObjectsUsingBlock:^(NurseryModel *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
            myModel.isSelect = NO;
        }];
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        
    }
    [self totalCount];
    [self.pullTableView reloadData];
}
- (void)totalCount {
    bottomcell.count = _removeArray.count;
    if (_removeArray.count == self.dataAry.count) {
        bottomcell.isAllSelect = YES;
    }
    else {
        bottomcell.isAllSelect = NO;
    }

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
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        }
        return cell;
    }else
    {
        NuseryListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[NuseryListTableViewCell IdStr]];
        if (!cell) {
            cell =[[NuseryListTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 120)];
        }
        NurseryModel *model=self.dataAry[indexPath.row];
        cell.model=model;
        return cell;
    }

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
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self.pullTableView setEditing:YES animated:animated];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NurseryModel *model=self.dataAry[indexPath.row];
    
    NuseryListTableViewCell *cell = (NuseryListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    //    NSLog(@"%d",cell.selected);
    //    NSLog(@"%d",model.isSelect);
    
    // 判断编辑状态,必须要写
    if (self.pullTableView.editing)
    {   if (model.isSelect == YES) {
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
        //NSLog(@"didSelectRowAtIndexPath");
        // 获取当前显示数据
        //ZIKSupplyModel *tempModel = [self.supplyInfoMArr objectAtIndex:indexPath.row];
        // 添加到我们的删除数据源里面
        model.isSelect = YES;
        [_removeArray addObject:model];
        [self totalCount];
        return;
    }
    

    NuseryDetialViewController *nuseryDetialVC=[[NuseryDetialViewController alloc]initWuid:model.nrseryId];
    [self.navigationController pushViewController:nuseryDetialVC animated:YES];
}

-(UIView *)makeNavView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(17, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:15 right:30 bottom:10 left:10];
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80,26, 160, 30)];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setText:@"我的苗圃"];
    [titleLab setFont:[UIFont systemFontOfSize:21]];
    [view addSubview:titleLab];
    UIButton *collectionBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-40, 26, 30, 30)];
    [collectionBtn setImage:[UIImage imageNamed:@"myNuserAdd"] forState:UIControlStateNormal];
    [collectionBtn addTarget:self action:@selector(tianjiaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:collectionBtn];

    return view;
}
-(void)tianjiaBtnAction:(UIButton *)sender
{
    if (self.pullTableView.editing) {
        [self deleteCell];
    }
    NuseryDetialViewController *nuseryDetialViewController=[[NuseryDetialViewController alloc]init];
    [self.navigationController pushViewController:nuseryDetialViewController animated:YES];
}
-(void)getDataList
{
    [HTTPCLIENT getNurseryListWithPage:[NSString stringWithFormat:@"%ld",(long)self.pageCount] WithPageSize:@"15" Success:^(id responseObject) {
        [self.pullTableView headerEndRefreshing];
        [self.pullTableView footerEndRefreshing];
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSArray *ary=[responseObject objectForKey:@"result"];
            NSArray *aryzz=[NurseryModel creatNursweryListByAry:ary];
            NurseryModel *model1 = [self.dataAry lastObject];
            NurseryModel *model2=[aryzz lastObject];
            if (ary.count==0&&self.dataAry.count>0) {
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
            
        }
    } failure:^(NSError *error) {
        [self.pullTableView headerEndRefreshing];
        [self.pullTableView footerEndRefreshing];
    }];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
// 反选方法
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 判断编辑状态,必须要写
    if (self.pullTableView.editing)
    {
        //NSLog(@"didDeselectRowAtIndexPath");
        // 获取当前反选显示数据
        NurseryModel *tempModel = [self.dataAry objectAtIndex:indexPath.row];
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

-(void)backBtnAction:(UIButton *)sender
{
    if (self.pullTableView.editing) {
        self.pullTableView.editing = NO;
        bottomcell.hidden = YES;
        self.pullTableView.frame = CGRectMake(0, 64, kWidth, kHeight-64);
        __weak typeof(self) weakSelf = self;//解决循环引用的问题
        [self.pullTableView addHeaderWithCallback:^{//添加刷新控件
            [weakSelf.dataAry removeAllObjects];
            _pageCount=1;
            [weakSelf getDataList];
        }];
        
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
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
