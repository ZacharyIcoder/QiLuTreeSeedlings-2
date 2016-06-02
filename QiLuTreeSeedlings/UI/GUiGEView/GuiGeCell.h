//
//  GuiGeCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuiGeModel.h"
@protocol GuiGeCellDelegate <NSObject>
-(void)reloadView;
-(void)actionTextField:(UITextField *)textField;
-(void)dianxuanAction;
@end
@interface GuiGeCell : UIView
@property (nonatomic,strong) NSMutableArray *answerAry;
@property (nonatomic,strong) NSMutableArray *answerAry2;
@property (nonatomic,weak)UIView *erjiView;
@property (nonatomic,strong)GuiGeModel *model;
@property (nonatomic,weak)id <GuiGeCellDelegate>delegate;
-(id)initWithFrame:(CGRect)frame andModel:(GuiGeModel *)model;
-(id)initWithFrame:(CGRect)frame andValueModel:(GuiGeModel *)model;
@end
