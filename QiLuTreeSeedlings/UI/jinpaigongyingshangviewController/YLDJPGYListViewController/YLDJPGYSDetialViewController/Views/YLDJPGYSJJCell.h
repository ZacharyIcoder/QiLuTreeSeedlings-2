//
//  YLDJPGYSJJCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDJPGYSJJCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jianjieL;
@property (weak, nonatomic) IBOutlet UIButton *chakanBtn;
@property (nonatomic,copy) NSString *jianjieStr;
+(YLDJPGYSJJCell *)yldJPGYSJJCell;
@end
