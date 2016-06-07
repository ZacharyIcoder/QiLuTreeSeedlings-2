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
#import "UIButton+ZIKEnlargeTouchArea.h"
@interface GuiGeCell ()<UITextFieldDelegate,PickeShowDelegate,GuiGeCellDelegate>

@property (nonatomic,strong)UITextField *oneTextField;
@property (nonatomic,strong)UITextField *minTextField;
@property (nonatomic,strong)UITextField *maxTextField;
@property (nonatomic,strong)PickerShowView *pickerView;
@property (nonatomic,weak)UIButton *nowBtn;
@property (nonatomic,weak)UIView *imageVV;
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
        
        UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 44)];
        [nameLab setFont:[UIFont systemFontOfSize:14]];
        [nameLab setTextColor:DarkTitleColor];
        [self addSubview:nameLab];
        [nameLab setText:model.name];
        if (model.name.length>=6&&self.frame.size.width<320) {
            [nameLab setFont:[UIFont systemFontOfSize:13]];
        }
        if ([model.type isEqualToString:@"文本"]) {
            Propers *propers=[model.propertyLists firstObject];
            if (propers.unit) {
                UILabel *unitLab=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-60, 0, 50, 44)];
                [unitLab setFont:[UIFont systemFontOfSize:14]];
                [unitLab setTextAlignment:NSTextAlignmentCenter];
                [unitLab setTextColor:DarkTitleColor];
                [self addSubview:unitLab];
                unitLab.text=propers.unit;
            }
            if (propers.range) {
                self.model.keyStr2=[NSString stringWithFormat:@"spec_min_%@",self.model.uid];
                self.model.keyStr3=[NSString stringWithFormat:@"spec_max_%@",self.model.uid];
                [self.answerAry addObjectsFromArray:@[@"",@""]];
                UITextField *minTextField=[[UITextField alloc]initWithFrame:CGRectMake(self.frame.size.width/2-70/320.f*self.frame.size.width+10, 0, 60/320.f*self.frame.size.width, 44)];
                 [minTextField setFont:[UIFont systemFontOfSize:14]];
                minTextField.textColor=DarkTitleColor;
                minTextField.placeholder=@"最小值";
                self.minTextField=minTextField;
                minTextField.tag=111;
//                minTextField.clearsOnBeginEditing=YES;
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
                maxTextField.textColor=DarkTitleColor;
               // maxTextField.clearsOnBeginEditing=YES;
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
                oneTextField.textColor=DarkTitleColor;
                oneTextField.placeholder=[NSString stringWithFormat:@"请输入%@",model.name];
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
            pickBtn.center=CGPointMake(self.frame.size.width/2+10, self.frame.size.height/2);
            [pickBtn setEnlargeEdgeWithTop:7 right:100 bottom:7 left:80];
            //[pickBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [self addSubview:pickBtn];
            [pickBtn addTarget:self action:@selector(pickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [pickBtn setTitle:[NSString stringWithFormat:@"请选择%@",self.model.name] forState:UIControlStateNormal];
            [pickBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
            self.nowBtn=pickBtn;
            [pickBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            
            UIImageView *imageVVV=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-42, 15, 15, 15)];
            [imageVVV setImage:[UIImage imageNamed:@"xiala2"]];
            
            [self addSubview:imageVVV];
            PickerShowView *pickerView=[[PickerShowView alloc]initWithFrame:CGRectMake(0, 0, kWidth,kHeight)];
            self.pickerView=pickerView;
            pickerView.delegate=self;
            NSMutableArray *dataxxAry=[NSMutableArray array];
            for (int i=0; i<model.propertyLists.count; i++) {
                Propers *propers=model.propertyLists[i];
                [dataxxAry addObject:propers.value];
            }
            if (!model.main) {
                [dataxxAry addObject:[NSString stringWithFormat:@"请选择%@",self.model.name]];
            }
            [pickerView resetPickerData:dataxxAry];
            if (model.main) {
                [pickerView.delegate selectNum:0 andselectInfo:[dataxxAry firstObject]];
            }else{
                [pickerView.pickerView selectRow:dataxxAry.count-1  inComponent:0 animated:NO];
            }
        }//单选结合结束
        
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(15, self.frame.size.height-0.5, self.frame.size.width-30, 0.5)];
        self.imageVV=lineView;
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
        UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 44)];
        [nameLab setFont:[UIFont systemFontOfSize:14]];
        [nameLab setTextColor:DarkTitleColor];
        [self addSubview:nameLab];
        [nameLab setText:model.name];
        if ([model.type isEqualToString:@"文本"]) {
            Propers *propers=[model.propertyLists firstObject];
            if (propers.unit) {
                UILabel *unitLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-60, 0, 50, 44)];
                [unitLab setTextAlignment:NSTextAlignmentCenter];
                [unitLab setFont:[UIFont systemFontOfSize:14]];
                [unitLab setTextColor:DarkTitleColor];
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
                minTextField.textColor=MoreDarkTitleColor;
                //minTextField.clearsOnBeginEditing=YES;
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
                maxTextField.textColor=MoreDarkTitleColor;
                //maxTextField.clearsOnBeginEditing=YES;
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
                oneTextField.placeholder=[NSString stringWithFormat:@"请输入%@",model.name];
                oneTextField.delegate=self;
                oneTextField.textColor=MoreDarkTitleColor;
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
            UIButton *pickBtn=[[UIButton alloc]initWithFrame:CGRectMake(110, 7, 160/320.f*kWidth, 30)];
            pickBtn.center=CGPointMake(self.frame.size.width/2+10, self.frame.size.height/2);
            [pickBtn setEnlargeEdgeWithTop:7 right:100 bottom:7 left:80];
            [pickBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [self addSubview:pickBtn];
            [pickBtn addTarget:self action:@selector(pickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [pickBtn setTitle:[NSString stringWithFormat:@"请选择%@",self.model.name] forState:UIControlStateNormal];
            [pickBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
            self.nowBtn=pickBtn;
            UIImageView *imageVVV=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-42.5, 15, 15, 15)];
            [imageVVV setImage:[UIImage imageNamed:@"xiala2"]];
            
            [self addSubview:imageVVV];
            if (self.model.values.count>0) {
                self.answerAry =[NSMutableArray arrayWithObject:[self.model.values firstObject]];
                [pickBtn setTitle:[self.model.values firstObject] forState:UIControlStateNormal];
                [pickBtn setTitleColor:MoreDarkTitleColor forState:UIControlStateNormal];
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
                        cell.delegate=self;
                        self.erjiView=cell;
                        [self addSubview:cell];
                        
                    }else{
                        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 43, kWidth, 43.5)];
                        [view setBackgroundColor:[UIColor whiteColor]];
                        [self addSubview:view];
                        UIImageView *linevvvv=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43, self.frame.size.width-20, 0.5)];
                        [linevvvv setBackgroundColor:kLineColor];
                        [view addSubview:linevvvv];
                        self.erjiView=view;
                        if (self.model.selectProper.unit) {
                            UILabel *unitLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-60, 0, 50, 44)];
                            [unitLab setTextAlignment:NSTextAlignmentCenter];
                            [unitLab setFont:[UIFont systemFontOfSize:14]];
                            [unitLab setTextColor:DarkTitleColor];
                            [view addSubview:unitLab];
                            unitLab.text=self.model.selectProper.unit;
                        }
                        if (self.model.selectProper.range) {
                            [self.answerAry2 addObjectsFromArray:@[@"",@""]];
                            UITextField *minTextField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth/2-70/320.f*kWidth+10, 0, 60/320.f*kWidth, 44)];
                             [minTextField setFont:[UIFont systemFontOfSize:14]];
                             minTextField.placeholder=@"最小值";
                            minTextField.textColor=MoreDarkTitleColor;
                           // minTextField.clearsOnBeginEditing=YES;
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
                            maxTextField.textColor=MoreDarkTitleColor;
                            //maxTextField.clearsOnBeginEditing=YES;
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
                            oneTextField.textColor=MoreDarkTitleColor;
                            oneTextField.delegate=self;
                            self.oneTextField=oneTextField;
                            oneTextField.placeholder=[NSString stringWithFormat:@"请输入%@",model.name];
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
                                self.answerAry2=[NSMutableArray arrayWithObjects:self.model.values[1], nil];
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

            PickerShowView *pickerView=[[PickerShowView alloc]initWithFrame:CGRectMake(0, 0, kWidth,kHeight)];
            self.pickerView=pickerView;
            pickerView.delegate=self;
            NSMutableArray *dataxxAry=[NSMutableArray array];
            for (int i=0; i<model.propertyLists.count; i++) {
                Propers *propers=model.propertyLists[i];
                [dataxxAry addObject:propers.value];
            }
            if (!model.main) {
                [dataxxAry addObject:[NSString stringWithFormat:@"请选择%@",self.model.name]];
            }
            [pickerView resetPickerData:dataxxAry];
            if (self.model.values.count<=0) {
                            if (model.main) {
                                [pickerView.delegate selectNum:0 andselectInfo:[dataxxAry firstObject]];
                            }else{
                                [pickerView.pickerView selectRow:dataxxAry.count-1  inComponent:0 animated:NO];
                            }
            }


        }//单选结合结束
        
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(15, self.frame.size.height-0.5, self.frame.size.width-30, 0.5)];
        self.imageVV=lineView;
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
    if (textField.keyboardType==UIKeyboardTypeDecimalPad)
    {
        if (textField.text.length>0) {
            CGFloat sss=[textField.text floatValue];
            if (sss>0) {
                textField.text=[NSString stringWithFormat:@"%.2lf",sss];
            }else{
                textField.text=[NSString stringWithFormat:@"%.2lf",sss];
                
            }
        }
       
       
    }
    if (textField.tag==111) {
        //[self.answerAry insertObject:textField.text atIndex:0];
        [self.answerAry replaceObjectAtIndex:0 withObject:textField.text];
//        if (self.maxTextField.text.length==0) {
//            //self.maxTextField.text=textField.text;
//             [self.answerAry replaceObjectAtIndex:1 withObject:textField.text];
////            [self.answerAry insertObject:textField.text atIndex:1];
//        }
//        if (textField.text.length==0) {
//            if (self.maxTextField.text.length>0) {
//               // textField.text=self.maxTextField.text;
//                [self.answerAry replaceObjectAtIndex:0 withObject:textField.text];
//            }
//        }

    }
    if (textField.tag==112) {
//        [self.answerAry insertObject:textField.text atIndex:1];
        [self.answerAry replaceObjectAtIndex:1 withObject:textField.text];
    }
    if (textField.tag==113) {
//       [self.answerAry insertObject:textField.text atIndex:0];
        [self.answerAry replaceObjectAtIndex:0 withObject:textField.text];
    }
    if (textField.tag==121) {
         [self.answerAry2 replaceObjectAtIndex:0 withObject:textField.text];
    }
    if (textField.tag==122) {
         [self.answerAry2 replaceObjectAtIndex:1 withObject:textField.text];
    }
    if (textField.tag==123) {
//        [self.answerAry2 insertObject:textField.text atIndex:0];
         [self.answerAry2 replaceObjectAtIndex:0 withObject:textField.text];
    }
    if (textField.tag!=113&&textField.tag!=123) {
        if (textField.keyboardType==UIKeyboardTypeDecimalPad||textField.keyboardType==UIKeyboardTypeNumberPad)
        {
            if (self.maxTextField.text.length>0) {
                CGFloat minNum=[self.minTextField.text floatValue];
                CGFloat maxNum=[self.maxTextField.text floatValue];
                if (minNum>maxNum) {
                    [ToastView showTopToast:@"最小值不得大于最大值"];
                    if (textField.tag==111||textField.tag==121) {
                        textField.text=self.maxTextField.text;
                        if (textField.tag==111) {
                            [self.answerAry replaceObjectAtIndex:0 withObject:textField.text];
                        }
                        if (textField.tag==121) {
                            [self.answerAry2 replaceObjectAtIndex:0 withObject:textField.text];
                        }
                        
                    }
                    if (textField.tag==112||textField.tag==122) {
                        textField.text=self.minTextField.text;
                        if (textField.tag==112) {
                            [self.answerAry replaceObjectAtIndex:1 withObject:textField.text];
                        }
                        if (textField.tag==122) {
                            [self.answerAry2 replaceObjectAtIndex:1 withObject:textField.text];
                        }
                        
                    }
              }
     
            }
        }
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
-(void)selectNum:(NSInteger)select andselectInfo:(NSString *)selectStr
{
    
    [self.answerAry2 removeAllObjects];
    self.model.keyStr2=@"";
    self.model.keyStr3=@"";
    self.model.sonModel=nil;
    self.model.selectProper=nil;
    if (select>=self.model.propertyLists.count) {
        [self.answerAry replaceObjectAtIndex:0 withObject:@""];
        self.model.answer=@"";
        [self.nowBtn setTitle:selectStr forState:UIControlStateNormal];
        [self.nowBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
        CGRect frame=self.frame;
        frame.size.height=44;
        self.frame=frame;
        [self.erjiView removeFromSuperview];
        self.erjiView=nil;
        if (self.delegate) {
            [self.delegate reloadView];
        }
        return;
    }else{
        //[self.answerAry insertObject:selectStr atIndex:0];
        [self.answerAry replaceObjectAtIndex:0 withObject:selectStr];
        self.model.answer=selectStr;
        [self.nowBtn setTitle:selectStr forState:UIControlStateNormal];
        [self.nowBtn setTitleColor:MoreDarkTitleColor forState:UIControlStateNormal];
    }
    Propers *procprs=self.model.propertyLists[select];
    if (procprs.operation) {

        if(self.erjiView)
        {
            [self.erjiView removeFromSuperview];
            self.erjiView=nil;
        }
        if (procprs.relation.length>0) {
         GuiGeCell *cell=[[GuiGeCell alloc]initWithFrame:CGRectMake(0, 45, self.frame.size.width, 44) andModel:procprs.guanlianModel];
            cell.delegate=self;
             self.erjiView=cell;
            [self addSubview:cell];
          
        }else{
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 43, self.frame.size.width, 43.5)];
            [self addSubview:view];
            [view setBackgroundColor:[UIColor whiteColor]];
            UIImageView *linevvvv=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43, self.frame.size.width-20, 0.5)];
            [linevvvv setBackgroundColor:kLineColor];
            [view addSubview:linevvvv];
            self.erjiView=view;
            if (procprs.unit) {
                UILabel *unitLab=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-60, 0, 50, 44)];
                [unitLab setTextAlignment:NSTextAlignmentCenter];
                [unitLab setFont:[UIFont systemFontOfSize:14]];
                [unitLab setTextColor:DarkTitleColor];
                [view addSubview:unitLab];
                unitLab.text=procprs.unit;
            }
            if (procprs.range) {
                [self.answerAry2 addObjectsFromArray:@[@"",@""]];
                UITextField *minTextField=[[UITextField alloc]initWithFrame:CGRectMake(self.frame.size.width/2-70/320.f*self.frame.size.width+10, 0, 60/320.f*self.frame.size.width, 44)];
                 [minTextField setFont:[UIFont systemFontOfSize:14]];
                minTextField.placeholder=@"最小值";
                minTextField.textColor=MoreDarkTitleColor;
                self.model.keyStr2=[NSString stringWithFormat:@"spec_min_%@_%@",[self.answerAry firstObject],self.model.uid];
                self.model.keyStr3=[NSString stringWithFormat:@"spec_max_%@_%@",[self.answerAry firstObject],self.model.uid];
                self.minTextField=minTextField;
                minTextField.tag=121;
                //minTextField.clearsOnBeginEditing=YES;
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
                maxTextField.textColor=MoreDarkTitleColor;
               // maxTextField.clearsOnBeginEditing=YES;
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
                oneTextField.placeholder=[NSString stringWithFormat:@"请输入%@",[self.answerAry firstObject]];
                oneTextField.textColor=MoreDarkTitleColor;
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
-(void)reloadView
{
    if (self.erjiView) {
        CGRect frame=self.frame;
        frame.size.height=CGRectGetMaxY(self.erjiView.frame);
        self.frame=frame;
        self.imageVV.frame=CGRectMake(15, self.frame.size.height-0.5, self.frame.size.width-30, 0.5);
    }else{
        CGRect frame=self.frame;
        frame.size.height=44;
        self.frame=frame;
        self.imageVV.frame=CGRectMake(15, self.frame.size.height-0.5, self.frame.size.width-30, 0.5);
    }


}
-(void)dianxuanAction
{
    
}
-(void)actionTextField:(UITextField *)textField
{
    
}
- (void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    int kssss;
    if (textField.keyboardType==UIKeyboardTypeNumberPad) {
        kssss=8;
    }else{
        kssss=10;
    }
    if (textField.keyboardType==UIKeyboardTypeDecimalPad) {
        kssss=11;
        NSArray *valueAryy=[textField.text componentsSeparatedByString:@"."];
        if (valueAryy.count==1) {
            NSString *zhengshuStr=[valueAryy firstObject];
            if (zhengshuStr.length>8) {
                [ToastView showTopToast:[NSString stringWithFormat:@"整数部分不得超过8位"]];
                textField.text = [toBeString substringToIndex:[toBeString length] - 1];
                return;
            }
        }
        if (valueAryy.count==2) {
            // NSLog(@"%@",[valueAryy firstObject]);
            NSString *zhengshuStr=[valueAryy firstObject];
            if (zhengshuStr.length>8) {
                 [ToastView showTopToast:[NSString stringWithFormat:@"整数部分不得超过8位"]];
                textField.text = [toBeString substringToIndex:[toBeString length] - 1];
                return;
            }
            NSString *xiaoshuStr=valueAryy[1];
            if (xiaoshuStr.length>2) {
                [ToastView showTopToast:[NSString stringWithFormat:@"小数精确到两位"]];
                textField.text = [toBeString substringToIndex:[toBeString length] - 1];
                return;
            }
            
        }
        if (valueAryy.count>2) {
            [ToastView showTopToast:[NSString stringWithFormat:@"请不要输入多个小数点"]];
            textField.text = [toBeString substringToIndex:[toBeString length] - 1];
            return;
        }
        
    }
    
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kssss) {
                // NSLog(@"最多%d个字符!!!",kMaxLength);
                 [ToastView showTopToast:[NSString stringWithFormat:@"最多为%d位",kssss]];
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
