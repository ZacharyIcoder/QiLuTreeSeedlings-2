//
//  YouLickView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/1/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GusseYourLikeModel.h"
@protocol YouLickViewDelegate <NSObject>

- (void)YouLickViewsPush:(GusseYourLikeModel *)model;

@end
@interface YouLickView : UITableViewCell
@property (nonatomic,strong) NSArray *dataAry;
@property (nonatomic,weak) id<YouLickViewDelegate> delegate;
-(id)initWithFrame:(CGRect)frame WithAry:(NSArray *)dataAry;
+(CGFloat)HightForCell:(NSArray *)dataAry;
@end
