//
//  ActionView.m
//  RongQingSchool
//
//  Created by caitong on 15/8/31.
//  Copyright (c) 2015年 荣庆通达驾校. All rights reserved.
//

#import "JXActionView.h"
//屏幕尺寸
#define UISCREEN_SIZE ([[UIScreen mainScreen] bounds].size)

@implementation JXActionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.bounds = CGRectMake(0, 0, UISCREEN_SIZE.width, self.bounds.size.height);
    
    CGRect r = self.horPic.frame;
    r.size.width = UISCREEN_SIZE.width;
    self.horPic.frame = r;
    
    r = self.titleLb.frame;
    r.size.width = UISCREEN_SIZE.width;
    self.titleLb.frame = r;
    
    r = self.descLb.frame;
    r.size.width = UISCREEN_SIZE.width;
    self.descLb.frame = r;
    
    if([self isNullOrEmpty:self.leftBtn.titleLabel.text]){
        r = self.leftBtn.frame;
        r.size.width = 0;
        self.leftBtn.frame = r;
        
        r = self.rightBtn.frame;
        r.origin.x = 0;
        r.size.width = UISCREEN_SIZE.width;
        self.rightBtn.frame = r;
        
        r = self.verPic.frame;
        r.origin.x = 0;
        r.size.width = 0;
        self.verPic.frame = r;
    }
    else{
        r = self.leftBtn.frame;
        r.size.width = UISCREEN_SIZE.width/2;
        self.leftBtn.frame = r;
        
        r = self.rightBtn.frame;
        r.origin.x = UISCREEN_SIZE.width/2;
        r.size.width = UISCREEN_SIZE.width/2;
        self.rightBtn.frame = r;
        
        r = self.verPic.frame;
        r.origin.x = UISCREEN_SIZE.width/2;
        self.verPic.frame = r;
    }
    
    
}
/**
 *  判断字符串是否为空
 *
 *  @param str 要判断的字符串
 *
 *  @return 结果
 */
-(BOOL)isNullOrEmpty:(NSString *)str{

    //如果不是字符串，一般来讲就是数据错误
    if(![str isKindOfClass:[NSString class]]) return YES;

    return str == NULL || str == Nil || [str isEqual:[NSNull null]] || [str isEqualToString:@""];
}

-(void)addClickBlock:(ActionClickIndexBlock)block{
    self.clickBlock = block;
}

-(IBAction)click:(UIButton *)sender{
    if(self.clickBlock)
        self.clickBlock(sender.tag);
}

@end
