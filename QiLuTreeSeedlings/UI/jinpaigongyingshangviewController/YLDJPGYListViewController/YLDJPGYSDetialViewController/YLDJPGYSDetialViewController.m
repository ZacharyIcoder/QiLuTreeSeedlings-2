//
//  YLDJPGYSDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDJPGYSDetialViewController.h"
#import "HttpClient.h"
#import "YLDJPGYSDBigCell.h"
#import "YLDJPGYSJJCell.h"
#import "YLDJPGYSInfoLabCell.h"
#import "ZIKMyHonorViewController.h"
#import "ZIKStationShowHonorView.h"
#import "ZIKStationHonorListModel.h"
#import "YYModel.h"
#import "yYLDGZZRongYaoTableCell.h"
#import "ZIKBaseCertificateAdapter.h"
#import "ZIKCertificateAdapter.h"
#import "ZIKMyShopViewController.h"
@interface YLDJPGYSDetialViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy) NSDictionary *dic;
@property (nonatomic) BOOL isShow;
@property (nonatomic,strong) NSMutableArray *honorAry;
@property (nonatomic, strong) ZIKStationShowHonorView *showHonorView;
@end

@implementation YLDJPGYSDetialViewController
-(id)initWithUid:(NSString *)memberUid
{
    self=[super init];
    if (self) {
        self.uid=memberUid;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.honorAry=[NSMutableArray array];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [HTTPCLIENT goldSupplyDetialWithUid:self.uid Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            self.dic=[responseObject objectForKey:@"result"];
            NSArray *honorList=[self.dic objectForKey:@"list"];
            [honorList enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKStationHonorListModel *honorListModel = [ZIKStationHonorListModel yy_modelWithDictionary:dic];
                [self.honorAry addObject:honorListModel];
            }];
            [tableView reloadData];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 200;
    }
    if (indexPath.row==1) {
        if (_isShow) {
            NSString *str=self.dic[@"brief"];
            NSString *jianjieStr=@"简介：";
            if (str.length>0) {
                jianjieStr = [NSString stringWithFormat:@"简介：%@",str];
            }
            CGFloat hightzz=[self getHeightWithContent:jianjieStr width:kWidth-24 font:15];
            if (hightzz>40) {
                return hightzz+40;
              
            }else{
                return 80;
            }
        }else{
           return 80;
        }

        
    }
    if (indexPath.row==2) {
        NSString *companyName=self.dic[@"companyName"];
        if (companyName.length>0) {
            CGFloat hiss=[self getHeightWithContent:companyName width:kWidth-124 font:15];
            if (hiss>18) {
                return 160;
            }
        }
        
        return 140;
    }
    if(indexPath.row==3)
    {
        if (self.honorAry.count<=0) {
            return 60;
        }
        return 170;
    }
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        YLDJPGYSDBigCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDJPGYSDBigCell"];
        if (!cell) {
            cell=[YLDJPGYSDBigCell YLDJPGYSDBigCell];
            [cell.backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.touxiangBtn addTarget:self action:@selector(touxiangBtnAction) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.dic=self.dic;
        return cell;
    }
    if (indexPath.row==1) {
        YLDJPGYSJJCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDJPGYSJJCell"];
        if (!cell) {
            cell=[YLDJPGYSJJCell yldJPGYSJJCell];
            [cell.chakanBtn addTarget:self action:@selector(chakanBtnAction) forControlEvents:UIControlEventTouchUpInside];
        }
        NSString *str=self.dic[@"brief"];
        NSString *jianjieStr=@"简介：";
        if (str.length>0) {
            jianjieStr = [NSString stringWithFormat:@"简介：%@",str];
        }
        CGRect frame=cell.frame;
         CGFloat hightzz=[self getHeightWithContent:jianjieStr width:kWidth-24 font:15];
        if (hightzz<40) {
            cell.chakanBtn.hidden=YES;
        }
        if (_isShow) {
          CGFloat hightzz=[self getHeightWithContent:jianjieStr width:kWidth-24 font:15];
            if (hightzz>40) {
                frame.size.height=hightzz+40;
                cell.frame=frame;
                cell.chakanBtn.hidden=NO;
                cell.chakanBtn.selected=YES;
            }
        }else{
            frame.size.height=80;
            cell.frame=frame;
            cell.chakanBtn.selected=NO;
        }
        
        cell.jianjieStr=jianjieStr;
        return cell;
    }
    if (indexPath.row==2) {
        YLDJPGYSInfoLabCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDJPGYSInfoLabCell"];
        if (!cell) {
            cell=[YLDJPGYSInfoLabCell yldJPGYSInfoLabCell];
        }
        NSString *companyName=self.dic[@"companyName"];
        if (companyName.length>0) {
            CGFloat hiss=[self getHeightWithContent:companyName width:kWidth-124 font:15];
            CGRect frame =cell.frame;
            if (hiss>18) {
                frame.size.height=160;
            }else{
                frame.size.height=140;
            }
            cell.frame=frame;
        }
        
        

        cell.dic=self.dic;
        return cell;
    }
    if (indexPath.row==3) {
        yYLDGZZRongYaoTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"yYLDGZZRongYaoTableCell"];
        if (!cell) {
            cell =[yYLDGZZRongYaoTableCell yldGZZRongYaoTableCell];
            cell.dataAry=self.honorAry;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell.allBtn addTarget:self action:@selector(allRongYuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell showImageActionBlock:^(ZIKStationHonorListModel *model) {
                if (!self.showHonorView) {
                    self.showHonorView = [ZIKStationShowHonorView instanceShowHonorView];
                    self.showHonorView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
                }
                ZIKBaseCertificateAdapter *modelAdapter = [[ZIKCertificateAdapter alloc] initWithData:model];
                [self.showHonorView loadData:modelAdapter];
                
                
                [self.view addSubview:self.showHonorView];
                [UIView animateWithDuration:.3 animations:^{
                    self.showHonorView.frame = CGRectMake(0, 0, kWidth, kHeight);
                }];
            }];
        }
        return cell;

    }
    UITableViewCell *cell=[UITableViewCell new];
    
    return cell;
}
-(void)allRongYuBtnAction:(UIButton *)sender
{
    ZIKMyHonorViewController *zsdasda=[[ZIKMyHonorViewController alloc]init];
    zsdasda.type = TypeJPGYSHonorOther;
    zsdasda.memberUid=self.uid;
    [self.navigationController pushViewController:zsdasda animated:YES];
}
-(void)touxiangBtnAction
{
    ZIKMyShopViewController *shopVC = [[ZIKMyShopViewController alloc] init];
    shopVC.memberUid = self.uid;
    shopVC.type = 1;
    [self.navigationController pushViewController:shopVC animated:YES];
}
-(void)chakanBtnAction
{
    _isShow=!_isShow;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}
//获取字符串的高度
-(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
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
