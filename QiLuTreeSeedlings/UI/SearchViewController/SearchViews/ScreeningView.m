//
//  ScreeningView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/3.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ScreeningView.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "ToastView.h"
#import "SreeningViewCell.h"
#import "TreeSpecificationsModel.h"
#import "YLDPickLocationView.h"
#import "ToastView.h"
#import "ZIKSideView.h"
#import "GuiGeView.h"
#import "GuiGeModel.h"
@interface ScreeningView ()<UITextFieldDelegate,ZIKSelectViewUidDelegate,YLDPickLocationDelegate,GuiGeViewDelegate>
@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong)UIScrollView *backScrollView;

@property (nonatomic,strong) UIButton *gongyingBtn;
@property (nonatomic,strong) UIButton *areaBtn;
@property (nonatomic,weak) UITextField *nowTextFlield;
@property (nonatomic,strong)UIButton *nameBtn;
@property (nonatomic, strong) ZIKSideView      *sideView;
@property (nonatomic, strong) NSMutableArray   *productTypeDataMArray;
@property (nonatomic,strong) UIButton *quedingBtn;
@property (nonatomic,strong) GuiGeView *guigeView;
@property (nonatomic,strong)NSMutableArray *guige1Ary;
@end
@implementation ScreeningView
@synthesize gongyingBtn;
-(void)setSearchStr:(NSString *)searchStr
{
    if ([searchStr isEqualToString:self.nameTextField.text]) {
        
    }else
    {
            self.nameTextField.text=searchStr;
            [self nameBtnAction:_quedingBtn];
       
    }
}
-(id)initWithFrame:(CGRect)frame andSearch:(NSString *)searchStr andSerachType:(NSInteger )searchType
{
    self=[super initWithFrame:frame];
    if (self) {
        
        self.searchType=searchType;
        self.guige1Ary=[NSMutableArray array];
        self.productTypeDataMArray=[NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(hidingKey)
         
                                                     name:@"pickViewShowInView"
         
                                                   object:nil];

        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(kWidth*0.2, 0, kWidth*0.8, 64)];
        [backView setBackgroundColor:kRGB(210, 210, 210, 1)];
        [self addSubview:backView];
        UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(17, 7+20, 30, 30)];
        [backBtn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
        [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
        [backView addSubview:backBtn];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(backView.frame.size.width/2-30, 10+20, 60, 24)];
        titleLab.text=@"筛选";
        [titleLab setTextColor:titleLabColor];
        titleLab.textAlignment=NSTextAlignmentCenter;
        [backView addSubview:titleLab];
        self.backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0.2*kWidth, 44+20, 0.8*kWidth, kHeight-44-44-20)];
        [self.backScrollView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.backScrollView];
        CGRect tempFrame=CGRectMake(0, 5, kWidth*0.8, 44);
        UIView *nameView=[[UIView alloc]initWithFrame:tempFrame];
        [nameView setBackgroundColor:[UIColor whiteColor]];
        UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 2, 70, 40)];
        nameLab.text=@"苗木名称";
        [nameLab setTextColor:titleLabColor];
        [nameLab setFont:[UIFont systemFontOfSize:14]];
        [nameView addSubview:nameLab];
        UIImageView *lineNameL=[[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, kWidth*0.8, 0.5)];
        [nameView addSubview:lineNameL];
        [lineNameL setBackgroundColor:kLineColor];
        UITextField *nameField=[[UITextField alloc]initWithFrame:CGRectMake(80, 2, kWidth*0.8-75-80, 40)];
        self.nameTextField=nameField;
        nameField.tag=10001;
        [nameField setFont:[UIFont systemFontOfSize:14]];
        nameField.delegate=self;
        nameField.placeholder=@"请输入苗木名称";
        [nameView addSubview:nameField];
        nameField.text=searchStr;
        [nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [nameField setTextColor:NavColor];
        [self.backScrollView addSubview:nameView];
        UIButton *quedingBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameField.frame)+5, 9, 50, 25)];
        [nameView addSubview:quedingBtn];
        [quedingBtn addTarget:self action:@selector(nameBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [quedingBtn setImage:[UIImage imageNamed:@"treeNameSure"] forState:UIControlStateNormal];
        [quedingBtn setImage:[UIImage imageNamed:@"treeNameSure2"] forState:UIControlStateSelected];
        [quedingBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        self.nameBtn=quedingBtn;
        if (searchStr.length>0) {
            [self nameBtnAction:quedingBtn];
        }
        tempFrame.origin.y+=50;
        if (searchType==1) {
            UIView *gongyingshangView=[[UIView alloc]initWithFrame:tempFrame];
            UILabel *gongyingLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 2, 70, 40)];
            
            gongyingLab.text=@"供应商";
            [gongyingLab setFont:[UIFont systemFontOfSize:14]];
            [gongyingLab setTextColor:titleLabColor];
            UIImageView *lineGYL=[[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, kWidth*0.8, 0.5)];
            [gongyingshangView addSubview:lineGYL];
            [lineGYL setBackgroundColor:kLineColor];
            
            [gongyingshangView addSubview:gongyingLab];
            
            UIButton *nomegongyingbtn=[[UIButton alloc]initWithFrame:CGRectMake(160, 7,90, 25)];
            [nomegongyingbtn setTitle:@"普通供应商" forState:UIControlStateNormal];
            nomegongyingbtn.tag=110;
            [nomegongyingbtn setTitle:@"普通供应商" forState:UIControlStateSelected];
            [nomegongyingbtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            //nomegongyingbtn.titleEdgeInsets = UIEdgeInsetsMake(0, -90, 0, 0);
            [nomegongyingbtn setTitleColor:detialLabColor forState:UIControlStateNormal];
            [nomegongyingbtn setTitleColor:NavColor forState:UIControlStateSelected];
            [nomegongyingbtn setBackgroundImage:[UIImage imageNamed:@"unselectBtnAction"] forState:UIControlStateNormal];
            [nomegongyingbtn setBackgroundImage:[UIImage imageNamed:@"selectBtnAction2"] forState:UIControlStateSelected];
            [nomegongyingbtn addTarget:self action:@selector(gongyingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [gongyingshangView addSubview:nomegongyingbtn];
            UIButton *goldgongyingbtn=[[UIButton alloc]initWithFrame:CGRectMake(60, 7, 90, 25)];
            [goldgongyingbtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [goldgongyingbtn setTitle:@"金牌供应商" forState:UIControlStateNormal];
            goldgongyingbtn.tag=111;
            [goldgongyingbtn setTitle:@"金牌供应商" forState:UIControlStateSelected];
            [goldgongyingbtn addTarget:self action:@selector(gongyingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [goldgongyingbtn setTitleColor:detialLabColor forState:UIControlStateNormal];
            [goldgongyingbtn setTitleColor:NavColor forState:UIControlStateSelected];
            [goldgongyingbtn setBackgroundImage:[UIImage imageNamed:@"unselectBtnAction"] forState:UIControlStateNormal];
            [goldgongyingbtn setBackgroundImage:[UIImage imageNamed:@"selectBtnAction2"] forState:UIControlStateSelected];
            //goldgongyingbtn.titleEdgeInsets = UIEdgeInsetsMake(0, -90, 0, 0);
            [gongyingshangView addSubview:goldgongyingbtn];
            [self.backScrollView addSubview:gongyingshangView];
            tempFrame.origin.y+=50;
   
        }
        UIView *areaView=[[UIView alloc]initWithFrame:tempFrame];
        UILabel *areaLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 2, 70, 40)];
        
        [areaLab setText:@"地区"];
        [areaLab setFont:[UIFont systemFontOfSize:14]];
        [areaLab setTextColor:titleLabColor];
        [areaView addSubview:areaLab];
        UIButton *areaBtn=[[UIButton alloc]initWithFrame:CGRectMake(90, 7, 130/320.f*kWidth, 30)];
        self.areaBtn=areaBtn;
        [areaBtn setTitle:@"请选择地区" forState:UIControlStateNormal];
        [areaBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [areaBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
        [areaBtn addTarget: self action:@selector(areaBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [areaView addSubview:areaBtn];
        [self.backScrollView addSubview:areaView];
        
        UIView *shaixuanView=[[UIView alloc]initWithFrame:CGRectMake(kWidth*0.2, CGRectGetMaxY(self.backScrollView.frame), kWidth*0.8, 50)];
        [shaixuanView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:shaixuanView];
        UIButton *shaixuanBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*0.43, 0, kWidth*0.3, 38)];
        [shaixuanView addSubview:shaixuanBtn];
        [shaixuanBtn setBackgroundColor:NavColor];
        self.quedingBtn=shaixuanBtn;
        [shaixuanBtn setTitle:@"筛选" forState:UIControlStateNormal];
        [shaixuanBtn addTarget:self action:@selector(screeningViewAction) forControlEvents:UIControlEventTouchUpInside];
        UIButton *chongzhiBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*0.07, 0, kWidth*0.3, 38)];
        [chongzhiBtn setBackgroundColor:kRGB(241, 157, 65, 1)];
        [chongzhiBtn setTitle:@"重置" forState:UIControlStateNormal];
        [chongzhiBtn addTarget:self action:@selector(chongzhiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [shaixuanView setBackgroundColor:BGColor];
        [shaixuanView addSubview:chongzhiBtn];
    }
    return self;
}
-(void)areaBtnAction
{
    CGRect tempFrame = [[UIScreen mainScreen] bounds];
    
      YLDPickLocationView * pickLocation = [[YLDPickLocationView alloc] initWithFrame:tempFrame CityLeve:CityLeveXian];
        
        pickLocation.delegate = self;
     [pickLocation showPickView];
    [self hidingKey];
   
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        if (self.nameBtn.selected==YES) {
            self.nameBtn.selected=NO;
        }
    }
}
-(void)chongzhiBtnAction:(UIButton *)sender
{
    [self clearOldCellAction];
    [self getTreeSHUXINGWithBtn:self.nameBtn];
}
-(void)selectSheng:(CityModel *)sheng shi:(CityModel *)shi xian:(CityModel *)xian zhen:(CityModel *)zhen
{
        NSMutableString *namestr=[NSMutableString new];
        if (sheng.code) {
            [namestr appendString:sheng.cityName];
            self.province=sheng.code;
        }else
        {
            self.province=nil;
        }
    
        if (shi.code) {
            [namestr appendString:shi.cityName];
            self.City=shi.code;
        }else
        {
            self.City=nil;
        }
        if (xian.code) {
            [namestr appendString:xian.cityName];
            self.county=xian.code;
        }else{
             self.county=nil;
        }
        if (namestr.length>0) {
            [self.areaBtn setTitle:namestr forState:UIControlStateNormal];
            [self.areaBtn.titleLabel sizeToFit];
        }else{
            [self.areaBtn setTitle:@"不限" forState:UIControlStateNormal];
            [self.areaBtn.titleLabel sizeToFit];
        }

}
-(void)gongyingBtnAction:(UIButton *)sender
{
   
    if (sender.selected) {
        sender.selected=NO;
        self.goldsupplier=@"";
        return;
    }else
    {
        if (gongyingBtn) {
            gongyingBtn.selected=NO;
            
        }
        if (sender.tag==110) {
            //NSLog(@"普通供应商");
            self.goldsupplier=@"0";
        }
        if (sender.tag==111) {
           self.goldsupplier=@"1";
        }
       sender.selected=YES;
        gongyingBtn=sender;
    }
}
-(void)nameBtnAction:(UIButton *)sender
{
    [self.nameTextField resignFirstResponder];
    if (sender.selected) {
        return;
    }
    if (self.nameTextField.text.length==0) {
        [ToastView showToast:@"请输入苗木名称"
                 withOriginY:66.0f
               withSuperView:APPDELEGATE.window];
        return;
    }
    self.productName=self.nameTextField.text;
    
    [self clearOldCellAction];
    [self getTreeSHUXINGWithBtn:sender];
  
}
- (void)getTreeSHUXINGWithBtn:(UIButton *)sender
{
    [self.guige1Ary removeAllObjects];
    if (self.guigeView) {
        [self.guigeView removeFromSuperview];
        self.guigeView=nil;
    }
    [HTTPCLIENT huoqumiaomuGuiGeWithTreeName:self.nameTextField.text andType:@"1" andMain:@"0" Success:^(id responseObject) {
        if (![[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showToast:[responseObject objectForKey:@"msg"]
                     withOriginY:66.0f
                   withSuperView:APPDELEGATE.window];
            if ([responseObject[@"msg"] isEqualToString:@"该苗木不存在"]) {
                [self requestProductType];
            }
        }else{
            sender.selected=YES;
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            self.productUid=[dic objectForKey:@"productUid"];
            NSArray *guigeAry=[dic objectForKey:@"list"];
            for (int i=0; i<guigeAry.count; i++) {
                NSDictionary *dic=guigeAry[i];
                if ([[dic objectForKey:@"level"] integerValue]==0) {
                    GuiGeModel *guigeModel=[GuiGeModel creatGuiGeModelWithDic:dic];
                    [self.guige1Ary addObject:guigeModel];
                }
            }
            
            for (int i=0; i<guigeAry.count; i++) {
                NSDictionary *dic=guigeAry[i];
                if ([[dic objectForKey:@"level"] integerValue]==1) {
                    GuiGeModel *guigeModel=[GuiGeModel creatGuiGeModelWithDic:dic];
                    
                    
                    for (int j=0; j<self.guige1Ary.count; j++) {
                        GuiGeModel *guigeModel1=self.guige1Ary[j];
                        for (int k=0 ; k<guigeModel1.propertyLists.count; k++) {
                            
                            Propers *proper=guigeModel1.propertyLists[k];
                            //                            if ([guigeModel1.name isEqualToString:@"根部要求测"]) {
                            //                                NSLog(@"%@",proper.relation);
                            //                            }
                            if ([proper.relation isEqualToString:guigeModel.uid]) {
                                proper.guanlianModel=guigeModel;
                            }
                        }
                    }
                }
            }

            CGFloat YSS=88;
            if (self.searchType==1) {
                YSS=138;
            }
            GuiGeView *guigeView=[[GuiGeView alloc]initWithAry:self.guige1Ary andFrame:CGRectMake(0, YSS, kWidth*0.8, 0) andMainSure:NO];
            [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(guigeView.frame))];
            guigeView.delegate=self;
            self.guigeView=guigeView;
            [self.backScrollView addSubview:guigeView];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)reloadViewWithFrame:(CGRect)frame
{
    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(frame))];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.nowTextFlield=textField;
}
-(void)backBtn:(UIButton *)sender
{  CGRect frame=self.frame;
    frame.origin.x=kWidth;
    __weak typeof(self) weakSelf=self;
    [UIView animateWithDuration:0.1 animations:^{
    weakSelf.frame=frame;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        if (weakSelf.delegate) {
            [weakSelf.delegate ScreeningbackBtnAction];
        }
    }];
}
-(void)cellBeginEditing:(UITextField *)field
{
    self.nowTextFlield=field;
}

-(void)hidingKey
{
    if (self.nowTextFlield) {
        [self.nowTextFlield resignFirstResponder];
    }

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hidingKey];
}

-(void)showViewAction
{    CGRect frame=self.frame;
    frame.origin.x=0;
    [UIView animateWithDuration:0.1 animations:^{
        self.frame=frame;
    } completion:^(BOOL finished) {
        
    }];

}
-(void)screeningViewAction
{
    if (self.nameBtn.selected==NO) {
        [ToastView showTopToast:@"请确认树种名称"];
        return;
    }
    __weak typeof(self) weakSelf=self;
    NSMutableArray *screenTijiaoAry=[NSMutableArray array];
 
    
    BOOL canrun = [self.guigeView  getAnswerAry:screenTijiaoAry];
    if (canrun) {
//        for (int i=0; i<screenTijiaoAry.count; i++) {
//            NSDictionary *dic=screenTijiaoAry[i];
//            NSLog(@"%@---%@",dic[@"field"],dic[@"value"]);
//        }
    }else{
        return;
    }

    CGRect frame=self.frame;
    frame.origin.x=kWidth;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.frame=frame;
    } completion:^(BOOL finished) {
        
    }];
    if (self.delegate) {
        if (!self.productName) {
            self.productName=self.nameTextField.text;
        }
        
        [self.delegate creeingActionWithAry:screenTijiaoAry WithProvince:self.province WihtCity:self.City  WithCounty:self.county WithGoldsupplier:self.goldsupplier WithProductUid:self.productUid withProductName:self.productName
         ];
    }
    
}
-(void)clearOldCellAction
{
    self.province=nil;
    self.productUid=nil;
    self.productName=nil;
    self.City=nil;

    self.county=nil;
    self.goldsupplier=nil;
    self.gongyingBtn.selected=NO;
    [self.areaBtn setTitle:@"请选择地区" forState:UIControlStateNormal];
}
- (void)requestProductType {
    [HTTPCLIENT getTypeInfoSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue] == 1 ) {
            NSArray *typeListArray = [[responseObject objectForKey:@"result"] objectForKey:@"typeList"];
            if (typeListArray.count == 0) {
                [ToastView showTopToast:@"暂时没有产品信息!"];
            }
            else if (typeListArray.count > 0) {
                self.productTypeDataMArray = (NSMutableArray *)typeListArray;
                [self showSideView];
            }
        }
        else if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            
        }
    } failure:^(NSError *error) {
        //NSLog(@"%@",error);
    }];
}

- (void)showSideView {
    //[self.nameTextField resignFirstResponder];
    if (!self.sideView) {
        self.sideView = [[ZIKSideView alloc] initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight)];
    }
    self.sideView.pleaseSelectLabel.text = @"请选择苗木";
    self.sideView.selectView.uidDelegate = self;
    //    self.selectView = self.sideView.selectView;
    //    self.selectView.delegate = self;
    self.sideView.dataArray = self.productTypeDataMArray;
    self.sideView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:.3 animations:^{
        self.sideView.frame = CGRectMake(0, 0, kWidth, kHeight);
    }];
    [self addSubview:self.sideView];
}

- (void)didSelectorUid:(NSString *)selectId title:(NSString *)selectTitle {
    //NSLog(@"%@",selectTitle);
    self.nameTextField.text = selectTitle;
    [self.sideView removeSideViewAction];
    [self nameBtnAction:self.nameBtn];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
