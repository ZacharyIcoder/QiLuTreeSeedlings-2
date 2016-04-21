//
//  UserInfoNomerTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/11.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoNomerTableViewCell : UITableViewCell
@property (nonatomic,strong)UIView *lineImage;
-(id)initWithFrame:(CGRect)frame andImageName:(NSString *)imageName andTitle:(NSString *)title;
@end
