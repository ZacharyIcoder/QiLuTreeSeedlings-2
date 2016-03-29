//
//  SreeningViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/4.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeSpecificationsModel.h"
//<<<<<<< Updated upstream
//@protocol cellBeginendDelegate <NSObject>
//
//@optional
//- (void)cellBeginEditing:(UITextField *)field;
//- (void)cellKeyHight:(CGFloat)hight;
//- (void)cellEndEditing;
//@end
//=======
//@protocol cellBeginendDelegate <NSObject>
//
//@optional
////- (void)cellBeginEditing:(UITextField *)field;
//////-(void)cellKeyHight:(CGFloat)hight;
//////- (void)cellEndEditing;
////@end

@interface SreeningViewCell : UIView<UITextFieldDelegate>
@property (nonatomic,strong)TreeSpecificationsModel *model;
@property (nonatomic,strong)NSMutableArray *answerAry;
//@property (nonatomic,weak)id <cellBeginendDelegate> delegate;
-(id)initWithFrame:(CGRect)frame AndModel:(TreeSpecificationsModel *)model;
-(id)initWithFrame:(CGRect)frame AndModel:(TreeSpecificationsModel *)model andAnswer:(NSString *)answer;
@end
