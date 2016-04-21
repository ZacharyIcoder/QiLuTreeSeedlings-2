//
//  BuyOtherInfoTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/8.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyOtherInfoTableViewCell : UITableViewCell
@property (nonatomic,strong) NSArray *ary;
@property (nonatomic,strong)NSArray *dingzhiAry;
-(id)initWithFrame:(CGRect)frame andName:(NSString *)name;
@end
