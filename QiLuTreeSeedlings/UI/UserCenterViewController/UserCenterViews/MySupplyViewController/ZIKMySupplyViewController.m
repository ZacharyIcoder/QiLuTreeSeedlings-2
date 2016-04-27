//
//  ZIKMySupplyViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/22.
//  Copyright © 2016年 中亿信息技术. All rights reserved.
//
#import "ZIKMySupplyViewController.h"
#import "HttpClient.h"
#import "YYModel.h"
#import "ZIKSupplyModel.h"
#import "ZIKMySupplyTableViewCell.h"
#import "MJRefresh.h"
//#import "ZIKSupplyPublishViewController.h"
#import "ZIKSupplyPublishVC.h"
#import "ZIKMySupplyDetailViewController.h"
#import "ZIKBottomDeleteTableViewCell.h"
@interface ZIKMySupplyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *emptyUI;
    // 保存选中行数据
    NSMutableArray *_removeArray;
    ZIKBottomDeleteTableViewCell *bottomcell;
    UILongPressGestureRecognizer *tapDeleteGR;
}
@property (nonatomic, assign) NSInteger      page;//页数从1开始
@property (nonatomic, strong) NSMutableArray *supplyInfoMArr;//供应信息数组
@property (nonatomic, strong) UITableView    *mySupplyTableView;//我的供应列表
@property (nonatomic, assign) BOOL           isCanPublish;//是否能够发布
@end

@implementation ZIKMySupplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNav];
    //[self initData];
    [self initUI];
    //[self requestData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self initData];
    [self requestData];
    self.mySupplyTableView.editing = NO;
    bottomcell.hidden = YES;
    self.mySupplyTableView.frame = CGRectMake(0, 64, Width, Height-64);
}

- (void)requestData {
    [self requestSupplyRestrict];
    ShowActionV();
    [self requestSellList:[NSString stringWithFormat:@"%ld",(long)self.page]];
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.mySupplyTableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.mySupplyTableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];

}

- (void)initUI {
    self.mySupplyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Height-64) style:UITableViewStylePlain];
    self.mySupplyTableView.delegate   = self;
    self.mySupplyTableView.dataSource = self;
    [self.view addSubview:self.mySupplyTableView];
    [ZIKFunction setExtraCellLineHidden:self.mySupplyTableView];
    //self.mySupplyTableView.backgroundColor = [UIColor yellowColor];
    tapDeleteGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteCell)];
    [self.mySupplyTableView addGestureRecognizer:tapDeleteGR];
    [self.mySupplyTableView addObserver:self forKeyPath:@"editing" options:NSKeyValueObservingOptionNew context:NULL];


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
            [self.mySupplyTableView removeGestureRecognizer:tapDeleteGR];
        }
        else {
            [self.mySupplyTableView addGestureRecognizer:tapDeleteGR];
        }
       // NSLog(@"Height is changed! new=%@", [change valueForKey:NSKeyValueChangeNewKey]);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
    [self.mySupplyTableView removeObserver:self forKeyPath:@"editing"];
}

//删除按钮action
- (void)deleteButtonClick {
    if (_removeArray.count  == 0) {
        [ToastView showToast:@"请选择要删除的选项" withOriginY:200 withSuperView:self.view];
        return;
    }
    __weak typeof(_removeArray) removeArr = _removeArray;
    __weak __typeof(self) blockSelf = self;

    __block NSString *uidString = @"";
    [_removeArray enumerateObjectsUsingBlock:^(ZIKSupplyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        uidString = [uidString stringByAppendingString:[NSString stringWithFormat:@",%@",model.uid]];
    }];
    NSString *uids = [uidString substringFromIndex:1];
    [HTTPCLIENT deleteMySupplyInfo:uids Success:^(id responseObject) {
        //NSLog(@"%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 1) {

            [removeArr enumerateObjectsUsingBlock:^(ZIKSupplyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([blockSelf.supplyInfoMArr containsObject:model]) {
                    [blockSelf.supplyInfoMArr removeObject:model];
                }
            }];
            [blockSelf.mySupplyTableView reloadData];
            if (blockSelf.supplyInfoMArr.count == 0) {
                [self requestData];
                bottomcell.hidden = YES;
                self.mySupplyTableView.editing = NO;
                self.mySupplyTableView.frame = CGRectMake(0, 64, Width, Height-64);
            }
            if (_removeArray.count > 0) {
                [_removeArray removeAllObjects];
            }
            [self totalCount];
            [ToastView showToast:@"删除成功" withOriginY:200 withSuperView:self.view];
        }
        else {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"error"]] withOriginY:200 withSuperView:self.view];
        }
    } failure:^(NSError *error) {
        //[HTTPCLIENT]
    }];

}
//全选按钮
- (void)selectBtnClick {
  bottomcell.isAllSelect ? (bottomcell.isAllSelect = NO) : (bottomcell.isAllSelect = YES);
    if (bottomcell.isAllSelect) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        [self.supplyInfoMArr enumerateObjectsUsingBlock:^(ZIKSupplyModel *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
            myModel.isSelect = YES;
            [_removeArray addObject:myModel];
        }];
        //[self.mySupplyTableView deselectRowAtIndexPath:[self.mySupplyTableView indexPathForSelectedRow] animated:YES];
    }
    else if (bottomcell.isAllSelect == NO) {
        [self.supplyInfoMArr enumerateObjectsUsingBlock:^(ZIKSupplyModel *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
            myModel.isSelect = NO;
        }];
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }

    }
    [self totalCount];
    [self.mySupplyTableView reloadData];
}

