//
//  YLDGongZuoZhanMessageCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDZhanZhangDetialModel.h"
@interface YLDGongZuoZhanMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIImageView *logoV;
@property (nonatomic,strong)YLDZhanZhangDetialModel*model;
+(YLDGongZuoZhanMessageCell *)yldGongZuoZhanMessageCell;
@end
