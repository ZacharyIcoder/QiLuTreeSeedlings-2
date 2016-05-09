//
//  ZIKPurchaseRecordsViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/5.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKPurchaseRecordsViewController.h"
#import "BuySearchTableViewCell.h"
#import "HotBuyModel.h"
#import "MJRefresh.h"
#import "BuyDetialInfoViewController.h"
#import "ZIKBottomDeleteTableViewCell.h"
#import "ZIKEmptyTableViewCell.h"
#define BOTTOM_CELL_HEIGH 50

@interface ZIKPurchaseRecordsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *recordsVC;
@property (nonatomic, strong) NSMutableArray *recordMarr;
@property (nonatomic, strong) NSMutableArray *buyDataAry;
@property (nonatomic, assign) NSInteger      page;//页数从1开始

@end

@implementation ZIKPurchaseRecordsViewController
{
    UILongPressGestureRecognizer *_tapDeleteGR;//长按手势
    ZIKBottomDeleteTableViewCell *_bottomcell; //底部删除view

    NSMutableArray *_removeArray;
    NSArray *_deleteIndexArr;//选中的删除index
}

#pragma mark - 返回箭头按钮点击事件
-(void)backBtnAction:(UIButton *)sender
{
    if (self.recordsVC.editing) {
        self.recordsVC.editing = NO;
        if (_removeArray.count > 0) {//选中的删除model清空
            [_removeArray removeAllObjects];
        }
        if (_deleteIndexArr.count > 0) {//选中的删除cell 的 index清空
            _deleteIndexArr = nil;
        }
        _bottomcell.hidden = YES;
        _bottomcell.count = 0;
        self.recordsVC.frame = CGRectMake(0, self.recordsVC.frame.origin.y, Width, Height-64);//更改tableview 的frame
        __weak typeof(self) weakSelf = self;//解决循环引用的问题
        [self.recordsVC addHeaderWithCallback:^{//添加刷新控件
            [weakSelf requestPurchaseRecordsList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
        }];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"购买记录";
    [self initData];
    [self initUI];
    [self requestData];
}

- (void)requestData {
    [self requestPurchaseRecordsList:[NSString stringWithFormat:@"%ld",(long)self.page]];
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.recordsVC addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestPurchaseRecordsList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.recordsVC addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestPurchaseRecordsList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];

}


- (void)initUI {

    self.recordsVC = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Height-64) style:UITableViewStylePlain];
    self.recordsVC.delegate   = self;
    self.recordsVC.dataSource = self;
    [self.view addSubview:self.recordsVC];
    self.recordsVC.backgroundColor = BGColor;
    [ZIKFunction setExtraCellLineHidden:self.recordsVC];

    //添加长按手势
    _tapDeleteGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR)];
    [self.recordsVC addGestureRecognizer:_tapDeleteGR];


    //底部删除view
    _bottomcell = [ZIKBottomDeleteTableViewCell cellWithTableView:nil];
    _bottomcell.count = 0;
    _bottomcell.frame = CGRectMake(0, Height-BOTTOM_CELL_HEIGH, Width, BOTTOM_CELL_HEIGH);
    [self.view addSubview:_bottomcell];
    [_bottomcell.seleteImageButton addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomcell.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _bottomcell.layer.shadowColor   = [UIColor blackColor].CGColor;///shadowColor阴影颜色
    _bottomcell.layer.shadowOpacity = 0.2;////阴影透明度，默认0
    _bottomcell.layer.shadowOffset  = CGSizeMake(0, -3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移1，默认(0, -3),这个跟shadowRadius配合使用
    _bottomcell.layer.shadowRadius  = 3;//阴影半径，默认3
    _bottomcell.hidden = YES;

}

- (void)tapGR {
    if (!self.recordsVC.editing) {
        [self.recordsVC removeHeader];//编辑状态取消下拉刷新
        self.recordsVC.editing = YES;
        _bottomcell.hidden = NO;
        _bottomcell.isAllSelect = NO;
        self.recordsVC.frame = CGRectMake(0, self.recordsVC.frame.origin.y, Width, Height-64-BOTTOM_CELL_HEIGH);
    }
}

- (void)selectBtnClick {
    _bottomcell.isAllSelect ? (_bottomcell.isAllSelect = NO) : (_bottomcell.isAllSelect = YES);
    if (_bottomcell.isAllSelect) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        [self.recordMarr enumerateObjectsUsingBlock:^(HotBuyModel  *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [_removeArray addObject:myModel];
        }];
        NSMutableArray *tempMArr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.recordMarr.count; i++) {
            [self.recordsVC selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [tempMArr addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        _bottomcell.count = _removeArray.count;
        _deleteIndexArr = (NSArray *)tempMArr;
    }
    else if (_bottomcell.isAllSelect == NO) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        _bottomcell.count = 0;
        _deleteIndexArr = nil;
        for (NSInteger i = 0; i < self.recordMarr.count; i++) {
            [self.recordsVC deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
        }
    }

}

- (void)deleteButtonClick {
    if (_removeArray.count  == 0) {
        [ToastView showToast:@"请选择要删除的选项" withOriginY:200 withSuperView:self.view];
        return;
    }
    __weak typeof(_removeArray) removeArr = _removeArray;
    __weak __typeof(self) blockSelf = self;

    __block NSString *uidString = @"";
    [_removeArray enumerateObjectsUsingBlock:^(HotBuyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        uidString = [uidString stringByAppendingString:[NSString stringWithFormat:@",%@",model.uid]];
    }];
    NSString *uids = [uidString substringFromIndex:1];
    [HTTPCLIENT purchaseHistoryDeleteWithUid:uids Success:^(id responseObject) {
        //NSLog(@"%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 1) {

            [removeArr enumerateObjectsUsingBlock:^(HotBuyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([blockSelf.recordMarr containsObject:model]) {
                    [blockSelf.recordMarr removeObject:model];
                }
            }];
            [blockSelf.recordsVC reloadData];
            if (blockSelf.recordMarr.count == 0) {
                _bottomcell.hidden = YES;
                self.recordsVC.editing = NO;
                self.recordsVC.frame = CGRectMake(0, self.recordsVC.frame.origin.y, Width, Height-64);
                [self requestData];
            }
            if (_removeArray.count > 0) {
                [_removeArray removeAllObjects];
            }
            if (_deleteIndexArr.count > 0) {
                _deleteIndexArr = nil;
            }
            _bottomcell.count = 0;
            _bottomcell.hidden = YES;
            //[self updateBottomDeleteCellView];
            [ToastView showToast:@"删除成功" withOriginY:200 withSuperView:self.view];
            self.recordsVC.frame = CGRectMake(0, self.recordsVC.frame.origin.y, Width, Height-64);//更改tableview 的frame
            __weak typeof(self) weakSelf = self;//解决循环引用的问题
            [self.recordsVC addHeaderWithCallback:^{//添加刷新控件
                [weakSelf requestPurchaseRecordsList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
            }];

        }
        else {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"error"]] withOriginY:200 withSuperView:self.view];
        }
    } failure:^(NSError *error) {
        //[HTTPCLIENT]
    }];

}

