//
//  SellDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/14.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "SellDetialViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "SupplyDetialMode.h"
#import "HotSellModel.h"
#import "SellBanderTableViewCell.h"
#import "SellSearchTableViewCell.h"
#import "BuyOtherInfoTableViewCell.h"
#import "SellQiyeInfoTableViewCell.h"
#import "SellSearchTableViewCell.h"
#import "BigImageViewShowView.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
@interface SellDetialViewController ()<UITableViewDataSource,UITableViewDelegate,SellBanderDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) UIButton *collectionBtn;
@property (nonatomic,strong)SupplyDetialMode *model;
@property (nonatomic,strong)NSArray *guseLikeAry;
@property (nonatomic,strong)HotSellModel *hotModel;
@property (nonatomic,strong)BigImageViewShowView *bigImageVShowV;
@end

@implementation SellDetialViewController
-(id)initWithUid:(HotSellModel *)model
{
    self.hotModel=model;
    self=[super init];
    if (self) {
        
        [HTTPCLIENT sellDetailWithUid:model.uid WithAccessID:APPDELEGATE.userModel.access_id Success:^(id responseObject) {
            
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *dic=[responseObject objectForKey:@"result"];
                SupplyDetialMode *model=[SupplyDetialMode creatSupplyDetialModelByDic:[dic objectForKey:@"detail"]];
                self.model=model;
                  BigImageViewShowView *bigImageVShowV=[[BigImageViewShowView  alloc]initWithImageAry:model.images];
                self.hotModel.title=model.title;
                self.bigImageVShowV=bigImageVShowV;
                [self.view addSubview:bigImageVShowV];
                if(model.collect)
                {
                    self.collectionBtn.selected=YES;
                }
                self.guseLikeAry=[HotSellModel hotSellAryByAry:[dic objectForKey:@"list"]];
              
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            
        }];
}
    return self;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, kWidth, kHeight-50) style:UITableViewStyleGrouped];
    self.tableView=tableView;
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    UIView *navView=[self makeNavView];
    [self.view addSubview:navView];
    
    UIButton *messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth/2, 50)];
    [messageBtn setBackgroundColor:[UIColor whiteColor]];
    [messageBtn setTitle:@"短信留言" forState:UIControlStateNormal];
    [messageBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    messageBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    [messageBtn addTarget:self action:@selector(meaageAction) forControlEvents:UIControlEventTouchUpInside];
    [messageBtn setImage:[UIImage imageNamed:@"shotMessageImage"] forState:UIControlStateNormal];
    [self.view addSubview:messageBtn];
    UIButton *phoneBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2, kHeight-50, kWidth/2, 50)];
    [phoneBtn setTitle:@"联系商家" forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    [phoneBtn setImage:[UIImage imageNamed:@"phoneImage"] forState:UIControlStateNormal];
    [phoneBtn setBackgroundColor:NavColor];
    [phoneBtn addTarget:self action:@selector(CallAction) forControlEvents:UIControlEventTouchUpInside];
    //[messageBtn setBackgroundColor:[UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1]];
    [self.view addSubview:phoneBtn];
    
    //    [APPDELEGATE]
}
-(void)CallAction
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.model.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)meaageAction
{     NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"sms://%@",self.model.phone];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 330;
    }
    if (indexPath.section==1) {
        if (self.model.spec.count>0) {
             return self.model.spec.count*30+40;
        }
       
    }
    if (indexPath.section==2) {
        return 130;
    }
    if (indexPath.section==3) {
        NSString *labelText=self.model.descriptions;

        if (labelText.length==0) {
            labelText=@"暂无";
        }
        return [self getHeightWithContent:labelText width:kWidth-40 font:13]+20;
    }
    if (indexPath.section==4) {
        return 100;
    }
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==4) {
        return self.guseLikeAry.count;
    }else
    {
    return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.01;
    }
    if(section==4)
    {
        return 50;
    }else
    {
        return 30;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view=[[UIView alloc]init];
        return view;
    }
    if (section==4) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
        [view setBackgroundColor:BGColor];
        UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 24.25, kWidth, 0.5)];
        [lineView setBackgroundColor:kLineColor];
        [view addSubview:lineView];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-35, 0, 70, 50)];
        [titleLab setTextColor:titleLabColor];
        [titleLab setBackgroundColor:BGColor];
        [titleLab setTextAlignment:NSTextAlignmentCenter];
        [titleLab setText:@"猜你喜欢"];
        [view addSubview:titleLab];
        return view;
    }
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    [view setBackgroundColor:BGColor];
    UIImageView *linImag=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 2.3, 16)];
    [linImag setBackgroundColor:NavColor];
    [view addSubview:linImag];
    UILabel *messageLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, 60, 20)];
    [messageLab setFont:[UIFont systemFontOfSize:13]];
    [messageLab setTextColor:detialLabColor];
    [view addSubview:messageLab];
    if (section==1) {
        messageLab.text=@"苗木要求";
    }else if (section==2){
        messageLab.text=@"其他信息";
    }else if (section==3){
        messageLab.text=@"产品描述";
    }
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.model) {
        if (indexPath.section==0) {
            SellBanderTableViewCell *cell=[[SellBanderTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 330) andModel:self.model andHotSellModel:self.hotModel];
            cell.delegate=self;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.section==1) {
            BuyOtherInfoTableViewCell *cell=[[BuyOtherInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, self.model.spec.count*30+40) andName:self.model.productName];
            cell.ary=self.model.spec;
             cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if(indexPath.section==2)
        {
            SellQiyeInfoTableViewCell *cell=[[SellQiyeInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 30*4+10)];
            cell.model=self.model;
             cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    if(indexPath.section==3)
    {
        
        NSString *labelText=self.model.descriptions;
        if (labelText.length==0) {
            labelText=@"暂无";
        }
        
        CGFloat height = [self getHeightWithContent:labelText width:kWidth-40 font:13];
        //NSLog(@"%f",height);
        UITableViewCell *cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kWidth, height+20)];
        UILabel *cellLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, kWidth-40, height)];
        [cellLab setTextColor:titleLabColor];
        [cellLab setFont:[UIFont systemFontOfSize:13]];
        cellLab.numberOfLines=0;
        [cell addSubview:cellLab];
        [cellLab setText:labelText];
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    if (indexPath.section==4) {
        SellSearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[SellSearchTableViewCell IDStr]];
        if (!cell) {
            cell=[[SellSearchTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 100)];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.hotSellModel=self.guseLikeAry[indexPath.row];
        return cell;
    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}
