//
//  ZIKMiaoQiZhongXinModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/9.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZIKMiaoQiZhongXinModel : NSObject
/**
 *  供应商类型
 */
@property (nonatomic, copy) NSString *goldsupplier;
/**
 *  性别
 */
@property (nonatomic, copy) NSString *sex;
/**
 *  电话
 */
@property (nonatomic, copy) NSString *phone;
/**
 *  地址
 */
@property (nonatomic, copy) NSString *area;
/**
 *  姓名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  诚信保证金
 */
@property (nonatomic, copy) NSString *creditMargin;
/**
 *   名称
 */
@property (nonatomic, copy) NSString *companyName;
/**
 *  简介
 */
@property (nonatomic, copy) NSString *qybrief;
/**
 *  星级
 */
@property (nonatomic, copy) NSString *starLevel;

@property (nonatomic, copy) NSString *grbrief;

@property (nonatomic, copy) NSString *legalPerson;

@property (nonatomic, assign) BOOL isShow;

- (void)initStatusType;
@end
