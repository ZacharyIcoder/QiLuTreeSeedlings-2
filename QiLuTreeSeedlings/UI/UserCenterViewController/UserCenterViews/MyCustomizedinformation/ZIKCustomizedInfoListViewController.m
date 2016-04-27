//
//  ZIKCustomizedInfoListViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKCustomizedInfoListViewController.h"
#import "ZIKCustomizedSetViewController.h"
#import "MJRefresh.h"
#import "YYModel.h"
#import "ZIKCustomizedModel.h"
#import "BuyOtherInfoTableViewCell.h"
#import "ZIKCustomizedTableViewCell.h"
#import "ZIKBottomDeleteTableViewCell.h"
@interface ZIKCustomizedInfoListViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UIView *emptyUI;
    // 保存选中行数据
    NSMutableArray *_removeArray;
    ZIKBottomDeleteTableViewCell *bottomcell;


}
@property (nonatomic, assign) NSInteger      page;//页数从1开始
@property (nonatomic, strong) NSMutableArray *customizedInfoMArr;//定制信息数组
@property (nonatomic, strong) UITableView    *myCustomizedInfoTableView;//我的定制信息列表
@end

@implementation ZIKCustomizedInfoListViewController
{
    UILongPressGestureRecognizer *tapDeleteGR;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNav];
    //[self initData];
    [self initUI];
    //[self requestData];
    //NSLog(@"%@",  [NSString stringWithUTF8String:object_getClassName(self)]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self initData];
    [self requestData];
}

- (void)configNav {
    self.vcTitle = @"已定制信息";
    self.rightBarBtnTitleString = @"定制";
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{
        //NSLog(@"添加");
        ZIKCustomizedSetViewController *setVC = [[ZIKCustomizedSetViewController alloc] init];
        [weakSelf.navigationController pushViewController:setVC animated:YES];
    };
}

- (void)requestData {
    ShowActionV();
    [self requestSellList:[NSString stringWithFormat:@"%ld",(long)self.page]];
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.myCustomizedInfoTableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        ShowActionV();
        [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.myCustomizedInfoTableView addFooterWithCallback:^{
        weakSelf.page++;
        ShowActionV();
        [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
}

- (void)initUI {
    self.myCustomizedInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Height-64) style:UITableViewStyleGrouped];
    self.myCustomizedInfoTableView.delegate   = self;
    self.myCustomizedInfoTableView.dataSource = self;
    [self.view addSubview:self.myCustomizedInfoTableView];
    [ZIKFunction setExtraCellLineHidden:self.myCustomizedInfoTableView];

    tapDeleteGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteCell)];
    [self.myCustomizedInfoTableView addGestureRecognizer:tapDeleteGR];
    [self.myCustomizedInfoTableView addObserver:self forKeyPath:@"editing" options:NSKeyValueObservingOptionNew context:NULL];


    //底部结算
    bottomcell = [ZIKBottomDeleteTableViewCell cellWithTableView:nil];
    bottomcell.frame = CGRectMake(0, Height-44, Width, 44);
    [self.view addSubview:bottomcell];
    [bottomcell.seleteImageButton addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    bottomcell.hidden = YES;
    [bottomcell.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"editing"]) {
        if ([[change valueForKey:NSKeyValueChangeNewKey] integerValue] == 1) {
            [self.myCustomizedInfoTableView removeGestureRecognizer:tapDeleteGR];
        }
        else {
            [self.myCustomizedInfoTableView addGestureRecognizer:tapDeleteGR];
        }
        // NSLog(@"Height is changed! new=%@", [change valueForKey:NSKeyValueChangeNewKey]);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
    [self.myCustomizedInfoTableView removeObserver:self forKeyPath:@"editing"];
}

- (void)requestSellList:(NSString *)page {
    //我的供应列表
    RemoveActionV();
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
            emptyUI.hidden = NO;
            return ;
        }
        else if (array.count == 0 && self.page > 1) {
            self.myCustomizedInfoTableView.hidden = NO;
            emptyUI.hidden = YES;
            self.page--;
            [self.myCustomizedInfoTableView footerEndRefreshing];
            //没有更多数据了
            [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
            return;
        }
        else {
            self.myCustomizedInfoTableView.hidden = NO;
            emptyUI.hidden = YES;
            if (self.page == 1) {
                [self.customizedInfoMArr removeAllObjects];
            }
            [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKCustomizedModel *model = [ZIKCustomizedModel yy_modelWithDictionary:dic];
                [self.customizedInfoMArr addObject:model];
            }];
            [self.myCustomizedInfoTableView reloadData];
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
    bottomcell.isAllSelect ? (bottomcell.isAllSelect = NO) : (bottomcell.isAllSelect = YES);
    if (bottomcell.isAllSelect) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        [self.customizedInfoMArr enumerateObjectsUsingBlock:^(ZIKCustomizedModel *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
            myModel.isSelect = YES;
            [_removeArray addObject:myModel];
        }];
        //[self.mySupplyTableView deselectRowAtIndexPath:[self.mySupplyTableView indexPathForSelectedRow] animated:YES];
    }
    else if (bottomcell.isAllSelect == NO) {
        [self.customizedInfoMArr enumerateObjectsUsingBlock:^(ZIKCustomizedModel *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
            myModel.isSelect = NO;
        }];
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }

    }
    [self totalCount];
    [self.myCustomizedInfoTableView reloadData];
}

