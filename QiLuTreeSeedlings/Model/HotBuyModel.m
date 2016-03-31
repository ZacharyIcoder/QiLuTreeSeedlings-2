//
//  HotBuyModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/2.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "HotBuyModel.h"
#import "ZIKFunction.h"
@implementation HotBuyModel
+(HotBuyModel *)hotBuyModelCreatByDic:(NSDictionary *)dic
{
    HotBuyModel *model=[[HotBuyModel alloc]init];
    if (dic) {
        model.area=[dic objectForKey:@"area"];
        model.creatTime=[dic objectForKey:@"createTime"];
        model.effective=[dic objectForKey:@"effective"];
        model.price=[dic objectForKey:@"price"];
        model.New=[[dic objectForKey:@"new"] integerValue];
         model.effect=[[dic objectForKey:@"effect"] integerValue];
        model.title=[dic objectForKey:@"title"];
        model.count=[[dic objectForKey:@"count"] integerValue];
        model.uid=[dic objectForKey:@"uid"];
        model.supplybuyUid=[dic objectForKey:@"supplybuyUid"];
        NSDate *creatTimeDate=[ZIKFunction getDateFromString:model.creatTime];
        model.timeAger=[ZIKFunction compareCurrentTime:creatTimeDate];
    }
    return model;
}
+(NSArray *)creathotBuyModelAryByAry:(NSArray *)ary
{
    NSMutableArray *Ary=[[NSMutableArray alloc]init];
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        HotBuyModel *model=[HotBuyModel hotBuyModelCreatByDic:dic];
        [Ary addObject:model];
    }
    return Ary;
}
@end
