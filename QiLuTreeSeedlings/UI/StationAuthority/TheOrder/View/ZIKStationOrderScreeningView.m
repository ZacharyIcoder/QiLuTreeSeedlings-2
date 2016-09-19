//
//  ZIKStationOrderScreeningView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/15.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationOrderScreeningView.h"
#import "UIDefines.h"

#import "UIButton+ZIKEnlargeTouchArea.h"
//@interface ZIKOrderStateButton : UIButton
//@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *uid;
//@end


@interface ZIKOrderTypeButton : UIButton
@property (nonatomic, strong) NSString *name;//订单名称
@property (nonatomic, strong) NSString *uid;//订单Uid
@end

@implementation ZIKOrderTypeButton

@end

@interface ZIKStationOrderScreeningView ()

@property (nonatomic, strong) UILabel *orderStateLabel;        //订单状态label
@property (nonatomic, strong) UILabel *orderTypeTitleLabel;    //订单类型Name Label
@property (nonatomic, strong) UILabel *orderTypeLabel;         //订单类型label
@property (nonatomic, strong) NSString *orderTypeAllUid;
@property (nonatomic, strong) UILabel *orderAddressTitleLabel; //用苗地Label
@property (nonatomic, strong) UIView  *contentView;            //订单选择中间视图

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
    self.isScreen = NO;
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

    //订单状态
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

    orderStateTitleArray  = [NSArray arrayWithObjects:@"已结束",@"报价中",@"已报价", nil];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*60 + 15+(10*i), CGRectGetMaxY(orderStateTitleLabel.frame)+10, 60, 20)];
        button.tag = 100 + i;
        [button setTitle:orderStateTitleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [button setTitleColor:detialLabColor forState:UIControlStateNormal];
        [button setTitleColor:NavColor forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"unselectBtnAction"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"selectBtnAction2"] forState:UIControlStateSelected];
        [button setEnlargeEdgeWithTop:8 right:6 bottom:8 left:6];
        [button addTarget:self action:@selector(stateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
    }
    //订单状态end

    //订单类型
    UILabel *orderTypeTitleLabel = [[UILabel alloc] init];
    orderTypeTitleLabel.frame = CGRectMake(orderStateTitleLabel.frame.origin.x, CGRectGetMaxY(orderStateTitleLabel.frame)+40, 60, 20);
    orderTypeTitleLabel.text = @"订单类型";
    orderTypeTitleLabel.textColor = DarkTitleColor;
    orderTypeTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    [contentView addSubview:orderTypeTitleLabel];
    self.orderTypeTitleLabel = orderTypeTitleLabel;

    UILabel *orderTypeLabel = [[UILabel alloc] init];
    orderTypeLabel.frame = CGRectMake(CGRectGetMaxX(orderTypeTitleLabel.frame), orderTypeTitleLabel.frame.origin.y, kWidth*0.8-CGRectGetMaxX(orderTypeTitleLabel.frame)-20, orderTypeTitleLabel.frame.size.height);
    orderTypeLabel.textAlignment = NSTextAlignmentRight;
    orderTypeLabel.text = @"全部";
    orderTypeLabel.textColor = detialLabColor;
    orderTypeLabel.font = [UIFont systemFontOfSize:15.0f];
    //orderStateLabel.backgroundColor = [UIColor yellowColor];
    [contentView addSubview:orderTypeLabel];
    self.orderTypeLabel  = orderTypeLabel;

    //订单类型end

    //用苗地

    UIView *topLineView = [[UIView alloc] init];
    topLineView.frame = CGRectMake(15, CGRectGetMaxY(orderTypeTitleLabel.frame)+40+1, contentView.frame.size.width-30, 1);
    topLineView.backgroundColor = kLineColor;
    [contentView addSubview:topLineView];

    UILabel *orderAddressTitleLabel = [[UILabel alloc] init];
    orderAddressTitleLabel.frame = CGRectMake(orderStateTitleLabel.frame.origin.x, CGRectGetMaxY(orderTypeTitleLabel.frame)+40, 60, 60);
    orderAddressTitleLabel.text = @"供苗地";
    orderAddressTitleLabel.textColor = DarkTitleColor;
    orderAddressTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    [contentView addSubview:orderAddressTitleLabel];

    UIView *addressSelectView = [[UIView alloc] init];
    addressSelectView.frame = CGRectMake(CGRectGetMaxX(orderAddressTitleLabel.frame), orderAddressTitleLabel.frame.origin.y, contentView.frame.size.width-CGRectGetMaxX(orderAddressTitleLabel.frame), orderAddressTitleLabel.frame.size.height);
    //addressSelectView.backgroundColor = [UIColor yellowColor];
    [contentView addSubview:addressSelectView];

    UILabel *addressSelectLabel = [[UILabel alloc] init];
    addressSelectLabel.frame = CGRectMake(20, 0, addressSelectView.frame.size.width-40, addressSelectView.frame.size.height);
    addressSelectLabel.text = @"请选择地址";
    addressSelectLabel.numberOfLines = 3;
    addressSelectLabel.textAlignment = NSTextAlignmentLeft;
    addressSelectLabel.textColor = detialLabColor;
    addressSelectLabel.font = [UIFont systemFontOfSize:14.0f];
    [addressSelectView addSubview:addressSelectLabel];
    self.orderAddressSelectLabel = addressSelectLabel;

    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAddress:)];
    [addressSelectView addGestureRecognizer:tapGR];

    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.frame = CGRectMake(15, CGRectGetMaxY(orderAddressTitleLabel.frame)+1, topLineView.frame.size.width, 1);
    bottomLineView.backgroundColor = kLineColor;
    [contentView addSubview:bottomLineView];

    //用苗地end

