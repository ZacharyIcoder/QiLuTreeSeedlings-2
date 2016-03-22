//
//  TreeSpecificationsModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/4.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "TreeSpecificationsModel.h"

@implementation TreeSpecificationsModel
+(TreeSpecificationsModel *)creatTreeSpecificationsModelByDic:(NSDictionary *)dic
{    TreeSpecificationsModel *model=[[TreeSpecificationsModel alloc]init];
    if(dic){
   
    model.alert=[dic objectForKey:@"alert"];
    model.dataType=[[dic objectForKey:@"dataType"] integerValue];
    model.defaultValue=[dic objectForKey:@"defaultValue"];
    model.required=[[dic objectForKey:@"required"] integerValue];
    model.field=[dic objectForKey:@"field"];
    model.name=[dic objectForKey:@"name"];
    model.optionList=[dic objectForKey:@"optionList"];
    model.optionType=[[dic objectForKey:@"optionType"] integerValue];
    model.textLength=[[dic objectForKey:@"textLength"] integerValue];
    model.type=[[dic objectForKey:@"type"] integerValue];
    model.unit=[dic objectForKey:@"unit"];
    }
    return model;
}
+(NSArray *)creatTreeSpecificationsModelAryByAry:(NSArray *)ary
{
    NSMutableArray *Ary=[NSMutableArray array];
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        TreeSpecificationsModel *model=[TreeSpecificationsModel creatTreeSpecificationsModelByDic:dic];
        //NSLog(@"%@",model.name);
        [Ary addObject:model];
    }
    return Ary;
}
@end
