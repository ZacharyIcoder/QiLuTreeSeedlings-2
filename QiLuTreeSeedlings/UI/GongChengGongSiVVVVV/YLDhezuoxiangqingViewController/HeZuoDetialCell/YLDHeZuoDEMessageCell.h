//
//  YLDHeZuoDEMessageCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/22.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDHeZuoDEMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *shuliangLab;
@property (weak, nonatomic) IBOutlet UILabel *shuomingLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shuomingH;
@property (nonatomic,strong)NSDictionary *dic;
+(YLDHeZuoDEMessageCell *)yldHeZuoDEMessageCell;
@end