//中间视图end

    //底部重置和筛选按钮视图
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

- (void)setOrderTypeArr:(NSArray *)orderTypeArr {
    _orderTypeArr = orderTypeArr;
    _orderTypeAllUid = @"";
    for (NSInteger i = 0; i < self.orderTypeArr.count; i++) {
        ZIKOrderTypeButton *button = [[ZIKOrderTypeButton alloc] initWithFrame:CGRectMake(i*60 + 15+(10*i), CGRectGetMaxY(_orderTypeTitleLabel.frame)+10, 60, 20)];
        button.tag = 200 + i;
        [button setTitle:[self.orderTypeArr[i] objectForKey:@"name"] forState:UIControlStateNormal];
        button.name = [self.orderTypeArr[i] objectForKey:@"name"];
        button.uid = [self.orderTypeArr[i] objectForKey:@"uid"];
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [button setTitleColor:detialLabColor forState:UIControlStateNormal];
        [button setTitleColor:NavColor forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"unselectBtnAction"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"selectBtnAction2"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];

        _orderTypeAllUid = [_orderTypeAllUid stringByAppendingString:[NSString stringWithFormat:@"%@,",button.uid]];
    }

}

- (void)selectAddress:(UITapGestureRecognizer *)gesture {
    //CLog(@"%@",gesture);
    if([self.delegate respondsToSelector:@selector(addressSelectLabelAction)]) {
        [self.delegate addressSelectLabelAction];
    }
}

- (void)typeBtnClick:(ZIKOrderTypeButton *)button {
    button.selected = !button.selected;
    __block NSString *orderTypeStr     = @"";
    __block NSString *orderTypeUid     = @"";
    //__block NSString *orderTypeAllUid  = @"";
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ZIKOrderTypeButton class]]) {
            if (((ZIKOrderTypeButton *)obj).selected) {
                orderTypeStr = [orderTypeStr stringByAppendingString:[NSString stringWithFormat:@"%@,",((ZIKOrderTypeButton *)obj).currentTitle]];
                orderTypeUid = [orderTypeUid stringByAppendingString:[NSString stringWithFormat:@"%@,",((ZIKOrderTypeButton *)obj).uid]];
            }
//            orderTypeAllUid = [orderTypeAllUid stringByAppendingString:[NSString stringWithFormat:@"%@,",((ZIKOrderTypeButton *)obj).uid]];

        }
    }];
    if ([orderTypeStr isEqualToString:@""]) {
        self.orderTypeLabel.text = @"全部";
        self.orderTypeLabel.textColor = detialLabColor;
        self.orderType = [_orderTypeAllUid substringToIndex:_orderTypeAllUid.length-1];
    } else {
        orderTypeStr = [orderTypeStr substringToIndex:orderTypeStr.length-1];
        self.orderTypeLabel.text = orderTypeStr;
        self.orderTypeLabel.textColor = NavColor;
        self.orderType = [orderTypeUid substringToIndex:orderTypeUid.length-1];
    }

}

