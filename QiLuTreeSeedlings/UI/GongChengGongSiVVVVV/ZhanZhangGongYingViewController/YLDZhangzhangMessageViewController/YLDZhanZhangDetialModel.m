//
//  YLDZhanZhangDetialModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/6.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDZhanZhangDetialModel.h"

@implementation YLDZhanZhangDetialModel
+(YLDZhanZhangDetialModel *)yldZhanZhangDetialModelWithDic:(NSDictionary *)dic
{
    YLDZhanZhangDetialModel *model=[YLDZhanZhangDetialModel new];
    model.area=dic[@"area"];
    model.brief=dic[@"brief"];
    model.chargelPerson=dic[@"chargelPerson"];
    model.creditMargin=dic[@"creditMargin"];
    model.phone=dic[@"phone"];
    model.type=dic[@"type"];
    model.uid=dic[@"uid"];
    model.viewNo=dic[@"viewNo"];
    model.workstationName=dic[@"workstationName"];
    model.workstationPic=dic[@"workstationPic"];
    return model;
    
}
@end
