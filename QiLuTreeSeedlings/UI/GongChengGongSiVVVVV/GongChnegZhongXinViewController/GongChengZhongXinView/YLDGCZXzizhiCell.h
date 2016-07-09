//
//  YLDGCZXzizhiCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDGCZXzizhiCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagev;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
+(YLDGCZXzizhiCell *)yldGCZXzizhiCell;
-(void)setMessageWithImageName:(NSString *)imageName andTitle:(NSString *)title;
@end
