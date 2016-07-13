//
//  HotSellModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/2.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "HotSellModel.h"
#import "ZIKFunction.h"
@implementation HotSellModel
+(HotSellModel *)hotSellCreatByDic:(NSDictionary *)dic
{
    HotSellModel *hotSellModel=[[HotSellModel alloc]init];
    if (dic) {
        hotSellModel.area=[dic objectForKey:@"area"];
        hotSellModel.createTime=[dic objectForKey:@"createTime"];
        if (hotSellModel.createTime.length==0) {
            hotSellModel.createTime=[dic objectForKey:@"time"];
            if (hotSellModel.createTime.length<=11) {
                hotSellModel.createTime=[NSString stringWithFormat:@"%@ 00:00:00",hotSellModel.createTime];
            }
        }
         hotSellModel.searchtime=[dic objectForKey:@"searchTime"];
        hotSellModel.iamge=[dic objectForKey:@"image"];
        hotSellModel.title=[dic objectForKey:@"title"];
        hotSellModel.uid=[dic objectForKey:@"uid"];
        if (hotSellModel.uid.length==0) {
            hotSellModel.uid=[dic objectForKey:@"supplybuyUid"];
        }
        hotSellModel.edit=[[dic objectForKey:@"edit"] integerValue];
        hotSellModel.price=[dic objectForKey:@"price"];
        hotSellModel.count=[dic objectForKey:@"count"];
        hotSellModel.supplybuyUid=[dic objectForKey:@"supplybuyUid"];
        hotSellModel.supplybuyNurseryUid=[dic objectForKey:@"supplybuyNurseryUid"];
        hotSellModel.goldsupplier=[[dic objectForKey:@"goldsupplier"] integerValue];
        NSDate *creatTimeDate=[ZIKFunction getDateFromString:hotSellModel.createTime];
        hotSellModel.timeAger=[ZIKFunction compareCurrentTime:creatTimeDate];
       
    }
    return hotSellModel;
}
+(NSArray *)hotSellAryByAry:(NSArray *)ary
{
    NSMutableArray *Ary=[[NSMutableArray alloc]init];
    for (int i=0; i<ary.count; i++) {
        HotSellModel *model=[HotSellModel hotSellCreatByDic:ary[i]];
        [Ary addObject:model];
    }
    return Ary;
}
@end
