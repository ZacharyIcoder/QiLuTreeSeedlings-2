//
//  YLDShopIndexModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/25.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDShopIndexModel.h"

@implementation YLDShopIndexModel
+(YLDShopIndexModel *)yldShopIndexModelByDic:(NSDictionary *)dic
{
    YLDShopIndexModel *model=[YLDShopIndexModel new];
    model.goldsupplier=[dic objectForKey:@"goldsupplier"];
    model.shopBackgroundUrl=[dic objectForKey:@"shopBackgroundUrl"];
    model.name=[dic objectForKey:@"name"];
    model.shopHeadUrl=[dic objectForKey:@"shopHeadUrl"];
    model.visitCount=[[dic objectForKey:@"visitCount"] integerValue];
    model.creditMargin=[dic objectForKey:@"creditMargin"];
    model.visitDay=[[dic objectForKey:@"visitDay"] integerValue];
    model.shareCount=[[dic objectForKey:@"shareCount"] integerValue];
    model.goldsupplierflag=[[dic objectForKey:@"goldsupplierflag"] integerValue];
    return model;
}
@end
