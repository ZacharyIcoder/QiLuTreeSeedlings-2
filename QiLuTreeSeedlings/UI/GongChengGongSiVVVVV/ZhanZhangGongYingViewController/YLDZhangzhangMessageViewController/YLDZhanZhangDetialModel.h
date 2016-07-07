//
//  YLDZhanZhangDetialModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/6.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDZhanZhangDetialModel : NSObject
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *brief;
@property (nonatomic,copy) NSString *chargelPerson;
@property (nonatomic,copy) NSString *creditMargin;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *viewNo;
@property (nonatomic,copy) NSString *workstationName;
@property (nonatomic,copy) NSString *workstationPic;
+(YLDZhanZhangDetialModel *)yldZhanZhangDetialModelWithDic:(NSDictionary *)dic;
@end
