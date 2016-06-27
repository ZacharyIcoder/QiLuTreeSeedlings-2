//
//  ZIKStationOrderQuoteViewController.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/25.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKArrowViewController.h"

@interface ZIKStationOrderQuoteViewController : ZIKArrowViewController
/**
 *  苗木名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  苗木数量
 */
@property (nonatomic, copy) NSString *count;
/**
 *  报价要求
 */
@property (nonatomic, copy) NSString *quoteAsk;
@end
