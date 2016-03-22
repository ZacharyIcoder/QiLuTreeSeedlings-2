//
//  GusseYourLikeModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/2.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "GusseYourLikeModel.h"

@implementation GusseYourLikeModel
+(GusseYourLikeModel *)creatGusseYoutLikeBy:(NSDictionary *)dic
{
    GusseYourLikeModel *model=[[GusseYourLikeModel alloc]init];
    model.ifNew=[[dic objectForKey:@"ifNew"] intValue];
    model.productName=[dic objectForKey:@"productName"];
    model.prductUid=[dic objectForKey:@"productUid"];
    model.type=[[dic objectForKey:@"type"] intValue];
    return model;
}
+(NSArray *)creatGusseLikeAryByAry:(NSArray *)ary
{
    NSMutableArray *Ary=[[NSMutableArray alloc]init];
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        GusseYourLikeModel *model=[GusseYourLikeModel creatGusseYoutLikeBy:dic];
        [Ary addObject:model];
    }
    return Ary;
}
@end
