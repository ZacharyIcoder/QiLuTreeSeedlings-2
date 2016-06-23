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
@interface YLDGCGSZiZhiTiJiaoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *honorData;
@property (nonatomic,copy)NSString *kHonorCellID;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,weak)UITextField *qiyeTextField;
@property (nonatomic,weak)UITextField *areaTextField;
@property (nonatomic,weak)UITextField *addressTextField;
@property (nonatomic,weak)UITextField *legalPersonField;
@property (nonatomic,weak)UITextField *phoneTextField;
@property (nonatomic,weak)UITextField *youbianTextField;
@property (nonatomic,weak)BWTextView *jieshaTextView;
@end

@implementation YLDGCGSZiZhiTiJiaoViewController
@synthesize kHonorCellID;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"资质提交";
    self.honorData=[NSMutableArray array];
    //临时数据
    NSString * honorPath = [[NSBundle mainBundle] pathForResource:@"honor" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:honorPath];
    NSArray *array = [dic objectForKey:@"honorList"];
    [self.honorData addObjectsFromArray:array];
    
    
    kHonorCellID= @"honorcellID";
    static NSString *const HeaderIdentifier = @"HeaderIdentifier";
    self.headerView=[self creatHeaderView];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize=CGSizeMake(kWidth, self.headerView.frame.size.height);
    flowLayout.itemSize=  CGSizeMake(180, 145);
    flowLayout.minimumLineSpacing=5;
    flowLayout.minimumInteritemSpacing=5;
    flowLayout.sectionInset=UIEdgeInsetsMake(5, 5,5,5);
    UICollectionView *collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-60) collectionViewLayout:flowLayout];
    [collectionView setBackgroundColor:BGColor];
    collectionView.delegate=self;
    collectionView.dataSource=self;
    [self.view addSubview:collectionView];
      [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
      [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
    UIButton *tijiaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-50, kWidth-80, 40)];
    [tijiaoBtn setBackgroundColor:NavColor];
    [tijiaoBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    [self.view addSubview:tijiaoBtn];

    // Do any additional setup after loading the view.
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
    if (self.honorData.count > 0) {
        // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.honorData[indexPath.row] objectForKey:@"url"]]];
        NSString *myurlstr = [NSString stringWithFormat:@"%@",[self.honorData[indexPath.row] objectForKey:@"url"]];
        NSURL *honorUrl = [NSURL URLWithString:myurlstr];
        NSURL *myurl    = [[NSURL alloc] initWithString:myurlstr];
       // NSLog(@"%@",myurl);
        [cell.honorImageView setImageWithURL:honorUrl placeholderImage:[UIImage imageNamed:@"MoRentu"]];
        cell.honorTitleLabel.text = [self.honorData[indexPath.row] objectForKey:@"title"];
        cell.honorTimeLabel.text  = [self.honorData[indexPath.row] objectForKey:@"time"];
    }
    return cell;
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
    self.areaTextField=[self creatTextFieldWithName:@"地区" alortStr:@"请输入地区名称" andFrame:tempFrame andView:view];
    tempFrame.origin.y+=50;
    self.addressTextField=[self creatTextFieldWithName:@"地址" alortStr:@"请输入地址" andFrame:tempFrame andView:view];
    tempFrame.origin.y+=50;
    self.legalPersonField=[self creatTextFieldWithName:@"法人代表" alortStr:@"请输入法人代表" andFrame:tempFrame andView:view];
    tempFrame.origin.y+=50;
    self.phoneTextField=[self creatTextFieldWithName:@"电话" alortStr:@"请输入电话号码" andFrame:tempFrame andView:view];
    tempFrame.origin.y+=50;
    self.phoneTextField=[self creatTextFieldWithName:@"邮编" alortStr:@"请输入邮编号码" andFrame:tempFrame andView:view];
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
-(void)addBtnAction
{
    YLDZiZhiAddViewController *viewCon=[[YLDZiZhiAddViewController alloc]init];
    [self.navigationController pushViewController:viewCon animated:YES];
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
