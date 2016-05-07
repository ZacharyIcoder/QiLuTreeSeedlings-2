//
//  YLDMyMessageModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/7.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "YLDMyMessageModel.h"

@implementation YLDMyMessageModel
+(YLDMyMessageModel *)creatModelWithDic:(NSDictionary *)dic
{
    YLDMyMessageModel *model=[[YLDMyMessageModel alloc]init];
    
    if (dic) {
        model.message=[dic objectForKey:@"message"];
        model.pushTimeStr=[dic objectForKey:@"pushTimeStr"];
        model.readTimeStr=[dic objectForKey:@"readTimeStr"];
        model.reads=[[dic objectForKey:@"reads"] integerValue];
        model.uid=[dic objectForKey:@"uid"];
    }
    return model;
}
+(NSArray *)creatModelAryWithAry:(NSArray *)ary
{
    NSMutableArray *modelAry=[NSMutableArray array];
    for (NSDictionary *dic in ary) {
      YLDMyMessageModel *model  = [YLDMyMessageModel creatModelWithDic:dic];
        [modelAry addObject:model];
    }
    return modelAry;
}
@end
