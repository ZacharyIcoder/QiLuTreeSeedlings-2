//
//  HotBuyView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/17.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "HotBuyView.h"
#import "UIDefines.h"
#import "HotBuyViewCell.h"
@implementation HotBuyView
-(id)initWithAry:(NSArray *)ary andY:(CGFloat)Y
{
    self=[super init];
    if (self) {
        self.cellAry = [NSMutableArray array];
        [self setFrame:CGRectMake(0, Y, kWidth, 60*ary.count)];
        for (int i=0; i<ary.count; i++) {
            HotBuyModel *model=ary[i];
            HotBuyViewCell *cell=[[HotBuyViewCell alloc]initWithFrame:CGRectMake(0, i*60, kWidth, 60) andDic:model];
            [cell.actionBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];  
            [self addSubview:cell];
            cell.actionBtn.tag=i;
            [self.cellAry addObject:cell];
            [self setBackgroundColor:[UIColor whiteColor]];
        }
    }
    return self;
}
-(void)btnAction:(UIButton *)sender
{
    if (self.delegate) {
            HotBuyModel *model=self.dataAry[sender.tag];
        //NSLog(@"%@",model.uid);
            [self.delegate HotBuyViewsPush:model];

    }
}
-(void)setDataAry:(NSArray *)dataAry
{
    _dataAry=dataAry;
    for (int i = 0; i<self.cellAry.count; i++) {
        HotBuyModel *model=self.dataAry[i];
        HotBuyViewCell *cell=self.cellAry[i];
        cell.model=model;
    }
    //NSLog(@"%lu",(unsigned long)dataAry.count);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
