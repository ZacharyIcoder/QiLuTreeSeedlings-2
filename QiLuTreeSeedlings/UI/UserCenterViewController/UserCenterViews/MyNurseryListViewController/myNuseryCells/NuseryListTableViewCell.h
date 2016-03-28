//
//  NuseryListTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/26.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NurseryModel.h"
@interface NuseryListTableViewCell : UITableViewCell
@property (nonatomic,strong) NurseryModel *model;
+(NSString *)IdStr;
@end
