//
//  YLDGongChengZhongXinBigCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDGCGSModel.h"
@protocol YLDGongChengZhongXinBigCelldelegate<NSObject>
@end
@interface YLDGongChengZhongXinBigCell : UITableViewCell
- (IBAction)BackBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *userImagV;
- (IBAction)shareBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *personName;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (nonatomic,strong) YLDGCGSModel *model;
+(YLDGongChengZhongXinBigCell *)yldGongChengZhongXinBigCell;
@end
