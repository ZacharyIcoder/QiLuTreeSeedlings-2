//
//  ZIKMiaoQiDetailModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZIKMiaoQiDetailModel : NSObject
/**
 *  地址
 */
@property (nonatomic, copy) NSString *address;
/**
 *  名称
 */
@property (nonatomic, copy) NSString *companyName;
/**
 *  诚信保证金
 */
@property (nonatomic, copy) NSString *creditMargin;
/**
 *   供应商类型
 */
@property (nonatomic, copy) NSString *goldsupplier;
/**
 *  会员uid,
 */
@property (nonatomic, copy) NSString *memberUid;
/**
 *   姓名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  电话
 */
@property (nonatomic, copy) NSString *phone;
/**
 *  企业简介
 */
@property (nonatomic, copy) NSString *qybrief;
/**
 *  性别
 */
@property (nonatomic, copy) NSString *sex;
/**
 *  星级
 */
@property (nonatomic, copy) NSString *starLevel;
/**
 *  荣誉列表
 */
@property (nonatomic, copy) NSArray  *honor;

@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *legalPerson;
@property (nonatomic, copy) NSString *memberPhone;
@end
