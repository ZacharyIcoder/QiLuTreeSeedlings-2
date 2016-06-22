//
//  ZIKMyOfferQuoteListModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/22.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZIKMyOfferQuoteListModel : NSObject
/**
 *  --报价时间
 */
@property (nonatomic, copy) NSString *createTime;
/**
 *  --截止日期
 */
@property (nonatomic, copy) NSString *endDate;
/**
 *  --工程公司
 */
@property (nonatomic, copy) NSString *engineeringCompany;
/**
 *  --苗木名称
 */
@property (nonatomic, copy) NSString *itemName;
/**
 *  --苗木数量
 */
@property (nonatomic, copy) NSString *itemQuantity;
/**
 *  --订单名称
 */
@property (nonatomic, copy) NSString *orderName;
/**
 *  --订单类型
 */
@property (nonatomic, copy) NSString *orderType;
/**
 *  --报价价格
 */
@property (nonatomic, copy) NSString *price;
/**
 *  --报价要求
 */
@property (nonatomic, copy) NSString *quote;
/**
 *  -报价数量
 */
@property (nonatomic, copy) NSString *quoteQuantity;
/**
 *  --1：已报价，2:已合作，3：已过期
 */
@property (nonatomic, copy) NSString *status;
@end
