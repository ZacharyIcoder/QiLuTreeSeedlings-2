//
//  BuyDetialModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyDetialModel : NSObject
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *address;
@property (nonatomic) NSInteger collect;
@property (nonatomic,strong) NSString *collectUid;
@property (nonatomic,strong) NSString *count;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *descriptions;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSArray *spec;
@property (nonatomic,strong) NSString *supplybuyName;
@property (nonatomic,strong) NSString *supplybuyUid;
@property (nonatomic,strong) NSString *title;
@property (nonatomic) NSInteger views;
@property (nonatomic,strong) NSString *productName;
@property (nonatomic) NSInteger state;
+(BuyDetialModel *)creatBuyDetialModelByDic:(NSDictionary*)dic;
@end
