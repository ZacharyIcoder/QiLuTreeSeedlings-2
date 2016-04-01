//
//  HotBuyView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/17.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotBuyModel.h"
@protocol HotBuyViewsDelegate <NSObject>

- (void)HotBuyViewsPush:(HotBuyModel *)model;

@end
@interface HotBuyView : UIView
@property (nonatomic,weak) id<HotBuyViewsDelegate> delegate;
@property (nonatomic,strong) NSArray *dataAry;
@property (nonatomic,strong) NSMutableArray *cellAry;
-(id)initWithAry:(NSArray *)ary andY:(CGFloat)Y;
@end
