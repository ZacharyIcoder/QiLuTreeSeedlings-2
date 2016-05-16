//
//  ZIKHaveReadInfoViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/14.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKHaveReadInfoViewController.h"

#import "MJRefresh.h"
#import "YYModel.h"
#import "ZIKHaveReadTableViewCell.h"
#import "YLDCustomUnReadTableViewCell.h"
#import "ZIKBottomDeleteTableViewCell.h"//底部删除view,可编辑状态下
//#import "ZIKHaveReadModel.h"
#import "ZIKCustomizedInfoListModel.h"
#import "BuyDetialInfoViewController.h"
@interface ZIKHaveReadInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView    *readVC;      //已读信息列表
@property (nonatomic, strong) NSMutableArray *readDataMArr;//已读信息数据Marr
@property (nonatomic, assign) NSInteger      page;         //页数从1开始
@end

@implementation ZIKHaveReadInfoViewController
{
    ZIKBottomDeleteTableViewCell *_bottomcell;
    NSMutableArray *_removeArray;
    UILongPressGestureRecognizer *_longPressGr;
    NSArray *_deleteIndexArr;//选中的删除index
}

#pragma mark - 返回箭头按钮点击事件
-(void)backBtnAction:(UIButton *)sender
{
    if (self.readVC.editing) {
        self.readVC.editing = NO;
        if (_removeArray.count > 0) {//选中的删除model清空
            [_removeArray removeAllObjects];
        }
        if (_deleteIndexArr.count > 0) {//选中的删除cell 的 index清空
            _deleteIndexArr = nil;
        }
        _bottomcell.hidden = YES;
        _bottomcell.count = 0;
        self.readVC.frame = CGRectMake(0, self.readVC.frame.origin.y, Width, Height-64);//更改tableview 的frame
        __weak typeof(self) weakSelf = self;//解决循环引用的问题
        [self.readVC addHeaderWithCallback:^{//添加刷新控件
            [weakSelf requestHaveReadList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
        }];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = [NSString stringWithFormat:@"定制:%@",self.name];
    [self initData];
    [self initUI];
    [self requestData];
}

#pragma mark - 请求数据
- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.readVC addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestHaveReadList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.readVC addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestHaveReadList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.readVC headerBeginRefreshing];
}

#pragma mark - 初始化数据
- (void)initData {
    self.page         = 1;
    self.readDataMArr = [[NSMutableArray alloc] init];
    _removeArray = [[NSMutableArray alloc] init];
}

#pragma mark - 初始化UI
- (void)initUI {
    self.readVC = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Height-64) style:UITableViewStylePlain];
    self.readVC.backgroundColor = [UIColor clearColor];
    self.readVC.dataSource = self;
    self.readVC.delegate   = self;
    [self.view addSubview:self.readVC];
    [ZIKFunction setExtraCellLineHidden:self.readVC];
    self.readVC.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.readVC.allowsMultipleSelectionDuringEditing = YES;

    //添加长按手势
    _longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR)];
    [self.readVC addGestureRecognizer:_longPressGr];

    //底部删除view
    _bottomcell = [ZIKBottomDeleteTableViewCell cellWithTableView:nil];
    _bottomcell.count = 0;
    _bottomcell.frame = CGRectMake(0, Height-BOTTOM_DELETE_CELL_HEIGHT, Width, BOTTOM_DELETE_CELL_HEIGHT);
    [self.view addSubview:_bottomcell];
    [_bottomcell.seleteImageButton addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomcell.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _bottomcell.hidden = YES;

}

- (void)tapGR {
    if (!self.readVC.editing) {
        [self.readVC removeHeader];//编辑状态取消下拉刷新
        self.readVC.editing = YES;
        _bottomcell.hidden = NO;
        _bottomcell.isAllSelect = NO;
        self.readVC.frame = CGRectMake(0, self.readVC.frame.origin.y, Width, Height-64-BOTTOM_DELETE_CELL_HEIGHT);
    }
}

