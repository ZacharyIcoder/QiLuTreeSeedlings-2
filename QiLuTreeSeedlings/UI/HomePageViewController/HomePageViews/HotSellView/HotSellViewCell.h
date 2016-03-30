//
//  HotSellViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/24.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotSellModel.h"
@interface HotSellViewCell : UIView
@property (nonatomic,strong) UIButton *actionBtn;
@property (nonatomic,strong) HotSellModel *model;
-(id)initWithFrame:(CGRect)frame andDic:(HotSellModel *)Model;
@end
