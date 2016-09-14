//
//  ZIKShaiDanDetailModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/14.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZIKShaiDanDetailModel : NSObject
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
 *  点赞ID，未点赞时，无该字段
 */
@property (nonatomic, copy) NSString *dianZanUid;
/**
 *  大图去掉‘-detail’即可
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
 *  发布人
 */
@property (nonatomic, copy) NSString *memberName;
/**
 *  发布人Uid
 */
@property (nonatomic, copy) NSString *memberUid;
/**
 *  晒单ID
 */
@property (nonatomic, copy) NSString *uid;
/**
 *  评论列表
 */
@property (nonatomic, strong) NSArray *pingLunList;
@end
