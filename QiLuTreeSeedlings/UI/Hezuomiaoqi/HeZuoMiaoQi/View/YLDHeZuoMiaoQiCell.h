//
//  YLDHeZuoMiaoQiCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "ZIKHeZuoMiaoQiModel.h"
@interface YLDHeZuoMiaoQiCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *startView;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *personLab;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (nonatomic,strong)ZIKHeZuoMiaoQiModel *model;
+(YLDHeZuoMiaoQiCell *)yldHeZuoMiaoQiCell;
@end
