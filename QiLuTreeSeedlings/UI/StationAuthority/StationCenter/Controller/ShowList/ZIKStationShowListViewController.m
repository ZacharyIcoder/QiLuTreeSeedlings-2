//
//  ZIKStationShowListViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/8/29.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationShowListViewController.h"

/*****工具******/
#import "HttpClient.h"
#import "YYModel.h"//类型转换
#import "MJRefresh.h"//MJ刷新
#import "ZIKFunction.h"
/*****工具******/

#import "ZIKAddShowListViewController.h"//新增晒单
#import "ZIKAddShaiDanViewController.h"//新增晒单
#import "ZIKSelectMenuView.h"

#import "ZIKShaiDanTableViewCell.h"
#import "ZIKShaiDanModel.h"

#import "ZIKStationShowListDetailViewController.h"//晒单详情
#import "ZIKBottomDeleteTableViewCell.h"//底部删除view


#define REFRESH_CELL_HEIGH 50 //底部删除view视图高度

@interface ZIKStationShowListViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *showListTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomLayoutConstraint;
@property (nonatomic, assign) NSInteger      page;            //页数从1开始
@property (nonatomic, strong) NSMutableArray *shaiData;

@property (nonatomic, assign) NSInteger shaiType;//0全部，1我的
@end

@implementation ZIKStationShowListViewController
{
    @private
    UILongPressGestureRecognizer *_tapDeleteGR;//长按手势
    ZIKBottomDeleteTableViewCell *_bottomcell; //编辑底部删除view
    
    NSMutableArray *_removeArray;    // 保存选中行数据
    NSArray *_deleteIndexArr;//编辑状态下,选中的删除index
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initUI];
//    [self requestData];
}

#pragma  mark - 初始化数据
- (void)initData {
    self.page           = 1;//页面page从1开始
    self.shaiData = [NSMutableArray array];
//    _refreshMarr        = [[NSMutableArray alloc] init];
    _removeArray        = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self requestData];
}

- (void)initUI {
   self.vcTitle = @"站长晒单";
   self.leftBarBtnImgString = @"BackBtn";
   self.rightBarBtnTitleString = @"新增晒单";
    __weak typeof(self) weakSelf  = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{
        ZIKAddShaiDanViewController *addShowListVC = [[ZIKAddShaiDanViewController alloc] initWithNibName:@"ZIKAddShaiDanViewController" bundle:nil];
        [weakSelf.navigationController pushViewController:addShowListVC animated:YES];

//        ZIKAddShowListViewController *addShowListVC = [[ZIKAddShowListViewController alloc] initWithNibName:@"ZIKAddShowListViewController" bundle:nil];
//        [weakSelf.navigationController pushViewController:addShowListVC animated:YES];

    };

    NSArray *titleArray = [NSArray arrayWithObjects:@"全部晒单",@"我的晒单", nil];
    ZIKSelectMenuView *selectMenuView = [[ZIKSelectMenuView alloc] initWithFrame:CGRectMake(0, 64, kWidth, 43) dataArray:titleArray];
    selectMenuView.menuBtnBlock = ^(NSInteger menuBtnTag){
          if (menuBtnTag == 0) {
              CLog(@"全部晒单");
              weakSelf.showListTableView.editing = NO;
              if (_removeArray.count > 0) {//选中的删除model清空
                  [_removeArray removeAllObjects];
              }
              if (_deleteIndexArr.count > 0) {//选中的删除cell 的 index清空
                  _deleteIndexArr = nil;
              }

              _bottomcell.hidden = YES;
              _bottomcell.count = 0;
              weakSelf.tableBottomLayoutConstraint.constant = 0;
              [weakSelf.showListTableView addHeaderWithCallback:^{
                  [weakSelf requestMyQuoteList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
              }];
        } else {
            CLog(@"我的晒单");
        }
        weakSelf.shaiType = menuBtnTag;
        weakSelf.page = 1;
        [weakSelf.showListTableView headerBeginRefreshing];
    };
    [self.view addSubview:selectMenuView];

    self.showListTableView.delegate = self;
    self.showListTableView.dataSource = self;
    [ZIKFunction setExtraCellLineHidden:self.showListTableView];
    
    self.showListTableView.allowsMultipleSelectionDuringEditing = YES;
    
    //添加长按手势
    _tapDeleteGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR)];
    [self.showListTableView addGestureRecognizer:_tapDeleteGR];
    
    //底部删除view
    _bottomcell = [ZIKBottomDeleteTableViewCell cellWithTableView:nil];
    _bottomcell.count = 0;
    _bottomcell.frame = CGRectMake(0, Height-REFRESH_CELL_HEIGH, Width, REFRESH_CELL_HEIGH);
    [self.view addSubview:_bottomcell];
    [_bottomcell.seleteImageButton addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomcell.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _bottomcell.hidden = YES;

    __weak typeof(_bottomcell) weakCell  = _bottomcell;//解决循环引用的问题
    __weak typeof(_removeArray) weakRemove  = _removeArray;//解决循环引用的问题
//    __weak typeof(_deleteIndexArr) weakIndex  = _deleteIndexArr;//解决循环引用的问题

    self.leftBarBtnBlock = ^{
        if (weakSelf.showListTableView.editing) {
            weakSelf.showListTableView.editing = NO;
            weakCell.hidden = YES;
            if (weakRemove.count > 0) {//选中的删除model清空
                [weakRemove removeAllObjects];
            }
            if (_deleteIndexArr.count > 0) {//选中的删除cell 的 index清空
                _deleteIndexArr = nil;
            }
            weakCell.count = 0;
            weakSelf.tableBottomLayoutConstraint.constant = 0;
        } else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };

}


