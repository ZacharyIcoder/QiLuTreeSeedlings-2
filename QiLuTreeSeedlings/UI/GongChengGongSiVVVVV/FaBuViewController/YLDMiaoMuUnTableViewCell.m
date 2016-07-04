//
//  YLDMiaoMuUnTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/16.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDMiaoMuUnTableViewCell.h"
#import "UIDefines.h"
@implementation YLDMiaoMuUnTableViewCell
+(YLDMiaoMuUnTableViewCell *)yldMiaoMuUnTableViewCell
{
     YLDMiaoMuUnTableViewCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"YLDMiaoMuUnTableViewCell" owner:self options:nil] lastObject];
    UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 79.5,kWidth-20 , 0.5)];
    [cell addSubview:lineView];
    cell.bianhaoLab.layer.masksToBounds=YES;
    cell.bianhaoLab.layer.cornerRadius=2;
    [lineView setBackgroundColor:kLineColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
+(YLDMiaoMuUnTableViewCell *)yldMiaoMuUnTableViewCell2
{
    YLDMiaoMuUnTableViewCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"YLDMiaoMuUnTableViewCell" owner:self options:nil] lastObject];
    UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 79.5,kWidth-20 , 0.5)];
    [cell addSubview:lineView];
    cell.bianhaoLab.layer.masksToBounds=YES;
    cell.bianhaoLab.layer.cornerRadius=2;
    [lineView setBackgroundColor:kLineColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setMessageDic:(NSDictionary *)messageDic
{
    _messageDic=messageDic;
    self.nameLab.text=messageDic[@"name"];
    self.numLab.text=[NSString stringWithFormat:@"%@棵",messageDic[@"quantity"]];
    NSString *shuomingStr=messageDic[@"description"];
    if (shuomingStr.length!=0) {
        self.jieshaoLab.text=[NSString stringWithFormat:@"要求说明：%@",messageDic[@"description"]];  
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
