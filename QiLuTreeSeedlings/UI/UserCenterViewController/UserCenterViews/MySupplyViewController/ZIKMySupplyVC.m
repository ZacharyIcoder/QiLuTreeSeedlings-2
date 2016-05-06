//
//  ZIKMySupplyVC.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/3.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKMySupplyVC.h"
#import "ZIKSupplyPublishVC.h"
#import "HttpClient.h"
#import "YYModel.h"
#import "ZIKSupplyModel.h"
#import "ZIKMySupplyTableViewCell.h"
#import "MJRefresh.h"
#import "ZIKMySupplyCellBackButton.h"
#import "ZIKMySupplyDetailViewController.h"
#import "ZIKBottomDeleteTableViewCell.h"
#import "ZIKMySupplyBottomRefreshTableViewCell.h"//底部刷新view

#define NAV_HEIGHT 64
#define MENUVIEW_HEIGHT 43
#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)?YES:NO
#define CELL_FOOTERVIEW_HEIGH 8
#define SUPPLY_STATE_BUTTON_FONT [UIFont systemFontOfSize:14.0f]

typedef NS_ENUM(NSInteger, SupplyState) {
    SupplyStateAll       = 0,//全部
    SupplyStateThrough   = 2,//已通过
    SupplyStateOverdue   = 3,//已退回
    SupplyStateNoThrough = 5 //过期
};

@interface ZIKMySupplyVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic, assign) NSInteger      page;//页数从1开始
@property (nonatomic, strong) NSMutableArray *supplyInfoMArr;//供应信息数组
@property (nonatomic, assign) BOOL           isCanPublish;//是否能够发布
@property (nonatomic, assign) SupplyState    state;
@property (nonatomic, strong) UITableView    *supplyTableView;
@end

@implementation ZIKMySupplyVC
{
    UIView *lineView;
    UIButton *cuttentButton;
    ZIKBottomDeleteTableViewCell *bottomcell;
    UILongPressGestureRecognizer *tapDeleteGR;
    ZIKMySupplyBottomRefreshTableViewCell *refreshCell;
    NSMutableArray *refreshMarr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//        if (IS_IOS_7) {
//            self.edgesForExtendedLayout = UIRectEdgeNone;
//        }
    [self configNav];
    [self initData];
    [self initUI];
    [self requestData];
    _state = cuttentButton.tag;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.supplyInfoMArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kZIKMySupplyTableViewCellID = @"kZIKMySupplyTableViewCellID";

    ZIKMySupplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKMySupplyTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKMySupplyTableViewCell" owner:self options:nil] lastObject];
    }
    if (self.supplyInfoMArr.count > 0) {
        [cell configureCell:self.supplyInfoMArr[indexPath.section]];
    }
    //cell.UITableViewCellSeparatorStyle
     //cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    ZIKSupplyModel *model = self.supplyInfoMArr[section];
    if ([model.state isEqualToString:@"3"]) {
        return CELL_FOOTERVIEW_HEIGH+35;
    }
    return CELL_FOOTERVIEW_HEIGH;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = nil;
    ZIKSupplyModel *model = nil;
    if (self.supplyInfoMArr.count > 0) {
        model =   self.supplyInfoMArr[section];
    }
    if ([model.state isEqualToString:@"3"]) {
        view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, Width, 35+CELL_FOOTERVIEW_HEIGH);
        ZIKMySupplyCellBackButton *button = [[ZIKMySupplyCellBackButton alloc] initWithFrame:CGRectMake(0, 0, Width, 35)];
        button.backgroundColor = [UIColor whiteColor];
        //[button setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 5)];
        [button setImage:[UIImage imageNamed:@"注意"] forState:UIControlStateNormal];
        [button setTitle:@"查看退回原因" forState:UIControlStateNormal];

        [view addSubview:button];
        button.tag = section;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.supplyTableView.editing && self.state == SupplyStateThrough) {
        return;
    }
    ZIKSupplyModel *model = self.supplyInfoMArr[indexPath.section];
    ZIKMySupplyDetailViewController *detailVC = [[ZIKMySupplyDetailViewController alloc] initMySupplyDetialWithUid:model];
    [self.navigationController pushViewController:detailVC animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ZIKSupplyModel *model = self.supplyInfoMArr[indexPath.row];
//    __block  ZIKMySupplyTableViewCell *cell = (ZIKMySupplyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    if (!self.mySupplyTableView.editing) {
//        cell.backgroundColor = [UIColor lightGrayColor];
//        double delayInSeconds = 0.1;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            cell.backgroundColor = [UIColor whiteColor];
//        });
//    }
//    // 判断编辑状态,必须要写
//    if (self.mySupplyTableView.editing)
//    {   if (model.isSelect == YES) {
//        model.isSelect = NO;
//        cell.isSelect = NO;
//        cell.selected = NO;
//        // 删除反选数据
//        if ([_removeArray containsObject:model])
//        {
//            [_removeArray removeObject:model];
//        }
//        [self totalCount];
//        return;
//    }
//        //NSLog(@"didSelectRowAtIndexPath");
//        // 获取当前显示数据
//        //ZIKSupplyModel *tempModel = [self.supplyInfoMArr objectAtIndex:indexPath.row];
//        // 添加到我们的删除数据源里面
//        model.isSelect = YES;
//        [_removeArray addObject:model];
//        [self totalCount];
//        return;
//    }
//
//    //ZIKSupplyModel *model = self.supplyInfoMArr[indexPath.row];
//    ZIKMySupplyDetailViewController *detailVC = [[ZIKMySupplyDetailViewController alloc] initMySupplyDetialWithUid:model];
//    [self.navigationController pushViewController:detailVC animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)btnClick:(ZIKMySupplyCellBackButton *)button {
    ZIKSupplyModel *model = self.supplyInfoMArr[button.tag];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退回原因" message:model.reason delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即编辑", nil];
    [alert show];
    alert.tag = 300 + button.tag;
    alert.delegate = self;

}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"%ld",(long)buttonIndex);
    if (buttonIndex == 1) {
        ShowActionV();
        ZIKSupplyModel *model = self.supplyInfoMArr[alertView.tag - 300];
        [HTTPCLIENT getMySupplyDetailInfoWithAccessToken:nil accessId:nil clientId:nil clientSecret:nil deviceId:nil uid:model.uid Success:^(id responseObject) {
            RemoveActionV();
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *dic = [responseObject objectForKey:@"result"];
                SupplyDetialMode *model = [SupplyDetialMode creatSupplyDetialModelByDic:[dic objectForKey:@"detail"]];
                model.supplybuyName = APPDELEGATE.userModel.name;
                model.phone = APPDELEGATE.userModel.phone;
                //        ZIKMySupplyDetailViewController *detailVC = [[ZIKMySupplyDetailViewController alloc] initMySupplyDetialWithUid:model];
                ZIKSupplyPublishVC *spvc = [[ZIKSupplyPublishVC alloc] initWithModel:model];
                [self.navigationController pushViewController:spvc animated:YES];
            }

        } failure:^(NSError *error) {
            ;
        }];
    }
}

