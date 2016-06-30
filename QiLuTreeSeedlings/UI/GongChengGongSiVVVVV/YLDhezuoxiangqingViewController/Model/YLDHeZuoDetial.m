//
//  YLDHeZuoDetial.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/29.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDHeZuoDetial.h"

@implementation YLDHeZuoDetial
+(YLDHeZuoDetial *)creatYLDHeZuoDetialWithDic:(NSDictionary *)dic
{
    YLDHeZuoDetial *model=[YLDHeZuoDetial new];
    model.area=[dic objectForKey:@"area"];
    model.cooperateList=[dic objectForKey:@"cooperateList"];
    model.dbh=[dic objectForKey:@"dbh"];
    model.descriptions=[dic objectForKey:@"description"];
    model.endDate=[dic objectForKey:@"endDate"];
    model.groundDiameter=[dic objectForKey:@"groundDiameter"];
    model.orderDate=[dic objectForKey:@"orderDate"];
    model.orderName=[dic objectForKey:@"orderName"];
    model.orderType=[dic objectForKey:@"orderType"];
    model.person=[dic objectForKey:@"person"];
    model.phone=[dic objectForKey:@"phone"];
    model.quantityRequired=[dic objectForKey:@"quantityRequired"];
    model.quotationRequired=[dic objectForKey:@"quotationRequired"];
    model.status=[dic objectForKey:@"status"];
    model.uid=[dic objectForKey:@"uid"];
    model.company=[dic objectForKey:@"company"];
    return model;
}
@end