#pragma mark - 请求数据
- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.showListTableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestMyQuoteList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.showListTableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestMyQuoteList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.showListTableView headerBeginRefreshing];
}

- (void)requestMyQuoteList:(NSString *)page {
    [self.showListTableView headerEndRefreshing];
    [HTTPCLIENT workstationAllShaiDanWithThpe:_shaiType PageNumber:page pageSize:@"15" Success:^(id responseObject) {
        //CLog(@"%@",responseObject) ;
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        }
        NSDictionary *resultDic = responseObject[@"result"];
        NSArray *quoteListArray = resultDic[@"list"];
        if (self.page == 1 && quoteListArray.count == 0) {
            [ToastView showTopToast:@"暂无数据"];
            [self.showListTableView footerEndRefreshing];
            if(self.shaiData.count > 0 ) {
                [self.shaiData removeAllObjects];
            }
            [self.showListTableView reloadData];
            return ;
        } else if (quoteListArray.count == 0 && self.page > 1) {
            [ToastView showTopToast:@"已无更多信息"];
            self.page--;
            [self.showListTableView footerEndRefreshing];
            return;
        } else {
            if (self.page == 1) {
                [self.shaiData removeAllObjects];
            }

            [quoteListArray enumerateObjectsUsingBlock:^(NSDictionary *orderDic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKShaiDanModel *model = [ZIKShaiDanModel yy_modelWithDictionary:orderDic];
                [self.shaiData addObject:model];
            }];

            [self.showListTableView reloadData];
            if (self.showListTableView.editing) {
                if (_deleteIndexArr.count > 0) {
                    [_deleteIndexArr enumerateObjectsUsingBlock:^(NSIndexPath *selectDeleteIndex, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.showListTableView selectRowAtIndexPath:selectDeleteIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
                    }];
                }
                [self updateBottomDeleteCellView];
            }

            [self.showListTableView footerEndRefreshing];

        }

        
    } failure:^(NSError *error) {
        ;
    }];
}

