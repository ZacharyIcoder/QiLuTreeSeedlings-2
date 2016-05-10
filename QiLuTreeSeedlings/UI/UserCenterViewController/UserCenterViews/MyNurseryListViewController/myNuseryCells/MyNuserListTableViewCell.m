//
//  MyNuserListTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/26.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "MyNuserListTableViewCell.h"
#import "UIDefines.h"
@implementation MyNuserListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.addressLab.textColor = detialLabColor;
    self.chargelPersonLab.textColor = detialLabColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setModel:(NurseryModel *)model
{
    _model=model;
    self.titleLab.text=model.nurseryName;
    NSString *contentStr1 = [NSString stringWithFormat:@"地址：%@",model.nurseryAddress];
    NSMutableAttributedString *addressLabstr = [[NSMutableAttributedString alloc]initWithString:contentStr1];
    //设置：在0-3个单位长度内的内容显示成红色
    [addressLabstr addAttribute:NSForegroundColorAttributeName value:titleLabColor range:NSMakeRange(0, 3)];
    self.addressLab.attributedText=addressLabstr;


    NSString *contentStr2 = [NSString stringWithFormat:@"负责人：%@",model.chargelPerson];
    NSMutableAttributedString *chargelPersonLabstr = [[NSMutableAttributedString alloc]initWithString:contentStr2];
    //设置：在0-3个单位长度内的内容显示成红色
    [chargelPersonLabstr addAttribute:NSForegroundColorAttributeName value:titleLabColor range:NSMakeRange(0, 3)];
    self.chargelPersonLab.attributedText=chargelPersonLabstr;
    if (model.isSelect==YES) {
        self.selected=YES;
        self.isSelect=YES;
    }
}

+(NSString *)IdStr
{
    return @"NuseryListTableViewCell";
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ZIKMyNuserListTableViewCellID = @"ZIKSupplyPublishNameTableViewCellID";
    MyNuserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZIKMyNuserListTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyNuserListTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}


@end
