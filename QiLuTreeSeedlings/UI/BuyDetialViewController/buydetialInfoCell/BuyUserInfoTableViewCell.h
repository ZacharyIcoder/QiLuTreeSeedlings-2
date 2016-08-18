//
//  BuyUserInfoTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/8.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyDetialModel.h"
@interface BuyUserInfoTableViewCell : UITableViewCell
@property (nonatomic,strong)NSDictionary *dic;
@property (nonatomic,strong)BuyDetialModel *model;
@property (nonatomic, assign) BOOL isGouMai;

-(id)initWithFrame:(CGRect)frame;
- (instancetype)initWithCaiGouFrame:(CGRect)frame;
@end
