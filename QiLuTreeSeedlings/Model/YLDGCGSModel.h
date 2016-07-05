//
//  YLDGCGSModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDGCGSModel : NSObject
@property (nonatomic,strong)NSString *area;
@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *attachment;
@property (nonatomic,strong)NSString *brief;
@property (nonatomic,strong)NSString *province;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *county;
@property (nonatomic,strong)NSString *companyName;
@property (nonatomic,strong)NSString *legalPerson;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *uid;
+(YLDGCGSModel *)yldGCGSModelWithDic:(NSDictionary *)dic;
@end
