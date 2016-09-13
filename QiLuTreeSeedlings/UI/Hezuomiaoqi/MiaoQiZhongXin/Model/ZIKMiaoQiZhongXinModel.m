//
//  ZIKMiaoQiZhongXinModel.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/9.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMiaoQiZhongXinModel.h"

@implementation ZIKMiaoQiZhongXinModel
// 如果实现了该方法，则处理过程中会忽略该列表内的所有属性
+ (NSArray *)modelPropertyBlacklist {
    return @[@"isShow"];
}

- (void)initStatusType {
      self.isShow = NO;
}

@end
