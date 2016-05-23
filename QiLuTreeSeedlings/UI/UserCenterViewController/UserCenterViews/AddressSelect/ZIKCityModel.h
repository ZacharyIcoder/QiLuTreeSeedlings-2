//
//  ZIKCityModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZIKCity : NSObject

@property (nonatomic,  strong) NSString *cityID;
@property (nonatomic,  strong) NSString *cityName;
@property (nonatomic,  strong) NSString *code;
@property (nonatomic,  strong) NSString *parent_code;
@property (nonatomic,  strong) NSString *level;
@property (nonatomic,  strong) NSString *select;
//@property (nonatomic,  strong) NSArray  *towns;

@end

@interface ZIKProvince : NSObject

@property (nonatomic,  strong) NSString *provinceID;
@property (nonatomic,  strong) NSString *provinceName;
@property (nonatomic,  strong) NSArray  *citys;
//@property (nonatomic,  strong) City     *selectedCity;
@property (nonatomic,  strong) NSString *code;
@property (nonatomic,  strong) NSString *parent_code;
@property (nonatomic,  strong) NSString *level;
@end

@interface ZIKCityModel : NSObject
@property (nonatomic, strong) ZIKProvince *province;
@property (nonatomic, strong) NSArray  *selectedIndexs;
+(ZIKCityModel *)initCityModelWithDic:(NSDictionary *)dic;
//+(CityModel *)creatCtiyModelByDic:(NSDictionary *)dic;
//+(NSMutableArray *)creatCityAryByAry:(NSArray *)ary;

@end
