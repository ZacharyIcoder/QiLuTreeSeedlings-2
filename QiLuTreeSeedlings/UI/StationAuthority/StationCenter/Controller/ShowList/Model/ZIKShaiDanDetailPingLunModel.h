//
//  ZIKShaiDanDetailPingLunModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/14.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZIKShaiDanDetailPingLunModel : NSObject
/**
 *  评论内容
 */
@property (nonatomic, copy) NSString *content;
/**
 *  评论时间
 */
@property (nonatomic, copy) NSString *createTimeStr;
/**
 *  是否可删除；1可删除；0不可删除
 */
@property (nonatomic, copy) NSString *del;
/**
 *  --会员名
 */
@property (nonatomic, copy) NSString *memberName;
/**
 *  评论ID
 */
@property (nonatomic, copy) NSString *uid;
@end
