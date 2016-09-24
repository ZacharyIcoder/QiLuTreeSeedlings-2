//
//  YLDMMPiLiangBianJiCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/22.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLDMMPiLiangBianJiCell;
@class BWTextView;
@protocol YLDMMPiLiangBianJiCellDelegate <NSObject>
@optional
-(void)deleteWithSelf:(YLDMMPiLiangBianJiCell *)cell andRow:(NSInteger)row andDic:(NSMutableDictionary*)dic;
@end
@interface YLDMMPiLiangBianJiCell : UITableViewCell
@property (nonatomic,weak) UITextField *nameTextField;
@property (nonatomic,weak) UITextField *numTextField;
@property (nonatomic,weak) BWTextView *shuomingTextView;
@property (nonatomic,weak) UITextField *unitTextField;
@property (nonatomic,weak) UIButton *deleteBtn;
@property (nonatomic,weak) NSMutableDictionary *messageDic;
@property (nonatomic,weak) id<YLDMMPiLiangBianJiCellDelegate> delegate;
-(BOOL)checkChangeMessage;
-(void)getChangeMessage;
@end
