//
//  ZIKSupplyModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/22.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZIKSupplyModel : NSObject
/**
 *  地址
 */
@property (nonatomic,copy) NSString *area;
/**
 *  数量
 */
@property (nonatomic,copy) NSString *count;
/**
 *  价格
 */
@property (nonatomic,copy) NSString *price;
/**
 *  缩略图
 */
@property (nonatomic,copy) NSString *image;
/**
 *  创建时间
 */
@property (nonatomic,copy) NSString *createTime;
/**
 *  是否可编辑
 */
@property (nonatomic,copy) NSString *edit;
/**
 *  标题
 */
@property (nonatomic,copy) NSString *title;
/**
 *  uid
 */
@property (nonatomic,copy) NSString *uid;
/**
 *  是否选中
 */
@property (nonatomic,assign) BOOL isSelect;
@end
