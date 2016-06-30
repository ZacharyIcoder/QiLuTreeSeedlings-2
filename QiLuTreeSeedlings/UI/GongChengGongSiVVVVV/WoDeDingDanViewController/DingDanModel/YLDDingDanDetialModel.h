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
//1：可建立合作（已报价，但无合作工作站）
//2：部分合作（有合作工作站，但要求数量不足）
//3：已合作（有合作工作站，且苗木数量已足够）
//4:可编辑（无人报价）
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *dbh;
@property (nonatomic,copy) NSString *groundDiameter;
@property (nonatomic,copy) NSString *company;
+(YLDDingDanDetialModel *)yldDingDanDetialModelWithDic:(NSDictionary *)dic;
@end
