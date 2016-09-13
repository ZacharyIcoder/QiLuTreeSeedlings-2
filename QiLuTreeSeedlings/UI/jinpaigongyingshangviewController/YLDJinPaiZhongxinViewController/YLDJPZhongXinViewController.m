//
//  YLDJPZhongXinViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/13.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDJPZhongXinViewController.h"
#import "YLDJPGYSInfoViewController.h"
#import "YLDJPGYSDBigCell.h"
#import "HttpClient.h"
#import "UIDefines.h"
#import "YLDJPGYSJJCell.h"
#import "YLDJPGYSInfoLabCell.h"
#import "YLDGCZXzizhiCell.h"
@interface YLDJPZhongXinViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSDictionary *dic;
@property (nonatomic) BOOL isShow;
@end

@implementation YLDJPZhongXinViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getdata];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, -20, kWidth, kHeight-50) style:UITableViewStylePlain];
    tableView.dataSource=self;
    tableView.delegate=self;
    self.tableView=tableView;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone; 
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view.
}
-(void)getdata
{
    [HTTPCLIENT goldSupplierInfoSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]==1) {
            self.dic=[responseObject objectForKey:@"result"];
            [self.tableView reloadData];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
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
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        YLDJPGYSDBigCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDJPGYSDBigCell"];
        
        if (!cell) {
            cell=[YLDJPGYSDBigCell YLDJPGYSDBigCell];
        }
        cell.myDic=self.dic;
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
   
    if (indexPath.row==0) {
        YLDGCZXzizhiCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGCZXzizhiCell"];
        if (!cell) {
            cell=[YLDGCZXzizhiCell yldGCZXzizhiCell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [cell setMessageWithImageName:@"GCZXgongsizizhi.png" andTitle:@"公司资质"];
        return cell;
    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}
-(void)touxiangBtnAcion
{
    YLDJPGYSInfoViewController *vvcc=[[YLDJPGYSInfoViewController alloc]init];
    [self.navigationController pushViewController:vvcc animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row==3)
    {
        
    }
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
