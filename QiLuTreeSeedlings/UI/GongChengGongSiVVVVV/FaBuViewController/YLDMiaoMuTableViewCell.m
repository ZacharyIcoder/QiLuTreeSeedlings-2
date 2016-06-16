//
//  YLDMiaoMuTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/16.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDMiaoMuTableViewCell.h"
#import "UIDefines.h"
@interface YLDMiaoMuTableViewCell ()
@property (nonatomic,weak)UITextField *nameField;
@property (nonatomic,weak)UITextField *numField;
@property (nonatomic,weak)UITextField *jianjieField;
@end
@implementation YLDMiaoMuTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame=CGRectMake(0, 0, kWidth, 80);
        [self setBackgroundColor:[UIColor whiteColor]];
        UITextField *nameTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 5, kWidth/2-45, 30)];
        nameTextField.tag=111;
        self.nameField=nameTextField;
        [nameTextField setFont:[UIFont systemFontOfSize:14]];
        nameTextField.placeholder=@"请输入苗木品种";
        nameTextField.borderStyle=UITextBorderStyleRoundedRect;
        nameTextField.textColor=NavColor;
        [self addSubview:nameTextField];
        nameTextField.enabled=NO;
        UITextField *numTextField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth/2-25, 5, kWidth/2-45, 30)];
        numTextField.placeholder=@"请输入需求数量";
        numTextField.tag=112;
        self.numField=numTextField;
        [numTextField setFont:[UIFont systemFontOfSize:14]];
        numTextField.borderStyle=UITextBorderStyleRoundedRect;
        numTextField.textColor=NavYellowColor;
        numTextField.keyboardType=UIKeyboardTypeNumberPad;
        [self addSubview:numTextField];
        numTextField.enabled=NO;
        UITextField *shuomingTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 40, kWidth-80, 30)];
        shuomingTextField.placeholder=@"请输入需求数量";
        shuomingTextField.borderStyle=UITextBorderStyleRoundedRect;
        shuomingTextField.textColor=DarkTitleColor;
        shuomingTextField.tag=113;
         self.jianjieField=shuomingTextField;
        [shuomingTextField setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:shuomingTextField];
        shuomingTextField.enabled=NO;
//        UIButton *addBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, 5, 55, 65)];
//        [addBtn setImage:[UIImage imageNamed:@"addView"] forState:UIControlStateNormal];
//        [self addSubview:addBtn];
//        [addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
       
        UIImageView *lineImagV=[[UIImageView alloc]initWithFrame:CGRectMake(10,80-0.5, kWidth-20, 0.5)];
        [lineImagV setBackgroundColor:kLineColor];
        
        [self addSubview:lineImagV];
 
    }
    return self;
    
}
-(void)setMessageDic:(NSDictionary *)messageDic
{
    _messageDic=messageDic;
    self.nameField.text=messageDic[@"name"];
    self.numField.text=messageDic[@"quantity"];
    self.jianjieField.text=messageDic[@"decription"];
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
