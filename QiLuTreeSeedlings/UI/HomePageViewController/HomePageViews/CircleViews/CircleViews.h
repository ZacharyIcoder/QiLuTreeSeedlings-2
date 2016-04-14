//
//  CircleViews.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/1/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CircleViewsDelegate <NSObject>

- (void)circleViewsPush:(NSInteger)index;

@end
@interface CircleViews : UITableViewCell
@property (nonatomic,weak) id<CircleViewsDelegate> delegate;
@end
