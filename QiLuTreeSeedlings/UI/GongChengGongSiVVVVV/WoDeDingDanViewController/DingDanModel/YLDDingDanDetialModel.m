//
//  YLDDingDanDetialModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDDingDanDetialModel.h"

@implementation YLDDingDanDetialModel
+(YLDDingDanDetialModel *)yldDingDanDetialModelWithDic:(NSDictionary *)dic
{
    YLDDingDanDetialModel *model=[YLDDingDanDetialModel new];
    model.area=dic[@"area"];
    model.descriptionzz=dic[@"description"];
    model.endDate=dic[@"endDate"];
    model.itemList=dic[@"itemList"];
    model.dbh=dic[@"dbh"];
    model.groundDiameter=dic[@"groundDiameter"];
    model.orderDate=dic[@"orderDate"];
    model.orderName=dic[@"orderName"];
    model.orderType=dic[@"orderType"];
    model.phone=dic[@"phone"];
    model.quantityRequired=dic[@"quantityRequired"];
    model.quotationRequired=dic[@"quotationRequired"];
    model.status=dic[@"status"];
    model.uid=dic[@"uid"];
    model.measureRequired=[NSString stringWithFormat:@"胸径离地面%@CM处，地径离地面%@CM处",model.dbh,model.groundDiameter];
    return model;
}
@end
