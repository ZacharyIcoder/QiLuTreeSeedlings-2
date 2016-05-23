//
//  ZIKCityModel.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKCityModel.h"
#import "GetCityDao.h"
@implementation ZIKCity
+(ZIKCity *)initCityWithLevel:(NSString *)level {
//    GetCityDao *dao = [[GetCityDao alloc] init];
//    [dao openDataBase];
    return nil;
}
@end

@implementation ZIKProvince
+(ZIKProvince *)initProvinceWithDic:(NSDictionary *)dic {
    ZIKProvince *province    = [ZIKProvince new];
    province.provinceID   = dic[@"id"];
    province.provinceName = dic[@"name"];
    province.code         = dic[@"code"];
    province.parent_code  = dic[@"parent_code"];
    province.level        = dic[@"level"];
//    City *city = [City new];
//    province.citys =
    return province;
}
@end

@implementation ZIKCityModel
+(ZIKCityModel *)initCityModelWithDic:(NSDictionary *)dic {
    ZIKCityModel *cityModel = [ZIKCityModel new];
    ZIKProvince *province      = [ZIKProvince initProvinceWithDic:dic];
    cityModel.province      = province;
    return cityModel;
}
@end
