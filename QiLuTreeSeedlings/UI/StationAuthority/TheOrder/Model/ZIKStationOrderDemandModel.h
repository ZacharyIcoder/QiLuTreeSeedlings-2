//
//  ZIKStationOrderDemandModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/7.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZIKStationOrderDemandModel : NSObject
/**
 *  地区
 */
@property (nonatomic, copy) NSString *area;
/**
 *  描述
 */
@property (nonatomic, copy) NSString *demandDescription;
/**
 *  结束时间
 */
@property (nonatomic, copy) NSString *endDate;
/**
 *  胸径
 */
@property (nonatomic, copy) NSString *dbh;
/**
 *  地径
 */
@property (nonatomic, copy) NSString *groundDiameter;
/**
 *  发布日期
 */
@property (nonatomic, copy) NSString *orderDate;
/**
 *  -订单名称
 */
@property (nonatomic, copy) NSString *orderName;
/**
 *  订单类型
 */
@property (nonatomic, copy) NSString *orderType;
/**
 *  联系方式
 */
@property (nonatomic, copy) NSString *phone;
/**
 *  联系人
 */
@property (nonatomic, copy) NSString *person;
/**
 *  订单公司
 */
@property (nonatomic, copy) NSString *company;
/**
 *  质量要求
 */
@property (nonatomic, copy) NSString *quantityRequired;
/**
 *  报价要求
 */
@property (nonatomic, copy) NSString *quotationRequired;
/**
 *  状态
 */
@property (nonatomic, copy) NSString *status;
/**
 *  --1:可报价，0：不可报价
 */
@property (nonatomic, copy) NSString *quote;
/**
 *  订单ID
 */
@property (nonatomic, copy) NSString *uid;
@end
