//
//  YLDZhanZhangMessageViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDZhanZhangMessageViewController.h"
#import "ZIKMyHonorViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "YLDGongZuoZhanMessageCell.h"
#import "YLDZhanZhangMessageCell.h"
#import "YLDGongZuoZhanJianJieCell.h"
#import "yYLDGZZRongYaoTableCell.h"
#import "MJRefresh.h"
#import "YLDZhanZhangDetialModel.h"
#import "HotSellModel.h"
#import "SellSearchTableViewCell.h"
#import "ZIKStationHonorListModel.h"
#import "YYModel.h"
#import "SellDetialViewController.h"
#import "ZIKStationShowHonorView.h"//
#import "ZIKBaseCertificateAdapter.h"
#import "ZIKCertificateAdapter.h"
#import "ZIKMyShopViewController.h"

#import "SearchViewController.h"
@interface YLDZhanZhangMessageViewController ()<UITableViewDelegate,UITableViewDataSource,YLDZhanZhangMessageCellDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic)NSInteger pageNum;
@property (nonatomic,strong)YLDZhanZhangDetialModel *model;
@property (nonatomic,strong)NSMutableArray *supplyAry;
@property (nonatomic,strong)NSMutableArray *honorAry;
@property (nonatomic)BOOL isShow;
@property (nonatomic, strong) ZIKStationShowHonorView *showHonorView;
@end

@implementation YLDZhanZhangMessageViewController
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
    self.supplyAry=[NSMutableArray array];
    self.honorAry=[NSMutableArray array];
    self.isShow=NO;
    self.pageNum=1;
     self.edgesForExtendedLayout = UIRectEdgeNone;
    UITableView *talbeView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    talbeView.delegate=self;
    talbeView.dataSource=self;
    talbeView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView=talbeView;
    [self.view addSubview:talbeView];
    __weak typeof(self)weakSelf=self;
    [talbeView addHeaderWithCallback:^{
       
        weakSelf.pageNum=1;
         ShowActionV();
        [weakSelf getDatListWithPageNum:weakSelf.pageNum];
    }];
    [talbeView addFooterWithCallback:^{
        weakSelf.pageNum+=1;
         ShowActionV();
        [weakSelf getDatListWithPageNum:weakSelf.pageNum];
   }];
    [talbeView headerBeginRefreshing];