#pragma mark - tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shaiData.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKShaiDanTableViewCell *cell = [ZIKShaiDanTableViewCell cellWithTableView:tableView];
    if (self.shaiData.count > 0) {
        [cell configureCell:self.shaiData[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKShaiDanModel *model = self.shaiData[indexPath.row];
    
    if (self.showListTableView.editing) {
        [_removeArray addObject:model];
        _bottomcell.count = _removeArray.count;
        NSArray *selectedRows = [self.showListTableView indexPathsForSelectedRows];
        _deleteIndexArr = selectedRows;
        
        [self updateBottomDeleteCellView];
        return;
    }

    ZIKStationShowListDetailViewController *detailVC = [[ZIKStationShowListDetailViewController alloc] initWithNibName:@"ZIKStationShowListDetailViewController" bundle:nil];
    detailVC.uid = model.uid;
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - tableviw反选cell事件
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKShaiDanModel *model = [self.shaiData objectAtIndex:indexPath.row];
    if (self.showListTableView.editing ) {//编辑状态
        if ([_removeArray containsObject:model]) {//删除反选数据
            [_removeArray removeObject:model];
        }
        NSArray *selectedRows = [self.showListTableView indexPathsForSelectedRows];
        _deleteIndexArr = selectedRows;
        _bottomcell.count = _removeArray.count;
        [self updateBottomDeleteCellView];
    }
}

#pragma mark - 更改底部删除视图( 过期编辑状态下  是否全选)
- (void)updateBottomDeleteCellView {
    (_deleteIndexArr.count == self.shaiData.count) ? (_bottomcell.isAllSelect = YES) : (_bottomcell.isAllSelect = NO);
}

#pragma mark - 长按触发事件
- (void)tapGR {
    if (self.shaiData.count == 0 || self.shaiType == 0) {
        return;
    }
    if (!self.showListTableView.editing) {
        [self.showListTableView removeHeader];//编辑状态取消下拉刷新
        self.showListTableView.editing = YES;
        _bottomcell.hidden = NO;
        _bottomcell.isAllSelect = NO;
//        self.showListTableView.frame = CGRectMake(0, self.showListTableView.frame.origin.y, Width, Height-64-50-REFRESH_CELL_HEIGH);
        self.tableBottomLayoutConstraint.constant = 50;
    }
    
}

#pragma mark - 底部全选按钮点击事件
- (void)selectBtnClick {
    _bottomcell.isAllSelect ? (_bottomcell.isAllSelect = NO) : (_bottomcell.isAllSelect = YES);
    if (_bottomcell.isAllSelect) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        [self.shaiData enumerateObjectsUsingBlock:^(ZIKShaiDanModel *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [_removeArray addObject:myModel];
        }];
        NSMutableArray *tempMArr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.shaiData.count; i++) {
            [self.showListTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [tempMArr addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        _deleteIndexArr = (NSArray *)tempMArr;
    }
    else if (_bottomcell.isAllSelect == NO) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        _deleteIndexArr = nil;
        for (NSInteger i = 0; i < self.shaiData.count; i++) {
            [self.showListTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
        }
    }
    _bottomcell.count = _removeArray.count;
}

#pragma mark - 底部删除按钮点击事件
- (void)deleteButtonClick {
    if (_removeArray.count  == 0) {
        [ToastView showToast:@"请选择要删除的选项" withOriginY:200 withSuperView:self.view];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除所选内容？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    alert.tag = 300;
    alert.delegate = self;
}


#pragma mark - 可选方法实现
#pragma mark - 设置删除按钮标题
// 设置删除按钮标题
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}

#pragma mark - 设置行是否可编辑
// 设置行是否可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
     return YES;
}

#pragma mark -  删除数据风格
// 删除数据风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"commitEditingStyle");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"%ld",(long)buttonIndex);
    if(alertView.tag == 300)//是否退出编辑
    {
        if (buttonIndex == 1) {
            __weak typeof(_removeArray) removeArr = _removeArray;
            __weak __typeof(self) blockSelf = self;

            __block NSString *uidString = @"";
            [_removeArray enumerateObjectsUsingBlock:^(ZIKShaiDanModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                uidString = [uidString stringByAppendingString:[NSString stringWithFormat:@",%@",model.uid]];
            }];
            NSString *uids = [uidString substringFromIndex:1];
            [HTTPCLIENT workstationShaiDanDeleteWithUids:uids Success:^(id responseObject) {
                if ([responseObject[@"success"] integerValue] == 1) {

                    [removeArr enumerateObjectsUsingBlock:^(ZIKShaiDanModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([blockSelf.shaiData containsObject:model]) {
                            [blockSelf.shaiData removeObject:model];
                        }
                    }];
                    [blockSelf.showListTableView reloadData];
                    if (blockSelf.shaiData.count == 0) {
                        _bottomcell.hidden = YES;
                        self.showListTableView.editing = NO;
//                        self.showListTableView.frame = CGRectMake(0, self.supplyTableView.frame.origin.y, Width, Height-64-50);
                        self.tableBottomLayoutConstraint.constant = 0;
                        [self requestData];
                    }
                    if (_removeArray.count > 0) {
                        [_removeArray removeAllObjects];
                    }
                    if (_deleteIndexArr.count > 0) {
                        _deleteIndexArr = nil;
                    }
                    _bottomcell.count = 0;
                    [self updateBottomDeleteCellView];
                    [ToastView showToast:@"删除成功" withOriginY:200 withSuperView:self.view];
                }
                else {
                    [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"error"]] withOriginY:200 withSuperView:self.view];
                }
            } failure:^(NSError *error) {

            }];
        }
    }
}


@end
