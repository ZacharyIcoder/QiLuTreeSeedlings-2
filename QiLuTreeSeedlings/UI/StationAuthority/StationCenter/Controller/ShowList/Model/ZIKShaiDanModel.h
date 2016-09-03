//
//  ZIKShaiDanModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/1.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZIKShaiDanModel : NSObject
/**
 *  晒单ID
 */
@property (nonatomic, copy) NSString *uid;
/**
 *  晒单内容
 */
@property (nonatomic, copy) NSString *content;
/**
 *  晒单时间
 */
@property (nonatomic, copy) NSString *createTimeStr;
/**
 *  点赞数
 */
@property (nonatomic, copy) NSString *dianZan;
/**
 *  图片
 */
@property (nonatomic, copy) NSString *images;
/**
 *  评论数
 */
@property (nonatomic, copy) NSString *pingLun;
/**
 *  晒单名称
 */
@property (nonatomic, copy) NSString *title;
/**
 *  工作站
 */
@property (nonatomic, copy) NSString *workstationName;
@end
