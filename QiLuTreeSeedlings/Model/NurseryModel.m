//
//  NurseryModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/26.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "NurseryModel.h"

@implementation NurseryModel
+(NurseryModel *)creaNursweryModelByDic:(NSDictionary *)dic
{
    NurseryModel *model=[[NurseryModel alloc]init];
    model.nrseryId = [dic objectForKey:@"nrseryId"];
  
        model.uid = [dic objectForKey:@"uid"];
   
    model.chargelPerson=[dic objectForKey:@"chargelPerson"];
    model.nurseryAddress=[dic objectForKey:@"nurseryAddress"];
    model.nurseryName=[dic objectForKey:@"nurseryName"];
    model.areaall=[dic objectForKey:@"areaall"];
    model.brief=[dic objectForKey:@"brief"];
    model.checked=[[dic objectForKey:@"checked"] integerValue];
    model.createTime=[dic objectForKey:@"createTime"];
    model.memberId=[dic objectForKey:@"memberId"];
    model.nurseryAddress=[dic objectForKey:@"nurseryAddress"];
    model.nurseryAreaProvince=[dic objectForKey:@"nurseryAreaProvince"];
    model.nurseryAreaCity=[dic objectForKey:@"nurseryAreaCity"];
    model.nurseryAreaCounty=[dic objectForKey:@"nurseryAreaCounty"];
    model.nurseryAreaTown=[dic objectForKey:@"nurseryAreaTown"];
    model.phone=[dic objectForKey:@"phone"];
    model.updateTime=[dic objectForKey:@"updateTime"];
    return model;
}
+(NSMutableArray *)creatNursweryListByAry:(NSArray *)ary
{
    NSMutableArray *listAry=[NSMutableArray array];
    
    for (NSDictionary *dic in ary) {
        NurseryModel *model=[self creaNursweryModelByDic:dic];
        [listAry addObject:model];
    }
    
    return listAry;
}
@end
