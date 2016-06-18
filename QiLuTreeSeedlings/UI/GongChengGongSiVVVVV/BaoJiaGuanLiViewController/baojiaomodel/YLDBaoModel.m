//
//  YLDBaoModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/18.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDBaoModel.h"

@implementation YLDBaoModel
+(YLDBaoModel *)yldBaoModelWithDic:(NSDictionary *)dic
{
    YLDBaoModel *model=[YLDBaoModel new];
    model.area=dic[@"area"];
    model.descriptions=dic[@"description"];
    model.endDate=dic[@"endDate"];
    model.name=dic[@"name"];
    model.orderName=dic[@"orderName"];
    model.quantity=dic[@"quantity"];
    model.status=dic[@"status"];
    model.uid=dic[@"uid"];
    return model;
}
+(NSMutableArray *)yldBaoModelAryWithAry:(NSArray *)dataAry
{
    NSMutableArray *ary=[NSMutableArray array];
    for (int i=0; i<dataAry.count; i++) {
       YLDBaoModel *model = [YLDBaoModel yldBaoModelWithDic:dataAry[i]];
        [ary addObject:model];
    }
    return ary;
}
@end
