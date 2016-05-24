//
//  GuiGeView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "GuiGeView.h"
#import "GuiGeCell.h"
#import "UIDefines.h"
@interface GuiGeView()<GuiGeCellDelegate>
@property (nonatomic,strong) NSMutableArray *cellAry;
@property (nonatomic) CGFloat yincanggao;
@property (nonatomic) CGFloat wanzhenggao;
@property (nonatomic,strong) UIView *hidingView;
@end
@implementation GuiGeView
-(id)initWithAry:(NSArray *)modelAry andFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.clipsToBounds=YES;
        [self setBackgroundColor:BGColor];
        self.cellAry=[NSMutableArray array];
        CGFloat Y=0;
        for (int i=0; i<modelAry.count; i++) {
            GuiGeModel *model=modelAry[i];
            GuiGeCell *cell=[[GuiGeCell alloc]initWithFrame:CGRectMake(0, Y, frame.size.width, 44) andModel:model];
            Y+=cell.frame.size.height;
            if (model.main) {
                self.yincanggao=Y;
            }
            cell.delegate=self;
            [self.cellAry addObject:cell];
            [self addSubview:cell];
        }
        CGRect frame=self.frame;
        frame.size.height=self.yincanggao+44;
        self.frame=frame;
        self.wanzhenggao=Y;
        UIButton *showBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.frame.size.height-44, frame.size.width, 44)];
        self.showBtn=showBtn;
        [showBtn setTitle:@"更多规格" forState:UIControlStateNormal];
        [showBtn setTitleColor:NavColor  forState:UIControlStateNormal];
        [showBtn setTitleColor:NavColor  forState:UIControlStateSelected];
        [showBtn setBackgroundColor:BGColor];
        [showBtn setTitle:@"隐藏规格" forState:UIControlStateSelected];
        [showBtn addTarget:self action:@selector(showBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:showBtn];
    }
    return self;
}
-(id)initWithValueAry:(NSArray *)modelAry andFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
         self.clipsToBounds=YES;
        [self setBackgroundColor:BGColor];
        self.cellAry=[NSMutableArray array];
        CGFloat Y=0;
        for (int i=0; i<modelAry.count; i++) {
            GuiGeModel *model=modelAry[i];
            GuiGeCell *cell=[[GuiGeCell alloc]initWithFrame:CGRectMake(0, Y, frame.size.width, 44) andValueModel:model];
            Y+=cell.frame.size.height;
            if (model.main) {
                self.yincanggao=Y;
            }
            cell.delegate=self;
            [self.cellAry addObject:cell];
            [self addSubview:cell];
        }
        CGRect frame=self.frame;
        frame.size.height=self.yincanggao+44;
        self.frame=frame;
        self.wanzhenggao=Y;
        
        UIButton *showBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.frame.size.height-44, frame.size.width, 44)];
        self.showBtn=showBtn;
        [showBtn setTitle:@"更多规格" forState:UIControlStateNormal];
        [showBtn setTitleColor:NavColor  forState:UIControlStateNormal];
        [showBtn setTitleColor:NavColor  forState:UIControlStateSelected];
        [showBtn setBackgroundColor:BGColor];
        [showBtn setTitle:@"隐藏规格" forState:UIControlStateSelected];
        [showBtn addTarget:self action:@selector(showBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:showBtn];
    }
    return self;
}
-(void)showBtnAction:(UIButton *)sender
{
    if (self.showBtn.selected==NO) {
        CGRect frame=self.frame;
        frame.size.height=self.wanzhenggao+44;
        //NSLog(@"%lf",frame.size.height);
        self.frame=frame;
    }else
    {
        CGRect frame=self.frame;
        frame.size.height=self.yincanggao+44;
        //NSLog(@"%lf",frame.size.height);
        self.frame=frame;
    }
    if (self.delegate) {
        [self.delegate reloadViewWithFrame:self.frame];
    }
      [self reloadBtnaVVV];
    sender.selected=!sender.selected;
}
-(BOOL)getAnswerAry:(NSMutableArray *)answerAryz
{
    [answerAryz removeAllObjects];
    for (int i=0; i<_cellAry.count; i++) {
        GuiGeCell *cell=_cellAry[i];
        if (cell.model.main==1) {
            if (cell.answerAry.count>0) {
                NSString *answer1=[cell.answerAry firstObject];
                if (answer1.length==0) {
                    [ToastView showTopToast:[NSString stringWithFormat:@"请完善%@信息",cell.model.name]];
                    [answerAryz removeAllObjects];
                    return NO;
                }
            }else{
                [ToastView showTopToast:[NSString stringWithFormat:@"请完善%@信息",cell.model.name]];
                [answerAryz removeAllObjects];
                return NO;
            }
           
        }//判断主要规格是否都已填写
       
        if ([cell.model.type isEqualToString:@"文本"]) {

            Propers *propers=[cell.model.propertyLists firstObject];
            if (propers.range)
            {
                if (cell.answerAry.count>0)
                {
                    NSString *answer1=[cell.answerAry firstObject];
                    NSString *answer2=[cell.answerAry lastObject];
                    if (answer1.length>0) {
                        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                        dic[@"field"]=cell.model.keyStr2;
                        dic[@"value"]=answer1;
                        [answerAryz addObject:dic];
                    }
                    if (answer2.length>0) {
                        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                        dic[@"field"]=cell.model.keyStr3;
                        dic[@"value"]=answer2;
                        [answerAryz addObject:dic];
                    }

                }
                
            }else{
                if (cell.answerAry.count>0) {
                    NSString *answer1=[cell.answerAry firstObject];
                    if (answer1.length>0) {
                         NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                        dic[@"field"]=cell.model.keyStr2;
                        dic[@"value"]=answer1;
                        [answerAryz addObject:dic];
                    }
                }
                
            }
            
        }//文本判断
        
        if([cell.model.type isEqualToString:@"复选"])
        {
            if (cell.answerAry.count>0) {
               
                NSMutableString *anserStr=[NSMutableString new];
                if (cell.answerAry.count>=1) {
                    [anserStr appendFormat:@"%@",cell.answerAry[0]];
                }
                for (int i=1; i<cell.answerAry.count; i++) {
                    [anserStr appendFormat:@",%@",cell.answerAry[i]];
                }
                NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                dic[@"field"]=cell.model.keyStr1;
                dic[@"value"]=anserStr;
                [answerAryz addObject:dic];
            }
        }//复选判断
        if ([cell.model.type isEqualToString:@"单选结合"]) {
            if (cell.answerAry.count>0) {
                NSString *answers1=[cell.answerAry firstObject];
                if (answers1.length>0) {
                    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                    dic[@"field"]=cell.model.keyStr1;
                    dic[@"value"]=[cell.answerAry firstObject];
                    [answerAryz addObject:dic];
                }
             
            }
            
            if (cell.model.selectProper) {
                if(cell.model.selectProper.operation)
                {
                    if (cell.model.selectProper.relation.length>0)
                    {
                          GuiGeCell *soncell=(GuiGeCell*)cell.erjiView;
                        if (soncell.answerAry.count>0) {
                           NSString *answers1=[soncell.answerAry firstObject];
                            if (answers1.length>0) {
                                NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                                dic[@"field"]=cell.model.selectProper.guanlianModel.keyStr1;
                                dic[@"value"]=[soncell.answerAry firstObject];
                                
                                [answerAryz addObject:dic];
                            }
                           
                        }
                      
                    }else{
                        if (cell.answerAry2.count>0) {
                            NSString *answers1=[cell.answerAry2 firstObject];
                            NSString *answers2=[cell.answerAry2 lastObject];
                            if (answers1.length>0) {
                                NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                                dic[@"field"]=cell.model.keyStr2;
                                dic[@"value"]=answers1;
                                
                                [answerAryz addObject:dic];
                            }
                            if (answers2.length>0) {
                                NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                                dic[@"field"]=cell.model.keyStr3;
                                dic[@"value"]=answers2;
                                
                                [answerAryz addObject:dic];
                            }
                        }
                    }
                }
            }
        }//单选结合判断
        
    }
    return YES;
}

-(void)reloadView
{
    CGFloat Y=0;
    for (int i=0; i<self.cellAry.count; i++) {
        
        GuiGeCell *cell=self.cellAry[i];
        CGRect framex=cell.frame;
        framex.origin.y=Y;
        cell.frame=framex;
        Y+=framex.size.height;
        if (cell.model.main) {
            self.yincanggao=Y;
        }
        
     }
  self.wanzhenggao=Y;
    if (self.showBtn.selected==NO) {
        CGRect frame=self.frame;
        frame.size.height=self.yincanggao+44;
        self.frame=frame;
    }else
    {
        CGRect frame=self.frame;
        frame.size.height=self.wanzhenggao+44;
        self.frame=frame;
    }
     [self reloadBtnaVVV];
    if (self.delegate) {
        [self.delegate reloadViewWithFrame:self.frame];
    }
   
}
-(void)reloadBtnaVVV
{
    CGRect frame = self.showBtn.frame;
    frame.origin.y=self.frame.size.height-44;
    self.showBtn.frame=frame;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
