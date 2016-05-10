//
//  CityModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/10.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel
+(CityModel *)creatCtiyModelByDic:(NSDictionary *)dic
{
    CityModel *model=[CityModel new];
    model.cityID = [dic objectForKey:@"id"];
    model.cityName = [dic objectForKey:@"name"];
    model.code=[dic objectForKey:@"code"];
    model.parent_code=[dic objectForKey:@"parent_code"];
    model.level=[dic objectForKey:@"level"];
    return model;
}
+(NSMutableArray *)creatCityAryByAry:(NSArray *)ary
{
    NSMutableArray *cityAry=[NSMutableArray array];
    for (NSDictionary *dic in ary) {
        CityModel *model = [CityModel creatCtiyModelByDic:dic];
        [cityAry addObject:model];
    }
    return cityAry;
}
@end
