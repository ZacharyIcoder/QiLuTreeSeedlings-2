//
//  MasterInfoModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/30.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterInfoModel : NSObject
/**
 *  工作站地址
 */
@property (nonatomic, copy) NSString *area;
/**
 *  描述
 */
@property (nonatomic, copy) NSString *brief;
/**
 *  名称
 */
@property (nonatomic, copy) NSString *chargelPerson;
/**
 *  电话
 */
@property (nonatomic, copy) NSString *phone;
/**
 *  工作站名称
 */
@property (nonatomic, copy) NSString *workstationName;
/**
 *  工作站编号
 */
@property (nonatomic, copy) NSString *workstationNo;
/**
 *  站长头像url地址
 */
@property (nonatomic, copy) NSString *workstationPic;
/**
 *  站长类型（分站，总站）
 */
@property (nonatomic, copy) NSString *type;
/**
 *  信誉保证金
 */
@property (nonatomic, copy) NSString *creditMargin;

/**
 *  站长ID
 */
@property (nonatomic, copy) NSString *uid;
@end
