//
//  MyBuyListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/17.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "MyBuyListViewController.h"
#import "BuySearchTableViewCell.h"
#import "HotBuyModel.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "ToastView.h"
#import "BuySearchTableViewCell.h"
#import "BuyDetialInfoViewController.h"
#import "buyFabuViewController.h"
#import "MyBuyNullTableViewCell.h"
#import "ZIKBottomDeleteTableViewCell.h"
#import "MJRefresh.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
@interface MyBuyListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    ZIKBottomDeleteTableViewCell *bottomcell;
    NSMutableArray *_removeArray;
}
@property (nonatomic) NSInteger PageCount;
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic,strong) UITableView *pullTableView;
@end

@implementation MyBuyListViewController
@synthesize PageCount,dataAry;
-(id)init
{
    self=[super init];
    if (self) {
        PageCount=1;
        dataAry =[NSMutableArray array];
        [self getDataList];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    PageCount = 1;
    dataAry = [NSMutableArray array];
    [self getDataList];
//    self.pullTableView.editing = NO;
//    bottomcell.hidden = YES;
//    self.pullTableView.frame = CGRectMake(0, 64, kWidth, kHeight-64);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [APPDELEGATE requestBuyRestrict];
    [self makeNavView];
    _removeArray=[NSMutableArray array];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    self.pullTableView=tableView;
     tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UILongPressGestureRecognizer *tapDeleteGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteCell)];
    [tableView addGestureRecognizer:tapDeleteGR];
//    tableView add
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.pullTableView addHeaderWithCallback:^{
        [weakSelf.dataAry removeAllObjects];
        weakSelf.PageCount=1;
        [weakSelf getDataList];
    }];
    [self.pullTableView addFooterWithCallback:^{
        weakSelf.PageCount ++;
         [weakSelf getDataList];
        
    }];

    [self.pullTableView setBackgroundColor:BGColor];
    //底部结算
    bottomcell = [ZIKBottomDeleteTableViewCell cellWithTableView:nil];
    bottomcell.frame = CGRectMake(0, kHeight-44, kWidth, 44);
    [self.view addSubview:bottomcell];
    [bottomcell.seleteImageButton addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    bottomcell.hidden = YES;
    [bottomcell.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];

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
    [HTTPCLIENT deleteMyBuyInfo:uids Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 1) {
            [ToastView showTopToast:@"删除成功"];
           
            [removeArr enumerateObjectsUsingBlock:^(HotBuyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([blockSelf.dataAry containsObject:model]) {
                    [blockSelf.dataAry removeObject:model];
                }
            }];
            [blockSelf.pullTableView reloadData];
            [blockSelf.pullTableView deleteRowsAtIndexPaths:blockSelf.pullTableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
            if (blockSelf.dataAry.count == 0) {
                self.PageCount=1;
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
        [self.dataAry enumerateObjectsUsingBlock:^(HotBuyModel *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if(myModel.effect==0)
            {
                myModel.isSelect = YES;
                [_removeArray addObject:myModel];
            }
          
        }];
        NSInteger effectCount=self.dataAry.count-_removeArray.count;
        if (effectCount>0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"有%ld条在有效期内，不可删除",effectCount]];
        }
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
    [self.pullTableView reloadData];
}
- (void)totalCount {
    NSString *countString = [NSString stringWithFormat:@"合计:%d条",(int)_removeArray.count];
    bottomcell.countLabel.text = countString;
    bottomcell.isAllSelect = YES;
    [self.dataAry enumerateObjectsUsingBlock:^(HotBuyModel *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (myModel.effect==0&&myModel.isSelect == NO) {
            bottomcell.isAllSelect = NO;
        }
        
    }];
}

-(void)editingBtnAction:(UIButton *)sender
{
    
    if ([APPDELEGATE isCanPublishBuy]==NO) {
        [ToastView showTopToast:@"暂无发布权限"];
        return;
    }
    if (self.pullTableView.editing) {
        [self deleteCell];
    }
    buyFabuViewController *buyFaBuVC=[[buyFabuViewController alloc]init];
    [self.navigationController pushViewController:buyFaBuVC animated:YES];       
}
-(void)getDataList
{
    [HTTPCLIENT myBuyInfoListWtihPage:[NSString stringWithFormat:@"%ld",(long)PageCount] Success:^(id responseObject) {
        [self.pullTableView headerEndRefreshing];
        [self.pullTableView footerEndRefreshing];
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSArray *ary=[[responseObject objectForKey:@"result"] objectForKey:@"list"];
            NSArray *aryzz=[HotBuyModel creathotBuyModelAryByAry:ary];
            HotBuyModel *model1 = [self.dataAry lastObject];
            HotBuyModel *model2=[aryzz lastObject];
            if (ary.count==0) {
                [ToastView showTopToast:@"已无更多信息"];
                PageCount--;
                if (PageCount<1) {
                    PageCount=1;
                }
                
            }
            if ([model1.uid isEqualToString:model2.uid]) {
                [ToastView showTopToast:@"已无更多信息"];
                PageCount--;
                if (PageCount<1) {
                    PageCount=1;
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
    if(self.dataAry.count==0)
    {
        if (indexPath.row==0) {
            MyBuyNullTableViewCell *cell=[[MyBuyNullTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 260)];
            [cell.fabuBtn addTarget:self action:@selector(editingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }else
    {
        BuySearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[BuySearchTableViewCell IDStr]];
        if (!cell) {
            cell=[[BuySearchTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 60)];
        }
        HotBuyModel *model=self.dataAry[indexPath.row];
        cell.hotBuyModel=model;
        
        return cell;
    }
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotBuyModel *model = self.dataAry[indexPath.row];
    BuySearchTableViewCell *cell = (BuySearchTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    //    NSLog(@"%d",cell.selected);
    //    NSLog(@"%d",model.isSelect);
    
    // 判断编辑状态,必须要写
    if (self.pullTableView.editing)
    {
        
        if (model.effect==1) {
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
        HotBuyModel *model=self.dataAry[indexPath.row];
        //NSLog(@"%@",model.uid);
        BuyDetialInfoViewController *buyDetialVC=[[BuyDetialInfoViewController alloc]initMyDetialWithSaercherInfo:model.uid];
        [self.navigationController pushViewController:buyDetialVC animated:YES];
    }
    
}
// 反选方法
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 判断编辑状态,必须要写
    if (self.pullTableView.editing)
    {
        //NSLog(@"didDeselectRowAtIndexPath");
        // 获取当前反选显示数据
        HotBuyModel *tempModel = [self.dataAry objectAtIndex:indexPath.row];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataAry.count==0) {
        return 260;
    }else
    {
    return 60;
    }
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
            weakSelf.PageCount=1;
            [weakSelf getDataList];
        }];
        
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }

}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self.pullTableView setEditing:YES animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)makeNavView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:10 right:25 bottom:10 left:10];
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80,26, 160, 30)];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setText:@"我的求购"];
    [titleLab setFont:[UIFont systemFontOfSize:21]];
    
    UIButton *editingBtnz=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, 26, 50, 30)];
    [editingBtnz setTitle:@"发布" forState:UIControlStateNormal];
    //[editingBtnz setTitle:@"取消" forState:UIControlStateSelected];
    [editingBtnz addTarget:self action:@selector(editingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //editingBtn=editingBtnz;
    [view addSubview:editingBtnz];
    [view addSubview:titleLab];
    [self.view addSubview:view];
    return view;
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
