//
//  HotBuyModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/2.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotBuyModel : NSObject
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *creatTime;
@property (nonatomic,strong) NSString *effective;
@property (nonatomic,strong) NSString *price;
@property (nonatomic)        NSInteger count;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *supplybuyUid;
@property (nonatomic)NSInteger New;
@property (nonatomic)NSInteger effect;
@property (nonatomic,strong) NSString *timeAger;
+(HotBuyModel *)hotBuyModelCreatByDic:(NSDictionary *)dic;
+(NSArray *)creathotBuyModelAryByAry:(NSArray *)ary;
@end
