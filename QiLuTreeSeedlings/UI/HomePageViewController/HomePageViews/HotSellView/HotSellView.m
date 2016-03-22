//
//  HotSellView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/24.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "HotSellView.h"
#import "HotSellViewCell.h"
#import "UIDefines.h"
#import "HotSellModel.h"
@implementation HotSellView
-(id)initWith:(CGFloat)Y andAry:(NSArray *)ary
{
    self=[super init];
    if (self) {
        [self setFrame:CGRectMake(0, Y, kWidth, 100*ary.count)];
        for (int i=0; i<ary.count; i++) {
           // NSDictionary *dic=[[NSDictionary alloc]init];
            HotSellModel *model=ary[i];
            HotSellViewCell *cell=[[HotSellViewCell alloc]initWithFrame:CGRectMake(0, i*100, kWidth, 100) andDic:model];
            [cell.actionBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:cell];
            cell.actionBtn.tag=i;
            [self setBackgroundColor:[UIColor whiteColor]];
        }
    }
    return self;
}
-(void)btnAction:(UIButton *)sender
{
    if (self.delegate) {
        [self.delegate HotSellViewsPush:sender.tag];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
