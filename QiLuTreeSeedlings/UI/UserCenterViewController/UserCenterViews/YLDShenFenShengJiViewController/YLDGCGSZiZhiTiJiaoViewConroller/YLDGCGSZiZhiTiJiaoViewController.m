//
//  YLDGCGSZiZhiTiJiaoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/23.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDGCGSZiZhiTiJiaoViewController.h"
#import "ZIKMyHonorCollectionViewCell.h"
#import "YLDZiZhiAddViewController.h"
#import "UIImageView+AFNetworking.h"
#import "BWTextView.h"
#import "YLDPickLocationView.h"
#import "GetCityDao.h"
#import "HttpClient.h"
#import "JSONKit.h"
@interface YLDGCGSZiZhiTiJiaoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,YLDPickLocationDelegate,YLDZiZhiAddDelegate>
@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *honorData;
@property (nonatomic,copy)NSString *kHonorCellID;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,weak)UITextField *qiyeTextField;
@property (nonatomic,weak)UIButton *areaBtn;
@property (nonatomic,weak)UITextField *addressTextField;
@property (nonatomic,weak)UITextField *legalPersonField;
@property (nonatomic,weak)UITextField *phoneTextField;
@property (nonatomic,weak)UITextField *youbianTextField;
@property (nonatomic,weak)BWTextView *jieshaTextView;
@property (nonatomic,strong)NSString *AreaProvince;
@property (nonatomic,strong)NSString *AreaCity;
@property (nonatomic,strong)NSString *AreaCounty;
@property (nonatomic,strong)NSString *uid;
@property (nonatomic, assign) BOOL isEditState;
@end

