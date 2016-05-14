//
//  ZIKHaveReadModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/14.
//  Copyright © 2016年 中亿科技. All rights reserved.
//
/**
 *  按产品ID查询订制信息 已读model
 */
#import <Foundation/Foundation.h>

@interface ZIKHaveReadModel : NSObject

/**
 *  标题
 */
@property (nonatomic,copy) NSString       *title;

/**
 *  求购ID
 */
@property (nonatomic,copy) NSString       *uid;

/**
 *  --true:已读；false：未读
 */
@property (nonatomic,copy) NSString       *reads;

/**
 *  发送时间
 */
@property (nonatomic,copy) NSString       *sendTime;

/**
 *  订制设置ID
 */
@property (nonatomic,copy) NSString       *memberCustomUid;

/**
 *  信息uid
 */
@property (nonatomic,copy) NSString       *mesUid;

@end
