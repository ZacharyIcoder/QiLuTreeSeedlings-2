//
//  BuyDetialModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "BuyDetialModel.h"
@implementation spec
+(spec *)creatspecModelByDic:(NSDictionary*)dic
{
    spec *specs=[[spec alloc]init];
    specs.main=[[dic objectForKey:@"main"] integerValue];
    specs.type=[dic objectForKey:@"type"];
    specs.name=[dic objectForKey:@"name"];
    specs.unit=[dic objectForKey:@"unit"];
    specs.value=[dic objectForKey:@"values"];
    return specs;
}
@end
@implementation BuyDetialModel
+(BuyDetialModel *)creatBuyDetialModelByDic:(NSDictionary*)dic
{
    BuyDetialModel *model=[BuyDetialModel new];
    model.spec=[NSMutableArray array];
    model.address=[dic objectForKey:@"address"];
    model.collect=[[dic objectForKey:@"collect"] integerValue];
    model.collectUid=[dic objectForKey:@"collectUid"];
    model.count=[dic objectForKey:@"count"];
    model.createTime=[dic objectForKey:@"createTime"];
    model.descriptions=[dic objectForKey:@"description"];
    model.endTime=[dic objectForKey:@"endTime"];
    model.phone=[dic objectForKey:@"phone"];
    model.price=[dic objectForKey:@"price"];
     NSArray *specAry=[dic objectForKey:@"spec"];
    for (int i=0; i<specAry.count; i++) {
        NSDictionary *dic=specAry[i];
        spec *specs=[spec creatspecModelByDic:dic];
        [model.spec addObject:specs];
    }
    model.supplybuyName=[dic objectForKey:@"supplybuyName"];
    model.supplybuyUid=[dic objectForKey:@"supplybuyUid"];
    model.title=[dic objectForKey:@"title"];
    model.views=[[dic objectForKey:@"views"] integerValue];
    model.productName=[dic objectForKey:@"productName"];
   // --0/1/2/3/4/5   已关闭，只能删除/过期,可编辑删除/未审核,可编辑删除/审核不通过,可编辑删除/审核通过，只能关闭/已删除
    model.state=[[dic objectForKey:@"state"] integerValue];
    model.buy=[[dic objectForKey:@"buy"] integerValue];
    model.push=[[dic objectForKey:@"push"]integerValue];
    model.publishUid=[dic objectForKey:@"publishUid"];
    model.buyPrice=[[dic objectForKey:@"buyPrice"] floatValue];
    model.goldsupplier=[dic[@"goldsupplier"] integerValue];
    model.searchTime=dic[@"searchTime"];
    if (model.supplybuyName.length<=0) {
        model.supplybuyName=@"请付费查看";
    }

    model.companyName = dic[@"companyName"];
    return model;
}
@end
