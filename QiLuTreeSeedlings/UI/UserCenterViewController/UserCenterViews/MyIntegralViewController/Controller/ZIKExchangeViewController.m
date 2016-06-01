//
//  ZIKExchangeViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/31.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKExchangeViewController.h"
/*****工具******/
#import "YYModel.h"//类型转换
/*****工具******/

#import "ZIKIntegraExchangeModel.h"
#import "ZIKIntegralCollectionViewCell.h"
#import "ZIKExchangeSuccessView.h"
#import "JXActionView.h"

NSString *kCellID = @"cellID";

@interface ZIKExchangeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *integralCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, weak) JXActionView *actionView;
@end

@implementation ZIKExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.vcTitle = @"积分兑换";
    self.dataArr = [NSMutableArray arrayWithCapacity:10];
    _integralCollectionView.delegate = self;
    _integralCollectionView.dataSource = self;
    [self requestData];
}

- (void)requestData {
    [HTTPCLIENT integraRuleSuccess:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 1) {
            //CLog(@"%@",responseObject);
            NSDictionary *resultDic = responseObject[@"result"];
            NSArray *arr = resultDic[@"list"];
            [arr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKIntegraExchangeModel *model = [ZIKIntegraExchangeModel yy_modelWithDictionary:dic];
                [self.dataArr addObject:model];
            }];
            [self.integralCollectionView reloadData];
         }
        else {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:200 withSuperView:self.view];
            return ;
        }

    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UINib *nib = [UINib nibWithNibName:@"ZIKIntegralCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [cv registerNib:nib forCellWithReuseIdentifier:kCellID];
    ZIKIntegralCollectionViewCell *cell = [[ZIKIntegralCollectionViewCell alloc] init];
    cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID
                                         forIndexPath:indexPath];
    if (self.dataArr.count > 0) {
        ZIKIntegraExchangeModel *model = self.dataArr[indexPath.row];
        [cell configureCell:model];
    }

    return cell;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    ZIKIntegraExchangeModel *model = self.dataArr[indexPath.row];
//    [self requestExchange:model.integral money:model.money];
    self.actionView = [[[NSBundle mainBundle] loadNibNamed:@"JXActionView" owner:self options:nil] lastObject];
    self.actionView.titleLb.text = @"确定交卷吗？";
    [self.actionView.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.actionView.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.actionView.frame = CGRectMake(0, kHeight, kWidth, self.actionView.frame.size.height);
    __weak typeof(self) weakSelf = self;
    [self.actionView addClickBlock:^(NSInteger index) {
        if(index==0){
            //[weakSelf actionClick:nil];
        }
        else{
            // [weakSelf actionClick:nil];
            //[weakSelf alertBack:nil];
        }
    }];

}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestExchange:(NSString *)integral money:(NSString *)money {
    [HTTPCLIENT integralrecordexchangeWithIntegral:integral withMoney:money Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 1) {
//            ZIKExchangeSuccessView *view = [ZIKExchangeSuccessView successView];
//            view.frame = CGRectMake(0, 64, kWidth, 160);
//            [self.view addSubview:view];
//            [_integralCollectionView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];

         }
        else {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
        }
    } failure:^(NSError *error) {
        ;
    }];
}

@end
