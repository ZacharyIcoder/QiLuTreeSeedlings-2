//
//  ZIKStationAgentModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/13.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZIKStationAgentModel : NSObject
/**
 *  工作站地址
 */
@property (nonatomic, copy) NSString *areaall;
/**
 *  站长姓名
 */
@property (nonatomic, copy) NSString *chargelPerson;
/**
 *  电话
 */
@property (nonatomic, copy) NSString *phone;
/**
 *  星级
 */
@property (nonatomic, copy) NSString *starLevelApi;
/**
 *  uid
 */
@property (nonatomic, copy) NSString *uid;
/**
 *  工作站名称
 */
@property (nonatomic, copy) NSString *workstationName;
@end
