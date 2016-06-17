//
//  YLDDingDanDetialModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDDingDanDetialModel : NSObject
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *descriptionzz;
@property (nonatomic,copy) NSString *endDate;
@property (nonatomic,copy) NSArray *itemList;
@property (nonatomic,copy) NSString *measureRequired;
@property (nonatomic,copy) NSString *orderDate;
@property (nonatomic,copy) NSString *orderName;
@property (nonatomic,copy) NSString *orderType;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *quantityRequired;
@property (nonatomic,copy) NSString *quotationRequired;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *dbh;
@property (nonatomic,copy) NSString *groundDiameter;
+(YLDDingDanDetialModel *)yldDingDanDetialModelWithDic:(NSDictionary *)dic;
@end
