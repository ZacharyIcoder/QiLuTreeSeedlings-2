//
//  ZIKConsumeRecordFrame.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/27.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ZIKConsumeRecordModel;
/** reason的字体 */
#define StatusReasonFont [UIFont systemFontOfSize:15]

/** 时间的字体 */
#define StatusTimeFont [UIFont systemFontOfSize:13]

@interface ZIKConsumeRecordFrame : NSObject
/**
 *  icon Frame
 */
@property (nonatomic, assign, readonly) CGRect iconF ;
/**
 *  reason Frame
 */
@property (nonatomic, assign, readonly) CGRect reasonF;
/**
 *  price Frame
 */
@property (nonatomic, assign, readonly) CGRect priceF;
/**
 *  time Frame
 */
@property (nonatomic, assign, readonly) CGRect timeF;
/**
 *  cell的高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@property (nonatomic, strong) ZIKConsumeRecordModel *recordModel;
@end
