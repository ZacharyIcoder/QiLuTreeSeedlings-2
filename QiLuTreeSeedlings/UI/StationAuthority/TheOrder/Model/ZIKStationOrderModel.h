//
//  ZIKStationOrderModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZIKStationOrderModel : NSObject

/**
 *  --地区
 */
@property (nonatomic, copy) NSString *area;
/**
 *  --截止日期
 */
@property (nonatomic, copy) NSString *endDate;
/**
 *  --工程公司
 */
@property (nonatomic, copy) NSString *engineeringCompany;
/**
 *  --苗木
 */
@property (nonatomic, copy) NSString *miaomu;
/**
 *  --发布日期
 */
@property (nonatomic, copy) NSString *orderDate;
/**
 *  --订单名称
 */
@property (nonatomic, copy) NSString *orderName;
/**
 *  --订单类型
 */
@property (nonatomic, copy) NSString *orderType;
/**
 *  --报价要求
 */
@property (nonatomic, copy) NSString *quotation;
/**
 *  --状态
 */
@property (nonatomic, copy) NSString *status;
/**
 *  --订单ID
 */
@property (nonatomic, copy) NSString *uid;

@end