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

#import "BuyMessageAlertView.h"//提示界面

#import "ZIKIntegraExchangeModel.h"
#import "ZIKIntegralCollectionViewCell.h"
#import "ZIKExchangeSuccessView.h"

NSString *kCellID = @"cellID";

@interface ZIKExchangeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *integralCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) ZIKExchangeSuccessView *successView;
@end

@implementation ZIKExchangeViewController
{
    @private
    BOOL _isCharge;
}
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
            if ([resultDic[@"ischarge"] integerValue] == 1) {
                _isCharge  = YES;
            }
            else {
                _isCharge = NO;
            }
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
    if (_isCharge) {
        BuyMessageAlertView *buyMessageAlertV = [BuyMessageAlertView addActionViewWithTitle:@"确认要兑换吗?" andDetail:@"兑换后,积分减少,账户余额增加"];
        buyMessageAlertV.rightBtn.tag = indexPath.row;
        [buyMessageAlertV.rightBtn addTarget:self action:@selector(miaopudetialAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [ToastView showTopToast:@"未充值过的用户不能参与积分兑换功能，请先充值"];
        return;
    }

}

- (void)miaopudetialAction:(UIButton *)btn {
    ZIKIntegraExchangeModel *model = self.dataArr[btn.tag];
    [self requestExchange:model.integral money:model.money];
    [BuyMessageAlertView removeActionView];
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
            ZIKExchangeSuccessView *view = [ZIKExchangeSuccessView successView];
            view.frame = CGRectMake(0, 64, kWidth, 160);
            [self.view addSubview:view];
            self.successView = view;
            [_integralCollectionView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(back:) userInfo:nil repeats:YES];
         }
        else {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
        }
    } failure:^(NSError *error) {
        ;
    }];
}

-(void)back:(NSTimer *)sender {
    int listSecond = [self.successView.timeLabel.text intValue];
    if(1 == listSecond)
    {
        [sender invalidate];
        [self.successView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
     }
    else
    {
        listSecond --;
          self.successView.timeLabel.text    = [NSString stringWithFormat:@"%d",listSecond];
    }

}
@end
