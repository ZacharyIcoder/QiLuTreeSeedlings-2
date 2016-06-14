//
//  YLDFaBuGongChengDingDanViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDFaBuGongChengDingDanViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "PickerShowView.h"
@interface YLDFaBuGongChengDingDanViewController ()<PickeShowDelegate>
@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong) NSArray *typeAry;
@property (nonatomic,strong) NSArray *piceAry;
@property (nonatomic,strong) NSArray *qualityAry;
@end

@implementation YLDFaBuGongChengDingDanViewController
@synthesize typeAry;
-(id)init
{
    self=[super init];
    if (self) {
        [HTTPCLIENT huiquZhiliangYaoQiuBaoDingSuccess:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]==1) {
                NSDictionary *result=[responseObject objectForKey:@"result"];
                NSArray *bigDataAry=[result objectForKey:@"lxBeanList"];
                for (int i=0; i<bigDataAry.count; i++) {
                    NSDictionary *ddddis=bigDataAry[i];
                    NSString *lxName=ddddis[@"lxName"];
                    if ([lxName isEqualToString:@"订单类型"]) {
                        self.typeAry=ddddis[@"zidianList"];
                    }
                    if ([lxName isEqualToString:@"报价要求"]) {
                         self.piceAry=ddddis[@"zidianList"];
                    }
                    if ([lxName isEqualToString:@"质量要求"]) {
                        self.qualityAry=ddddis[@"zidianList"];
                    }
                }
            }else
            {
              [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }

        } failure:^(NSError *error) {
            
        }];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle = @"订单发布";
    UIScrollView *backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    [backScrollView setBackgroundColor:BGColor];
    [self.view addSubview:backScrollView];
    CGRect tempFrame=CGRectMake(0, 67, kWidth, 50);
    UIButton *pickTypeBtn=[self danxuanViewWithName:@"订单类型" alortStr:@"请输入订单类型" andFrame:tempFrame];
    [pickTypeBtn addTarget:self action:@selector(pickTypeBtnAcion:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}
-(void)pickTypeBtnAcion:(UIButton *)sender
{
    NSMutableArray *newAry=[NSMutableArray array];
    for (int i=0; i<self.typeAry.count; i++) {
        NSDictionary *dic=self.typeAry[i];
        NSString *name=dic[@"name"];
        [newAry addObject:name];
    }
    PickerShowView *pickerSV=[[PickerShowView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    pickerSV.delegate=self;
    [pickerSV resetPickerData:newAry];
    [pickerSV showInView];
}
-(UIButton *)danxuanViewWithName:(NSString *)nameStr alortStr:(NSString *)alortStr andFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, frame.size.height)];
    [nameLab setText:nameStr];
    [nameLab setTextColor:DarkTitleColor];
    [nameLab setFont:[UIFont systemFontOfSize:14]];
    UIButton *pickBtn=[[UIButton alloc]initWithFrame:CGRectMake(110, 0, 160/320.f*kWidth, frame.size.height)];
    pickBtn.center=CGPointMake(frame.size.width/2+10,frame.size.height/2);
    [pickBtn setEnlargeEdgeWithTop:7 right:100 bottom:7 left:80];
    [pickBtn setTitle:alortStr forState:UIControlStateNormal];
    [pickBtn setTitleColor:titleLabColor forState:UIControlStateNormal];
    [pickBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    UIImageView *lineImagV=[[UIImageView alloc]initWithFrame:CGRectMake(10,frame.size.height-0.5, kWidth-20, 0.5)];
    [lineImagV setBackgroundColor:kLineColor];
    [view addSubview:lineImagV];
    UIImageView *imageVVV=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-42.5, 15, 15, 15)];
    [imageVVV setImage:[UIImage imageNamed:@"xiala2"]];
    [view addSubview:imageVVV];

    [view addSubview:pickBtn];
    return pickBtn;
}
-(UITextField *)creatTextFieldWithName:(NSString *)nameStr alortStr:(NSString *)alortStr andFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, frame.size.height)];
    [nameLab setText:nameStr];
    [nameLab setTextColor:DarkTitleColor];
    [nameLab setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:nameLab];
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(110, 7, 160/320.f*kWidth, 30)];
    textField.placeholder=alortStr;
    [view addSubview:textField];
    UIImageView *lineImagV=[[UIImageView alloc]initWithFrame:CGRectMake(10,frame.size.height-0.5, kWidth-20, 0.5)];
    [lineImagV setBackgroundColor:kLineColor];
    [view addSubview:lineImagV];
    return textField;
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
