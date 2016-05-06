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
@interface ZIKPurchaseRecordsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *recordsVC;
@property (nonatomic, strong) NSMutableArray *recordMarr;
@property (nonatomic, strong) NSMutableArray *buyDataAry;
@property (nonatomic, assign) NSInteger      page;//页数从1开始

@end

@implementation ZIKPurchaseRecordsViewController
{
    UIButton *editBtn;
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
    editBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width-40-15, 26, 40, 30)];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
    [self.view addSubview:editBtn];
    [editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];

    self.recordsVC = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Height-64) style:UITableViewStylePlain];
    self.recordsVC.delegate   = self;
    self.recordsVC.dataSource = self;
    [self.view addSubview:self.recordsVC];
    [ZIKFunction setExtraCellLineHidden:self.recordsVC];

//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.frame = CGRectMake(Width-60-15, 80, 60, 60);
//    imageView.image = [UIImage imageNamed:@"标签-已退回"];
//    [self.recordsVC addSubview:imageView];
//    [imageView bringSubviewToFront:self.view];

}

- (void)edit:(UIButton *)button {
    if (self.recordsVC.editing)
    {
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        self.recordsVC.editing = NO;
    }
    else
    {
        [button setTitle:@"取消" forState:UIControlStateNormal];
        self.recordsVC.editing = YES;
    }

}

- (void)initData {
    self.page = 1;
    self.recordMarr = [NSMutableArray array];
    self.buyDataAry = [NSMutableArray array];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordMarr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BuySearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BuySearchTableViewCell IDStr]];
    if (!cell) {
        cell=[[BuySearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[BuySearchTableViewCell IDStr] WithFrame:CGRectMake(0, 0, kWidth, 65)];
    }
    HotBuyModel  *model = self.recordMarr[indexPath.row];
    cell.hotBuyModel=model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {

    }
    else {
        HotBuyModel *model = self.recordMarr[indexPath.row];
        BuyDetialInfoViewController *buyDetialVC=[[BuyDetialInfoViewController alloc]initMyDetialWithSaercherInfo:model.supplybuyUid];
        [self.navigationController pushViewController:buyDetialVC animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
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
                [self.recordMarr removeAllObjects];
                [self.recordsVC footerEndRefreshing];
                [self.recordsVC reloadData];
                [ToastView showToast:@"暂无数据" withOriginY:200 withSuperView:self.view];
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
    if ( [editBtn.titleLabel.text isEqualToString:@"编辑"]) {
        return UITableViewCellEditingStyleDelete;
    }
    else {
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
    }
}

// 编辑时触发的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 判断编辑状态
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"commitEditingStyle");
        // (1)从数据源数组里面删除数据
        [self.recordMarr removeObjectAtIndex:indexPath.row];
        HotBuyModel *model = self.recordMarr[indexPath.row];
        [self deleteDataWithUid:model.uid];
        // (2)重新刷新数据
        // a.刷新某一行数据,带有动画效果
        [self.recordsVC deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        // b.刷新整个表单视图
        //[_tableView reloadData];
    }
    else {
        {
            NSLog(@"commitEditingStyle");
        }

    }
    
}


- (void)deleteDataWithUid:(NSString *)uid {
    [HTTPCLIENT purchaseHistoryDeleteWithUid:uid Success:^(id responseObject) {
        ;
    } failure:^(NSError *error) {
        ;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
