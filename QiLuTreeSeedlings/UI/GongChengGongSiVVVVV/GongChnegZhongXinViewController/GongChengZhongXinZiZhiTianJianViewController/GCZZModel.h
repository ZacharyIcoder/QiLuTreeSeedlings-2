//
//  GCZZModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCZZModel : NSObject
@property (nonatomic,strong) NSString *acqueTime;
@property (nonatomic,strong) NSString *attachment;
@property (nonatomic,strong) NSString *companyQualification;
@property (nonatomic,strong) NSString *issuingAuthority;
@property (nonatomic,strong) NSString *level;
@property (nonatomic,strong) NSString *uid;
+(GCZZModel *)GCZZModelWithDic:(NSDictionary *)dic;
+(NSMutableArray *)GCZZModelAryWithAry:(NSArray *)ary
;
@end
