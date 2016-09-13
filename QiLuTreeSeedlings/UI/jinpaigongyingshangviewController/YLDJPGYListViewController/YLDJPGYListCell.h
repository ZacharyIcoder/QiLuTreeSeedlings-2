//
//  YLDJPGYListCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDJPGYSListModel.h"
@interface YLDJPGYListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shenfenV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UILabel *personL;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (nonatomic,strong)YLDJPGYSListModel *model;
+(YLDJPGYListCell *)yldJPGYListCell;
@end
