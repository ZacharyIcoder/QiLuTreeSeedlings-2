//
//  ZIKIntegraModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/7.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZIKIntegraModel : NSObject
/**
 *  获取时间
 */
@property (nonatomic, copy ) NSString        *createTime;
/**
 *  获取渠道
 */
@property (nonatomic, copy ) NSString        *level;
/**
 *  获得的积分
 */
@property (nonatomic, copy ) NSString        *score;
/**
 *  1获得积分，2减去积分
 */
@property (nonatomic, copy ) NSString        *taskType;
@end