//    [self getDatListWithPageNum:self.pageNum];
    // Do any additional setup after loading the view.
}
-(void)getDatListWithPageNum:(NSInteger)pageNum
{
    [HTTPCLIENT workstationdetialWithuid:self.uid WithpageNumber:[NSString stringWithFormat:@"%ld",(long)pageNum] WithpageSize:@"15" Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *result=[responseObject objectForKey:@"result"];
            if (self.pageNum==1) {
                self.model=[YLDZhanZhangDetialModel yldZhanZhangDetialModelWithDic:[result objectForKey:@"masterInfo"]];
                [self.supplyAry removeAllObjects];
                [self.honorAry removeAllObjects];
                NSArray *honorList=[result objectForKey:@"honorList"];
                [honorList enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZIKStationHonorListModel *honorListModel = [ZIKStationHonorListModel yy_modelWithDictionary:dic];
                    [self.honorAry addObject:honorListModel];
                }];

            }
            NSArray *supplyList=[result objectForKey:@"supplyList"];
            if (supplyList.count<=0) {
                if (self.pageNum!=1) {
                  [ToastView showTopToast:@"已无更多数据"];
                }
                  self.pageNum--;
            }else{
                NSArray *supplyary=[HotSellModel hotSellAryByAry:supplyList];
                [self.supplyAry addObjectsFromArray:supplyary];
            }
            [self.tableView reloadData];
            
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        RemoveActionV();
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } failure:^(NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        RemoveActionV();
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==4) {
        return self.supplyAry.count;
    }else{
       return 1; 
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 200;
    }
    if (indexPath.section==1) {
        if (self.isShow) {
        CGFloat hiss=[self getHeightWithContent:self.model.brief width:kWidth-20 font:15];
            if (hiss>40) {
                return hiss+40;
            }else{
                return 80;
            }
        }else{
          return 80;
        }
        
    }
    if (indexPath.section==2) {
        CGFloat hiss=[self getHeightWithContent:self.model.workstationName width:kWidth-124 font:15];
        if (hiss>18) {
            return 140;
        }
        return 120;
    }
    if (indexPath.section==3) {
        if (self.honorAry.count<=0) {
            return 60;
        }
        return 170;
    }
    if (indexPath.section==4) {
        return 100;
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1||section==0) {
        return 0.01;
    }else if(section==4)
    {
        return 55;
    }else{
        return 10;
    }
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        
        YLDZhanZhangMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDZhanZhangMessageCell"];
        if (!cell) {
            cell=[YLDZhanZhangMessageCell yldZhanZhangMessageCell];
            cell.delegate=self;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.model=self.model;
        return cell;
        
    }
    if (indexPath.section==1) {
        
        YLDGongZuoZhanJianJieCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGongZuoZhanJianJieCell"];
        if (!cell) {
            cell=[YLDGongZuoZhanJianJieCell yldGongZuoZhanJianJieCell];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell.moreBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
        }
        CGRect frame=cell.frame;
        if (self.isShow) {
            CGFloat hiss=[self getHeightWithContent:self.model.brief width:kWidth-20 font:15];
            frame.size.height=hiss+40;
            cell.moreBtn.selected=YES;
        }else{
            frame.size.height=80;
            cell.moreBtn.selected=NO;
            CGFloat hiss=[self getHeightWithContent:[NSString stringWithFormat:@"简介%@",self.model.brief] width:kWidth-20 font:15];
            if (hiss<40) {
                cell.moreBtn.hidden=YES;
            }
        }
        cell.frame=frame;
        cell.jianjieStr=self.model.brief;
        return cell;
        
    }
    if (indexPath.section==2) {
        
        YLDGongZuoZhanMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGongZuoZhanMessageCell"];
        if (!cell) {
            cell=[YLDGongZuoZhanMessageCell yldGongZuoZhanMessageCell];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.model=self.model;
        return cell;
        
    }
    if(indexPath.section==3)
    {
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
    if (indexPath.section==4) {
        SellSearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[SellSearchTableViewCell IDStr]];
        if (!cell) {
            cell=[[SellSearchTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 100)];
        }
        cell.hotSellModel=self.supplyAry[indexPath.row];
        return cell;
    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section==4) {
        return [self makeTitleViewWithTitle:@"供应" AndColor:NavColor andY:13];
    }
    UIView *view;
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==4) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        HotSellModel *model=self.supplyAry[indexPath.row];
        SellDetialViewController *sellDetialViewC=[[SellDetialViewController alloc]initWithUid:model];
        [self.navigationController pushViewController:sellDetialViewC animated:YES];
    }
}
-(void)moreBtnAction
{
    self.isShow=!self.isShow;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
    
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
-(void)showShopAcionWithUid:(NSString *)uid
{
        ZIKMyShopViewController *shopVC = [[ZIKMyShopViewController alloc] init];
    
        shopVC.memberUid = uid;
        shopVC.type = 1;
        [self.navigationController pushViewController:shopVC animated:YES];
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)allRongYuBtnAction:(UIButton *)sender
{
    ZIKMyHonorViewController *zsdasda=[[ZIKMyHonorViewController alloc]init];
    zsdasda.type = TypeHonorOther;
    zsdasda.workstationUid=self.model.uid;
    [self.navigationController pushViewController:zsdasda animated:YES];
}
//构建小标题栏
-(UIView *)makeTitleViewWithTitle:(NSString *)title AndColor:(UIColor *)color andY:(CGFloat )y
{
    UIView *sectionFourHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 55)];
    sectionFourHeaderView.backgroundColor = [UIColor whiteColor];

    UIView *bgColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    bgColorView.backgroundColor = kRGB(239, 239, 244, 1);
    [sectionFourHeaderView addSubview:bgColorView];

    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, y, kWidth, 36)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [sectionFourHeaderView addSubview:view];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 7, 22)];
    [imageV setBackgroundColor:color];
    [view addSubview:imageV];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(25, 0, 70, 36)];
    titleLab.text=title;
    [titleLab setTextColor:color];
    [titleLab setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:titleLab];

    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(kWidth-46-15-10+5, 4, 46, 30);
    [button setTitle:@"更多" forState:UIControlStateNormal];
    [button setTitleColor:detialLabColor forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [button.titleLabel setTextAlignment:NSTextAlignmentRight];
    [view addSubview:button];

    [button addTarget:self action:@selector(gongYingMoreButton) forControlEvents:UIControlEventTouchUpInside];

    UIButton *imageButton = [[UIButton alloc] init];
    imageButton.frame = CGRectMake(kWidth-10-15, 11, 15, 15);
    [imageButton setBackgroundImage:[UIImage imageNamed:@"moreRow"] forState:UIControlStateNormal];
    [view addSubview:imageButton];
    [imageButton addTarget:self action:@selector(gongYingMoreButton) forControlEvents:UIControlEventTouchUpInside];


    UIView *lineV=[[UIView alloc]initWithFrame:CGRectMake(10, 54, kWidth-20, 0.5)];
    [lineV setBackgroundColor:kLineColor];
    [sectionFourHeaderView addSubview:lineV];
    return sectionFourHeaderView;
    
}

- (void)gongYingMoreButton {
    SearchViewController *searVC=[[SearchViewController alloc]initWithSearchType:1];
    [self.navigationController pushViewController:searVC animated:YES];
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