- (void)stateBtnClick:(UIButton *)button {
    button.selected = !button.selected;
    __block NSString *orderStateStr    = @"";
    __block NSString *orderStateUid    = @"";
    __block NSString *orderStateAllUid = @"";
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            if (((UIButton *)obj).selected && (obj.tag < 200 && obj.tag >= 100)) {
                orderStateStr = [orderStateStr stringByAppendingString:[NSString stringWithFormat:@"%@,",((UIButton *)obj).currentTitle]];
                orderStateUid = [orderStateUid stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)(((UIButton *)obj).tag-100)]];
            }
            if (![obj isKindOfClass:[ZIKOrderTypeButton class]]) {
                orderStateAllUid = [orderStateAllUid stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)(((UIButton *)obj).tag-100)]];
            }
        }
    }];
    if (button.tag < 200) {
        if ([orderStateStr isEqualToString:@""]) {
            self.orderStateLabel.text = @"全部";
            self.orderStateLabel.textColor = detialLabColor;
            self.orderState = [orderStateAllUid substringToIndex:orderStateAllUid.length-1];

        } else {
            orderStateStr = [orderStateStr substringToIndex:orderStateStr.length-1];
            self.orderStateLabel.text = orderStateStr;
            self.orderStateLabel.textColor = NavColor;
            self.orderState = [orderStateUid substringToIndex:orderStateUid.length-1];
        }
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
        if ([weakSelf.delegate respondsToSelector:@selector(StationOrderScreeningbackBtnAction)]) {
            [weakSelf.delegate StationOrderScreeningbackBtnAction];
        }
    }];
}

#pragma mark - 开始筛选按钮点击事件
- (void)screeningViewAction {
    if ([self.orderState isEqualToString:@""] || self.orderState == nil) {
        self.orderState = @"0,1,2";
    }
    if ([self.orderType isEqualToString:@""] || self.orderType == nil) {
        self.orderType = [_orderTypeAllUid substringToIndex:_orderTypeAllUid.length-1];
    }
//    if ([self.orderAddressSelectLabel.text isEqualToString:@"请选择地址"]) {
//        [ToastView showTopToast:@"请选择地址"];
//        return;
//    }
    if ([self.orderStateLabel.text isEqualToString:@"全部"] && [self.orderTypeLabel.text isEqualToString:@"全部"] && [self.orderAddressSelectLabel.text isEqualToString:@"请选择地址"]) {
        self.isScreen = NO;
    } else {
        self.isScreen = YES;
    }
    [self removeSideViewAction];
    if ([self.delegate respondsToSelector:@selector(screeningBtnClickSendOrderStateInfo:orderTypeInfo:orderAddressInfo:)]) {
        [self.delegate screeningBtnClickSendOrderStateInfo:self.orderState orderTypeInfo:self.orderType orderAddressInfo:self.orderAddressSelectLabel.text];
    }
}

#pragma mark - 重置按钮点击事件
- (void)chongzhiBtnAction:(UIButton *)button {
    //CLog(@"%@",self.contentView.subviews);
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            ((UIButton *)obj).selected = NO;
//            [button setBackgroundImage:[UIImage imageNamed:@"unselectBtnAction"] forState:UIControlStateNormal];
         }
    }];
    self.orderStateLabel.text = @"全部";
    self.orderStateLabel.textColor = detialLabColor;
    self.orderState = @"0,1,2";
    self.orderTypeLabel.text = @"全部";
    self.orderTypeLabel.textColor = detialLabColor;
    self.orderType = _orderTypeAllUid;
    self.orderAddress = @"";
    self.orderAddressSelectLabel.text = @"请选择地址";

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
