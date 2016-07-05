//
//  YLDGCGSModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDGCGSModel.h"

@implementation YLDGCGSModel
+(YLDGCGSModel *)yldGCGSModelWithDic:(NSDictionary *)dic
{
    YLDGCGSModel *model=[YLDGCGSModel new];
    model.area=dic[@"area"];
    model.area=dic[@"attachment"];
    model.area=dic[@"brief"];
    model.city=dic[@"city"];
    model.companyName=dic[@"companyName"];
    model.county=dic[@"county"];
    model.legalPerson=dic[@"legalPerson"];
    model.phone=dic[@"phone"];
    model.province=dic[@"province"];
    model.uid=dic[@"uid"];
    model.address=dic[@"address"];
    return model;
}
@end
