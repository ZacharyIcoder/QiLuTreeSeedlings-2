//
//  YLDTuiJianGongZuoZhanCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDTuiJianGongZuoZhanCell.h"

@implementation YLDTuiJianGongZuoZhanCell
+(YLDTuiJianGongZuoZhanCell *)yldTuiJianGongZuoZhanCell
{
    YLDTuiJianGongZuoZhanCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDTuiJianGongZuoZhanCell" owner:self options:nil] lastObject];
    
    
    return cell;
}
-(void)setModel:(YLDWorkstationlistModel *)model
{
    _model=model;
    self.ZhanZhangNameLab.text=model.workstationName;
    self.ZzNumbLab.text=model.viewNo;
    self.addressLab.text=model.area;
    self.manNameLab.text=model.chargelPerson;
    if ([model.type isEqualToString:@"总站"]) {
        [self.LogImag setImage:[UIImage imageNamed:@"ico_工作站-总站text.png"]];
    }else{
      [self.LogImag setImage:[UIImage imageNamed:@"ico_工作站-分站text.png"]];  
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