- (void)requestData {
    [self requestSupplyRestrict];
    ShowActionV();
    [self requestMySupplyList:[NSString stringWithFormat:@"%ld",(long)self.page]];
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.supplyTableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestMySupplyList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.supplyTableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestMySupplyList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];

}

#pragma mark - 请求我的供应列表信息
- (void)requestMySupplyList:(NSString *)page {
    //我的供应列表
   
    [self.supplyTableView headerEndRefreshing];
    HttpClient *httpClient = [HttpClient sharedClient];
    [httpClient getMysupplyListWithToken:nil withAccessId:nil withClientId:nil withClientSecret:nil withDeviewId:nil withState:[NSString stringWithFormat:@"%ld",(long)self.state] withPage:page withPageSize:@"15" success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
            return ;
        }
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        //NSLog(@"%@",[responseObject objectForKey:@"msg"]);
        NSArray *array = dic[@"list"];
        if (array.count == 0 && self.page == 1) {
        [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
            if (self.supplyInfoMArr.count > 0) {
                [self.supplyInfoMArr removeAllObjects];
            }
            [self.supplyTableView footerEndRefreshing];
            [self.supplyTableView reloadData];
            return ;
        }
        else if (array.count == 0 && self.page > 1) {
            self.page--;
            [self.supplyTableView footerEndRefreshing];
            //没有更多数据了
            [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
            return;
        }
        else {
            if (self.page == 1) {
                [self.supplyInfoMArr removeAllObjects];
            }
            [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKSupplyModel *model = [ZIKSupplyModel yy_modelWithDictionary:dic];
                [self.supplyInfoMArr addObject:model];
            }];
            [self.supplyTableView reloadData];
            [self.supplyTableView footerEndRefreshing];
        }

    } failure:^(NSError *error) {

    }];
}


#pragma  mark - 初始化数据
- (void)initData {
    self.page = 1;
    self.supplyInfoMArr = [NSMutableArray array];
    refreshMarr = [[NSMutableArray alloc] init];
}

