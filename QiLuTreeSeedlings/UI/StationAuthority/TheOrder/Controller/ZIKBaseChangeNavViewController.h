//
//  ZIKBaseChangeNavViewController.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKBaseViewController.h"
#import "ZIKSearchBarView.h"

typedef void(^RightBarBtnClickedBlock)();
typedef void(^LeftBarBtnClickedBlock)();


@interface ZIKBaseChangeNavViewController : ZIKBaseViewController
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
 *  是否搜索状态
 */
@property (nonatomic, assign) BOOL isSearch;
/**
 *  右侧按钮是否隐藏
 */
@property (nonatomic, assign) BOOL isRightBtnHidden;
///**
// *  导航栏
// */
//@property (nonatomic, strong) UIView *navView;
/**
 *  搜索栏
 */
@property (nonatomic, strong)  ZIKSearchBarView *searchBarView;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *vcTitle;
@end
