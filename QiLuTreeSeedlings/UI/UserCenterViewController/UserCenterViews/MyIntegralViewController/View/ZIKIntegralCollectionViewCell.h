//
//  ZIKIntegralCollectionViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/31.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZIKIntegralCollectionViewCell : UICollectionViewCell
/**
 *  cell背景图
 */
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
/**
 *  所需积分Label
 */
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
/**
 *  金额Label
 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end
