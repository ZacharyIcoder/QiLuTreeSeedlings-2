//
//  UserBigInfoView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/4/1.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"
@protocol UserBigInfoViewDelegate <NSObject>
- (void)clickedHeadImage;
@end
@interface UserBigInfoView : UIView
@property (nonatomic,strong) UIButton *setingBtn;
@property (nonatomic,strong) UserInfoModel *model;
@property (nonatomic,weak) id<UserBigInfoViewDelegate>userDelegate;
@end
