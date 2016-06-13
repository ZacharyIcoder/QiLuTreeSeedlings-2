//
//  ZIKNavConfigViewController.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/11.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKBaseViewController.h"

typedef void(^RightBarBtnClickedBlock)();
typedef void(^LeftBarBtnClickedBlock)();

@interface ZIKNavConfigViewController : ZIKBaseViewController
/**
 *  左侧按钮图像名称
 */
@property (nonatomic, copy) NSString *leftBarBtnImgString;
/**
 *  左侧按钮名称
 */
@property (nonatomic, copy) NSString *leftBarBtnTitleString;
/**
 *  左侧按钮block
 */
@property (nonatomic, copy) LeftBarBtnClickedBlock leftBarBtnBlock;

/**
 *  右侧按钮图像名称
 */
@property (nonatomic, copy) NSString *rightBarBtnImgString;
/**
 *  右侧按钮名称
 */
@property (nonatomic, copy) NSString *rightBarBtnTitleString;
/**
 *  右侧按钮block
 */
@property (nonatomic, copy) RightBarBtnClickedBlock rightBarBtnBlock;

/**
 *  nav标题
 */
@property (nonatomic, copy) NSString *vcTitle;
@end
