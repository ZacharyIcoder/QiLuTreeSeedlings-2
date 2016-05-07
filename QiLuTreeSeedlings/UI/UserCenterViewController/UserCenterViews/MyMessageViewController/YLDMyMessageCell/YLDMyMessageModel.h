//
//  YLDMyMessageModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/7.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDMyMessageModel : NSObject
@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) NSString *pushTimeStr;
@property (nonatomic,copy) NSString *readTimeStr;
@property (nonatomic) NSInteger reads;
@property (nonatomic,copy) NSString *uid;
+(YLDMyMessageModel *)creatModelWithDic:(NSDictionary *)dic;
+(NSArray *)creatModelAryWithAry:(NSArray *)ary;
@end
