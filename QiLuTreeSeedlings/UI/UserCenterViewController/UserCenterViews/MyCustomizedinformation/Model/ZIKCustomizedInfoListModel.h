//
//  ZIKCustomizedInfoListModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZIKCustomizedInfoListModel : NSObject
/**
 *  标题
 */
@property (nonatomic, copy) NSString       *title;
/**
 *  求购ID
 */
@property (nonatomic, copy) NSString       *uid;
/**
 *  发送时间
 */
@property (nonatomic, copy) NSString       *sendTime;
/**
 *  --true:已读；false：未读
 */
@property (nonatomic, copy) NSString       *reads;
/**
 *  订制设置ID
 */
@property (nonatomic,copy ) NSString       *memberCustomUid;

/**
 *  信息uid
 */
@property (nonatomic,copy ) NSString       *mesUid;

@end
