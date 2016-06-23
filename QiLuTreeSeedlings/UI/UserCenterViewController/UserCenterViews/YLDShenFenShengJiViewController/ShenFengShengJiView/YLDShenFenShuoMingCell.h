//
//  YLDShenFenShuoMingCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/22.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDShenFenShuoMingCell : UITableViewCell
@property (nonatomic,strong) NSDictionary *dic;
@property (weak, nonatomic) IBOutlet UILabel *detialLab;
@property (weak, nonatomic) IBOutlet UIButton *shengjiBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
+(YLDShenFenShuoMingCell *)yldShenFenShuoMingCell;
@end
