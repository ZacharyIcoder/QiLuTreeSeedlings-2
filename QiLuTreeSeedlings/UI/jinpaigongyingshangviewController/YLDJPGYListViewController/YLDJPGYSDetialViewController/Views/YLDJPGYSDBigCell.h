//
//  YLDJPGYSDBigCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+ZIKEnlargeTouchArea.h"
@interface YLDJPGYSDBigCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *shenfenLab;
@property (weak, nonatomic) IBOutlet UIImageView *touxiangImgV;
@property (weak, nonatomic) IBOutlet UILabel *companyNameL;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *touxiangBtn;
@property (nonatomic,copy) NSDictionary *dic;
@property (nonatomic,copy) NSDictionary *myDic;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnW;
+(id)YLDJPGYSDBigCell;
@end
