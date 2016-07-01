//
//  YLDBaoJiaMessageModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDBaoJiaMessageModel : NSObject
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *chargelPerson;
@property (nonatomic,copy) NSString *explain;
@property (nonatomic,copy) NSString *image2;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *quantity;
@property (nonatomic,copy) NSString *quoteTime;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *workstationName;
@property (nonatomic,copy) NSString *itemUid;
+(YLDBaoJiaMessageModel *)yldBaoJiaMessageModelWithDic:(NSDictionary *)dic;
+(NSMutableArray *)yldBaoJiaMessageModelWithAry:(NSArray *)dataAry;
@end
