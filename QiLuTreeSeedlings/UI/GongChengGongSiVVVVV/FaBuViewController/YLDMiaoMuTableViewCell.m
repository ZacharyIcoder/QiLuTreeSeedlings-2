//
//  YLDMiaoMuTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/16.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDMiaoMuTableViewCell.h"
#import "UIDefines.h"
#import "BWTextView.h"
@interface YLDMiaoMuTableViewCell ()
@property (nonatomic,weak)UITextField *nameField;
@property (nonatomic,weak)UITextField *numField;
@property (nonatomic,weak)BWTextView *jianjieField;
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
        //nameTextField.enabled=NO;
        UITextField *numTextField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth/2-25, 5, kWidth/2-45, 30)];
        numTextField.placeholder=@"请输入需求数量";
        numTextField.tag=112;
        self.numField=numTextField;
        [numTextField setFont:[UIFont systemFontOfSize:14]];
        numTextField.borderStyle=UITextBorderStyleRoundedRect;
        numTextField.textColor=NavYellowColor;
        numTextField.keyboardType=UIKeyboardTypeNumberPad;
        [self addSubview:numTextField];
        //numTextField.enabled=NO;
        BWTextView *shuomingTextView=[[BWTextView alloc]initWithFrame:CGRectMake(10, 40, kWidth-80, 30)];
        shuomingTextView.placeholder=@"请输入规格要求(100字以内)";
//        shuomingTextField.borderStyle=UITextBorderStyleRoundedRect;
        shuomingTextView.textColor=DarkTitleColor;
        shuomingTextView.tag=113;
         self.jianjieField=shuomingTextView;
        [shuomingTextView setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:shuomingTextView];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewChanged:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:shuomingTextView];
        shuomingTextView.layer.masksToBounds=YES;
        shuomingTextView.layer.cornerRadius=4;
        shuomingTextView.layer.borderColor=kLineColor.CGColor;
        shuomingTextView.layer.borderWidth=1;
        shuomingTextView.textColor=DarkTitleColor;

        //shuomingTextField.enabled=NO;
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

-(void)textViewChanged:(id)my {

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
