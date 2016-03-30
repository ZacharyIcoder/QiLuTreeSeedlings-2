//
//  HotSellView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/24.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotSellModel.h"
@protocol HotSellViewDelegate <NSObject>

- (void)HotSellViewsPush:(HotSellModel *)model;

@end
@interface HotSellView : UIView
@property (nonatomic,weak) id<HotSellViewDelegate> delegate;
@property (nonatomic,strong) NSArray *dataAry;
-(id)initWith:(CGFloat)Y andAry:(NSArray *)ary;
@end
