//
//  YLDTuiJianGongZuoZhanCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDWorkstationlistModel.h"
@interface YLDTuiJianGongZuoZhanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *LogImag;
@property (weak, nonatomic) IBOutlet UILabel *ZhanZhangNameLab;
@property (weak, nonatomic) IBOutlet UILabel *ZzNumbLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *manNameLab;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (nonatomic,strong)YLDWorkstationlistModel *model;
+(YLDTuiJianGongZuoZhanCell *)yldTuiJianGongZuoZhanCell;
@end