#pragma  mark - 初始化UI
- (void)initUI {
    //button bgview
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, Width, MENUVIEW_HEIGHT)];
    menuView.backgroundColor     = [UIColor whiteColor];
    menuView.layer.shadowColor   = [UIColor blackColor].CGColor;///shadowColor阴影颜色
    menuView.layer.shadowOpacity = 0.2;////阴影透明度，默认0
    menuView.layer.shadowOffset  = CGSizeMake(0, 3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移1，默认(0, -3),这个跟shadowRadius配合使用
    menuView.layer.shadowRadius  = 3;//阴影半径，默认3
    [self.view addSubview:menuView];
    menuView.contentMode = UIViewContentModeScaleToFill;


    //button
    NSArray *titles = @[@"全部",@"已通过",@"已退回",@"已过期"];
    //NSArray *titlesArr = @[@[@"全部",@"已通过",@"已退回",@"已过期"],@[]];
    CGFloat padding = 0.0f;
    CGFloat split = Width / titles.count;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(padding, 5, split, 30)];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:titleLabColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(actionMenu:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        btn.titleLabel.font = SUPPLY_STATE_BUTTON_FONT;
        [menuView addSubview:btn];
        padding += split;
        if (i == 0) {
            cuttentButton = btn;
            [btn setTitleColor:NavColor forState:UIControlStateNormal];
        }
    }
    //线
    lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, MENUVIEW_HEIGHT-3, split, 3);
    lineView.backgroundColor = NavColor;
    [menuView addSubview:lineView];

    //tableview
    self.supplyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(menuView.frame)+8, Width, Height-NAV_HEIGHT-MENUVIEW_HEIGHT-8) style:UITableViewStylePlain];
    self.supplyTableView.backgroundColor = [UIColor clearColor];
    self.supplyTableView.dataSource = self;
    self.supplyTableView.delegate   = self;
    [self.view addSubview:self.supplyTableView];
    //[ZIKFunction setExtraCellLineHidden:self.supplyTableView];
    self.supplyTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //添加长按手势
    tapDeleteGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR)];
    [self.supplyTableView addGestureRecognizer:tapDeleteGR];
    //[self.supplyTableView addObserver:self forKeyPath:@"editing" options:NSKeyValueObservingOptionNew context:NULL];


    //底部刷新view
    refreshCell = [ZIKMySupplyBottomRefreshTableViewCell cellWithTableView:nil];
    refreshCell.frame = CGRectMake(0, Height-50, Width, 50);
    [self.view addSubview:refreshCell];
    [refreshCell.refreshButton addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    refreshCell.layer.shadowColor   = [UIColor blackColor].CGColor;///shadowColor阴影颜色
    refreshCell.layer.shadowOpacity = 0.2;////阴影透明度，默认0
    refreshCell.layer.shadowOffset  = CGSizeMake(0, -3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移1，默认(0, -3),这个跟shadowRadius配合使用
    refreshCell.layer.shadowRadius  = 3;//阴影半径，默认3
    refreshCell.hidden = YES;

}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"editing"]) {
//        if ([[change valueForKey:NSKeyValueChangeNewKey] integerValue] == 1) {
//            [self.supplyTableView removeGestureRecognizer:tapDeleteGR];
//        }
//        else {
//            [self.supplyTableView addGestureRecognizer:tapDeleteGR];
//        }
//        // NSLog(@"Height is changed! new=%@", [change valueForKey:NSKeyValueChangeNewKey]);
//    } else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}

- (void)tapGR {
    if (!self.supplyTableView.editing && self.state == SupplyStateThrough)
    {
        self.supplyTableView.editing = YES;
        refreshCell.hidden = NO;
        self.supplyTableView.frame = CGRectMake(0, self.supplyTableView.frame.origin.y, Width, Height-64-50-50);
        [self.supplyTableView removeHeader];//编辑状态取消下拉刷新
        bottomcell.isAllSelect = NO;
        if (refreshMarr.count > 0) {
            [refreshMarr enumerateObjectsUsingBlock:^(ZIKSupplyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                model.isSelect = NO;
            }];
            [refreshMarr removeAllObjects];
        }
        //[self totalCount];
    }

}

#pragma mark - 底部刷新按钮点击事件
- (void)refreshBtnClick {

}

- (void)actionMenu:(UIButton *)button {
    if (cuttentButton != button && !self.supplyTableView.isDecelerating) {
        [button setTitleColor:NavColor forState:UIControlStateNormal];
        [cuttentButton setTitleColor:titleLabColor forState:UIControlStateNormal];
        cuttentButton = button;
        [UIView animateWithDuration:0.3 animations:^{
            lineView.frame = CGRectMake(button.frame.origin.x, lineView.frame.origin.y, lineView.frame.size.width, lineView.frame.size.height);
        }];
        if (button.tag == 0) {
            self.state = SupplyStateAll;
        }
        else if (button.tag == 1) {
            self.state = SupplyStateThrough;
        }
        else if (button.tag == 2) {
            self.state = SupplyStateOverdue;
        }
        else if (button.tag == 3) {
            self.state = SupplyStateNoThrough;
        }
        if (self.supplyInfoMArr.count > 0) {
            [self.supplyInfoMArr removeAllObjects];
            [self.supplyTableView reloadData];
        }
        [self.supplyTableView headerBeginRefreshing];
        //ShowActionV()
        //[self requestMySupplyList:[NSString stringWithFormat:@"%ld",(long)self.page]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置navgation
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

#pragma mark - 发布限制
- (void)requestSupplyRestrict {
    HttpClient *httpClient=[HttpClient sharedClient];
    //供求发布限制
    [httpClient getSupplyRestrictWithToken:APPDELEGATE.userModel.access_token  withId:APPDELEGATE.userModel.access_id withClientId:nil withClientSecret:nil withDeviceId:nil withType:@"2" success:^(id responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        if ( [dic[@"count"] integerValue] == 0 ) {// “count”: 1	--当数量大于0时，表示可发布；等于0时，不可发布
            self.isCanPublish = NO;
            //NSLog(@"不可发布");
        }
        else {
            //NSLog(@"可发布");
            self.isCanPublish = YES;
        }
    } failure:^(NSError *error) {

    }];
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

@end
