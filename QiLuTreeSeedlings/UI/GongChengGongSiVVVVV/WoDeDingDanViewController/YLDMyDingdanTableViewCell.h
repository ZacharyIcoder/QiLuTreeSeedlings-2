//
//  YLDMyDingdanTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDDingDanModel.h"
@interface YLDMyDingdanTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *dingdanTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;
@property (weak, nonatomic) IBOutlet UILabel *yongmiaodi;
@property (weak, nonatomic) IBOutlet UILabel *miaomuPinZhongLab;
@property (weak, nonatomic) IBOutlet UILabel *fabuRiQiLab;
@property (weak, nonatomic) IBOutlet UILabel *jiezhiRiqiLab;
@property (nonatomic,strong) YLDDingDanModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *loggV;
+(YLDMyDingdanTableViewCell *)yldMyDingdanTableViewCell;
@property (weak, nonatomic) IBOutlet UIImageView *fengxiView;
@end
