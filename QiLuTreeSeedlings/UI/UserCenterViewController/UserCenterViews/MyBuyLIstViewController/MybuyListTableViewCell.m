//
//  MybuyListTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/4/26.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "MybuyListTableViewCell.h"
#import "UIDefines.h"
@implementation MybuyListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.titleLab setTextColor:titleLabColor];
    [self.timeLab setTextColor:detialLabColor];
    [self.cityLab setTextColor:detialLabColor];
    [self.priceLab setTextColor:yellowButtonColor];
    UIImageView *iamgeV=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.frame.size.height-0.5, kWidth-20, 0.5)];
    [iamgeV setBackgroundColor:kLineColor];
    [self.contentView addSubview:iamgeV];
    
    
    // Initialization code
}
+(NSString *)IDStr
{
    return @"MybuyListTableViewCell";
}
-(void)setHotBuyModel:(HotBuyModel *)hotBuyModel
{
    _hotBuyModel=hotBuyModel;
    self.titleLab.text=hotBuyModel.title;
    self.cityLab.text=hotBuyModel.area;
    
    self.timeLab.text=hotBuyModel.timeAger;
    
    
    NSArray *priceAry=[hotBuyModel.price componentsSeparatedByString:@"."];
    self.priceLab.text=[priceAry firstObject];
    if (hotBuyModel.isSelect) {
         self.isSelect = YES;
        self.selected = YES;
       
    }
    
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ZIKMyNuserListTableViewCellID = @"MybuyListTableViewCell";
    MybuyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZIKMyNuserListTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MybuyListTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.timeimage setBackgroundColor:[UIColor whiteColor]];
    [self.dingweiimage setBackgroundColor:[UIColor whiteColor]];
    // Configure the view for the selected state
}

@end
