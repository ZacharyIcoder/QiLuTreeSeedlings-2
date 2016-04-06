//
//  ZIKConsumeRecordModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZIKConsumeRecordModel : NSObject
/**
 *  金额
 */
@property (nonatomic, copy) NSString *price;
/**
 *   时间
 */
@property (nonatomic, copy) NSString *time;
/**
 *  0代表收入，1代表支出
 */
@property (nonatomic, copy) NSString *type;
/**
 *  //关联操作类型
 */
@property (nonatomic, copy) NSString *opType;
/**
 *   交易明细
 */
@property (nonatomic, copy) NSString *reason;
/**
 *  关联操作编号
 */
@property (nonatomic, copy) NSString *opUid;
@end
