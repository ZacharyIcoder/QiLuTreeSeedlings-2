//
//  YLDBaoJiaCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/18.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDBaoModel.h"
@interface YLDBaoJiaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabx;
@property (weak, nonatomic) IBOutlet UILabel *nameMiaoMuLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UIImageView *statusV;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *shuomingLab;
@property (nonatomic,strong)YLDBaoModel *model;
+(YLDBaoJiaCell *)yldBaoJiaCell;
@end
