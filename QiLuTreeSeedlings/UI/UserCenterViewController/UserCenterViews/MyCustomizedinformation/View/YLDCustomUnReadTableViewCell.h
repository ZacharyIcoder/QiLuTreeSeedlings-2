//
//  YLDCustomUnReadTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/14.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKCustomizedInfoListModel.h"
@interface YLDCustomUnReadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *redDD;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (nonatomic,strong)ZIKCustomizedInfoListModel *model;
@end
