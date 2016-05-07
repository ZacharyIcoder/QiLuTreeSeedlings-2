//
//  YLDMyMessageTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/7.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDMyMessageModel.h"
@interface YLDMyMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *readImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *rowImage;
@property (nonatomic,strong) YLDMyMessageModel *model;
@end
