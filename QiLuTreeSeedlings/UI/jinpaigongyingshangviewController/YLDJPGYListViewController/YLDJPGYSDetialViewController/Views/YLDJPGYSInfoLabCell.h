//
//  YLDJPGYSInfoLabCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDJPGYSInfoLabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *personNameL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (nonatomic,copy) NSDictionary *dic;
+(YLDJPGYSInfoLabCell *)yldJPGYSInfoLabCell;
@end
