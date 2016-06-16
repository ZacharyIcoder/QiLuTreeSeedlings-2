//
//  YLDMiaoMuUnTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/16.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDMiaoMuUnTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bianhaoLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *jieshaoLab;
@property (nonatomic,strong) NSDictionary *messageDic;
+(YLDMiaoMuUnTableViewCell *)yldMiaoMuUnTableViewCell;
@end
