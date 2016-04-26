//
//  MybuyListTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/4/26.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotBuyModel.h"
@interface MybuyListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *timeimage;
@property (weak, nonatomic) IBOutlet UIImageView *dingweiimage;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (nonatomic,strong)HotBuyModel *hotBuyModel;
@property (nonatomic) BOOL isSelect;
+(NSString *)IDStr;
@end