-(void)backBtnAction:(UIButton *)sender
{
    if (self.myCustomizedInfoTableView.editing) {
        self.myCustomizedInfoTableView.editing = NO;
        bottomcell.hidden = YES;
        self.myCustomizedInfoTableView.frame = CGRectMake(0, 64, Width, Height-64);
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
    if (!self.myCustomizedInfoTableView.editing)
    {
        // barButtonItem.title = @"Remove";
        self.myCustomizedInfoTableView.editing = YES;
        bottomcell.hidden = NO;
        self.myCustomizedInfoTableView.frame = CGRectMake(0, 64, Width, Height-64-44);
        [self.myCustomizedInfoTableView removeHeader];//编辑状态取消下拉刷新
        bottomcell.isAllSelect = NO;
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
//    NSString *countString = [NSString stringWithFormat:@"合计:%d条",(int)_removeArray.count];
//    bottomcell.countLabel.text = countString;
    bottomcell.count = _removeArray.count;
    if (_removeArray.count == self.customizedInfoMArr.count) {
        bottomcell.isAllSelect = YES;
    }
    else {
        bottomcell.isAllSelect = NO;
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
    return  model.spec.count*30+10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;//self.customizedInfoMArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.customizedInfoMArr.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    //UIView *backView = [[UIView alloc] init];
    //backView.backgroundColor = [UIColor whiteColor];
    ZIKCustomizedModel *model = self.customizedInfoMArr[section];
    //backView.frame = CGRectMake(0, 0, kWidth, model.spec.count*30+30+10);
    BuyOtherInfoTableViewCell *mycell = [[BuyOtherInfoTableViewCell alloc] init];
    mycell.frame = CGRectMake(0, 0, kWidth, model.spec.count*30+10);
    mycell.backgroundColor = [UIColor whiteColor];
    mycell.dingzhiAry = model.spec;
    mycell.selectionStyle = UITableViewCellSelectionStyleNone;
    //[backView addSubview:mycell];
    //return backView;

    return mycell;
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

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    ZIKCustomizedModel *model = self.customizedInfoMArr[indexPath.row];
//    ZIKCustomizedSetViewController *viewC = [[ZIKCustomizedSetViewController alloc] initWithModel:model];
//    [self.navigationController pushViewController:viewC animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKCustomizedModel *model = self.customizedInfoMArr[indexPath.row];
    ZIKCustomizedTableViewCell *cell = (ZIKCustomizedTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    //    NSLog(@"%d",cell.selected);
    //    NSLog(@"%d",model.isSelect);
        // 判断编辑状态,必须要写
    if (self.myCustomizedInfoTableView.editing)
    {
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

        //NSLog(@"didSelectRowAtIndexPath");
        // 获取当前显示数据
        //ZIKSupplyModel *tempModel = [self.supplyInfoMArr objectAtIndex:indexPath.row];
        // 添加到我们的删除数据源里面
        model.isSelect = YES;
        [_removeArray addObject:model];
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
        //NSLog(@"didDeselectRowAtIndexPath");
        // 获取当前反选显示数据
        ZIKCustomizedModel *tempModel = [self.customizedInfoMArr objectAtIndex:indexPath.row];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"commitEditingStyle");
}

- (void)createEmptyUI {
    if (!emptyUI) {
        emptyUI                 = [[UIView alloc] init];
        emptyUI.frame           = CGRectMake(0, 64, Width, Height/2);
        emptyUI.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:emptyUI];
        UIImageView *imageView  = [[UIImageView alloc] init];
        imageView.frame         = CGRectMake(Width/2-50, 30, 100, 100);
        imageView.image         = [UIImage imageNamed:@"图片2"];
        [emptyUI addSubview:imageView];

        UILabel *label1         = [[UILabel alloc] init];
        label1.frame            = CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, Width, 25);
        label1.text             = @"您还没有定制任何信息~";
        label1.textAlignment    = NSTextAlignmentCenter;
        label1.textColor        = detialLabColor;
        [emptyUI addSubview:label1];

        UILabel *label2         = [[UILabel alloc] init];
        label2.frame            = CGRectMake(0, CGRectGetMaxY(label1.frame), Width, label1.frame.size.height);
        label2.text             = @"点击右上角开始添加吧";
        label2.textColor        = detialLabColor;
        label2.textAlignment    = NSTextAlignmentCenter;
        [emptyUI addSubview:label2];

    }

 }

- (void)initData {
    self.page               = 1;
    self.customizedInfoMArr = [NSMutableArray array];
    _removeArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)backBtnAction:(UIButton *)sender
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要退出编辑？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
//    [alert show];
//    alert.tag = 300;
//    alert.delegate = self;
//
//    //[self.navigationController popViewControllerAnimated:YES];
//}

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
                    [blockSelf.myCustomizedInfoTableView reloadData];
                    //            [blockSelf.mySupplyTableView deleteRowsAtIndexPaths:blockSelf.mySupplyTableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
                    if (blockSelf.customizedInfoMArr.count == 0) {
                        [self requestData];
                        bottomcell.hidden = YES;
                        self.myCustomizedInfoTableView.editing = NO;
                    }
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
