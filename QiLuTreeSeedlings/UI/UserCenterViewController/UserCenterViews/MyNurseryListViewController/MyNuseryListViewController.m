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
//#import "NuseryListTableViewCell.h"
#import "NuseryDetialViewController.h"
#import "MJRefresh.h"
#import "ZIKBottomDeleteTableViewCell.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#import "MyNuserListTableViewCell.h"
#import "ZIKEmptyTableViewCell.h"
#import "ZIKHintTableViewCell.h"
@interface MyNuseryListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *pullTableView;
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic)NSInteger pageCount;
@end

@implementation MyNuseryListViewController
{
    ZIKBottomDeleteTableViewCell *_bottomcell;
    NSMutableArray *_removeArray;
    UILongPressGestureRecognizer *_longPressGr;
    NSArray *_deleteIndexArr;//选中的删除index
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.pageCount=1;
    
    [self getDataList];
    [APPDELEGATE  requestBuyRestrict];
    self.pullTableView.editing = NO;
    _bottomcell.hidden = YES;
    self.pullTableView.frame = CGRectMake(0, 64, kWidth, kHeight-64);

}

-(void)dealloc
{
    [_pullTableView removeObserver:self forKeyPath:@"editing"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAry=[NSMutableArray array];
    _removeArray=[NSMutableArray array];
    self.pageCount=1;
    UIView *navView=[self makeNavView];
    [self.view addSubview:navView];
 
    UITableView *pullTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStyleGrouped];
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
    _longPressGr=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleteCell)];
    _longPressGr.minimumPressDuration=1.0;
    [pullTableView addGestureRecognizer:_longPressGr];
    [pullTableView addObserver:self forKeyPath:@"editing" options:NSKeyValueObservingOptionNew context:NULL];

    _bottomcell = [ZIKBottomDeleteTableViewCell cellWithTableView:nil];
    _bottomcell.frame = CGRectMake(0, kHeight-BOTTOM_DELETE_CELL_HEIGHT, kWidth, BOTTOM_DELETE_CELL_HEIGHT);
    [self.view addSubview:_bottomcell];
    [_bottomcell.seleteImageButton addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _bottomcell.hidden = YES;
    [_bottomcell.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"editing"]) {
        if ([[change valueForKey:NSKeyValueChangeNewKey] integerValue] == 1) {
            [_pullTableView removeGestureRecognizer:_longPressGr];
        }
        else {
            [_pullTableView addGestureRecognizer:_longPressGr];
        }
        // NSLog(@"Height is changed! new=%@", [change valueForKey:NSKeyValueChangeNewKey]);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//- (void)dealloc
//{
//    [_pullTableView removeObserver:self forKeyPath:@"editing"];
//}
//
// 隐藏删除按钮
- (void)deleteCell {
    if(self.dataAry.count == 0) {
        return;
    }
    if (!self.pullTableView.editing)
    {
        // barButtonItem.title = @"Remove";
        
        self.pullTableView.editing = YES;
        _bottomcell.hidden = NO;
        self.pullTableView.frame = CGRectMake(0, 64, kWidth, kHeight-64-BOTTOM_DELETE_CELL_HEIGHT);
        [self.pullTableView removeHeader];//编辑状态取消下拉刷新
        _bottomcell.isAllSelect = NO;
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
            //[blockSelf.pullTableView deleteRowsAtIndexPaths:blockSelf.pullTableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
//            if (blockSelf.dataAry.count == 0) {
//                self.pageCount=1;
//                [self getDataList];
                _bottomcell.hidden = YES;
                self.pullTableView.editing = NO;
                self.pullTableView.frame = CGRectMake(0, 64, kWidth, kHeight-64);
                __weak typeof(self) weakSelf=self;
                [self.pullTableView addHeaderWithCallback:^{
                    weakSelf.pageCount=1;
                    [weakSelf getDataList];
                }];
            //}
            if (_removeArray.count > 0) {
                [_removeArray removeAllObjects];
            }
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
    _bottomcell.isAllSelect = !_bottomcell.isAllSelect;
    if (_bottomcell.isAllSelect) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        [self.dataAry enumerateObjectsUsingBlock:^(NurseryModel *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [_removeArray addObject:myModel];
        }];
        NSMutableArray *tempMArr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.dataAry.count; i++) {
            [self.pullTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [tempMArr addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        _deleteIndexArr = (NSArray *)tempMArr;

    }
    else if (_bottomcell.isAllSelect == NO) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        _deleteIndexArr = nil;
        for (NSInteger i = 0; i < self.dataAry.count; i++) {
            [self.pullTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
        }
    }
    [self totalCount];
    //[self.pullTableView reloadData];
}
- (void)totalCount {
    _bottomcell.count = _removeArray.count;
    if (_removeArray.count == self.dataAry.count) {
        _bottomcell.isAllSelect = YES;
    }
    else {
        _bottomcell.isAllSelect = NO;
    }

}
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ZIKHintTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"ZIKHintTableViewCell" owner:self options:nil] lastObject];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.hintStr=@"可添加多个苗圃";
    cell.frame=CGRectMake(0, 5, kWidth, 30);
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
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
        ZIKEmptyTableViewCell *cell =  [[[NSBundle mainBundle] loadNibNamed:@"ZIKEmptyTableViewCell" owner:self options:nil] lastObject];
        cell.emptyImageNameStr = @"myNuserNull";
        cell.emptyFirstStr     = @"您还没有任何苗圃信息";
        cell.empthSecondStr    = @"点击右上角添加苗圃信息吧";
        return cell;
    }else
    {
        MyNuserListTableViewCell *cell = [MyNuserListTableViewCell cellWithTableView:tableView];
        if (self.dataAry.count > 0) {
            NurseryModel *model = self.dataAry[indexPath.row];
            cell.model = model;
        }
        return cell;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataAry.count==0) {
        return EMPTY_CELL_HEIGHT;
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
    if(self.dataAry.count<=0)
    {
        return;
    }
    NurseryModel *model=self.dataAry[indexPath.row];

    // 判断编辑状态,必须要写
    if (self.pullTableView.editing)
    {
        [_removeArray addObject:model];
        NSArray *selectedRows = [self.pullTableView indexPathsForSelectedRows];
        _deleteIndexArr = selectedRows;
        [self totalCount];
        return;
    }
    

    NuseryDetialViewController *nuseryDetialVC = [[NuseryDetialViewController alloc]initWuid:model.nrseryId];
    [self.navigationController pushViewController:nuseryDetialVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UIView *)makeNavView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(17, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:15 right:80 bottom:10 left:10];
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80,26, 160, 30)];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setText:@"我的苗圃"];
    [titleLab setFont:[UIFont systemFontOfSize:NavTitleSize]];
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
            if (self.pageCount==1) {
                [self.dataAry removeAllObjects];
            }
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
                 if (self.pullTableView.editing) {
                    if (_deleteIndexArr.count > 0) {
                        [_deleteIndexArr enumerateObjectsUsingBlock:^(NSIndexPath *selectDeleteIndex, NSUInteger idx, BOOL * _Nonnull stop) {
                            [self.pullTableView selectRowAtIndexPath:selectDeleteIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
                        }];
                    }
                    [self totalCount];
                     return ;
                }

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
        // 获取当前反选显示数据
        NurseryModel *tempModel = [self.dataAry objectAtIndex:indexPath.row];
        // 删除反选数据
        if ([_removeArray containsObject:tempModel])
        {
            [_removeArray removeObject:tempModel];
        }
        NSArray *selectedRows = [self.pullTableView indexPathsForSelectedRows];
        _deleteIndexArr = selectedRows;
        [self totalCount];
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

-(void)backBtnAction:(UIButton *)sender
{
    if (self.pullTableView.editing) {
        self.pullTableView.editing = NO;
        _bottomcell.hidden = YES;
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

@end
