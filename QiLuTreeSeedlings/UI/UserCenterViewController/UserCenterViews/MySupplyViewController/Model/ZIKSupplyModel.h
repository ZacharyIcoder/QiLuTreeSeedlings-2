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

/**
 *  是否退回，true退回(废弃)
 */
@property (nonatomic,copy) NSString *tuihui;
/**
 *  "state":3，     状态  2审核通过， 3退回， 5过期
 */
@property (nonatomic,copy) NSString *state;
/**
 *  -退回理由
 */
@property (nonatomic,copy) NSString *reason;
/**
 *  true已刷新，flase 未刷新
 */
@property (nonatomic,copy) NSString *shuaxin;
/**
 *  是否可刷新
 */
@property (nonatomic,assign) BOOL isCanRefresh;

@property (nonatomic, copy) NSString *searchTime;
@end
