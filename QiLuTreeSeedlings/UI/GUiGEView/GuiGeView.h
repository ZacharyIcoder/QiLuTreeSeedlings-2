//
//  GuiGeView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDefines.h"
#import "GuiGeModel.h"
@protocol GuiGeViewDelegate <NSObject>
-(void)reloadViewWithFrame:(CGRect)frame;
@end
@interface GuiGeView : UIView
//@property (nonatomic,strong) NSMutableArray *
@property (nonatomic,weak)id<GuiGeViewDelegate> delegate;
@property (nonatomic,strong) UIButton *showBtn;
@property (nonatomic) BOOL  MainSure;//YES 限制主要规格 NO不限制住要规格
-(id)initWithAry:(NSArray *)modelAry andFrame:(CGRect)frame;
-(id)initWithValueAry:(NSArray *)modelAry andFrame:(CGRect)frame;
-(BOOL)getAnswerAry:(NSMutableArray *)answerAryz;
@end
