//
//  ZIKCustomizedInfoListViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKCustomizedInfoListViewController.h"

/*****工具******/
#import "MJRefresh.h"
#import "YYModel.h"
/*****工具******/

/*****Model******/
#import "ZIKCustomizedModel.h"
/*****Model******/

/*****View******/
#import "BuyOtherInfoTableViewCell.h"
#import "ZIKCustomizedTableViewCell.h"
#import "ZIKBottomDeleteTableViewCell.h"
#import "ZIKHintTableViewCell.h"
/*****View******/

/*****Controller******/
#import "ZIKCustomizedSetViewController.h"
/*****Controller******/


@interface ZIKCustomizedInfoListViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, assign) NSInteger      page;//页数从1开始
@property (nonatomic, strong) NSMutableArray *customizedInfoMArr;//定制信息数组
@property (nonatomic, strong) UITableView    *myCustomizedInfoTableView;//我的定制信息列表

@end

@implementation ZIKCustomizedInfoListViewController
{
    @private
    UIView *_emptyUI;//无数据时显示的空白view
    NSMutableArray *_removeArray; // 保存选中行数据
    ZIKBottomDeleteTableViewCell *_bottomcell;//底部全选删除视图
    UILongPressGestureRecognizer *_tapDeleteGR;//长按删除手势
    NSArray *_deleteIndexArr;//选中的删除index
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self configNav];//配置navgationview
    [self initUI];//初始化UI
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self initData];
    [self requestData];
    self.myCustomizedInfoTableView.editing = NO;
    self.myCustomizedInfoTableView.frame = CGRectMake(0, 64+HINT_VIEW_HEIGHT, Width, Height-64-HINT_VIEW_HEIGHT);
    if (_removeArray.count > 0) {
        [_removeArray removeAllObjects];
    }
    _bottomcell.count = 0;
    _bottomcell.hidden = YES;
}

- (void)configNav {
    self.vcTitle = @"已定制信息";//标题
    self.rightBarBtnTitleString  = @"定制";
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{
        ZIKCustomizedSetViewController *setVC = [[ZIKCustomizedSetViewController alloc] init];
        [weakSelf.navigationController pushViewController:setVC animated:YES];
    };
}

- (void)requestData {
//    [self requestSellList:[NSString stringWithFormat:@"%ld",(long)self.page]];
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.myCustomizedInfoTableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.myCustomizedInfoTableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.myCustomizedInfoTableView headerBeginRefreshing];
}

- (void)initUI {
    
    ZIKHintTableViewCell *hintCell =  [[[NSBundle mainBundle] loadNibNamed:@"ZIKHintTableViewCell" owner:self options:nil] lastObject];
    hintCell.frame = CGRectMake(0, 64, Width, HINT_VIEW_HEIGHT);
    [self.view addSubview:hintCell];

    self.myCustomizedInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hintCell.frame), Width, Height-64-HINT_VIEW_HEIGHT) style:UITableViewStyleGrouped];
    self.myCustomizedInfoTableView.delegate   = self;
    self.myCustomizedInfoTableView.dataSource = self;
    [self.view addSubview:self.myCustomizedInfoTableView];
    [ZIKFunction setExtraCellLineHidden:self.myCustomizedInfoTableView];

    _tapDeleteGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteCell)];
    [self.myCustomizedInfoTableView addGestureRecognizer:_tapDeleteGR];
    [self.myCustomizedInfoTableView addObserver:self forKeyPath:@"editing" options:NSKeyValueObservingOptionNew context:NULL];


    //底部结算view
    _bottomcell = [ZIKBottomDeleteTableViewCell cellWithTableView:nil];
    _bottomcell.frame = CGRectMake(0, Height-BOTTOM_DELETE_CELL_HEIGHT, Width, BOTTOM_DELETE_CELL_HEIGHT);
    [self.view addSubview:_bottomcell];
    [_bottomcell.seleteImageButton addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _bottomcell.hidden = YES;
    [_bottomcell.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"editing"]) {
        if ([[change valueForKey:NSKeyValueChangeNewKey] integerValue] == 1) {
            [self.myCustomizedInfoTableView removeGestureRecognizer:_tapDeleteGR];
        }
        else {
            [self.myCustomizedInfoTableView addGestureRecognizer:_tapDeleteGR];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
    [self.myCustomizedInfoTableView removeObserver:self forKeyPath:@"editing"];
}

- (void)requestSellList:(NSString *)page {
    //我的供应列表;
    [self.myCustomizedInfoTableView headerEndRefreshing];
    HttpClient *httpClient = [HttpClient sharedClient];
    [httpClient getCustomSetListInfo:page pageSize:@"15" Success:^(id responseObject) {

        NSDictionary *dic = [responseObject objectForKey:@"result"];
        NSArray *array = dic[@"list"];
        if (array.count == 0 && self.page == 1) {
            [self.customizedInfoMArr removeAllObjects];
            [self.myCustomizedInfoTableView footerEndRefreshing];
            self.myCustomizedInfoTableView.hidden = YES;
            [self createEmptyUI];
            _emptyUI.hidden = NO;
            return ;
        }
        else if (array.count == 0 && self.page > 1) {
            self.myCustomizedInfoTableView.hidden = NO;
            _emptyUI.hidden = YES;
            self.page--;
            [self.myCustomizedInfoTableView footerEndRefreshing];
            //没有更多数据了
            [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
            return;
        }
        else {
            self.myCustomizedInfoTableView.hidden = NO;
            _emptyUI.hidden = YES;
            if (self.page == 1) {
                [self.customizedInfoMArr removeAllObjects];
            }
            [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKCustomizedModel *model = [ZIKCustomizedModel yy_modelWithDictionary:dic];
                [self.customizedInfoMArr addObject:model];

            }];
            [self.myCustomizedInfoTableView reloadData];
            if (self.myCustomizedInfoTableView.editing) {
                if (_deleteIndexArr.count > 0) {
                    [_deleteIndexArr enumerateObjectsUsingBlock:^(NSIndexPath *selectDeleteIndex, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.myCustomizedInfoTableView selectRowAtIndexPath:selectDeleteIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
                    }];
                }
                [self totalCount];
            }


            [self.myCustomizedInfoTableView footerEndRefreshing];
        }

    } failure:^(NSError *error) {

    }];
}

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
- (void)selectBtnClick {
    _bottomcell.isAllSelect = !_bottomcell.isAllSelect;
    if (_bottomcell.isAllSelect) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        [self.customizedInfoMArr enumerateObjectsUsingBlock:^(ZIKCustomizedModel *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [_removeArray addObject:myModel];
        }];
        NSMutableArray *tempMArr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.customizedInfoMArr.count; i++) {
            [self.myCustomizedInfoTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [tempMArr addObject:[NSIndexPath indexPathForRow:0 inSection:i]];
        }
        _deleteIndexArr = (NSArray *)tempMArr;


    }
    else if (_bottomcell.isAllSelect == NO) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        _deleteIndexArr = nil;
        for (NSInteger i = 0; i < self.customizedInfoMArr.count; i++) {
            [self.myCustomizedInfoTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] animated:YES];
        }

    }
    [self totalCount];
}

