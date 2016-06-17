//
//  ZIKSelectMenuView.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MenuBtnBlock) (NSInteger);
@interface ZIKSelectMenuView : UIView
/**
 *  按钮标题数组
 */
@property (nonatomic, strong) NSArray *titleArray;
/**
 *  点击的index
 */
@property (nonatomic, assign) NSInteger index;
/**
 *  菜单按钮点击Block
 */
@property (nonatomic, copy) MenuBtnBlock menuBtnBlock;
-(id)initWithFrame:(CGRect)frame dataArray:(NSArray *)array;
@end
