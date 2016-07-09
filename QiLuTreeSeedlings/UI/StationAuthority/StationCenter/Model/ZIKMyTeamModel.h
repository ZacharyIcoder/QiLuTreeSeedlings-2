//
//  ZIKMyTeamModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/6.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZIKMyTeamModel : NSObject
/**
 *  地址
 */
@property (nonatomic, copy) NSString *area;
/**
 *  负责人
 */
@property (nonatomic, copy) NSString *chargelPerson;
/**
 *  联系电话
 */
@property (nonatomic, copy) NSString *phone;
/**
 *  类型，总站、分站
 */
@property (nonatomic, copy) NSString *type;
/**
 *  工作站名称
 */
@property (nonatomic, copy) NSString *workstationName;
/**
 *  工作站编号
 */
@property (nonatomic, copy) NSString *viewNo;

/**
 *  工作站ID 工作站列表
 */
@property (nonatomic, copy) NSString *uid;
@end
