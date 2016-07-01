//
//  YLDBaoJiaMessageModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDBaoJiaMessageModel.h"

@implementation YLDBaoJiaMessageModel
+(YLDBaoJiaMessageModel *)yldBaoJiaMessageModelWithDic:(NSDictionary *)dic
{
    YLDBaoJiaMessageModel *model=[YLDBaoJiaMessageModel new];
    model.area=dic[@"area"];
    model.chargelPerson=dic[@"chargelPerson"];
    model.explain=dic[@"explain"];
    model.image2=dic[@"image2"];
    model.phone=dic[@"phone"];
    model.price=dic[@"price"];
    model.quantity=dic[@"quantity"];
    model.quoteTime=dic[@"quoteTime"];
    model.status=dic[@"status"];
    model.uid=dic[@"uid"];
    model.workstationName=dic[@"workstationName"];
    model.itemUid=dic[@"itemUid"];
    return model;
}
+(NSMutableArray *)yldBaoJiaMessageModelWithAry:(NSArray *)dataAry
{
    NSMutableArray *Ary=[NSMutableArray array];
    for (int i=0; i<dataAry.count; i++) {
        NSDictionary *dic=dataAry[i];
        YLDBaoJiaMessageModel *model=[YLDBaoJiaMessageModel yldBaoJiaMessageModelWithDic:dic];
        [Ary addObject:model];
    }
    return Ary;
}
@end
