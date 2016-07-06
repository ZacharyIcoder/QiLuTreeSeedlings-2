//
//  YLDWorkstationlistModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDWorkstationlistModel : NSObject
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *chargelPerson;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *viewNo;
@property (nonatomic,copy) NSString *workstationName;
@property (nonatomic,copy) NSString  *type;
+(YLDWorkstationlistModel *)YLDWorkstationlistModelWithDic:(NSDictionary *)dic;
+(NSMutableArray *)YLDWorkstationlistModelWithAry:(NSArray *)ary;
@end
