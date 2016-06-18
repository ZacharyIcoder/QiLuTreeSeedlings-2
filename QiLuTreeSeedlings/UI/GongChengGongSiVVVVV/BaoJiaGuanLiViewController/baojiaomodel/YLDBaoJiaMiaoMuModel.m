//
//  YLDBaoJiaMiaoMuModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/18.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDBaoJiaMiaoMuModel.h"

@implementation YLDBaoJiaMiaoMuModel
+(YLDBaoJiaMiaoMuModel *)yldBaoModelWithDic:(NSDictionary *)dic
{
    YLDBaoJiaMiaoMuModel *model=[YLDBaoJiaMiaoMuModel new];
    model.area=dic[@"area"];
    model.descriptions=dic[@"description"];
    model.endDate=dic[@"endDate"];
    model.name=dic[@"name"];
    model.orderName=dic[@"orderName"];
    model.quantity=dic[@"quantity"];
    model.status=dic[@"status"];
    model.quote=dic[@"quote"];
    return model;
}

@end
