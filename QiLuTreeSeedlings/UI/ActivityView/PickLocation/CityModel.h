//
//  CityModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/10.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject
@property (nonatomic,  strong) NSString *cityID;
@property (nonatomic,  strong) NSString *cityName;
@property (nonatomic,  strong) NSString *code;
@property (nonatomic,  strong) NSString *parent_code;
@property (nonatomic,  strong) NSString *level;
+(CityModel *)creatCtiyModelByDic:(NSDictionary *)dic;
+(NSMutableArray *)creatCityAryByAry:(NSArray *)ary;
@end