-(void)backBtnAction:(UIButton *)sender
{
    if (self.mySupplyTableView.editing) {
        self.mySupplyTableView.editing = NO;
        bottomcell.hidden = YES;
        self.mySupplyTableView.frame = CGRectMake(0, 64, Width, Height-64);
        __weak typeof(self) weakSelf = self;//解决循环引用的问题
        [self.mySupplyTableView addHeaderWithCallback:^{//添加刷新控件
            [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",weakSelf.page]];
        }];

    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
// 隐藏删除按钮
- (void)deleteCell {
    if (!self.mySupplyTableView.editing)
   {
       // barButtonItem.title = @"Remove";
        self.mySupplyTableView.editing = YES;
        bottomcell.hidden = NO;
        self.mySupplyTableView.frame = CGRectMake(0, 64, Width, Height-64-44);
        [self.mySupplyTableView removeHeader];//编辑状态取消下拉刷新
        bottomcell.isAllSelect = NO;
        if (_removeArray.count > 0) {
            [_removeArray enumerateObjectsUsingBlock:^(ZIKSupplyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                model.isSelect = NO;
            }];
            [_removeArray removeAllObjects];
        }
        [self totalCount];
    }

}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];

    [self.mySupplyTableView setEditing:YES animated:animated];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.supplyInfoMArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//self.supplyInfoMArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kZIKMySupplyTableViewCellID = @"kZIKMySupplyTableViewCellID";
    
    ZIKMySupplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKMySupplyTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKMySupplyTableViewCell" owner:self options:nil] lastObject];
    }
    if (self.supplyInfoMArr.count > 0) {
        [cell configureCell:self.supplyInfoMArr[indexPath.row]];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKSupplyModel *model = self.supplyInfoMArr[indexPath.row];
    ZIKMySupplyTableViewCell *cell = (ZIKMySupplyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"%d",cell.selected);
//    NSLog(@"%d",model.isSelect);z
    //cell.highlighted = NO;
        // 判断编辑状态,必须要写
        if (self.mySupplyTableView.editing)
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

    //ZIKSupplyModel *model = self.supplyInfoMArr[indexPath.row];
    ZIKMySupplyDetailViewController *detailVC = [[ZIKMySupplyDetailViewController alloc] initMySupplyDetialWithUid:model];
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
// 反选方法
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 判断编辑状态,必须要写
    if (self.mySupplyTableView.editing)
    {
        //NSLog(@"didDeselectRowAtIndexPath");
        // 获取当前反选显示数据
        ZIKSupplyModel *tempModel = [self.supplyInfoMArr objectAtIndex:indexPath.row];
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

- (void)totalCount {
//    NSString *countString = [NSString stringWithFormat:@"合计:%d条",(int)_removeArray.count];
//    bottomcell.countLabel.text = countString;
    bottomcell.count = _removeArray.count;
    if (_removeArray.count == self.supplyInfoMArr.count) {
        bottomcell.isAllSelect = YES;
    }
    else {
        bottomcell.isAllSelect = NO;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"commitEditingStyle");
}

- (void)requestSellList:(NSString *)page {
    //我的供应列表
    RemoveActionV();
    [self.mySupplyTableView headerEndRefreshing];
    HttpClient *httpClient = [HttpClient sharedClient];
    [httpClient getMysupplyListWithToken:nil withAccessId:nil withClientId:nil withClientSecret:nil withDeviewId:nil withPage:page withPageSize:@"15" success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
            return ;
        }
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        //NSLog(@"%@",[responseObject objectForKey:@"msg"]);
        NSArray *array = dic[@"list"];
        if (array.count == 0 && self.page == 1) {
            [self.supplyInfoMArr removeAllObjects];
            [self.mySupplyTableView footerEndRefreshing];
            self.mySupplyTableView.hidden = YES;
            [self createEmptyUI];
            return ;
        }
        else if (array.count == 0 && self.page > 1) {
            self.mySupplyTableView.hidden = NO;
            emptyUI.hidden = YES;
            self.page--;
            [self.mySupplyTableView footerEndRefreshing];
            //没有更多数据了
            [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
            return;
        }
        else {
            self.mySupplyTableView.hidden = NO;
            emptyUI.hidden = YES;
            if (self.page == 1) {
                [self.supplyInfoMArr removeAllObjects];
            }
            [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKSupplyModel *model = [ZIKSupplyModel yy_modelWithDictionary:dic];
                [self.supplyInfoMArr addObject:model];
            }];
            bottomcell.isAllSelect = NO;
            [self.mySupplyTableView reloadData];
            [self.mySupplyTableView footerEndRefreshing];
        }

    } failure:^(NSError *error) {

    }];
}

- (void)requestSupplyRestrict {
    HttpClient *httpClient=[HttpClient sharedClient];
    //供求发布限制
    [httpClient getSupplyRestrictWithToken:APPDELEGATE.userModel.access_token  withId:APPDELEGATE.userModel.access_id withClientId:nil withClientSecret:nil withDeviceId:nil withType:@"2" success:^(id responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        if ( [dic[@"count"] integerValue] == 0 ) {// “count”: 1	--当数量大于0时，表示可发布；等于0时，不可发布
            self.isCanPublish = NO;
            //NSLog(@"不可发布");
        }
        else if (APPDELEGATE.isNeedCompany == NO) {
            self.isCanPublish = NO;
        }
        else {
            //NSLog(@"可发布");
            self.isCanPublish = YES;
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configNav {
    self.vcTitle = @"我的供应";
    self.rightBarBtnTitleString = @"发布";
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{
        //NSLog(@"发布");
        if (weakSelf.isCanPublish) {
            ZIKSupplyPublishVC *spVC = [[ZIKSupplyPublishVC alloc] init];
            [weakSelf.navigationController pushViewController:spVC animated:YES];

        }
        else {
            //NSLog(@"不可发布");
            [ToastView showToast:@"请您先完善苗圃信息" withOriginY:Width/3 withSuperView:weakSelf.view];
        }

    };
}

- (void)initData {
    self.page = 1;
    self.supplyInfoMArr = [NSMutableArray array];
    _removeArray = [[NSMutableArray alloc] init];
}

- (void)createEmptyUI {
    if (!emptyUI) {
        emptyUI  = [[UIView alloc] init];
        emptyUI.frame = CGRectMake(0, 64, Width, Height/2);
        emptyUI.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:emptyUI];

        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(Width/2-50, 30, 100, 100);
        imageView.image = [UIImage imageNamed:@"我的供应（空）"];
        [emptyUI addSubview:imageView];

        UILabel *label1 = [[UILabel alloc] init];
        label1.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, Width, 25);
        label1.text = @"您还没有发布任何的供应信息";
        label1.textAlignment = NSTextAlignmentCenter;
        label1.textColor = detialLabColor;
        [emptyUI addSubview:label1];

        UILabel *label2 = [[UILabel alloc] init];
        label2.frame = CGRectMake(0, CGRectGetMaxY(label1.frame), Width, label1.frame.size.height);
        label2.text = @"点击按钮发布";
        label2.textColor = detialLabColor;
        label2.textAlignment = NSTextAlignmentCenter;
        [emptyUI addSubview:label2];

        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(Width/2-40, CGRectGetMaxY(label2.frame)+10, 80, 25);
        [button setTitleColor:detialLabColor forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 6.0f;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [detialLabColor CGColor];
        [button setTitle:@"发布供应" forState:UIControlStateNormal];
        [emptyUI addSubview:button];
        [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];

    }
 }

- (void)btnClick {
    if (self.isCanPublish) {
        //NSLog(@"可发布");
        ZIKSupplyPublishVC *spVC = [[ZIKSupplyPublishVC alloc] init];
        [self.navigationController pushViewController:spVC animated:YES];
    }
    else {
        // NSLog(@"不可发布");
        //[ToastView showTopToast:@"请先完善苗圃信息"];
        [ToastView showToast:@"请您先完善苗圃信息" withOriginY:Width/3 withSuperView:self.view];

        return;
    }
}

@end
