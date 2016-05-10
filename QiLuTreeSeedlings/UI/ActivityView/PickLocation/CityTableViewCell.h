//
//  CityTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/10.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"
@interface CityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cityNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *pickImage;
@property (nonatomic,strong) CityModel *model;
+(CityTableViewCell *)CityTableViewCell;
@end
