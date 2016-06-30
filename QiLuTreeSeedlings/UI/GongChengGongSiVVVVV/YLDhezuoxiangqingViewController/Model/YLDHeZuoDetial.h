//
//  YLDHeZuoDetial.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/29.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDHeZuoDetial : NSObject
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSArray *cooperateList;
@property (nonatomic,strong) NSString *dbh;
@property (nonatomic,strong) NSString *descriptions;
@property (nonatomic,strong) NSString *endDate;
@property (nonatomic,strong) NSString *groundDiameter;
@property (nonatomic,strong) NSString *orderDate;
@property (nonatomic,strong) NSString *orderName;
@property (nonatomic,strong) NSString *orderType;
@property (nonatomic,strong) NSString *person;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *quantityRequired;
@property (nonatomic,strong) NSString *quotationRequired;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *uid;
+(YLDHeZuoDetial *)creatYLDHeZuoDetialWithDic:(NSDictionary *)dic;
@end
