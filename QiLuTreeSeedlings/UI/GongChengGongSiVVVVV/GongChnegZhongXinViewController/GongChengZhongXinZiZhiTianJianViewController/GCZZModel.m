//
//  GCZZModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "GCZZModel.h"

@implementation GCZZModel
+(GCZZModel *)GCZZModelWithDic:(NSDictionary *)dic
{
    GCZZModel *model=[GCZZModel new];
    model.acqueTime=dic[@"acqueTime"];
    model.attachment=dic[@"attachment"];
    model.companyQualification=dic[@"companyQualification"];
    model.issuingAuthority=dic[@"issuingAuthority"];
    model.level=dic[@"level"];
    model.uid=dic[@"uid"];
    return model;
}
+(NSMutableArray *)GCZZModelAryWithAry:(NSArray *)ary
{
    NSMutableArray *arys=[NSMutableArray array];
    return arys;
}
@end
