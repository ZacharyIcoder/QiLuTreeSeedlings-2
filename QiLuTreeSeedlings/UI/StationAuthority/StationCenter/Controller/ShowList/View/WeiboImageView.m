//
//  WeiboImageView.m
//  MySinaWeibo
//
//  Created by 刘刘智明 on 16/8/20.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "WeiboImageView.h"

@implementation WeiboImageView

@synthesize originRect;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        originRect = frame;
        self.clipsToBounds = YES;
        self.userInteractionEnabled  = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return self;
}

- (void)dealloc
{
    
}


@end
