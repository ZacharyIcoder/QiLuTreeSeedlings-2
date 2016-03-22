//
//  SupplyDetialMode.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/14.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "SupplyDetialMode.h"

@implementation SupplyDetialMode
+(SupplyDetialMode *)creatSupplyDetialModelByDic:(NSDictionary *)dic
{
    SupplyDetialMode *model=[[SupplyDetialMode alloc]init];
    model.address=[dic objectForKey:@"address"];
    model.collect=[[dic objectForKey:@"collect"] integerValue];
    model.collectUid=[dic objectForKey:@"collectUid"];
    model.count=[dic objectForKey:@"count"];
    model.createTime=[dic objectForKey:@"createTime"];
    model.descriptions=[dic objectForKey:@"description"];
    model.endTime=[dic objectForKey:@"endTime"];
    model.dataState=[[dic objectForKey:@"dataState"] integerValue];
    model.images=[dic objectForKey:@"images"];
    model.spec=[dic objectForKey:@"spec"];
    model.phone=[dic objectForKey:@"phone"];
    model.price=[dic objectForKey:@"price"];
    model.supplybuyName=[dic objectForKey:@"supplybuyName"];
    model.supplybuyUid=[dic objectForKey:@"supplybuyUid"];
    model.title=[dic objectForKey:@"title"];
    model.uid=[dic objectForKey:@"uid"];
    model.views=[dic objectForKey:@"views"];
    model.productName=[dic objectForKey:@"productName"];
    return model;
}
@end
