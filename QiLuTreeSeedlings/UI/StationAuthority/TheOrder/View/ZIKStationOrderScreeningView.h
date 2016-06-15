//
//  ZIKStationOrderScreeningView.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/15.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZIKStationOrderScreeningViewDelegate <NSObject>

@required
- (void)screeningBtnClickSendOrderStateInfo:(NSString *)orderState orderTypeInfo:(NSString *)orderType orderAddressInfo:(NSString *)orderAddress;
- (void)StationOrderScreeningbackBtnAction;
@end

@interface ZIKStationOrderScreeningView : UIView
/**
 *  订单状态
 */
@property (nonatomic, copy) NSString *orderState;
/**
 *  订单类型
 */
@property (nonatomic, copy) NSString *orderType;
/**
 *  用苗地
 */
@property (nonatomic, copy) NSString *orderAddress;
/**
 *  筛选delegate
 */
@property (nonatomic, assign) id <ZIKStationOrderScreeningViewDelegate> delegate;

/**
 *  初始化
 *
 *  @param frame        frame
 *  @param orderState   订单状态
 *  @param orderType    订单类型
 *  @param orderAddress 用苗地
 */
- (id)initWithFrame:(CGRect)frame orderState:(NSString *)orderState orderType:(NSString *)orderType orderAddress:(NSString *)orderAddress;
@end