- (void)initData {
    self.page = 1;
    self.recordMarr = [NSMutableArray array];
    self.buyDataAry = [NSMutableArray array];
    _removeArray = [NSMutableArray array];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.recordMarr.count == 0) {
        return 260;
    }
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if (self.recordMarr.count == 0) {
        return 1;
    }
    return self.recordMarr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.recordMarr.count == 0) {
        ZIKEmptyTableViewCell *cell =  [[[NSBundle mainBundle] loadNibNamed:@"ZIKEmptyTableViewCell" owner:self options:nil] lastObject];
        return cell;
    }
    BuySearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BuySearchTableViewCell IDStr]];
    if (!cell) {
        cell = [[BuySearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[BuySearchTableViewCell IDStr] WithFrame:CGRectMake(0, 0, kWidth, 65)];
    }
    HotBuyModel  *model = self.recordMarr[indexPath.row];
    cell.hotBuyModel = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        HotBuyModel *model = self.recordMarr[indexPath.row];
        [_removeArray addObject:model];
        _bottomcell.count = _removeArray.count;
        NSArray *selectedRows = [self.recordsVC indexPathsForSelectedRows];
        _deleteIndexArr = selectedRows;
        [self updateBottomDeleteCellView];
        return;
    }
    else {
        HotBuyModel *model = self.recordMarr[indexPath.row];
        BuyDetialInfoViewController *buyDetialVC=[[BuyDetialInfoViewController alloc]initMyDetialWithSaercherInfo:model.supplybuyUid];
        [self.navigationController pushViewController:buyDetialVC animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - 更改底部删除视图( 过期编辑状态下  是否全选)
- (void)updateBottomDeleteCellView {
    (_deleteIndexArr.count == self.recordMarr.count) ? (_bottomcell.isAllSelect = YES) : (_bottomcell.isAllSelect = NO);
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    HotBuyModel *model = [self.recordMarr objectAtIndex:indexPath.row];

    if ([_removeArray containsObject:model]) {//删除反选数据
        [_removeArray removeObject:model];
    }
    NSArray *selectedRows = [self.recordsVC indexPathsForSelectedRows];
    _deleteIndexArr = selectedRows;
    _bottomcell.count = _removeArray.count;
    [self updateBottomDeleteCellView];
}

- (void)requestPurchaseRecordsList:(NSString *)page {
    //我的供应列表
    [self.recordsVC headerEndRefreshing];

    [HTTPCLIENT purchaseHistoryWithPage:page Success:^(id responseObject) {
        ;
        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
            return ;
        }
        else {

            NSArray *array = [responseObject objectForKey:@"result"];
            if (array.count == 0 && self.page == 1) {
                //[self.recordMarr removeAllObjects];
                [self.recordsVC footerEndRefreshing];
                [self.recordsVC reloadData];
                //[ToastView showToast:@"暂无数据" withOriginY:200 withSuperView:self.view];
                return ;
            }
            else if (array.count == 0 && self.page > 1) {
                self.page--;
                [self.recordsVC footerEndRefreshing];
                //没有更多数据了
                [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
                return;
            }
            else {
                if (self.page == 1) {
                    [self.recordMarr removeAllObjects];
                }
                [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                    HotBuyModel *model = [HotBuyModel hotBuyModelCreatByDic:dic];
                    [self.recordMarr addObject:model];
                }];
                [self.recordsVC reloadData];
                [self.recordsVC footerEndRefreshing];
            }


        }
    } failure:^(NSError *error) {
        ;
    }];
}

#pragma mark - 可选实现的协议方法
// 删除时的提示文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

// 开启某行是否可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 设置cell行编辑风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;

}

// 编辑时触发的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"commitEditingStyle");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
