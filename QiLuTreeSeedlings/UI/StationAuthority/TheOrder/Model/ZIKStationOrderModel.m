//
//  ZIKStationOrderModel.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationOrderModel.h"

@implementation ZIKStationOrderModel
// 如果实现了该方法，则处理过程中会忽略该列表内的所有属性
+ (NSArray *)modelPropertyBlacklist {
    return @[@"statusType"];
}

- (void)initStatusType {
    if ([self.status isEqualToString:@"已过期"]) {
        self.statusType = StationOrderStatusTypeOutOfDate;
    } else if ([self.status isEqualToString:@"报价中"]) {
        self.statusType = StationOrderStatusTypeQuotation;
    } else if ([self.status isEqualToString:@"已报价"]) {
        self.statusType = StationOrderStatusTypeAlreadyQuotation;
    }
}
@end
