//
//  ZIKStationHonorListModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/1.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZIKStationHonorListModel : NSObject
/**
 *  获奖时间
 */
@property (nonatomic, copy) NSString *acquisitionTime;
/**
 *  获奖图片
 */
@property (nonatomic, copy) NSString *image;
/**
 *  获奖名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  获奖Uid
 */
@property (nonatomic, copy) NSString *uid;

@end
