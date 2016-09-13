//
//  YLDJPGYSListModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDJPGYSListModel.h"

@implementation YLDJPGYSListModel
+(YLDJPGYSListModel *)modelByDic:(NSDictionary *)dic
{
    YLDJPGYSListModel *model=[YLDJPGYSListModel new];
    model.areaall=dic[@"areaall"];
    model.companyName=dic[@"companyName"];
    model.name=dic[@"name"];
    model.phone=dic[@"phone"];
    model.uid=dic[@"uid"];
    model.goldsupplier=[dic[@"goldsupplier"] integerValue];
    return model;
}
+(NSMutableArray *)aryByAry:(NSArray *)ary
{
    NSMutableArray *Ary=[NSMutableArray new];
    
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        YLDJPGYSListModel *model=[YLDJPGYSListModel modelByDic:dic];
        [Ary addObject:model];
    }
    
    return Ary;
}
@end
