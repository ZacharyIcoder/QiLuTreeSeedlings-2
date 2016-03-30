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

@interface HotSellView ()
@property NSMutableArray *cellAry;
@end
@implementation HotSellView
-(id)initWith:(CGFloat)Y andAry:(NSArray *)ary
{
    self=[super init];
    if (self) {
        _cellAry=[NSMutableArray array];
        [self setFrame:CGRectMake(0, Y, kWidth, 100*ary.count)];
        self.dataAry=ary;
        for (int i=0; i<ary.count; i++) {
            //NSDictionary *dic=[[NSDictionary alloc]init];
            HotSellModel *model=ary[i];
            HotSellViewCell *cell=[[HotSellViewCell alloc]initWithFrame:CGRectMake(0, i*100, kWidth, 100) andDic:model];
            [cell.actionBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:cell];
            [_cellAry addObject:cell];
            cell.actionBtn.tag=i;
            [self setBackgroundColor:[UIColor whiteColor]];
        }
    }
    return self;
}
-(void)setDataAry:(NSArray *)dataAry
{
    _dataAry=dataAry;
    for (int i=0; i<dataAry.count; i++) {
        if (_cellAry.count>=i+1) {
            HotSellViewCell *cell=_cellAry[i];
            HotSellModel *model=dataAry[i];
            cell.model=model;
        }
    }
}
-(void)btnAction:(UIButton *)sender
{
    
    if (self.delegate) {
        if (_dataAry.count>sender.tag) {
            HotSellModel *model=self.dataAry[sender.tag];
            [self.delegate HotSellViewsPush:model];
        }
        
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
