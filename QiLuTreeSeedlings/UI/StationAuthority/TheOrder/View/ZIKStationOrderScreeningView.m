//
//  ZIKStationOrderScreeningView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/15.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationOrderScreeningView.h"
#import "UIDefines.h"
@interface ZIKStationOrderScreeningView ()
@property (nonatomic, strong) UILabel *orderStateLabel;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation ZIKStationOrderScreeningView
{
    @private

    NSArray *orderStateTitleArray;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame orderState:(NSString *)orderState orderType:(NSString *)orderType orderAddress:(NSString *)orderAddress {
    self = [super initWithFrame:frame];
    if (self) {
        _orderState   = orderState;
        _orderType    = orderType;
        _orderAddress = orderAddress;
        [self initView];
    }
    return self;
}

- (void)initView {
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(kWidth*0.2, 0, kWidth*0.8, 64)];
    [backView setBackgroundColor:kRGB(210, 210, 210, 1)];
    [self addSubview:backView];

    UIButton *backBtn =[ [UIButton alloc] initWithFrame:CGRectMake(17, 7+20, 30, 30)];
    [backBtn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [backView addSubview:backBtn];

    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(backView.frame.size.width/2-30, 10+20, 60, 24)];
    titleLab.text = @"筛选";
    [titleLab setTextColor:titleLabColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLab];

//中间视图
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(backView.frame.origin.x, CGRectGetMaxY(backView.frame), backView.frame.size.width, kHeight-64-50)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;

    UILabel *orderStateTitleLabel = [[UILabel alloc] init];
    orderStateTitleLabel.frame = CGRectMake(15, 10, 60, 20);
    orderStateTitleLabel.text = @"订单状态";
    orderStateTitleLabel.textColor = DarkTitleColor;
    orderStateTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    [contentView addSubview:orderStateTitleLabel];

    UILabel *orderStateLabel = [[UILabel alloc] init];
    orderStateLabel.frame = CGRectMake(CGRectGetMaxX(orderStateTitleLabel.frame), orderStateTitleLabel.frame.origin.y, kWidth*0.8-CGRectGetMaxX(orderStateTitleLabel.frame)-20, orderStateTitleLabel.frame.size.height);
    orderStateLabel.textAlignment = NSTextAlignmentRight;
    orderStateLabel.text = @"全部";
    orderStateLabel.textColor = detialLabColor;
    orderStateLabel.font = [UIFont systemFontOfSize:15.0f];
    //orderStateLabel.backgroundColor = [UIColor yellowColor];
    [contentView addSubview:orderStateLabel];
    self.orderStateLabel  = orderStateLabel;

    orderStateTitleArray  = [NSArray arrayWithObjects:@"报价中",@"已报价",@"已结束", nil];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*60 + 15+(10*i), CGRectGetMaxY(orderStateTitleLabel.frame)+10, 60, 20)];
        button.tag = 100 + i;
        [button setTitle:orderStateTitleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [button setTitleColor:detialLabColor forState:UIControlStateNormal];
        [button setTitleColor:NavColor forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"unselectBtnAction"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"selectBtnAction2"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(stateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
    }

//中间视图end
    UIView *shaixuanView = [[UIView alloc] initWithFrame:CGRectMake(kWidth*0.2, kHeight-50, kWidth*0.8, 50)];
    [shaixuanView setBackgroundColor:kRGB(210, 210, 210, 1)];
    [self addSubview:shaixuanView];

    UIButton *shaixuanBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth*0.43, 8, kWidth*0.3, 34)];
    [shaixuanView addSubview:shaixuanBtn];
    [shaixuanBtn setBackgroundColor:NavColor];
    [shaixuanBtn setTitle:@"开始筛选" forState:UIControlStateNormal];
    [shaixuanBtn addTarget:self action:@selector(screeningViewAction) forControlEvents:UIControlEventTouchUpInside];

    UIButton *chongzhiBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth*0.07, 8, kWidth*0.3, 34)];
    [chongzhiBtn setBackgroundColor:kRGB(241, 157, 65, 1)];
    [chongzhiBtn setTitle:@"重置" forState:UIControlStateNormal];
    [chongzhiBtn addTarget:self action:@selector(chongzhiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [shaixuanView setBackgroundColor:BGColor];
    [shaixuanView addSubview:chongzhiBtn];


}

- (void)stateBtnClick:(UIButton *)button {
    button.selected = !button.selected;
    __block NSString *orderStateStr = @"";
   // CLog(@"%@",self.subviews);
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            if (((UIButton *)obj).selected && (obj.tag < 200 && obj.tag >= 100)) {
                orderStateStr = [orderStateStr stringByAppendingString:[NSString stringWithFormat:@"%@,",((UIButton *)obj).currentTitle]];
            }
        }
     }];
    if ([orderStateStr isEqualToString:@""]) {
        self.orderStateLabel.text = @"全部";
    } else {
          orderStateStr = [orderStateStr substringToIndex:orderStateStr.length-1];
        self.orderStateLabel.text = orderStateStr;
    }
    if ([self.orderStateLabel.text isEqualToString:@"全部"]) {
        self.orderStateLabel.textColor = detialLabColor;
    } else {
        self.orderStateLabel.textColor = NavColor;
    }
}

-(void)backBtn:(UIButton *)sender
{  CGRect frame = self.frame;
    frame.origin.x = kWidth;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.frame = frame;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        if (weakSelf.delegate) {
            [weakSelf.delegate StationOrderScreeningbackBtnAction];
        }
    }];
}

#pragma mark - 筛选按钮点击事件
- (void)screeningViewAction {
    [self removeSideViewAction];
}

#pragma mark - 重置按钮点击事件
- (void)chongzhiBtnAction:(UIButton *)button {

}

#pragma mark - 隐藏视图
- (void)removeSideViewAction
{
    [UIView animateWithDuration:.3 animations:^{
        self.frame = CGRectMake(kWidth, 0, kWidth, kHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
