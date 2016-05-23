//
//  GuiGeCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "GuiGeCell.h"
#import "UIDefines.h"
#import "PickerShowView.h"
@interface GuiGeCell ()<UITextFieldDelegate,PickeShowDelegate>

@property (nonatomic,strong)UITextField *oneTextField;
@property (nonatomic,strong)UITextField *minTextField;
@property (nonatomic,strong)UITextField *maxTextField;
@property (nonatomic,strong)PickerShowView *pickerView;
@property (nonatomic,weak)UIButton *nowBtn;
@end
@implementation GuiGeCell
-(id)initWithFrame:(CGRect)frame andModel:(GuiGeModel *)model
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.answerAry=[NSMutableArray array];
        self.answerAry2=[NSMutableArray array];
        CGFloat  boundsW=kWidth;
        self.model=model;
        self.answerAry=[NSMutableArray array];
        UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 44)];
        [nameLab setFont:[UIFont systemFontOfSize:15]];
        [nameLab setTextColor:titleLabColor];
        [self addSubview:nameLab];
        [nameLab setText:model.name];
        if ([model.type isEqualToString:@"文本"]) {
            Propers *propers=[model.propertyLists firstObject];
            if (propers.unit) {
                UILabel *unitLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-60, 0, 50, 44)];
                [unitLab setFont:[UIFont systemFontOfSize:15]];
                [unitLab setTextColor:titleLabColor];
                [self addSubview:unitLab];
                unitLab.text=propers.unit;
            }
            if (propers.range) {
                self.model.keyStr2=[NSString stringWithFormat:@"spec_min_%@",self.model.uid];
                self.model.keyStr3=[NSString stringWithFormat:@"spec_max_%@",self.model.uid];
                [self.answerAry addObjectsFromArray:@[@"",@""]];
                UITextField *minTextField=[[UITextField alloc]initWithFrame:CGRectMake(boundsW/2-80/320.f*boundsW, 0, 70/320.f*boundsW, 44)];
                self.minTextField=minTextField;
                minTextField.tag=111;
                minTextField.delegate=self;
                [self addSubview:minTextField];
                UIView *lineV1=[[UIView alloc]initWithFrame:CGRectMake(boundsW/2-7.5, 22, 15, 0.5)];
                [lineV1 setBackgroundColor:[UIColor blackColor]];
                [self addSubview:lineV1];
                UITextField *maxTextField=[[UITextField alloc]initWithFrame:CGRectMake(boundsW/2+10/320.f*boundsW, 0, 70/320.f*boundsW, 44)];
                maxTextField.delegate=self;
                maxTextField.tag=112;
                [self addSubview:maxTextField];
                self.maxTextField=maxTextField;
                if (propers.number) {
                    if ([propers.numberType isEqualToString:@"float"]) {
                        minTextField.keyboardType=UIKeyboardTypeDecimalPad;
                        maxTextField.keyboardType=UIKeyboardTypeDecimalPad;
                    }
                    if ([propers.numberType isEqualToString:@"int"]){
                        minTextField.keyboardType=UIKeyboardTypeNumberPad;
                        maxTextField.keyboardType=UIKeyboardTypeNumberPad;
                    }
                }
            }else
            {
                [self.answerAry addObjectsFromArray:@[@""]];
                self.model.keyStr2=[NSString stringWithFormat:@"spec_like_%@",self.model.uid];
                UITextField *oneTextField=[[UITextField alloc]initWithFrame:CGRectMake(80/320.f*boundsW, 0, 180/320.f*boundsW, 44)];
                oneTextField.tag=113;
                oneTextField.placeholder=model.alert;
                oneTextField.delegate=self;
                self.oneTextField=oneTextField;
                [self addSubview:oneTextField];
                if ([propers.numberType isEqualToString:@"float"]) {
                      self.model.keyStr2=[NSString stringWithFormat:@"spec_number_%@",self.model.uid];
                    oneTextField.keyboardType=UIKeyboardTypeDecimalPad;
                }
                if ([propers.numberType isEqualToString:@"int"]) {
                     self.model.keyStr2=[NSString stringWithFormat:@"spec_number_%@",self.model.uid];
                    oneTextField.keyboardType=UIKeyboardTypeNumberPad;
                }
            }
        }//文本编辑结束
        
        if ([model.type isEqualToString:@"复选"]) {
//
             self.model.keyStr1=[NSString stringWithFormat:@"spec_like_%@",self.model.uid];
            Propers *propers=[model.propertyLists firstObject];
            NSArray *valueAry=[propers.value componentsSeparatedByString:@"，"];
            for (int i=0; i<valueAry.count; i++) {
                UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(95, 10+40*i, 90, 28)];
                [btn setTitle:valueAry[i] forState:UIControlStateNormal];
                [btn setTitle:valueAry[i] forState:UIControlStateSelected];
//                for (int j=0; j<self.answerAry.count; j++) {
//                    if ([self.answerAry[j] isEqualToString:self.model.optionList[i]]) {
//                        btn.selected=YES;
//                    }
//                }
                [btn setBackgroundImage:[UIImage imageNamed:@"unselectBtnAction"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"selectBtnAction2"] forState:UIControlStateSelected];
                //btn.titleEdgeInsets = UIEdgeInsetsMake(0, -90, 0, 0);
                [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [btn setTitleColor:NavColor forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(fuxuanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag=3000+i;
                [self addSubview:btn];

            }
            CGRect frame=self.frame;
            frame.size.height=20+40*valueAry.count;
            self.frame=frame;
        }//复选结束
        
        if([model.type isEqualToString:@"单选结合"])
        {
            [self.answerAry addObjectsFromArray:@[@""]];
            self.model.keyStr1=[NSString stringWithFormat:@"spec_select_%@",self.model.uid];
            UIButton *pickBtn=[[UIButton alloc]initWithFrame:CGRectMake(80, 10, 130/320.f*kWidth, 30)];
            [self addSubview:pickBtn];
            [pickBtn addTarget:self action:@selector(pickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [pickBtn setTitle:@"请选择" forState:UIControlStateNormal];
//            if(self.model.anwser.length>0)
//            {
//                [pickBtn setTitle:self.model.anwser forState:UIControlStateNormal];
//            }
            [pickBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
            self.nowBtn=pickBtn;
            [pickBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            PickerShowView *pickerView=[[PickerShowView alloc]initWithFrame:CGRectMake(0, kHeight-216, kWidth,216+44)];
            self.pickerView=pickerView;
            pickerView.delegate=self;
            NSMutableArray *dataxxAry=[NSMutableArray array];
            for (int i=0; i<model.propertyLists.count; i++) {
                Propers *propers=model.propertyLists[i];
                [dataxxAry addObject:propers.value];
            }
            [pickerView resetPickerData:dataxxAry];
        }//单选结合结束
        
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(15, self.frame.size.height-0.5, kWidth-30, 0.5)];
        [lineView setBackgroundColor:kLineColor];
        [self addSubview:lineView];
    }
    return self;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag==111) {
        //[self.answerAry insertObject:textField.text atIndex:0];
        [self.answerAry replaceObjectAtIndex:0 withObject:textField.text];
        if (self.maxTextField.text.length==0) {
            self.maxTextField.text=textField.text;
             [self.answerAry replaceObjectAtIndex:1 withObject:textField.text];
//            [self.answerAry insertObject:textField.text atIndex:1];
        }
    }
    if (textField.tag==112) {
//        [self.answerAry insertObject:textField.text atIndex:1];
        [self.answerAry replaceObjectAtIndex:1 withObject:textField.text];
        if (self.minTextField.text.length==0) {
            self.minTextField.text=textField.text;
             [self.answerAry replaceObjectAtIndex:0 withObject:textField.text];
           //[self.answerAry insertObject:textField.text atIndex:0];
        }
    }
    if (textField.tag==113) {
//       [self.answerAry insertObject:textField.text atIndex:0];
        [self.answerAry replaceObjectAtIndex:0 withObject:textField.text];
    }
    if (textField.tag==121) {
         [self.answerAry2 replaceObjectAtIndex:0 withObject:textField.text];
        UITextField *maxTextField=[self.erjiView viewWithTag:122];
        if (maxTextField.text.length==0) {
            maxTextField.text=textField.text;
//            [self.answerAry2 insertObject:textField.text atIndex:1];
            [self.answerAry2 replaceObjectAtIndex:1 withObject:textField.text];
        }
    }
    if (textField.tag==122) {
//        [self.answerAry2 insertObject:textField.text atIndex:1];
         [self.answerAry2 replaceObjectAtIndex:1 withObject:textField.text];
        UITextField *minTextField=[self.erjiView viewWithTag:121];
        if (minTextField.text.length==0) {
           minTextField.text=textField.text;
//            [self.answerAry2 insertObject:textField.text atIndex:0];
             [self.answerAry2 replaceObjectAtIndex:0 withObject:textField.text];
        }
    }
    if (textField.tag==123) {
//        [self.answerAry2 insertObject:textField.text atIndex:0];
         [self.answerAry2 replaceObjectAtIndex:0 withObject:textField.text];
    }
    return YES;
}
-(void)pickBtnAction:(UIButton *)sender
{
    [self.pickerView showInView];
}
-(void)fuxuanBtnAction:(UIButton *)sender
{
    if (sender.selected) {
        sender.selected=NO;
        [self.answerAry removeObject:sender.titleLabel.text];
    }else{
        sender.selected=YES;
        [self.answerAry addObject:sender.titleLabel.text];
    }
    
}
-(void)selectNum:(NSInteger)select
{
    Propers *procprs=self.model.propertyLists[select];
    [self.answerAry2 removeAllObjects];
    self.model.keyStr2=@"";
    self.model.keyStr3=@"";
    self.model.sonModel=nil;
    self.model.selectProper=nil;
    if (procprs.operation) {
         self.model.selectProper=procprs;
        CGRect frame=self.frame;
        frame.size.height=88;
        self.frame=frame;
        if(self.erjiView)
        {
            [self.erjiView removeFromSuperview];
            self.erjiView=nil;
        }
        if (procprs.relation.length>0) {
//            self.model.sonModel=procprs.guanlianModel;
           
         GuiGeCell *cell=[[GuiGeCell alloc]initWithFrame:CGRectMake(0, 44, kWidth, 44) andModel:procprs.guanlianModel];
             self.erjiView=cell;
            [self addSubview:cell];
          
        }else{
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 44, kWidth, 44)];
            [self addSubview:view];
            self.erjiView=view;
            if (procprs.unit) {
                UILabel *unitLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-60, 0, 50, 44)];
                [unitLab setFont:[UIFont systemFontOfSize:15]];
                [unitLab setTextColor:titleLabColor];
                [view addSubview:unitLab];
                unitLab.text=procprs.unit;
            }
            if (procprs.range) {
                [self.answerAry2 addObjectsFromArray:@[@"",@""]];
                UITextField *minTextField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth/2-80/320.f*kWidth, 0, 70/320.f*kWidth, 44)];
                self.model.keyStr2=[NSString stringWithFormat:@"spec_min_%@_%@",[self.answerAry firstObject],self.model.uid];
                self.model.keyStr3=[NSString stringWithFormat:@"spec_max_%@_%@",[self.answerAry firstObject],self.model.uid];
                self.minTextField=minTextField;
                minTextField.tag=121;
                minTextField.delegate=self;
                [view  addSubview:minTextField];
                UIView *lineV1=[[UIView alloc]initWithFrame:CGRectMake(kWidth/2-7.5, 22, 15, 0.5)];
                [lineV1 setBackgroundColor:[UIColor blackColor]];
                [view addSubview:lineV1];
                UITextField *maxTextField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth/2+10/320.f*kWidth, 0, 70/320.f*kWidth, 44)];
                maxTextField.delegate=self;
                maxTextField.tag=122;
                [view addSubview:maxTextField];
                self.maxTextField=maxTextField;
                if (procprs.number) {
                    if ([procprs.numberType isEqualToString:@"float"]) {
                        minTextField.keyboardType=UIKeyboardTypeDecimalPad;
                        maxTextField.keyboardType=UIKeyboardTypeDecimalPad;
                    }
                    if ([procprs.numberType isEqualToString:@"int"]){
                        minTextField.keyboardType=UIKeyboardTypeNumberPad;
                        maxTextField.keyboardType=UIKeyboardTypeNumberPad;
                    }
                }
            }else
            {
                [self.answerAry2 addObjectsFromArray:@[@""]];
                self.model.keyStr2=[NSString stringWithFormat:@"spec_like_%@_%@",[self.answerAry firstObject],self.model.uid];
                UITextField *oneTextField=[[UITextField alloc]initWithFrame:CGRectMake(80/320.f*kWidth, 0, 180/320.f*kWidth, 44)];
                oneTextField.tag=123;
                oneTextField.delegate=self;
                self.oneTextField=oneTextField;
                [view addSubview:oneTextField];
                if ([procprs.numberType isEqualToString:@"float"]) {
                    self.model.keyStr2=[NSString stringWithFormat:@"spec_number_%@_%@",[self.answerAry firstObject],self.model.uid];
                    oneTextField.keyboardType=UIKeyboardTypeDecimalPad;
                }
                if ([procprs.numberType isEqualToString:@"int"]){
                    self.model.keyStr2=[NSString stringWithFormat:@"spec_number_%@_%@",[self.answerAry firstObject],self.model.uid];
                    oneTextField.keyboardType=UIKeyboardTypeNumberPad;
                }
            }

      }
    }else
    {
        if(self.erjiView)
        {
            CGRect frame=self.frame;
            frame.size.height=44;
            self.frame=frame;
            [self.erjiView removeFromSuperview];
            self.erjiView=nil;
        }

    }
    if (self.delegate) {
        [self.delegate reloadView];
    }
}
-(void)selectInfo:(NSString *)select
{
//    [self.answerAry insertObject:select atIndex:0];
     [self.answerAry replaceObjectAtIndex:0 withObject:select];
    self.model.answer=select;
    [self.nowBtn setTitle:select forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
