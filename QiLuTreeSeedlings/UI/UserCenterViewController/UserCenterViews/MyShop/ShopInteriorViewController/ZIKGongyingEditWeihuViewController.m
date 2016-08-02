//
//  ZIKGongyingEditWeihuViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/8/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKGongyingEditWeihuViewController.h"
#import "YYModel.h"//类型转换
#import "MJRefresh.h"//MJ刷新
//#import "ZIKShopBuyModel.h"
#import "ZIKSupplyModel.h"
//#import "ZIKShopBuyTableViewCell.h"
#import "ZIKMySupplyTableViewCell.h"
#import "ZIKFunction.h"
#import "ZIKGongyingEditWeihuViewController.h"
//#import "BuyDetialInfoViewController.h"
#import "ZIKMySupplyDetailViewController.h"

@interface ZIKGongyingEditWeihuViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) NSInteger      page;            //页数从1开始
@property (nonatomic, strong) NSMutableArray *supplyInfoMArr; //求购信息数组
@property (weak, nonatomic) IBOutlet UITableView *editSupplyTableView;

@end

@implementation ZIKGongyingEditWeihuViewController
{
    NSMutableArray *_refreshMarr;   //保存选中行数据
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initUI];
    //[self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self requestData];
}

- (void)initData {
    self.vcTitle = @"选择供应";
    self.page = 1;
    self.supplyInfoMArr = [NSMutableArray array];
    _refreshMarr = [NSMutableArray array];
    self.editSupplyTableView.editing = YES;
}

- (void)initUI {
    //    self.buyTableView.backgroundColor = [UIColor yellowColor];
    self.editSupplyTableView.delegate = self;
    self.editSupplyTableView.dataSource = self;
    [ZIKFunction setExtraCellLineHidden:self.editSupplyTableView];
}

- (void)requestData {
    //    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    //    [self.buyTableView addHeaderWithCallback:^{
    //        weakSelf.page = 1;
    //        [weakSelf requestBuyList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    //    }];
    //    [self.buyTableView addFooterWithCallback:^{
    //        weakSelf.page++;
    //        [weakSelf requestBuyList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    //    }];
    //    [self.buyTableView headerBeginRefreshing];
    [self requestSupplyList:[NSString stringWithFormat:@"%ld",(long)self.page]];

}


- (void)requestSupplyList:(NSString *)page {
    //    [self.buyTableView headerEndRefreshing];
    NSString *memberUid = APPDELEGATE.userModel.access_id;
    [HTTPCLIENT shopSupplyList:memberUid page:page pageSize:@"1500" selfrecommend:nil  Success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
            //            [self.buyTableView footerEndRefreshing];

            return ;
        }
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        NSArray *array = dic[@"list"];
        if (array.count == 0 && self.page == 1) {
            [ToastView showToast:@"你还没有发布通过的供应信息" withOriginY:Width/2 withSuperView:self.view];
            if (self.supplyInfoMArr.count > 0) {
                [self.supplyInfoMArr removeAllObjects];
            }
            //            [self.buyTableView footerEndRefreshing];
            [self.editSupplyTableView reloadData];
            return ;
        }
        else if (array.count == 0 && self.page > 1) {

            self.page--;
            //            [self.buyTableView footerEndRefreshing];
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
            [self.editSupplyTableView reloadData];
            //            [self.buyTableView footerEndRefreshing];

        }

        [self.supplyInfoMArr enumerateObjectsUsingBlock:^(ZIKSupplyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.selfrecommend isEqualToString:@"1"]) {
                [self.editSupplyTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                [_refreshMarr addObject:model];
            }
        }];


    } failure:^(NSError *error) {
        //        [self.buyTableView footerEndRefreshing];
    }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.supplyInfoMArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kZIKMySupplyTableViewCellID = @"kZIKMySupplyTableViewCellID";

    ZIKMySupplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKMySupplyTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKMySupplyTableViewCell" owner:self options:nil] lastObject];
    }
    if (self.supplyInfoMArr.count > 0) {
        [cell configureCell:self.supplyInfoMArr[indexPath.row]];
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKSupplyModel *model = self.supplyInfoMArr[indexPath.row];
    if (_refreshMarr.count >= 10) {
        [self.editSupplyTableView deselectRowAtIndexPath:indexPath animated:YES];
        [ToastView showTopToast:@"一次最多推荐10条"];
        return;
    } else {
        [_refreshMarr addObject:model];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKSupplyModel *model = self.supplyInfoMArr[indexPath.row];
    // 删除反选数据
    if ([_refreshMarr containsObject:model])
    {
        [_refreshMarr removeObject:model];
    }
}


- (IBAction)sureButtonClick:(UIButton *)sender {
    if (_refreshMarr.count == 0) {
        [ToastView showTopToast:@"请选择要维护的内容"];
        return;
    }
    __block NSString *buyUidString = @"";
    [_refreshMarr enumerateObjectsUsingBlock:^(ZIKSupplyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        buyUidString = [buyUidString stringByAppendingString:[NSString stringWithFormat:@",%@",model.uid]];
    }];
    buyUidString = [buyUidString substringFromIndex:1];

    [HTTPCLIENT shopAddSupply:buyUidString Success:^(id responseObject) {
        CLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
            return ;
        } else {
            [ToastView showTopToast:@"维护成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }

    } failure:^(NSError *error) {
        ;
    }];

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


@end
