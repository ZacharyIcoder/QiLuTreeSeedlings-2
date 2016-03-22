//
//  HotSellView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/24.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HotSellViewDelegate <NSObject>

- (void)HotSellViewsPush:(NSInteger)index;

@end
@interface HotSellView : UIView
@property (nonatomic,weak) id<HotSellViewDelegate> delegate;
-(id)initWith:(CGFloat)Y andAry:(NSArray *)ary;
@end
