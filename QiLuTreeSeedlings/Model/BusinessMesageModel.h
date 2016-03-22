//
//  BusinessMesageModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/19.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessMesageModel : NSObject
@property (nonatomic,strong) NSString *areaall;
@property (nonatomic,strong) NSString *brief;
@property (nonatomic,strong) NSString *companyAddress;
@property (nonatomic,strong) NSString *companyAreaCity;
@property (nonatomic,strong) NSString *companyAreaCounty;
@property (nonatomic,strong) NSString *companyAreaProvince;
@property (nonatomic,strong) NSString *companyAreaTown;
@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *legalPerson;
@property (nonatomic,strong) NSString *memberId;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *updateTime;
@property (nonatomic,strong) NSString *zipcode;
+(BusinessMesageModel *)creatBusinessMessageModelByDic:(NSDictionary *)dic;
@end
