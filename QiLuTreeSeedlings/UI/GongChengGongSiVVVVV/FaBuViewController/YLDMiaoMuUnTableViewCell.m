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
//    UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 79.5,kWidth-20 , 0.5)];
//    [cell addSubview:lineView];
    cell.bianhaoLab.layer.masksToBounds=YES;
    cell.bianhaoLab.layer.cornerRadius=2;
    //[lineView setBackgroundColor:kLineColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
+(YLDMiaoMuUnTableViewCell *)yldMiaoMuUnTableViewCell2
{
    YLDMiaoMuUnTableViewCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"YLDMiaoMuUnTableViewCell" owner:self options:nil] lastObject];
//    UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 79.5,kWidth-20 , 0.5)];
//    [cell addSubview:lineView];
    cell.bianhaoLab.layer.masksToBounds=YES;
    cell.bianhaoLab.layer.cornerRadius=2;
  //  [lineView setBackgroundColor:kLineColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UIButton *chakanBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, 10, 60, 30)];
    cell.chakanBtn=chakanBtn;
    [chakanBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [cell addSubview:chakanBtn];
    return cell;
}
-(void)setMessageDic:(NSDictionary *)messageDic
{
    _messageDic=messageDic;
    self.nameLab.text=messageDic[@"name"];
    self.numLab.text=[NSString stringWithFormat:@"%@棵(株)",messageDic[@"quantity"]];
    NSString *shuomingStr=messageDic[@"description"];
    if (shuomingStr.length!=0) {
        self.jieshaoLab.text=[NSString stringWithFormat:@"规格要求：%@",messageDic[@"description"]];
    }else{
        self.jieshaoLab.text=@"规格要求：";
    }
    NSString *stauts=[messageDic objectForKey:@"stauts"];
    if (self.chakanBtn) {
        if ([stauts integerValue]==1||[stauts integerValue]==2) {
           
            self.chakanBtn.tag=1;
            [self.chakanBtn addTarget:self action:@selector(chakanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            if ([stauts integerValue]==1) {
                 [self.chakanBtn setBackgroundColor:NavYellowColor];
                [self.chakanBtn setTitle:@"查看报价" forState:UIControlStateNormal];
            }else
            {
                [self.chakanBtn setBackgroundColor:NavColor];
                [self.chakanBtn setTitle:@"部分合作" forState:UIControlStateNormal];
            }
            
        }
        if ([stauts integerValue]==3) {
            [self.chakanBtn setBackgroundColor:NavColor];
            [self.chakanBtn setTitle:@"已合作" forState:UIControlStateNormal];
            self.chakanBtn.tag=3;
            [self.chakanBtn addTarget:self action:@selector(chakanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if ([stauts integerValue]==4) {
            [self.chakanBtn setBackgroundColor:[UIColor colorWithRed:64/255.f green:204/255.f blue:246/255.f alpha:1]];
            self.chakanBtn.tag=4;
            [self.chakanBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [self.chakanBtn addTarget:self action:@selector(chakanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
}
-(void)chakanBtnAction:(UIButton *)sender
{
    if (self.delegate) {
        [self.delegate chakanActionWithTag:sender.tag andDic:self.messageDic];
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
