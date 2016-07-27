//
//  YLDDingDanModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/16.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface YLDDingDanModel : NSObject
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *endDate;
@property (nonatomic,copy) NSString *miaomu;
@property (nonatomic,copy) NSString *orderDate;
@property (nonatomic,copy) NSString *orderName;
@property (nonatomic,copy) NSString *orderType;
@property (nonatomic,copy) NSString *quotation;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,assign) NSInteger auditStatus;
@property (nonatomic)CGFloat showHeight;
@property (nonatomic)BOOL isShow;
@property (nonatomic)BOOL isSelect;
+(YLDDingDanModel *)yldDingDanModelWithDic:(NSDictionary *)dic;
+(NSArray *)YLDDingDanModelAryWithAry:(NSArray *)ary;
+(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font;
@end
