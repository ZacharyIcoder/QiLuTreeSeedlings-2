//
//  HotBuyViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/17.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotBuyModel.h"
@interface HotBuyViewCell : UIView
@property (nonatomic,strong) UIButton *actionBtn;
@property (nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UILabel *cityLab;
@property (nonatomic,strong)UILabel *timelLab;
@property (nonatomic,strong)UILabel *priceLab;
@property (nonatomic,strong)NSDictionary *dic;
@property (nonatomic,strong) HotBuyModel *model;
-(id)initWithFrame:(CGRect)frame andDic:(HotBuyModel*)model;
@end