- (void)selectBtnClick {
    _bottomcell.isAllSelect = !_bottomcell.isAllSelect;
    if (_bottomcell.isAllSelect) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        [self.readDataMArr enumerateObjectsUsingBlock:^(ZIKCustomizedInfoListModel  *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [_removeArray addObject:myModel];
        }];
        NSMutableArray *tempMArr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.readDataMArr.count; i++) {
            [self.readVC selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
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
        for (NSInteger i = 0; i < self.readDataMArr.count; i++) {
            [self.readVC deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
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
    [_removeArray enumerateObjectsUsingBlock:^(ZIKCustomizedInfoListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        uidString = [uidString stringByAppendingString:[NSString stringWithFormat:@",%@",model.uid]];
    }];
    NSString *uids = [uidString substringFromIndex:1];
    [HTTPCLIENT deleterecordWithIds:uids Success:^(id responseObject) {
        //NSLog(@"%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 1) {

            [removeArr enumerateObjectsUsingBlock:^(ZIKCustomizedInfoListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([blockSelf.readDataMArr containsObject:model]) {
                    [blockSelf.readDataMArr removeObject:model];
                }
            }];
            [blockSelf.readVC reloadData];
            if (blockSelf.readDataMArr.count == 0) {
                _bottomcell.hidden = YES;
                self.readVC.editing = NO;
                self.readVC.frame = CGRectMake(0, self.readVC.frame.origin.y, Width, Height-64);
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
            self.readVC.frame = CGRectMake(0, self.readVC.frame.origin.y, Width, Height-64);//更改tableview 的frame
            __weak typeof(self) weakSelf = self;//解决循环引用的问题
            [self.readVC addHeaderWithCallback:^{//添加刷新控件
                [weakSelf requestHaveReadList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
            }];

        }
        else {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"error"]] withOriginY:200 withSuperView:self.view];
        }
    } failure:^(NSError *error) {
    }];
    
}

#pragma mark - 请求列表信息
- (void)requestHaveReadList:(NSString *)page {

    [self.readVC headerEndRefreshing];
    HttpClient *httpClient = [HttpClient sharedClient];
    [httpClient recordByProductWithProductUid:self.uidStr pageSize:page Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
            return ;
        }
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        NSArray *array = dic[@"recordList"];
        if (array.count == 0 && self.page == 1) {
            [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
            if (self.readDataMArr.count > 0) {
                [self.readDataMArr removeAllObjects];
            }
            [self.readVC footerEndRefreshing];
            [self.readVC reloadData];
            return ;
        }
        else if (array.count == 0 && self.page > 1) {
            self.page--;
            [self.readVC footerEndRefreshing];
            //没有更多数据了
            [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
            return;
        }
        else {

            if (self.page == 1) {
                [self.readDataMArr removeAllObjects];
            }
            [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKCustomizedInfoListModel *model = [ZIKCustomizedInfoListModel yy_modelWithDictionary:dic];
                [self.readDataMArr addObject:model];
            }];

            [self.readVC reloadData];
            if (self.readVC.editing) {
                if (_deleteIndexArr.count > 0) {
                    [_deleteIndexArr enumerateObjectsUsingBlock:^(NSIndexPath *selectDeleteIndex, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.readVC selectRowAtIndexPath:selectDeleteIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
                    }];
                }
                //[self updateBottomDeleteCellView];
            }
            [self.readVC footerEndRefreshing];

        }

    } failure:^(NSError *error) {
        ;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.readDataMArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kZIKCustomizedInfoListTableViewCellID = @"YLDCustomUnReadTableViewCell";
    YLDCustomUnReadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKCustomizedInfoListTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YLDCustomUnReadTableViewCell" owner:self options:nil] lastObject];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.readDataMArr.count > 0) {
        cell.model = self.readDataMArr[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        ZIKCustomizedInfoListModel *model = self.readDataMArr[indexPath.row];
        [_removeArray addObject:model];
        _bottomcell.count = _removeArray.count;
        NSArray *selectedRows = [self.readVC indexPathsForSelectedRows];
        _deleteIndexArr = selectedRows;
        [self updateBottomDeleteCellView];
        return;
    }
    else {
        ZIKCustomizedInfoListModel *model = self.readDataMArr[indexPath.row];
        BuyDetialInfoViewController *buyDetialVC=[[BuyDetialInfoViewController alloc]initWithDingzhiModel:model];
        [self.navigationController pushViewController:buyDetialVC animated:YES];
//        ZIKCustomizedInfoListModel *model = self.customizedInfoMArr[indexPath.row];
//        BuyDetialInfoViewController *viewC = [[BuyDetialInfoViewController alloc]initWithDingzhiModel:model];
//        [self.navigationController pushViewController:viewC animated:YES];

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - 更改底部删除视图( 过期编辑状态下  是否全选)
- (void)updateBottomDeleteCellView {
    (_deleteIndexArr.count == self.readDataMArr.count) ? (_bottomcell.isAllSelect = YES) : (_bottomcell.isAllSelect = NO);
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKCustomizedInfoListModel *model = [self.readDataMArr objectAtIndex:indexPath.row];

    if ([_removeArray containsObject:model]) {//删除反选数据
        [_removeArray removeObject:model];
    }
    NSArray *selectedRows = [self.readVC indexPathsForSelectedRows];
    _deleteIndexArr = selectedRows;
    _bottomcell.count = _removeArray.count;
    [self updateBottomDeleteCellView];
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
