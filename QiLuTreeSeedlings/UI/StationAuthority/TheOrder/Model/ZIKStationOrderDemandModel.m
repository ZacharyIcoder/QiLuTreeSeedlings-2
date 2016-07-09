//
//  ZIKStationOrderDemandModel.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/7.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationOrderDemandModel.h"

@implementation ZIKStationOrderDemandModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"demandDescription" : @"description"};
}

// 如果实现了该方法，则处理过程中会忽略该列表内的所有属性
+ (NSArray *)modelPropertyBlacklist {
    return @[@"itemListList"];
}
@end
