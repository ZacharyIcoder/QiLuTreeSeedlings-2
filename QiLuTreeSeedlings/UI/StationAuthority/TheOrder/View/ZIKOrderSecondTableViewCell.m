//
//  ZIKOrderSecondTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/13.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKOrderSecondTableViewCell.h"
#import "UIDefines.h"
@implementation ZIKOrderSecondTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.contentView
//    self.contentView.layer.shadowColor   = [UIColor blackColor].CGColor;///shadowColor阴影颜色
//    self.contentView.layer.shadowOpacity = 0.2;////阴影透明度，默认0
//    self.contentView.layer.shadowOffset  = CGSizeMake(0, -3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移1，默认(0, -3),这个跟shadowRadius配合使用
//    self.contentView.layer.shadowRadius  = 3;//阴影半径，默认3

//    [self.startTimeButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configureCell:(id)model {
}

- (IBAction)startTimeButtonClick:(UIButton *)sender {
    [self.endTimeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.endTimeButton setImage:[UIImage imageNamed:@"ico_排序默认"] forState:UIControlStateNormal];
    self.endTimeButton.tag = 1000;
    if (sender.tag == 1000 || sender.tag == 3000) {
        sender.tag = 2000;
        [sender setTitleColor:NavColor forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"ico_排序倒序"] forState:UIControlStateNormal];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"desc",@"sort",@"order_date",@"time", nil];
        if ([self.delegate respondsToSelector:@selector(sendTimeSortInfo:)]) {
            [self.delegate sendTimeSortInfo:dic];
        }
    } else if (sender.tag == 2000) {
        sender.tag = 3000;
        [sender setTitleColor:NavColor forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"ico_排序正序"] forState:UIControlStateNormal];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"asc",@"sort",@"order_date",@"time", nil];
        if ([self.delegate respondsToSelector:@selector(sendTimeSortInfo:)]) {
            [self.delegate sendTimeSortInfo:dic];
        }
    }

}

- (IBAction)endTimeButtonClick:(UIButton *)sender {
    [self.startTimeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.startTimeButton setImage:[UIImage imageNamed:@"ico_排序默认"] forState:UIControlStateNormal];
    self.startTimeButton.tag = 1000;
    if (sender.tag == 1000 || sender.tag == 3000) {
        sender.tag = 2000;
        [sender setTitleColor:NavColor forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"ico_排序倒序"] forState:UIControlStateNormal];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"desc",@"sort",@"end_date",@"time", nil];
        if ([self.delegate respondsToSelector:@selector(sendTimeSortInfo:)]) {
            [self.delegate sendTimeSortInfo:dic];
        }
    } else if (sender.tag == 2000) {
        sender.tag = 3000;
        [sender setTitleColor:NavColor forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"ico_排序正序"] forState:UIControlStateNormal];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"asc",@"sort",@"end_date",@"time", nil];
        if ([self.delegate respondsToSelector:@selector(sendTimeSortInfo:)]) {
            [self.delegate sendTimeSortInfo:dic];
        }
    }
}


@end
