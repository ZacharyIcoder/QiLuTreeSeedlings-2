//
//  NurseryModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/26.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NurseryModel : NSObject
@property (nonatomic,strong) NSString *nrseryId;
@property (nonatomic,strong) NSString *chargelPerson;
@property (nonatomic,strong) NSString *nurseryAddress;
@property (nonatomic,strong) NSString *nurseryName;
@property (nonatomic,strong) NSString *areaall;
@property (nonatomic,strong) NSString *brief;
@property (nonatomic) NSInteger checked;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *memberId;
@property (nonatomic,strong) NSString *nurseryAreaCity;
@property (nonatomic,strong) NSString *nurseryAreaCounty;
@property (nonatomic,strong) NSString *nurseryAreaProvince;
@property (nonatomic,strong) NSString *nurseryAreaTown;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *updateTime;
+(NurseryModel *)creaNursweryModelByDic:(NSDictionary *)dic;
+(NSMutableArray *)creatNursweryListByAry:(NSArray *)ary;
@end
