//
//  FabutiaojiaCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/4/6.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeSpecificationsModel.h"
@interface FabutiaojiaCell : UIView
@property (nonatomic,strong)TreeSpecificationsModel *model;
@property (nonatomic,strong)NSMutableArray *answerAry;
//@property (nonatomic,weak)id <cellBeginendDelegate> delegate;
//-(id)initWithFrame:(CGRect)frame AndModel:(TreeSpecificationsModel *)model;
-(id)initWithFrame:(CGRect)frame AndModel:(TreeSpecificationsModel *)model andAnswer:(NSString *)answer;
@end