//图片点击效果
-(void)showBigImageWtihIndex:(NSInteger)index
{
    if (self.bigImageVShowV) {
      [self.bigImageVShowV showWithIndex:index];
    }
    
}
//获取字符串的高度
-(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
}

-(UIView *)makeNavView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:0 right:15 bottom:0 left:3];
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80,26, 160, 30)];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setText:@"供应详情"];
    [titleLab setFont:[UIFont systemFontOfSize:20]];
        [view addSubview:titleLab];
    UIButton *collectionBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-40, 26, 30, 30)];
    self.collectionBtn = collectionBtn;
    [collectionBtn setImage:[UIImage imageNamed:@"collectionN"] forState:UIControlStateNormal];
    [collectionBtn setImage:[UIImage imageNamed:@"collectionT"] forState:UIControlStateSelected];
    [collectionBtn addTarget:self action:@selector(collectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:collectionBtn];
    return view;
}
-(void)collectionBtn:(UIButton *)sender
{
        if (sender.selected==NO) {
            [HTTPCLIENT collectSupplyWithSupplyNuresyid:self.model.uid Success:^(id responseObject) {
                
                if ([[responseObject objectForKey:@"success"] integerValue]) {
                    [ToastView showTopToast:@"收藏成功"];
                    sender.selected=YES;
                    [HTTPCLIENT sellDetailWithUid:self.hotModel.uid WithAccessID:APPDELEGATE.userModel.access_id Success:^(id responseObject) {
                        //NSLog(@"供应详情：%@",responseObject);
                        if ([[responseObject objectForKey:@"success"] integerValue]) {
                            NSDictionary *dic=[responseObject objectForKey:@"result"];
                            SupplyDetialMode *model=[SupplyDetialMode creatSupplyDetialModelByDic:[dic objectForKey:@"detail"]];
                            self.model=model;
                            
                        }
                    } failure:^(NSError *error) {
                        
                    }];

                    return ;
                }
            } failure:^(NSError *error) {
                return ;
            }];
        }
    if (sender.selected) {
        
//        NSArray *ary=[NSArray arrayWithObject:self.model.collectUid];
        NSMutableString *keystr=[NSMutableString new];
        [keystr appendFormat:@"%@",self.model.collectUid];
        [HTTPCLIENT deletesenderCollectWithIds:keystr Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                sender.selected=NO;
                [ToastView showTopToast:@"取消收藏成功"];
                }
        } failure:^(NSError *error) {
            
        }];
    }
    //NSLog(@"collectionBtnAction");
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSString *)jsonAnswerStrWithAry:(NSArray *)ary
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ary options:NSJSONWritingPrettyPrinted error:&parseError];
    
   NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==4) {
       HotSellModel  *model=self.guseLikeAry[indexPath.row];
        
        SellDetialViewController *vc=[[SellDetialViewController alloc]initWithUid:model];
        [self.navigationController pushViewController:vc
                                             animated:YES];
//        BuyDetialInfoViewController *vc=[[BuyDetialInfoViewController alloc]initWithSaercherInfo:model.uid];
        //[self.navigationController pushViewController:vc animated:YES];
    }
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
