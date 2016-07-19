//
//  ZIKStationOrderModel.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationOrderModel.h"
#import "ZIKFunction.h"
#import "UIDefines.h"
@implementation ZIKStationOrderModel
// 如果实现了该方法，则处理过程中会忽略该列表内的所有属性
+ (NSArray *)modelPropertyBlacklist {
    return @[@"statusType",@"isShow",@"isMore",@"rows"];
}

- (void)initStatusType {
    if ([self.status isEqualToString:@"已过期"]) {
        self.statusType = StationOrderStatusTypeOutOfDate;
    } else if ([self.status isEqualToString:@"报价中"]) {
        self.statusType = StationOrderStatusTypeQuotation;
    } else if ([self.status isEqualToString:@"已报价"]) {
        self.statusType = StationOrderStatusTypeAlreadyQuotation;
    }
//    self.isShow = NO;
//    self.isMore = NO;
//    self.rows = 1;
//
//    CGRect pzRect = [ZIKFunction getCGRectWithContent:self.miaomu width:kWidth-60 font:14.0f];
//    CGFloat width = pzRect.size.width;
//    CGFloat height = pzRect.size.height;
//    if (pzRect.size.height > 17) {
//        self.isMore = YES;
//        self.rows = height / 16.00;
//    }

}
@end
