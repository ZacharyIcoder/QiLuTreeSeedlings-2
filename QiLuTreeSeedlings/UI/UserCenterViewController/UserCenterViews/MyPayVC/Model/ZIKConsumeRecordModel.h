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
 *  //2代表充值，1代表消费
 */
@property (nonatomic, copy) NSString *type;
/**
 *   描述
 */
@property (nonatomic, copy) NSString *typeName;
@end
