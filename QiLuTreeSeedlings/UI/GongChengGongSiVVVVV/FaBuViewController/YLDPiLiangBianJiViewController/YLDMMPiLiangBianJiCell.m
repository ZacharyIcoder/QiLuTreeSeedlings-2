//
//  YLDMMPiLiangBianJiCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/22.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDMMPiLiangBianJiCell.h"
#import "UIDefines.h"


@implementation YLDMMPiLiangBianJiCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UITextField *nameTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 5, kWidth/2-45, 30)];
        nameTextField.tag=111;
        [nameTextField setFont:[UIFont systemFontOfSize:14]];
        nameTextField.placeholder=@"请输入苗木品种";
        nameTextField.borderStyle=UITextBorderStyleRoundedRect;
        nameTextField.textColor=NavColor;
        self.nameTextField=nameTextField;
        [self addSubview:nameTextField];
        
        UITextField *numTextField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth/2-25, 5, kWidth/2-45, 30)];
        numTextField.placeholder=@"请输入需求数量";
        numTextField.tag=112;
        [numTextField setFont:[UIFont systemFontOfSize:14]];
        numTextField.borderStyle=UITextBorderStyleRoundedRect;
        numTextField.textColor=NavYellowColor;
        numTextField.keyboardType=UIKeyboardTypeNumberPad;
        self.numTextField=numTextField;
        [self addSubview:numTextField];
        UITextField *shuomingTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 40, kWidth-80, 30)];
        shuomingTextField.placeholder=@"请输入苗木说明(100字以内)";
        shuomingTextField.borderStyle=UITextBorderStyleRoundedRect;
        shuomingTextField.textColor=DarkTitleColor;
        shuomingTextField.tag=113;
        self.shuomingTextField = shuomingTextField;
        [shuomingTextField setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:shuomingTextField];
        UIButton *deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, 5, 55, 65)];
        self.deleteBtn=deleteBtn;
        [deleteBtn setImage:[UIImage imageNamed:@"deleteRad"] forState:UIControlStateNormal];
        [self addSubview:deleteBtn];
        [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)deleteBtnAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(deleteWithSelf:andRow:andDic:)]) {
        [self.delegate deleteWithSelf:self andRow:sender.tag andDic:self.messageDic];
    }
}
-(void)setMessageDic:(NSMutableDictionary *)messageDic{
    _messageDic=messageDic;
    self.nameTextField.text=messageDic[@"name"];
    self.numTextField.text=[NSString stringWithFormat:@"%@",messageDic[@"quantity"]];
    NSString *shuomingStr=messageDic[@"description"];
    if (shuomingStr.length>0) {
        self.shuomingTextField.text=shuomingStr;
    }
}
-(BOOL)checkChangeMessage
{
    NSString *nameStr=self.nameTextField.text;
    NSString *numStr=self.numTextField.text;
    if (nameStr.length<=0) {
        [ToastView showTopToast:@"请输入苗木品种"];
        return NO;
    }
    if (numStr.length<=0) {
        [ToastView showTopToast:@"请输入需求数量"];
        return NO;
    }
    return YES;
}
-(void)getChangeMessage
{
//    NSMutableDictionary *dic=[NSMutableDictionary new];
    NSString *nameStr=self.nameTextField.text;
    NSString *numStr=self.numTextField.text;
    if (nameStr.length>0) {
       self.messageDic[@"name"]=nameStr;
    }
    if (numStr.length>0) {
        self.messageDic[@"quantity"]=numStr;
    }
    if (self.shuomingTextField.text.length>0) {
        self.messageDic[@"description"]=self.shuomingTextField.text;
    }else{
        [self.messageDic removeObjectForKey:@"description"];
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
