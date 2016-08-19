//
//  ZIKStationOrderDetailViewController.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKBaseChangeNavViewController.h"
#import "ZIKStationOrderModel.h"
@interface ZIKStationOrderDetailViewController : ZIKBaseChangeNavViewController
/**
 *  订单ID
 */
@property (nonatomic, copy) NSString *orderUid;
/**
 *  枚举的订单状态
 */
@property (nonatomic, assign) StationOrderStatusType statusType;
@end
