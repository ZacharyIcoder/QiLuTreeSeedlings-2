//
//  YLDBaoModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/18.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDBaoModel : NSObject
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *descriptions;
@property (nonatomic,copy) NSString *endDate;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *orderName;
@property (nonatomic,copy) NSString *quantity;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *uid;
+(YLDBaoModel *)yldBaoModelWithDic:(NSDictionary *)dic;
+(NSMutableArray *)yldBaoModelAryWithAry:(NSArray *)dataAry;
@end
