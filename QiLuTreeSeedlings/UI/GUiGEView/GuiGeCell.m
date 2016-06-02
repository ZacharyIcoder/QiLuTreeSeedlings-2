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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(id)initWithFrame:(CGRect)frame andModel:(GuiGeModel *)model
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.answerAry=[NSMutableArray array];
        self.answerAry2=[NSMutableArray array];
        //CGFloat  boundsW=kWidth;
        self.model=model;
        self.answerAry=[NSMutableArray array];
        
        UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 90, 44)];
        [nameLab setFont:[UIFont systemFontOfSize:14]];
        [nameLab setTextColor:titleLabColor];
        [self addSubview:nameLab];
        [nameLab setText:model.name];
        if ([model.type isEqualToString:@"文本"]) {
            Propers *propers=[model.propertyLists firstObject];
            if (propers.unit) {
                UILabel *unitLab=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-60, 0, 50, 44)];
                [unitLab setFont:[UIFont systemFontOfSize:14]];
                [unitLab setTextAlignment:NSTextAlignmentCenter];
                [unitLab setTextColor:titleLabColor];
                [self addSubview:unitLab];
                unitLab.text=propers.unit;
            }
            if (propers.range) {
                self.model.keyStr2=[NSString stringWithFormat:@"spec_min_%@",self.model.uid];
                self.model.keyStr3=[NSString stringWithFormat:@"spec_max_%@",self.model.uid];
                [self.answerAry addObjectsFromArray:@[@"",@""]];
                UITextField *minTextField=[[UITextField alloc]initWithFrame:CGRectMake(self.frame.size.width/2-70/320.f*self.frame.size.width+10, 0, 60/320.f*self.frame.size.width, 44)];
                 [minTextField setFont:[UIFont systemFontOfSize:14]];
                minTextField.placeholder=@"最小值";
                self.minTextField=minTextField;
                minTextField.tag=111;
                minTextField.clearsOnBeginEditing=YES;
                minTextField.delegate=self;
                minTextField.textAlignment = NSTextAlignmentRight;
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldChanged:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:minTextField];
                [self addSubview:minTextField];
                UIView *lineV1=[[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-7.5+10, 22, 15, 0.5)];
                [lineV1 setBackgroundColor:[UIColor blackColor]];
                [self addSubview:lineV1];
                UITextField *maxTextField=[[UITextField alloc]initWithFrame:CGRectMake(self.frame.size.width/2+10/320.f*self.frame.size.width+10, 0, 60/320.f*self.frame.size.width, 44)];
                [maxTextField setFont:[UIFont systemFontOfSize:14]];
                maxTextField.placeholder=@"最大值";
                maxTextField.delegate=self;
                maxTextField.tag=112;
                maxTextField.clearsOnBeginEditing=YES;
                [self addSubview:maxTextField];
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldChanged:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:maxTextField];
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
                UITextField *oneTextField=[[UITextField alloc]initWithFrame:CGRectMake(110/320.f*self.frame.size.width, 0, 200/320.f*self.frame.size.width, 44)];
                [oneTextField setFont:[UIFont systemFontOfSize:14]];
                oneTextField.tag=113;
                oneTextField.placeholder=model.alert;
                oneTextField.delegate=self;
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldChanged:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:oneTextField];
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
                UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(115, 10+40*i, 90, 28)];
                [btn setTitle:valueAry[i] forState:UIControlStateNormal];
                [btn setTitle:valueAry[i] forState:UIControlStateSelected];
                [btn setBackgroundImage:[UIImage imageNamed:@"unselectBtnAction"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"selectBtnAction2"] forState:UIControlStateSelected];
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
            UIButton *pickBtn=[[UIButton alloc]initWithFrame:CGRectMake(100, 7, 150/320.f*self.frame.size.width, 30)];
            [pickBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [self addSubview:pickBtn];
            [pickBtn addTarget:self action:@selector(pickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [pickBtn setTitle:[NSString stringWithFormat:@"请选择%@",self.model.name] forState:UIControlStateNormal];
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
            if (model.main) {
                [pickerView.delegate selectNum:0];
               [pickerView.delegate selectInfo:[dataxxAry firstObject]];
            }
        }//单选结合结束
        
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(15, self.frame.size.height-0.5, self.frame.size.width-30, 0.5)];
        [lineView setBackgroundColor:kLineColor];
        [self addSubview:lineView];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame andValueModel:(GuiGeModel *)model{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.answerAry=[NSMutableArray array];
        self.answerAry2=[NSMutableArray array];
        CGFloat  boundsW=self.frame.size.width;
        self.model=model;
        self.answerAry=[NSMutableArray array];
        UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 44)];
        [nameLab setFont:[UIFont systemFontOfSize:14]];
        [nameLab setTextColor:titleLabColor];
        [self addSubview:nameLab];
        [nameLab setText:model.name];
        if ([model.type isEqualToString:@"文本"]) {
            Propers *propers=[model.propertyLists firstObject];
            if (propers.unit) {
                UILabel *unitLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-60, 0, 50, 44)];
                [unitLab setTextAlignment:NSTextAlignmentCenter];
                [unitLab setFont:[UIFont systemFontOfSize:14]];
                [unitLab setTextColor:titleLabColor];
                [self addSubview:unitLab];
                unitLab.text=propers.unit;
            }
            if (propers.range) {
                self.model.keyStr2=[NSString stringWithFormat:@"spec_min_%@",self.model.uid];
                self.model.keyStr3=[NSString stringWithFormat:@"spec_max_%@",self.model.uid];
                [self.answerAry addObjectsFromArray:@[@"",@""]];
                UITextField *minTextField=[[UITextField alloc]initWithFrame:CGRectMake(boundsW/2-70/320.f*boundsW+10, 0, 60/320.f*boundsW, 44)];
                 [minTextField setFont:[UIFont systemFontOfSize:14]];
                minTextField.placeholder=@"最小值";
                self.minTextField=minTextField;
                minTextField.tag=111;
                minTextField.delegate=self;
                minTextField.clearsOnBeginEditing=YES;
                 minTextField.textAlignment = NSTextAlignmentRight;
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldChanged:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:minTextField];
                [self addSubview:minTextField];
                UIView *lineV1=[[UIView alloc]initWithFrame:CGRectMake(boundsW/2-7.5+10, 22, 15, 0.5)];
                [lineV1 setBackgroundColor:[UIColor blackColor]];
                [self addSubview:lineV1];
                UITextField *maxTextField=[[UITextField alloc]initWithFrame:CGRectMake(boundsW/2+10/320.f*boundsW+10, 0, 60/320.f*boundsW, 44)];
                 [maxTextField setFont:[UIFont systemFontOfSize:14]];
                maxTextField.placeholder=@"最大值";
                maxTextField.delegate=self;
                maxTextField.tag=112;
                maxTextField.clearsOnBeginEditing=YES;
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldChanged:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:maxTextField];
                [self addSubview:maxTextField];
                self.maxTextField=maxTextField;
                if (model.values.count>0) {
                    self.answerAry =[NSMutableArray arrayWithArray:model.values];
                    minTextField.text=[model.values firstObject];
                    maxTextField.text=[model.values lastObject];
                }
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
                UITextField *oneTextField=[[UITextField alloc]initWithFrame:CGRectMake(110/320.f*boundsW, 0, 180/320.f*boundsW, 44)];
                [oneTextField setFont:[UIFont systemFontOfSize:14]];
                oneTextField.tag=113;
                oneTextField.placeholder=model.alert;
                oneTextField.delegate=self;
                self.oneTextField=oneTextField;
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldChanged:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:oneTextField];
                [self addSubview:oneTextField];
                if (model.values.count>0) {
                    self.answerAry =[NSMutableArray arrayWithArray:model.values];
                    oneTextField.text=[model.values firstObject];
                   
                }
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
                UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(115, 10+40*i, 90, 28)];
                NSString *nameStr=valueAry[i];
                [btn setTitle:nameStr forState:UIControlStateNormal];
                [btn setTitle:nameStr forState:UIControlStateSelected];
                [btn setBackgroundImage:[UIImage imageNamed:@"unselectBtnAction"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"selectBtnAction2"] forState:UIControlStateSelected];
                //btn.titleEdgeInsets = UIEdgeInsetsMake(0, -90, 0, 0);
                [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [btn setTitleColor:NavColor forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(fuxuanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag=3000+i;
                [self addSubview:btn];
                for (int j=0; j<model.values.count; j++) {
                    NSString *namestr2=model.values[j];
                    if ([namestr2 isEqualToString:nameStr]) {
                        btn.selected=YES;
                        [self.answerAry addObject:nameStr];
                    }
                }
                
            }
            CGRect frame=self.frame;
            frame.size.height=20+40*valueAry.count;
            self.frame=frame;
        }//复选结束
        
        if([model.type isEqualToString:@"单选结合"])
        {
            [self.answerAry addObjectsFromArray:@[@""]];
            self.model.keyStr1=[NSString stringWithFormat:@"spec_select_%@",self.model.uid];
            UIButton *pickBtn=[[UIButton alloc]initWithFrame:CGRectMake(100, 7, 150/320.f*kWidth, 30)];
            [pickBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [self addSubview:pickBtn];
            [pickBtn addTarget:self action:@selector(pickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [pickBtn setTitle:[NSString stringWithFormat:@"请选择%@",self.model.name] forState:UIControlStateNormal];
            [pickBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
            self.nowBtn=pickBtn;
            if (self.model.values.count>0) {
                self.answerAry =[NSMutableArray arrayWithObject:[self.model.values firstObject]];
                [pickBtn setTitle:[self.model.values firstObject] forState:UIControlStateNormal];
                for (int i=0; i<model.propertyLists.count; i++) {
                    Propers *propers=model.propertyLists[i];
                    if ([[self.model.values firstObject] isEqualToString:propers.value]) {
                        self.model.selectProper=propers;
                        break;
                    }
                    //[dataxxAry addObject:propers.value];
                }
                if (self.model.selectProper.operation) {
                    //self.model.selectProper=procprs;
                    CGRect frame=self.frame;
                    frame.size.height=88;
                    self.frame=frame;
                    if(self.erjiView)
                    {
                        [self.erjiView removeFromSuperview];
                        self.erjiView=nil;
                    }
                    if (self.model.selectProper.relation.length>0) {
                        
                        GuiGeCell *cell=[[GuiGeCell alloc]initWithFrame:CGRectMake(0, 44, kWidth, 44) andValueModel:self.model.selectProper.guanlianModel];
                        self.erjiView=cell;
                        [self addSubview:cell];
                        
                    }else{
                        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 44, kWidth, 44)];
                        [self addSubview:view];
                        self.erjiView=view;
                        if (self.model.selectProper.unit) {
                            UILabel *unitLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-60, 0, 50, 44)];
                            [unitLab setTextAlignment:NSTextAlignmentCenter];
                            [unitLab setFont:[UIFont systemFontOfSize:14]];
                            [unitLab setTextColor:titleLabColor];
                            [view addSubview:unitLab];
                            unitLab.text=self.model.selectProper.unit;
                        }
                        if (self.model.selectProper.range) {
                            [self.answerAry2 addObjectsFromArray:@[@"",@""]];
                            UITextField *minTextField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth/2-70/320.f*kWidth+10, 0, 60/320.f*kWidth, 44)];
                             [minTextField setFont:[UIFont systemFontOfSize:14]];
                             minTextField.placeholder=@"最小值";
                            minTextField.clearsOnBeginEditing=YES;
                            minTextField.textAlignment = NSTextAlignmentRight;
                            self.model.keyStr2=[NSString stringWithFormat:@"spec_min_%@_%@",[self.answerAry firstObject],self.model.uid];
                            self.model.keyStr3=[NSString stringWithFormat:@"spec_max_%@_%@",[self.answerAry firstObject],self.model.uid];
                            self.minTextField=minTextField;
                            minTextField.tag=121;
                            minTextField.textAlignment = NSTextAlignmentRight;
                            minTextField.delegate=self;
                            [[NSNotificationCenter defaultCenter] addObserver:self
                                                                     selector:@selector(textFieldChanged:)
                                                                         name:UITextFieldTextDidChangeNotification
                                                                       object:minTextField];
                            [view  addSubview:minTextField];
                            UIView *lineV1=[[UIView alloc]initWithFrame:CGRectMake(kWidth/2-7.5+10, 22, 15, 0.5)];
                            [lineV1 setBackgroundColor:[UIColor blackColor]];
                            [view addSubview:lineV1];
                            UITextField *maxTextField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth/2+10/320.f*kWidth+10, 0, 60/320.f*kWidth, 44)];
                            [maxTextField setFont:[UIFont systemFontOfSize:14]];
                            maxTextField.placeholder=@"最大值";
                            maxTextField.delegate=self;
                            maxTextField.tag=122;
                            maxTextField.clearsOnBeginEditing=YES;
                            [[NSNotificationCenter defaultCenter] addObserver:self
                                                                     selector:@selector(textFieldChanged:)
                                                                         name:UITextFieldTextDidChangeNotification
                                                                       object:maxTextField];
                            [view addSubview:maxTextField];
                            self.maxTextField=maxTextField;
                            if (self.model.values.count==3) {
                                self.answerAry2=[NSMutableArray arrayWithObjects:self.model.values[1],self.model.values[2], nil];
                                minTextField.text=self.model.values[1];
                                maxTextField.text=self.model.values[2];
                            }
                            if (self.model.selectProper.number) {
                                if ([self.model.selectProper.numberType isEqualToString:@"float"]) {
                                    minTextField.keyboardType=UIKeyboardTypeDecimalPad;
                                    maxTextField.keyboardType=UIKeyboardTypeDecimalPad;
                                }
                                if ([self.model.selectProper.numberType isEqualToString:@"int"]){
                                    minTextField.keyboardType=UIKeyboardTypeNumberPad;
                                    maxTextField.keyboardType=UIKeyboardTypeNumberPad;
                                }
                            }
                        }else
                        {
                            [self.answerAry2 addObjectsFromArray:@[@""]];
                            self.model.keyStr2=[NSString stringWithFormat:@"spec_like_%@_%@",[self.answerAry firstObject],self.model.uid];
                            UITextField *oneTextField=[[UITextField alloc]initWithFrame:CGRectMake(110/320.f*self.frame.size.width, 0, 180/320.f*self.frame.size.width, 44)];
                            [oneTextField setFont:[UIFont systemFontOfSize:14]];
                            oneTextField.tag=123;
                            oneTextField.delegate=self;
                            self.oneTextField=oneTextField;
                            [view addSubview:oneTextField];
                            [[NSNotificationCenter defaultCenter] addObserver:self
                                                                     selector:@selector(textFieldChanged:)
                                                                         name:UITextFieldTextDidChangeNotification
                                                                       object:oneTextField];
                            if ([self.model.selectProper.numberType isEqualToString:@"float"]) {
                                self.model.keyStr2=[NSString stringWithFormat:@"spec_number_%@_%@",[self.answerAry firstObject],self.model.uid];
                                oneTextField.keyboardType=UIKeyboardTypeDecimalPad;
                            }
                            if (self.model.values.count==2) {
                                self.answerAry2=[NSMutableArray arrayWithObjects:self.model.values[1],self.model.values[2], nil];
                                oneTextField.text=self.model.values[1];
                                
                            }
                            if ([self.model.selectProper.numberType isEqualToString:@"int"]){
                                self.model.keyStr2=[NSString stringWithFormat:@"spec_number_%@_%@",[self.answerAry firstObject],self.model.uid];
                                oneTextField.keyboardType=UIKeyboardTypeNumberPad;
                            }
                        }
                        
                    }
                }

            }

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
        
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(15, self.frame.size.height-0.5, self.frame.size.width-30, 0.5)];
        [lineView setBackgroundColor:kLineColor];
        [self addSubview:lineView];
    }
    return self;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.delegate) {
        [self.delegate actionTextField:textField];
    }
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
    if (self.delegate) {
        [self.delegate dianxuanAction];
    }
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

        if(self.erjiView)
        {
            [self.erjiView removeFromSuperview];
            self.erjiView=nil;
        }
        if (procprs.relation.length>0) {
         GuiGeCell *cell=[[GuiGeCell alloc]initWithFrame:CGRectMake(0, 45, self.frame.size.width, 44) andModel:procprs.guanlianModel];
             self.erjiView=cell;
            [self addSubview:cell];
          
        }else{
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 45, self.frame.size.width, 44)];
            [self addSubview:view];
            self.erjiView=view;
            if (procprs.unit) {
                UILabel *unitLab=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-60, 0, 50, 44)];
                [unitLab setTextAlignment:NSTextAlignmentCenter];
                [unitLab setFont:[UIFont systemFontOfSize:14]];
                [unitLab setTextColor:titleLabColor];
                [view addSubview:unitLab];
                unitLab.text=procprs.unit;
            }
            if (procprs.range) {
                [self.answerAry2 addObjectsFromArray:@[@"",@""]];
                UITextField *minTextField=[[UITextField alloc]initWithFrame:CGRectMake(self.frame.size.width/2-70/320.f*self.frame.size.width+10, 0, 60/320.f*self.frame.size.width, 44)];
                 [minTextField setFont:[UIFont systemFontOfSize:14]];
                minTextField.placeholder=@"最小值";
                self.model.keyStr2=[NSString stringWithFormat:@"spec_min_%@_%@",[self.answerAry firstObject],self.model.uid];
                self.model.keyStr3=[NSString stringWithFormat:@"spec_max_%@_%@",[self.answerAry firstObject],self.model.uid];
                self.minTextField=minTextField;
                minTextField.tag=121;
                minTextField.clearsOnBeginEditing=YES;
                minTextField.delegate=self;
                minTextField.textAlignment = NSTextAlignmentRight;
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldChanged:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:minTextField];

                [view  addSubview:minTextField];
                UIView *lineV1=[[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-7.5+10, 22, 15, 0.5)];
                [lineV1 setBackgroundColor:[UIColor blackColor]];
                [view addSubview:lineV1];
                UITextField *maxTextField=[[UITextField alloc]initWithFrame:CGRectMake(self.frame.size.width/2+10/320.f*self.frame.size.width+10, 0, 60/320.f*self.frame.size.width, 44)];
                [maxTextField setFont:[UIFont systemFontOfSize:14]];
                maxTextField.placeholder=@"最大值";
                maxTextField.delegate=self;
                maxTextField.tag=122;
                maxTextField.clearsOnBeginEditing=YES;
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldChanged:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:maxTextField];
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
                UITextField *oneTextField=[[UITextField alloc]initWithFrame:CGRectMake(90/320.f*self.frame.size.width, 0, 180/320.f*self.frame.size.width, 44)];
                [oneTextField setFont:[UIFont systemFontOfSize:14]];
                oneTextField.tag=123;
                oneTextField.delegate=self;
                self.oneTextField=oneTextField;
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldChanged:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:oneTextField];
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
        
        self.model.selectProper=procprs;
        CGRect frame=self.frame;
        frame.size.height=CGRectGetMaxY(self.erjiView.frame);
        self.frame=frame;
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
//    [self.answerAry insertObject:select atIndex:0]

    self.model.answer=select;
    [self.nowBtn setTitle:select forState:UIControlStateNormal];
}
- (void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    int kssss;
    if (textField.keyboardType==UIKeyboardTypeDecimalPad||textField.keyboardType==UIKeyboardTypeNumberPad) {
        kssss=8;
    }else{
        kssss=10;
    }
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kssss) {
                // NSLog(@"最多%d个字符!!!",kMaxLength);
                 [ToastView showTopToast:[NSString stringWithFormat:@"最多%d个字符",kssss]];
                //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] view:nil];
                textField.text = [toBeString substringToIndex:kssss];
                return;
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kssss) {
            //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%ld个字符",(long)kMaxLength] view:nil];
            //NSLog(@"最多%d个字符!!!",kMaxLength);
            [ToastView showTopToast:[NSString stringWithFormat:@"最多%d个字符",kssss]];
            textField.text = [toBeString substringToIndex:kssss];
            return;
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end