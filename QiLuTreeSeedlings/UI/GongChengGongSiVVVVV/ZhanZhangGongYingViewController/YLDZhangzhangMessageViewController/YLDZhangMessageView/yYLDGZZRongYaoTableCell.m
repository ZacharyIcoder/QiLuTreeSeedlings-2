//
//  yYLDGZZRongYaoTableCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "yYLDGZZRongYaoTableCell.h"
#import "ZIKStationHonorListModel.h"
#import "UIDefines.h"
#import "UIButton+AFNetworking.h"
@implementation yYLDGZZRongYaoTableCell
+(yYLDGZZRongYaoTableCell *)yldGZZRongYaoTableCell
{
    yYLDGZZRongYaoTableCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"yYLDGZZRongYaoTableCell" owner:self options:nil] lastObject];
    
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDataAry:(NSArray *)dataAry{
    _dataAry=dataAry;
    int x=(int)dataAry.count/3;
    int y=(int)dataAry.count%3;
    if (y>0) {
        x+=1;
    }
    [self.imageScrollV setContentSize:CGSizeMake((kWidth-20)*x, 0)];
    self.imageScrollV.pagingEnabled=YES;
    self.imageScrollV.showsHorizontalScrollIndicator=NO;
    CGFloat  jianxi=(kWidth-290)/4;
    for (int i=0; i<dataAry.count; i++) {
        ZIKStationHonorListModel *model=dataAry[i];
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake((jianxi+90)*i+jianxi, 5, 90, 70)];
        if (model.image.length>0) {
            [btn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
        }
       
        btn.tag=i;
        [self.imageScrollV addSubview:btn];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
