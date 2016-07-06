//
//  YLDWorkstationlistModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDWorkstationlistModel.h"

@implementation YLDWorkstationlistModel
+(YLDWorkstationlistModel *)YLDWorkstationlistModelWithDic:(NSDictionary *)dic
{
    YLDWorkstationlistModel *model=[YLDWorkstationlistModel new];
    model.area=dic[@"area"];
    model.chargelPerson=dic[@"chargelPerson"];
    model.phone=dic[@"phone"];
    model.uid=dic[@"uid"];
    model.viewNo=dic[@"viewNo"];
    model.workstationName=dic[@"workstationName"];
    model.type=dic[@"type"];
    return model;
}
+(NSMutableArray *)YLDWorkstationlistModelWithAry:(NSArray *)ary
{
    NSMutableArray *Arys=[NSMutableArray array];
    for (int i=0; i<ary.count; i++) {
        YLDWorkstationlistModel *model=[YLDWorkstationlistModel YLDWorkstationlistModelWithDic:ary[i]];
        [Arys addObject:model];
    }
    
    return Arys;
}
@end