@implementation YLDGCGSZiZhiTiJiaoViewController
{
    UILongPressGestureRecognizer *_tapDeleteGR;//长按手势
}
@synthesize kHonorCellID;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isEditState=NO;
    [self.collectionView reloadData];
}
-(id)initWithUid:(NSString *)uid
{
    self=[super init];
    if (self) {
        self.uid=uid;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"资质提交";
    self.honorData=[NSMutableArray array];
    //临时数据
//    NSString * honorPath = [[NSBundle mainBundle] pathForResource:@"honor" ofType:@"plist"];
//    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:honorPath];
//    NSArray *array = [dic objectForKey:@"honorList"];
//    [self.honorData addObjectsFromArray:array];
    
    
    kHonorCellID= @"honorcellID";
    static NSString *const HeaderIdentifier = @"HeaderIdentifier";
    self.headerView=[self creatHeaderView];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize=CGSizeMake(kWidth, self.headerView.frame.size.height);
    flowLayout.itemSize=  CGSizeMake(182, 160);
    if (kWidth != 375) {
        CGFloat itemWidth  = (kWidth-10)/2;
        CGFloat itemHeight =  itemWidth * 8 / 9;
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    }
    flowLayout.minimumLineSpacing=10;
    flowLayout.minimumInteritemSpacing=10;
    flowLayout.sectionInset=UIEdgeInsetsMake(0,0,0,0);
    UICollectionView *collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-60) collectionViewLayout:flowLayout];
    [collectionView setBackgroundColor:BGColor];
    collectionView.delegate=self;
    collectionView.dataSource=self;
    self.collectionView=collectionView;
    [self.view addSubview:collectionView];
      [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
      [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
    UIButton *tijiaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-50, kWidth-80, 40)];
    [tijiaoBtn setBackgroundColor:NavColor];
    [tijiaoBtn addTarget:self action:@selector(tijiaoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [tijiaoBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    [self.view addSubview:tijiaoBtn];
    //添加长按手势
    _tapDeleteGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR)];
    [self.collectionView addGestureRecognizer:_tapDeleteGR];
    if (self.uid) {
        ShowActionV();
        [HTTPCLIENT gongchenggongsiShengheTuiHuiBianJiSuccess:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *result=[responseObject objectForKey:@"result"];
                NSDictionary *companyInfo=[result objectForKey:@"companyInfo"];
                self.AreaProvince=companyInfo[@"province"];
                self.AreaCity=companyInfo[@"city"];
                self.AreaCounty=companyInfo[@"county"];
                [self.areaBtn setTitle:companyInfo[@"area"]forState:UIControlStateNormal];
                self.addressTextField.text=companyInfo[@"address"];
                self.qiyeTextField.text=companyInfo[@"companyName"];
                self.legalPersonField.text=companyInfo[@"legalPerson"];
                self.phoneTextField.text=companyInfo[@"phone"];
                self.youbianTextField.text=companyInfo[@"zipcode"];
                self.jieshaTextView.text=companyInfo[@"brief"];
                [self.honorData removeAllObjects];
                [self.honorData addObjectsFromArray:companyInfo[@"qualList"]];
                [self.collectionView reloadData];
                
            }else
            {
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            RemoveActionV();
        } failure:^(NSError *error) {
            RemoveActionV();
        }];
    }
    // Do any additional setup after loading the view.
}
- (void)tapGR {
    self.isEditState = YES;
    [self.collectionView reloadData];
}
-(void)tijiaoBtnAction:(UIButton *)sender
{
    if (self.qiyeTextField.text.length<=0) {
        [ToastView showTopToast:@"请输入企业名称"];
        
        return;
    }
    if (self.AreaProvince.length<=0) {
        [ToastView showTopToast:@"请选择地区"];
        
        return;
    }
    if (self.addressTextField.text.length<=0) {
        [ToastView showTopToast:@"请输入详细地址"];
        
        return;
    }
    if (self.legalPersonField.text.length<=0) {
        [ToastView showTopToast:@"请输入法人代表"];
        
        return;
    }
    if (self.phoneTextField.text.length<=0) {
        [ToastView showTopToast:@"请输入手机号"];
        
        return;
    }
//    if (self.youbianTextField.text.length<=0) {
//        [ToastView showTopToast:@"请输入邮编"];
//        
//        return;
//    }
//    if (self.jieshaTextView.text.length<=0) {
//        [ToastView showTopToast:@"请输入简介"];
//        
//        return;
//    }
    if (self.honorData.count<=0) {
        [ToastView showTopToast:@"请天加至少一条资质"];
        
        return;
    }
    NSString *rongyuStr=[self.honorData JSONString];
    ShowActionV();
    [HTTPCLIENT shengjiGCGSWithcompanyName:self.qiyeTextField.text WithlegalPerson:self.legalPersonField.text Withphone:self.phoneTextField.text Withzipcode:self.youbianTextField.text Withbrief:self.jieshaTextView.text Withprovince:self.AreaProvince Withcity:self.AreaCity Withcounty:self.AreaCounty Withaddress:self.addressTextField.text WithqualJson:rongyuStr Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"您已提交审核，敬请期待"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            APPDELEGATE.userModel.projectCompanyStatus=-1;
            
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        RemoveActionV();
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.honorData.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UINib *nib = [UINib nibWithNibName:@"ZIKMyHonorCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [cv registerNib:nib forCellWithReuseIdentifier:kHonorCellID];
    //ZIKIntegralCollectionViewCell *cell = [[ZIKIntegralCollectionViewCell alloc] init];
    ZIKMyHonorCollectionViewCell * cell = [cv dequeueReusableCellWithReuseIdentifier:kHonorCellID
                                                                        forIndexPath:indexPath];
    cell.isEditState = self.isEditState;
     cell.indexPath = indexPath;
    if (self.honorData.count > 0) {
        // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.honorData[indexPath.row] objectForKey:@"url"]]];
        NSString *myurlstr = [NSString stringWithFormat:@"%@",[self.honorData[indexPath.row] objectForKey:@"attachment"]];
        NSURL *honorUrl = [NSURL URLWithString:myurlstr];
       // NSURL *myurl    = [[NSURL alloc] initWithString:myurlstr];
       // NSLog(@"%@",myurl);
        [cell.honorImageView setImageWithURL:honorUrl placeholderImage:[UIImage imageNamed:@"MoRentu"]];
        cell.honorTitleLabel.text = [self.honorData[indexPath.row] objectForKey:@"companyQualification"];
        cell.level=[self.honorData[indexPath.row] objectForKey:@"level"];
        cell.honorTimeLabel.text  = [self.honorData[indexPath.row] objectForKey:@"acqueTime"];
        __weak typeof(self) weakSelf = self;//解决循环引用的问题
        cell.editButtonBlock = ^(NSIndexPath *indexPath) {
            NSDictionary *dic=self.honorData[indexPath.row];
            GCZZModel *model=[GCZZModel  GCZZModelWithDic:dic];
            model.uid=[NSString stringWithFormat:@"%ld",indexPath.row];
            YLDZiZhiAddViewController *addhonorVC = [[YLDZiZhiAddViewController alloc] initWithModel:model andType:1];
            addhonorVC.delegate=self;
            [weakSelf.navigationController pushViewController:addhonorVC animated:YES];
        };
        cell.deleteButtonBlock = ^(NSIndexPath *indexPath) {
           
            NSString *title = NSLocalizedString(@"资质删除", nil);
            NSString *message = NSLocalizedString(@"是否确定删除该资质？", nil);
            NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
            NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            
            // Create the actions.
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
               
            }];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
               [weakSelf.honorData removeObjectAtIndex:indexPath.row];
                      weakSelf.isEditState=NO;
                      [weakSelf.collectionView reloadData];
            }];
            
            // Add the actions.
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        
            //[weakSelf deleteRequest:model.uid];
        };

    }
    return cell;
}
-(void)addBtnAction
{
    YLDZiZhiAddViewController *viewCon=[[YLDZiZhiAddViewController alloc]initWithType:1];
    viewCon.delegate=self;
    [self.navigationController pushViewController:viewCon animated:YES];
}
-(void)reloadViewWithModel:(GCZZModel *)model andDic:(NSMutableDictionary *)dic
{
    if (model) {
        [self.honorData replaceObjectAtIndex:[model.uid integerValue] withObject:dic];
//        [self.honorData addObject:dic];
        [self.collectionView reloadData];
    }else{
        [self.honorData addObject:dic];
        [self.collectionView reloadData];
    }
  
}
//头部显示的内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView;

    if (kind == UICollectionElementKindSectionHeader) {
        
        headerView=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderIdentifier" forIndexPath:indexPath];
        
        [headerView addSubview:self.headerView];
        
    }
    return headerView;
}
-(UIView *)creatHeaderView{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, self.headerView.frame.size.height)];
    [view setBackgroundColor:BGColor];
    CGRect tempFrame=CGRectMake(0, 0, kWidth, 50);
    self.qiyeTextField=[self creatTextFieldWithName:@"企业名称" alortStr:@"请输入企业名称" andFrame:tempFrame andView:view];
    tempFrame.origin.y+=50;
    self.areaBtn=[self danxuanViewWithName:@"地区" alortStr:@"请选择地区" andFrame:tempFrame andView:view];
    [self.areaBtn addTarget:self action:@selector(areaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    tempFrame.origin.y+=50;
    self.addressTextField=[self creatTextFieldWithName:@"地址" alortStr:@"请输入地址" andFrame:tempFrame andView:view];
    tempFrame.origin.y+=50;
    self.legalPersonField=[self creatTextFieldWithName:@"法人代表" alortStr:@"请输入法人代表" andFrame:tempFrame andView:view];
    tempFrame.origin.y+=50;
    self.phoneTextField=[self creatTextFieldWithName:@"电话" alortStr:@"请输入电话号码" andFrame:tempFrame andView:view];
    tempFrame.origin.y+=50;
    self.youbianTextField=[self creatTextFieldWithName:@"邮编" alortStr:@"请输入邮编号码" andFrame:tempFrame andView:view];
    tempFrame.origin.y+=50;
    tempFrame.size.height=100;
    self.jieshaTextView=[self jianjieTextViewWithName:@"简介" WithAlort:@"请输入简介（不超过50字）" WithFrame:tempFrame andView:view];
    UIImageView *shuLvView=[[UIImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempFrame)+10, 5, 27)];
    [shuLvView setBackgroundColor:NavColor];
    [view addSubview:shuLvView];
    UILabel *shssLab=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(tempFrame)+10, 80, 27)];
    [shssLab setFont:[UIFont systemFontOfSize:15]];
    [shssLab setText:@"资质管理"];
    [shssLab setTextColor:DarkTitleColor];
    [view addSubview:shssLab];
    UIButton *addBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-80, CGRectGetMaxY(tempFrame), 60, 40)];
    [addBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [addBtn setTitleColor:NavColor forState:UIControlStateNormal];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn addTarget: self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *mssageV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-35, CGRectGetMaxY(tempFrame)+11.5, 17, 17)];
    mssageV.image=[UIImage imageNamed:@"PLUS"];
    [view addSubview:mssageV];
    [view addSubview:addBtn];
    CGRect frame=view.frame;
    frame.size.height=CGRectGetMaxY(tempFrame)+40;
    view.frame=frame;
    [view addSubview:self.headerView];
    return view;
}
-(void)areaBtnAction:(UIButton *)sender
{
    YLDPickLocationView *pickLocationV=[[YLDPickLocationView alloc]initWithFrame:[UIScreen mainScreen].bounds CityLeve:CityLeveXian];
    pickLocationV.delegate=self;
    [pickLocationV showPickView];
}
-(void)selectSheng:(CityModel *)sheng shi:(CityModel *)shi xian:(CityModel *)xian zhen:(CityModel *)zhen
{
    NSMutableString *namestr=[NSMutableString new];
    if (sheng.code) {
        [namestr appendString:sheng.cityName];
        self.AreaProvince=sheng.code;
    }else
    {
        self.AreaProvince=nil;
    }
    
    if (shi.code) {
        [namestr appendString:shi.cityName];
        self.AreaCity=shi.code;
    }else
    {
        self.AreaCity=nil;
        
    }
    if (xian.code) {
        [namestr appendString:xian.cityName];
        self.AreaCounty=xian.code;
    }else
    {
        self.AreaCounty=nil;
        
    }
    
    if (namestr.length>0) {
         [self.areaBtn setTitleColor:MoreDarkTitleColor forState:UIControlStateNormal];
        [self.areaBtn setTitle:namestr forState:UIControlStateNormal];
        [self.areaBtn.titleLabel sizeToFit];
    }else{
        [self.areaBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
        [self.areaBtn setTitle:@"请选择地区" forState:UIControlStateNormal];
        [self.areaBtn.titleLabel sizeToFit];
        
    }
}

-(UIButton *)danxuanViewWithName:(NSString *)nameStr alortStr:(NSString *)alortStr andFrame:(CGRect)frame andView:(UIView *)views
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, frame.size.height)];
    [nameLab setText:nameStr];
    [view addSubview:nameLab];
    [nameLab setTextColor:DarkTitleColor];
    [nameLab setFont:[UIFont systemFontOfSize:14]];
    UIButton *pickBtn=[[UIButton alloc]initWithFrame:CGRectMake(110, 0, 190/320.f*kWidth, frame.size.height)];
    pickBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    pickBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 17, 0, 0);
    [pickBtn setEnlargeEdgeWithTop:7 right:100 bottom:7 left:80];
    [pickBtn setTitle:alortStr forState:UIControlStateNormal];
    [pickBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    [pickBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    UIImageView *lineImagV=[[UIImageView alloc]initWithFrame:CGRectMake(10,frame.size.height-0.5, kWidth-20, 0.5)];
    [lineImagV setBackgroundColor:kLineColor];
    [view addSubview:lineImagV];
    UIImageView *imageVVV=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-42.5, 15, 15, 15)];
    [imageVVV setImage:[UIImage imageNamed:@"xiala2"]];
    [view addSubview:imageVVV];
    
    [view addSubview:pickBtn];
    [views addSubview:view];
    return pickBtn;
}

