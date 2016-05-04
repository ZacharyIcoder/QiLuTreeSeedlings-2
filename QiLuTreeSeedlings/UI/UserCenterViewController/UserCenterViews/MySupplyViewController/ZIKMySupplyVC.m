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
#define NAV_HEIGHT 64
#define MENUVIEW_HEIGHT 43

typedef NS_ENUM(NSInteger, SupplyState) {
    SupplyStateAll       = 0,//全部
    SupplyStateThrough   = 1,//已通过
    SupplyStateNoThrough = 2,//未通过
    SupplyStateOverdue   = 3 //已退回
};

@interface ZIKMySupplyVC ()
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNav];
    [self initData];
    [self initUI];
}

//- (void)requestSellList:(NSString *)page {
//    //我的供应列表
//    RemoveActionV();
//    [self.supplyTableView headerEndRefreshing];
//    HttpClient *httpClient = [HttpClient sharedClient];
//    [httpClient getMysupplyListWithToken:nil withAccessId:nil withClientId:nil withClientSecret:nil withDeviewId:nil withPage:page withPageSize:@"15" success:^(id responseObject) {
//        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
//            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
//            return ;
//        }
//        NSDictionary *dic = [responseObject objectForKey:@"result"];
//        //NSLog(@"%@",[responseObject objectForKey:@"msg"]);
//        NSArray *array = dic[@"list"];
//        if (array.count == 0 && self.page == 1) {
//            [self.supplyInfoMArr removeAllObjects];
//            [self.mySupplyTableView footerEndRefreshing];
//            self.mySupplyTableView.hidden = YES;
//            [self createEmptyUI];
//            return ;
//        }
//        else if (array.count == 0 && self.page > 1) {
//            self.mySupplyTableView.hidden = NO;
//            emptyUI.hidden = YES;
//            self.page--;
//            [self.mySupplyTableView footerEndRefreshing];
//            //没有更多数据了
//            [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
//            return;
//        }
//        else {
//            self.mySupplyTableView.hidden = NO;
//            emptyUI.hidden = YES;
//            if (self.page == 1) {
//                [self.supplyInfoMArr removeAllObjects];
//            }
//            [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
//                ZIKSupplyModel *model = [ZIKSupplyModel yy_modelWithDictionary:dic];
//                [self.supplyInfoMArr addObject:model];
//            }];
//            bottomcell.isAllSelect = NO;
//            [self.mySupplyTableView reloadData];
//            [self.mySupplyTableView footerEndRefreshing];
//        }
//
//    } failure:^(NSError *error) {
//
//    }];
//}


#pragma  mark - 初始化数据
- (void)initData {
    self.page = 1;
    self.supplyInfoMArr = [NSMutableArray array];
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

    //button
    NSArray *titles = @[@"全部",@"已通过",@"已退回",@"已过期"];
    CGFloat padding = 0.0f;
    CGFloat split = Width / titles.count;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(padding, 5, split, 30)];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:titleLabColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(actionMenu:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
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
    self.supplyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(menuView.frame), Width, Height-NAV_HEIGHT-MENUVIEW_HEIGHT) style:UITableViewStylePlain];
    self.supplyTableView.backgroundColor = [UIColor clearColor];
//    self.supplyTableView.dataSource = self;
//    self.supplyTableView.delegate = self;
    [self.view addSubview:self.supplyTableView];


}

- (void)actionMenu:(UIButton *)button {
    if (cuttentButton != button) {
        [button setTitleColor:NavColor forState:UIControlStateNormal];
        [cuttentButton setTitleColor:titleLabColor forState:UIControlStateNormal];
        cuttentButton = button;
        [UIView animateWithDuration:0.3 animations:^{
            lineView.frame = CGRectMake(button.frame.origin.x, lineView.frame.origin.y, lineView.frame.size.width, lineView.frame.size.height);
        }];
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

@end
