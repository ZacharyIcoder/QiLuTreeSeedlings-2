//
//  ZIKRightBtnSringViewController.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/22.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//
typedef void(^RightBarBtnClickedBlock)();
#import "ZIKArrowViewController.h"

@interface ZIKRightBtnSringViewController : ZIKArrowViewController
/**
 *  右侧按钮名称
 */
@property (nonatomic, copy) NSString *rightBarBtnTitleString;
/**
 *  右侧按钮block
 */
@property (nonatomic, copy) RightBarBtnClickedBlock rightBarBtnBlock;

@end
