//
//  HotBuyView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/17.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HotBuyViewsDelegate <NSObject>

- (void)HotBuyViewsPush:(NSInteger)index;

@end
@interface HotBuyView : UIView
@property (nonatomic,weak) id<HotBuyViewsDelegate> delegate;

-(id)initWithAry:(NSArray *)ary andY:(CGFloat)Y;
@end
