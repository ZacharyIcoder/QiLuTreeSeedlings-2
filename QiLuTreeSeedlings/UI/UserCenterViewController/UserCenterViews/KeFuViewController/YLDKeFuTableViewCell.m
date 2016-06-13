//
//  YLDKeFuTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/13.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDKeFuTableViewCell.h"

#import "UIDefines.h"
@interface YLDKeFuTableViewCell()
@end
@implementation YLDKeFuTableViewCell
+(YLDKeFuTableViewCell *)yldKeFuTableViewCell
{
    YLDKeFuTableViewCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"YLDKeFuTableViewCell" owner:self options:nil] lastObject];
    return cell;
}
-(void)CallAction
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[self.messageDic objectForKey:@"phone"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)setMessageDic:(NSDictionary *)messageDic
{
    _messageDic=messageDic;
    NSString *nameStr=[messageDic objectForKey:@"name"];
    NSString *ssssStr=[NSString stringWithFormat:@"%@ %@",nameStr,[messageDic objectForKey:@"phone"]];
    NSMutableAttributedString *namestr = [[NSMutableAttributedString alloc] initWithString:ssssStr];
    
    [namestr addAttribute:NSForegroundColorAttributeName value:DarkTitleColor range:NSMakeRange(0,nameStr.length)]; //设置字体颜色
    
    [namestr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:17.0] range:NSMakeRange(0,nameStr.length)]; //设置字体字号和字体类别
    self.nameLab.attributedText=namestr;
    self.moneLab.text=[NSString stringWithFormat:@"%@元",[messageDic objectForKey:@"allAmount"]];
    self.timeLab.text=[NSString stringWithFormat:@"注册时间：%@",[messageDic objectForKey:@"createTime"]];
    
    [self.phoneBtn addTarget:self action:@selector(CallAction) forControlEvents:UIControlEventTouchUpInside];
    [self.messageBtn addTarget:self action:@selector(meaageAction) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)meaageAction
{
    
    if (self.delegate) {
        [self.delegate senderMessageWithDic:self.messageDic];
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
