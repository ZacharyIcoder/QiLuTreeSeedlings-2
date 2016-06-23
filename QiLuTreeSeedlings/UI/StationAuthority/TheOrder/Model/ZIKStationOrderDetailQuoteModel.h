//
//  ZIKStationOrderDetailQuoteModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/22.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZIKStationOrderDetailQuoteModel : NSObject
/**
 *  苗木名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  订单ID
 */
@property (nonatomic, copy) NSString *orderUid;
/**
 *  数量
 */
@property (nonatomic, copy) NSString *quantity;
/**
 *  状态1：已报价；0:立即报价
 */
@property (nonatomic, copy) NSString *stauts;
/**
 *  订单苗木ID
 */
@property (nonatomic, copy) NSString *uid;
/**
 *  -苗木说明
 */
@property (nonatomic, copy) NSString *treedescription;
@end
