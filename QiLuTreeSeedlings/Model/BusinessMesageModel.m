//
//  BusinessMesageModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/19.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "BusinessMesageModel.h"

@implementation BusinessMesageModel
+(BusinessMesageModel *)creatBusinessMessageModelByDic:(NSDictionary *)dic
{
    BusinessMesageModel *model=[BusinessMesageModel new];
    model.areaall=[dic objectForKey:@"areaall"];
    model.brief=[dic objectForKey:@"brief"];
    model.companyAddress=[dic objectForKey:@"companyAddress"];
    model.companyAreaCity=[dic objectForKey:@"companyAreaCity"];
    model.companyAreaCounty=[dic objectForKey:@"companyAreaCounty"];
    model.companyAreaProvince=[dic objectForKey:@"companyAreaProvince"];
    model.companyAreaTown=[dic objectForKey:@"companyAreaTown"];
    model.companyName=[dic objectForKey:@"companyName"];
    model.createTime=[dic objectForKey:@"createTime"];
    model.legalPerson=[dic objectForKey:@"legalPerson"];
    model.memberId=[dic objectForKey:@"memberId"];
    model.phone=[dic objectForKey:@"phone"];
    model.uid=[dic objectForKey:@"uid"];
    model.updateTime=[dic objectForKey:@"1448250483780"];
    model.zipcode=[dic objectForKey:@"zipcode"];
    return model;
}
@end
