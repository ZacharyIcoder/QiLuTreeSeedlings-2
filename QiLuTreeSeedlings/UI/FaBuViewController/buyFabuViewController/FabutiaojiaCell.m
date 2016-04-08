//
//  FabutiaojiaCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/4/6.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "FabutiaojiaCell.h"
#import "UIDefines.h"
#import "PickerShowView.h"
@interface FabutiaojiaCell ()<UITextFieldDelegate,PickeShowDelegate>
@property (nonatomic,weak) UIButton *nowBtn;
@property (nonatomic,strong)PickerShowView *pickerView;
@end
@implementation FabutiaojiaCell

-(id)initWithFrame:(CGRect)frame AndModel:(TreeSpecificationsModel *)model andAnswer:(NSString *)answer
{
    self=[super initWithFrame:frame];
    if (self) {
        self.model=model;
        self.model.anwser=answer;
        self.answerAry=[[NSMutableArray alloc]initWithCapacity:2];
        int k=15;
        UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(k, 0, 110, 50)];
        [nameLab setFont:[UIFont systemFontOfSize:15]];
        [nameLab setTextColor:titleLabColor];
        nameLab.text=model.name;
        if (model.unit.length!=0) {
            nameLab.text=[NSString stringWithFormat:@"%@(%@)",model.name,model.unit];
        }
        //[nameLab sizeToFit];
        // NSLog(@"%@",model.unit);
        [self addSubview:nameLab];
        
        if (self.model.type==1) {
            if (self.model.dataType==3||self.model.dataType==2||self.model.dataType==1) {
                UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(125, 0, 150/320.f*kWidth, 50)];
                textField.placeholder=self.model.alert;
                if(self.model.alert.length==0)
                {
                    textField.placeholder=@"请输入信息";
                }
                [textField setFont:[UIFont systemFontOfSize:15]];
                textField.delegate=self;
                textField.tag=40001;
                textField.clearButtonMode=UITextFieldViewModeWhileEditing;
                [self addSubview:textField];
                UIImageView *linView=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.frame.size.height-0.5,self.frame.size.width-20, 0.5)];
                [self addSubview:linView];
                [linView setBackgroundColor:kLineColor];
                if (self.model.anwser.length>0) {
                    textField.text=self.model.anwser;
                }
            }
        }
        
        if (self.model.type==2) {
            if(self.model.optionType==1)
            {
                [self creatType2Option1];
            }
            if(self.model.optionType==2)
            {
                [self creatType2Option2];
            }
            if(self.model.optionType==3)
            {
                [self creatType2Option3];
            }
        }

    }
    return self;
}
-(void)creatType2Option3
{
    UIButton *pickBtn=[[UIButton alloc]initWithFrame:CGRectMake(80, 10, 130/320.f*kWidth, 30)];
    [self addSubview:pickBtn];
    [pickBtn addTarget:self action:@selector(pickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [pickBtn setTitle:@"请选择" forState:UIControlStateNormal];
    if(self.model.anwser.length>0)
    {
        [pickBtn setTitle:self.model.anwser forState:UIControlStateNormal];
    }
    [pickBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    self.nowBtn=pickBtn;
    [pickBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    PickerShowView *pickerView=[[PickerShowView alloc]initWithFrame:CGRectMake(0, kHeight-216, kWidth,216+44)];
    self.pickerView=pickerView;
    pickerView.delegate=self;
    [pickerView resetPickerData:self.model.optionList];
}
-(void)pickBtnAction:(UIButton *)sender
{
    [self.pickerView showInView];
    [[NSNotificationCenter  defaultCenter] postNotificationName:@"pickViewShowInView" object:nil];
}
-(void)creatType2Option2
{
    if(self.model.anwser.length>0)
    {
        self.answerAry=[NSMutableArray arrayWithArray:[self.model.anwser componentsSeparatedByString:@","]];
    }
    for (int i=0; i<self.model.optionList.count; i++){
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(95, 10+40*i, 90, 30)];
        [btn setTitle:self.model.optionList[i] forState:UIControlStateNormal];
        [btn setTitle:self.model.optionList[i] forState:UIControlStateSelected];
        for (int j=0; j<self.answerAry.count; j++) {
            if ([self.answerAry[j] isEqualToString:self.model.optionList[i]]) {
                btn.selected=YES;
            }
        }
        [btn setImage:[UIImage imageNamed:@"unselectBtnAction"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"selectBtnAction2"] forState:UIControlStateSelected];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -90, 0, 0);
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:NavColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(type2Option2Action:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=3000+i;
        [self addSubview:btn];
        
    }
    CGRect frame=self.frame;
    frame.size.height= 40*self.model.optionList.count+10;
    
    self.frame=frame;
    UIImageView *linView=[[UIImageView alloc]initWithFrame:CGRectMake(10, frame.size.height, frame.size.width-20, 0.5)];
    [self addSubview:linView];
    [linView setBackgroundColor:kLineColor];
}
-(void)type2Option2Action:(UIButton *)sender
{
    if (sender.selected) {
        [self.answerAry removeObject:sender.titleLabel.text];
    }else
    {
        [self.answerAry addObject:sender.titleLabel.text];
    }
    sender.selected=!sender.selected;
    [self jsonAnswerStr];
}

-(void)creatType2Option1
{
    
    for (int i=0; i<self.model.optionList.count; i++) {
        int k1=i%2;
        int k2=i/2;
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(95+k1*90, 10+40*k2, 90, 30)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn setTitle:self.model.optionList[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:NavColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(Type2Option1BtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=2000+i;
        [btn setImage:[UIImage imageNamed:@"unselectBtnAction"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"selectBtnAction2"] forState:UIControlStateSelected];
        if ([self.model.anwser isEqualToString:self.model.optionList[i]]) {
            btn.selected=YES;
            self.nowBtn=btn;
        }
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -90, 0, 0);
        
        [self addSubview:btn];
    }
    CGRect frame=self.frame;
    NSInteger k=self.model.optionList.count/2;
    if (self.model.optionList.count%2!=0) {
        k=k+1;
    }
    frame.size.height= 40*k+10;
    
    self.frame=frame;
    UIImageView *linView=[[UIImageView alloc]initWithFrame:CGRectMake(10, frame.size.height, frame.size.width-20, 0.5)];
    [self addSubview:linView];
    [linView setBackgroundColor:kLineColor];
}
-(void)Type2Option1BtnAction:(UIButton *)sender
{
    if (sender.selected) {
        sender.selected=NO;
        self.model.anwser=@"";
        return;
    }
    if (!sender.selected) {
        if (self.nowBtn) {
            self.nowBtn.selected=NO;
        }
        sender.selected=YES;
        self.nowBtn=sender;
        self.model.anwser=sender.titleLabel.text;
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag==40001) {
        self.model.anwser=textField.text;
    }
    
}
-(void)jsonAnswerStr
{
    NSMutableString *anserStr=[NSMutableString new];
    if (self.answerAry.count>=1) {
        [anserStr appendFormat:@"%@",self.answerAry[0]];
    }
    for (int i=1; i<self.answerAry.count; i++) {
        [anserStr appendFormat:@",%@",self.answerAry[i]];
    }
    self.model.anwser=anserStr;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
-(void)selectInfo:(NSString *)select
{
    //NSLog(@"%@",select);
    [self.nowBtn setTitle:select forState:UIControlStateNormal];
    self.model.anwser=select;
}
-(void)selectNum:(NSInteger)select
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
