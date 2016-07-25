//
//  YLDShopIndexinfoCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/25.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDShopIndexModel.h"
@interface YLDShopIndexinfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rifangWigth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shenfenLabW;
@property (weak, nonatomic) IBOutlet UIImageView *backImageV;
@property (weak, nonatomic) IBOutlet UIImageView *touxiangImageV;
@property (weak, nonatomic) IBOutlet UIImageView *shenfenImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *shenfenLab;
@property (weak, nonatomic) IBOutlet UILabel *fangwenRiLab;
@property (weak, nonatomic) IBOutlet UILabel *fengxhangZongLab;
@property (weak, nonatomic) IBOutlet UILabel *fenxhangNumLab;
@property (nonatomic,strong)YLDShopIndexModel *model;
+(YLDShopIndexinfoCell *)yldShopIndexinfoCell;
@end
