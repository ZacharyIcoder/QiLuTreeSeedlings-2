//
//  yYLDGZZRongYaoTableCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface yYLDGZZRongYaoTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollV;
@property (nonatomic,strong)NSArray *dataAry;
+(yYLDGZZRongYaoTableCell *)yldGZZRongYaoTableCell;
@end