-(UITextField *)creatTextFieldWithName:(NSString *)nameStr alortStr:(NSString *)alortStr andFrame:(CGRect)frame andView:(UIView *)backView
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, frame.size.height)];
    [nameLab setText:nameStr];
    [nameLab setTextColor:DarkTitleColor];
    [nameLab setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:nameLab];
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(110, 0.5, 160/320.f*kWidth, frame.size.height-1)];
    textField.placeholder=alortStr;
    [view addSubview:textField];
    [textField setTextColor:MoreDarkTitleColor];
    [textField setFont:[UIFont systemFontOfSize:15]];
    UIImageView *lineImagV=[[UIImageView alloc]initWithFrame:CGRectMake(10,frame.size.height-0.5, kWidth-20, 0.5)];
    [lineImagV setBackgroundColor:kLineColor];
    
    [view addSubview:lineImagV];
    [backView addSubview:view];
    return textField;
}
-(BWTextView*)jianjieTextViewWithName:(NSString *)name WithAlort:(NSString *)alort WithFrame:(CGRect)frame andView:(UIView *)backView
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:[UIColor whiteColor]];
    [backView addSubview:view];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 50)];
    [nameLab setText:name];
    [nameLab setTextColor:DarkTitleColor];
    [nameLab setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:nameLab];
    
    BWTextView *TextView=[[BWTextView alloc]init];
    TextView.placeholder=@"请输入50字以内的说明...";
    TextView.tag=50;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:TextView];
    TextView.frame=CGRectMake(110, 10, kWidth-120, frame.size.height-20);
    TextView.font=[UIFont systemFontOfSize:16];
    TextView.textColor=DarkTitleColor;
    [view addSubview:TextView];
    return TextView;
}
- (void)textViewChanged:(NSNotification *)obj {
    BWTextView *textField = (BWTextView *)obj.object;
    NSInteger kssss=10;
    if (textField.tag>0) {
        kssss=textField.tag;
    }
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kssss) {
                // NSLog(@"最多%d个字符!!!",kMaxLength);
                [ToastView showToast:[NSString stringWithFormat:@"最多%ld个字符",kssss] withOriginY:250 withSuperView:self.view];
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
            [ToastView showToast:[NSString stringWithFormat:@"最多%ld个字符",kssss] withOriginY:250 withSuperView:self.view];
            textField.text = [toBeString substringToIndex:kssss];
            return;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