-(void)backBtnAction:(UIButton *)sender
{
    if (self.myCustomizedInfoTableView.editing) {
        self.myCustomizedInfoTableView.editing = NO;
        _bottomcell.hidden = YES;
        self.myCustomizedInfoTableView.frame = CGRectMake(0, 64+HINT_VIEW_HEIGHT, Width, Height-64-HINT_VIEW_HEIGHT);
        __weak typeof(self) weakSelf = self;//解决循环引用的问题
        [self.myCustomizedInfoTableView addHeaderWithCallback:^{//添加刷新控件
            [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",weakSelf.page]];
        }];

    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)deleteCell {
    if (self.customizedInfoMArr.count == 0) {
        return;
    }
    if (!self.myCustomizedInfoTableView.editing)
    {
        self.myCustomizedInfoTableView.editing = YES;
        _bottomcell.hidden = NO;
        self.myCustomizedInfoTableView.frame = CGRectMake(0, 64+HINT_VIEW_HEIGHT, Width, Height-64-HINT_VIEW_HEIGHT-BOTTOM_DELETE_CELL_HEIGHT);
        [self.myCustomizedInfoTableView removeHeader];//编辑状态取消下拉刷新
        _bottomcell.isAllSelect = NO;
        if (_removeArray.count > 0) {
            [_removeArray enumerateObjectsUsingBlock:^(ZIKCustomizedModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                model.isSelect = NO;
            }];
            [_removeArray removeAllObjects];
        }
        [self totalCount];
    }

}

- (void)totalCount {
    _bottomcell.count = _removeArray.count;
    if (_removeArray.count == self.customizedInfoMArr.count) {
        _bottomcell.isAllSelect = YES;
    }
    else {
        _bottomcell.isAllSelect = NO;
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];

    [self.myCustomizedInfoTableView setEditing:YES animated:animated];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //ZIKCustomizedModel *model = self.customizedInfoMArr[indexPath.section];
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    ZIKCustomizedModel *model = self.customizedInfoMArr[section];
        return  model.spec.count*30+20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;//self.customizedInfoMArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.customizedInfoMArr.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ZIKCustomizedModel *model = self.customizedInfoMArr[section];
    BuyOtherInfoTableViewCell *mycell = [[BuyOtherInfoTableViewCell alloc] init];
    mycell.frame = CGRectMake(0, 0, kWidth, model.spec.count*30+20);
    mycell.backgroundColor = [UIColor whiteColor];
    mycell.dingzhiAry = model.spec;
    mycell.selectionStyle = UITableViewCellSelectionStyleNone;

    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.frame = mycell.frame;
    [backView addSubview:mycell];

    return backView;
}

-(void)showOtherMessageAction:(UIButton *)sender
{
    if (self.customizedInfoMArr.count > 0) {
//        ZIKCustomizedModel *model = self.customizedInfoMArr[sender.tag];
//        model.isShow = !model.isShow;
        //一个section刷新
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:sender.tag];
        [self.myCustomizedInfoTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if (self.myCustomizedInfoTableView.editing) {
        if (_deleteIndexArr.count > 0) {
            [_deleteIndexArr enumerateObjectsUsingBlock:^(NSIndexPath *selectDeleteIndex, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.myCustomizedInfoTableView selectRowAtIndexPath:selectDeleteIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
            }];
        }
        [self totalCount];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKCustomizedTableViewCell *cell = [ZIKCustomizedTableViewCell cellWithTableView:tableView];
    if (self.customizedInfoMArr.count > 0) {
           ZIKCustomizedModel *model = self.customizedInfoMArr[indexPath.section];
           [cell configureCell:model];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKCustomizedModel *model = self.customizedInfoMArr[indexPath.section];
    if (self.myCustomizedInfoTableView.editing)
    {
            [_removeArray addObject:model];
            _bottomcell.count = _removeArray.count;
            NSArray *selectedRows = [self.myCustomizedInfoTableView indexPathsForSelectedRows];
            _deleteIndexArr = selectedRows;
        [self totalCount];
        return;
    }

    ZIKCustomizedSetViewController *viewC = [[ZIKCustomizedSetViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:viewC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
// 反选方法
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 判断编辑状态,必须要写
    if (self.myCustomizedInfoTableView.editing)
    {
        // 获取当前反选显示数据
        ZIKCustomizedModel *tempModel = [self.customizedInfoMArr objectAtIndex:indexPath.section];
        if ([_removeArray containsObject:tempModel]) {//删除反选数据
            [_removeArray removeObject:tempModel];
        }
        NSArray *selectedRows = [self.myCustomizedInfoTableView indexPathsForSelectedRows];
        _deleteIndexArr = selectedRows;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"commitEditingStyle");
}

- (void)createEmptyUI {
    if (!_emptyUI) {
        _emptyUI                 = [[UIView alloc] init];
        _emptyUI.frame           = CGRectMake(0, 64, Width, 260);
        _emptyUI.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_emptyUI];
        UIImageView *imageView  = [[UIImageView alloc] init];
        imageView.frame         = CGRectMake(Width/2-50, 25, 100, 100);
        imageView.image         = [UIImage imageNamed:@"图片2"];
        [_emptyUI addSubview:imageView];

        UILabel *label1         = [[UILabel alloc] init];
        label1.frame            = CGRectMake(0, CGRectGetMaxY(imageView.frame)+10, Width, 25);
        label1.text             = @"您还没有定制任何信息~";
        label1.textAlignment    = NSTextAlignmentCenter;
        label1.textColor        = detialLabColor;
        [_emptyUI addSubview:label1];

        UILabel *label2         = [[UILabel alloc] init];
        label2.frame            = CGRectMake(0, CGRectGetMaxY(label1.frame), Width, label1.frame.size.height);
        label2.text             = @"点击右上角开始添加吧";
        label2.textColor        = detialLabColor;
        label2.textAlignment    = NSTextAlignmentCenter;
        [_emptyUI addSubview:label2];

    }

 }

- (void)initData {
    self.page               = 1;
    self.customizedInfoMArr = [NSMutableArray array];
    _removeArray            = [NSMutableArray array];
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
            [_removeArray enumerateObjectsUsingBlock:^(ZIKCustomizedModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                uidString = [uidString stringByAppendingString:[NSString stringWithFormat:@",%@",model.customsetUid]];
            }];
            NSString *uids = [uidString substringFromIndex:1];
            [HTTPCLIENT deleteCustomSetInfo:uids Success:^(id responseObject) {
                //NSLog(@"%@",responseObject);
                if ([responseObject[@"success"] integerValue] == 1) {
                    [ToastView showToast:@"删除成功" withOriginY:250 withSuperView:self.view];
                    [removeArr enumerateObjectsUsingBlock:^(ZIKCustomizedModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([blockSelf.customizedInfoMArr containsObject:model]) {
                            [blockSelf.customizedInfoMArr removeObject:model];
                        }
                    }];
//                    [blockSelf.myCustomizedInfoTableView reloadData];
//                     if (blockSelf.customizedInfoMArr.count == 0) {
                        [self requestData];
                        _bottomcell.hidden = YES;
                        self.myCustomizedInfoTableView.editing = NO;
                    self.myCustomizedInfoTableView.frame = CGRectMake(0, 64+HINT_VIEW_HEIGHT, Width, Height-64-HINT_VIEW_HEIGHT);

                    //}
                    if (_removeArray.count > 0) {
                        [_removeArray removeAllObjects];
                    }
                    [self totalCount];
                }
                else {
                    [ToastView showToast:@"删除失败" withOriginY:250 withSuperView:self.view];
                }
            } failure:^(NSError *error) {
                
            }];

        }
    }
}


@end
