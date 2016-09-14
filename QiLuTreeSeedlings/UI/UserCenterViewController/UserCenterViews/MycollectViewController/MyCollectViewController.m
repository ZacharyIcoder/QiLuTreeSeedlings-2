//
//  MyCollectViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/12.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "MyCollectViewController.h"
#import "UIDefines.h"
#import "MJRefresh.h"
#import "HttpClient.h"
#import "ToastView.h"
#import "HotBuyModel.h"
#import "HotSellModel.h"
#import "BuySearchTableViewCell.h"
#import "SellSearchTableViewCell.h"
#import "noOneCollectCell.h"
#import "BuyDetialInfoViewController.h"
#import "SellDetialViewController.h"
#import "SearchViewController.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
@interface MyCollectViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)UIImageView *moveImageV;
//@property (nonatomic,strong)UIButton *nowBtn;
@property (nonatomic,strong)UIButton *gongyingBtn;
@property (nonatomic,strong)UIButton *qiugouBtn;
@property (nonatomic,strong)UITableView *buyTableView;
@property (nonatomic,strong)UITableView *sellTableView;
@property (nonatomic,strong)UIScrollView *backScrollView;
@property (nonatomic,strong)NSMutableArray *buyDataAry;
@property (nonatomic,strong)NSMutableArray *sellDataAry;
@property (nonatomic,strong)NSMutableArray *buyLikeAry;
@property (nonatomic,strong)NSMutableArray *sellLikeAry;
@property (nonatomic)NSInteger sellPageCount;
@property (nonatomic)NSInteger buyPageCount;
@end

@implementation MyCollectViewController
@synthesize sellPageCount,buyPageCount;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.sellDataAry removeAllObjects];
//    [self.buyDataAry removeAllObjects];
    sellPageCount=1;
    buyPageCount=1;
    [self getbuyDataAryWtihPage:[NSString stringWithFormat:@"%ld",(long)buyPageCount] andPageSiz:@"10"];
    [self getSellDataAryWithPage:[NSString stringWithFormat:@"%ld",(long)sellPageCount] andPageSize:@"10"];
}
-(void)dealloc
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *navView=[self makeNavView];
    self.buyDataAry=[NSMutableArray array];
    self.sellDataAry=[NSMutableArray array];
    self.buyLikeAry=[NSMutableArray array];
    self.sellLikeAry=[NSMutableArray array];
    [self.view addSubview:navView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *gongyingBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 64, kWidth/2+1, 44)];
    UIView *gongyingViw=[[UIView alloc]initWithFrame:gongyingBtn.frame];
    [gongyingViw setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:gongyingViw];
    [gongyingBtn setTitle:@"供应信息" forState:UIControlStateNormal];
    gongyingViw.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
    gongyingViw.layer.shadowOffset = CGSizeMake(-3,3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    gongyingViw.layer.shadowOpacity = 0.5;//阴影透明度，默认0
   gongyingViw.layer.shadowRadius = 3;//阴影半径，默认3
    [gongyingBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [gongyingBtn setTitleColor:NavColor forState:UIControlStateSelected];
    gongyingBtn.tag=11;
    gongyingBtn.selected=YES;
    self.gongyingBtn=gongyingBtn;
    [gongyingBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gongyingBtn];
   
    
    UIButton *qiugouBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2, 64, kWidth/2, 44)];
    [qiugouBtn setTitle:@"求购信息" forState:UIControlStateNormal];
    [qiugouBtn setTitleColor:titleLabColor forState:UIControlStateNormal];
    [qiugouBtn setTitleColor:NavColor forState:UIControlStateSelected];
    qiugouBtn.tag=12;
    UIView *qiugouViw=[[UIView alloc]initWithFrame:qiugouBtn.frame];
    [qiugouViw setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:qiugouViw];
    qiugouViw.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
    qiugouViw.layer.shadowOffset = CGSizeMake(3.5,3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    qiugouViw.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    qiugouViw.layer.shadowRadius = 3;//阴影半径，默认3
    [self.view addSubview:qiugouViw];
    self.qiugouBtn=qiugouBtn;
    [qiugouBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qiugouBtn];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(gongyingBtn.frame)-0.7, kWidth/2, 2.7)];
    self.moveImageV=imageV;
    [imageV setBackgroundColor:NavColor];
    [self.view addSubview:imageV];
    UIScrollView *backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(qiugouBtn.frame)+2, kWidth, kHeight-CGRectGetMaxY(qiugouBtn.frame))];
    self.backScrollView=backScrollView;
    backScrollView.tag=111;
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.showsVerticalScrollIndicator = NO;
    backScrollView.bouncesZoom = NO;
    backScrollView.bounces = NO;
    backScrollView.pagingEnabled = YES;
    backScrollView.delegate=self;
    [self.view addSubview:backScrollView];
    [backScrollView setContentSize:CGSizeMake(kWidth*2, 0)];
    __weak typeof(self) weakSelf=self;
    UITableView *sellTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, backScrollView.frame.size.height)];
    sellTableView.tag=123;
    sellTableView.delegate=self;
    sellTableView.dataSource=self;
    //sellTableView.pullDelegate=self;
    [sellTableView addHeaderWithCallback:^{
       weakSelf.sellPageCount=1;
        [weakSelf.sellDataAry removeAllObjects];
        [weakSelf getSellDataAryWithPage:[NSString stringWithFormat:@"%ld",(long)weakSelf.sellPageCount] andPageSize:@"10"];
    }];
    [sellTableView addFooterWithCallback:^{
        weakSelf.sellPageCount++;
        [weakSelf getSellDataAryWithPage:[NSString stringWithFormat:@"%ld",(long)weakSelf.sellPageCount] andPageSize:@"10"];
    }];
    sellTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sellTableView=sellTableView;
   // [sellTableView setBackgroundColor:[UIColor yellowColor]];
    [backScrollView addSubview:sellTableView];
    
    UITableView *buyTableView=[[UITableView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, backScrollView.frame.size.height)];
    buyTableView.tag=456;
    buyTableView.delegate=self;
    buyTableView.dataSource=self;
    //buyTableView.pullDelegate=self;
    [buyTableView addHeaderWithCallback:^{
        weakSelf.buyPageCount=1;
        [weakSelf.buyDataAry removeAllObjects];
        [weakSelf getbuyDataAryWtihPage:[NSString stringWithFormat:@"%ld",(long)weakSelf.buyPageCount] andPageSiz:@"10"];
    }];
    [buyTableView addFooterWithCallback:^{
        weakSelf.buyPageCount++;
        [weakSelf getbuyDataAryWtihPage:[NSString stringWithFormat:@"%ld",(long)weakSelf.buyPageCount] andPageSiz:@"10"];
    }];
    buyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.buyTableView=buyTableView;
    //[buyTableView setBackgroundColor:[UIColor redColor]];
    [backScrollView addSubview:buyTableView];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==123) {
        if (self.sellDataAry.count!=0) {
            return self.sellDataAry.count;
        }else
        {
            if (self.sellLikeAry.count!=0) {
                return self.sellLikeAry.count+1;
            }
        }
    }
    
    if (tableView.tag==456) {
        if (self.buyDataAry.count!=0) {
            //NSLog(@"%d",self.sellDataAry.count);
            return self.buyDataAry.count;
        }else
        {
            if (self.buyLikeAry.count!=0) {
                return self.buyLikeAry.count+1;
            }
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==123) {
        if (self.sellDataAry.count!=0) {
            return 100;
        }else
        {
            if (indexPath.row==0) {
                return 280;
            }
            if (self.sellLikeAry.count!=0) {
                if (indexPath.row!=0) {
                    return 100;
                }
            }
        }
    }
    
    if (tableView.tag==456) {
        if (self.buyDataAry.count!=0) {
            return 65;
        }else
        {
            if (indexPath.row==0) {
                return 280;
            }
            if (self.buyLikeAry.count!=0) {
                if (indexPath.row!=0) {
                    return 65;
                }
            }
        }
    }

    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==123) {
        if (self.sellDataAry.count!=0) {
            
            SellSearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[SellSearchTableViewCell IDStr]];
            if (!cell) {
                cell=[[SellSearchTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 100)];
               // cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            HotSellModel *model=self.sellDataAry[indexPath.row];
            cell.hotSellModel=model;
            return cell;
            //return 60;
        }else
        {
            if (indexPath.row==0) {
                noOneCollectCell *cell=[[noOneCollectCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 280) andType:1];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                 [cell.actionBtn addTarget:self action:@selector(moreSellMessageActon) forControlEvents:UIControlEventTouchUpInside];
                return cell;
                //return 280;
            }
            if (self.sellLikeAry.count!=0) {
                if (indexPath.row!=0) {
                    //return 60;
                    SellSearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[SellSearchTableViewCell IDStr]];
                    if (!cell) {
                        cell=[[SellSearchTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 100)];
                       //  cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    }
                    HotSellModel *model=self.sellLikeAry[indexPath.row-1];
                    cell.hotSellModel=model;
                    return cell;

                }
            }
        }
    }
    
    if (tableView.tag==456) {
        if (self.buyDataAry.count!=0) {
            BuySearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[BuySearchTableViewCell IDStr]];
            if (!cell) {
                cell=[[BuySearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[BuySearchTableViewCell IDStr] WithFrame:CGRectMake(0, 0, kWidth, 65)];
               //  cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            HotBuyModel *model=self.buyDataAry[indexPath.row];
            cell.hotBuyModel=model;
            return cell;
        }else
        {
            if (indexPath.row==0) {
                noOneCollectCell *cell=[[noOneCollectCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 280) andType:2];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                [cell.actionBtn addTarget:self action:@selector(moreBuyMessageAction) forControlEvents:UIControlEventTouchUpInside];
                return cell;

            }
            if (self.buyLikeAry.count!=0) {
                if (indexPath.row!=0) {
                    BuySearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[BuySearchTableViewCell IDStr]];
                    if (!cell) {
                        cell=[[BuySearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[BuySearchTableViewCell IDStr] WithFrame:CGRectMake(0, 0, kWidth, 65)];;
                     //    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    }
                    HotBuyModel *model=self.buyLikeAry[indexPath.row-1];
                    cell.hotBuyModel=model;
                    return cell;

                }
            }
        }
    }

    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}

-(void)moreSellMessageActon
{
    SearchViewController *searVC=[[SearchViewController alloc]initWithSearchType:1];
    //[self hiddingSelfTabBar];
    [self.navigationController pushViewController:searVC animated:YES];
    return;
}
-(void)moreBuyMessageAction
{
    SearchViewController *searVC=[[SearchViewController alloc]initWithSearchType:2];
   // [self hiddingSelfTabBar];
    [self.navigationController pushViewController:searVC animated:YES];
    return;
}


-(void)selectBtnAction:(UIButton *)sender
{
    if (sender.selected==YES) {
        return;
    }
    CGRect frame=self.moveImageV.frame;
    if (sender.tag==11) {
        frame.origin.x=0;
        sender.selected=YES;
        self.qiugouBtn.selected=NO;
        [self.backScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }else if (sender.tag==12)
    {
        frame.origin.x=kWidth/2;
        sender.selected=YES;
        self.gongyingBtn.selected=NO;
        [self.backScrollView setContentOffset:CGPointMake(kWidth, 0) animated:YES];
        
    }
    //nowBtn=sender;
    [UIView animateWithDuration:0.3 animations:^{
        self.moveImageV.frame=frame;
    }];
}
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    
//}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag==111) {
        if (scrollView.contentOffset.x>=kWidth-5) {
            if (self.gongyingBtn.selected==YES) {
                self.gongyingBtn.selected=NO;
                self.qiugouBtn.selected=YES;
                CGRect frame=self.moveImageV.frame;
                frame.origin.x=kWidth/2;
                [UIView animateWithDuration:0.3 animations:^{
                    self.moveImageV.frame=frame;
                }];
            }
        }
        if (scrollView.contentOffset.x<=5) {
            if (self.qiugouBtn.selected==YES) {
                self.qiugouBtn.selected=NO;
                self.gongyingBtn.selected=YES;
                CGRect frame=self.moveImageV.frame;
                frame.origin.x=0;
                [UIView animateWithDuration:0.3 animations:^{
                    self.moveImageV.frame=frame;
                }];
            }
        }

    }
   
}
-(UIView *)makeNavView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(17, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:15 right:80 bottom:10 left:10];
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80,26, 160, 30)];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setText:@"我的收藏"];
    [titleLab setFont:[UIFont systemFontOfSize:NavTitleSize]];
    [view addSubview:titleLab];
    
    return view;
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getbuyDataAryWtihPage:(NSString *)page andPageSiz:(NSString *)pageSize
{
    [HTTPCLIENT collectBuyListWithToken:@"" WithAccessID:@"" WithClientID:@"" WithClientSecret:@"" WithDeviceID:@"" WithPage:page WithPageSize:pageSize Success:^(id responseObject) {
        if([[responseObject objectForKey:@"success"] integerValue])
        {
            if (buyPageCount==1) {
                [self.buyDataAry removeAllObjects];
            }
            //NSLog(@"----%@",responseObject);
            NSArray *ary=[responseObject objectForKey:@"result"];
            if (ary.count==0&&buyPageCount>1) {
                buyPageCount--;
                [ToastView showTopToast:@"已无更多信息"];
            }
            NSArray *aryaa=[HotBuyModel  creathotBuyModelAryByAry:ary];
            for (int i=0; i<aryaa.count ; i++) {
                [self.buyDataAry addObject:aryaa[i]];
            }
            
            
            if (self.buyDataAry.count==0&&self.buyLikeAry.count==0) {
                [self creatBuyLikeAry];
            }else
            {
                [self.buyTableView reloadData];
            }
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        [self.buyTableView headerEndRefreshing];
        [self.buyTableView footerEndRefreshing];
        //NSLog(@"求购收藏%@",responseObject);
    } failure:^(NSError *error) {
        [self.buyTableView headerEndRefreshing];
        [self.buyTableView footerEndRefreshing];
    }];
}
-(void)getSellDataAryWithPage:(NSString *)page andPageSize:(NSString *)pageSize
{
    [HTTPCLIENT collectSellListWithPage:page WithPageSize:pageSize Success:^(id responseObject) {
        if([[responseObject objectForKey:@"success"] integerValue])
        {
            if (sellPageCount==1) {
                [self.sellDataAry removeAllObjects];
            }
            NSArray *ary=[responseObject objectForKey:@"result"];
            //NSArray *ary=[responseObject objectForKey:@"result"];
            if (ary.count==0&&sellPageCount>1) {
                buyPageCount--;
                [ToastView showTopToast:@"已无更多信息"];
            }
            NSArray *aryaa=[HotSellModel  hotSellAryByAry:ary];
            for (int i=0; i<aryaa.count ; i++) {
                [self.sellDataAry addObject:aryaa[i]];
            }
            if (self.sellDataAry.count==0&&self.sellLikeAry.count==0) {
                [self creatSellLikeAry];
            }
            else
            {
                [self.sellTableView reloadData];
            }
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        [self.sellTableView headerEndRefreshing];
        [self.sellTableView footerEndRefreshing];
    } failure:^(NSError *error) {
        [self.sellTableView headerEndRefreshing];
        [self.sellTableView footerEndRefreshing];
    }];
}
-(void)creatSellLikeAry
{
    HotSellModel *model=[self.sellLikeAry lastObject];
    NSString *searhTimeStr;
    if (self.sellPageCount>1) {
        searhTimeStr=model.searchtime;
    }
    [HTTPCLIENT SellListWithWithPageSize:@"5" WithPage:@"1" Withgoldsupplier:@"0" WithSerachTime:searhTimeStr  Success:^(id responseObject) {
        if([[responseObject objectForKey:@"success"] integerValue])
        {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            NSArray *ary=[dic objectForKey:@"list"];
            [self.sellLikeAry addObjectsFromArray:[HotSellModel hotSellAryByAry:ary]];
            [self.sellTableView reloadData];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)creatBuyLikeAry
{
    HotBuyModel *model=[self.buyLikeAry lastObject];
    NSString *searhTimeStr;
    if (self.buyPageCount>1) {
        searhTimeStr=model.searchTime;
    }
    [HTTPCLIENT BuyListWithWithPageSize:@"5" WithStatus:@"1" WithStartNumber:@"" withSearchTime:searhTimeStr  Success:^(id responseObject) {
        if([[responseObject objectForKey:@"success"] integerValue])
        {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            NSArray *ary=[dic objectForKey:@"list"];
            [self.buyLikeAry addObjectsFromArray:[HotBuyModel creathotBuyModelAryByAry:ary]];
            [self.buyTableView reloadData];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }

    } failure:^(NSError *error) {
        
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag==123) {
        if (self.sellDataAry.count==0)
        {
            if (indexPath.row==0)
            {
                return;
            }else
            {
                HotSellModel *model=self.sellLikeAry[indexPath.row-1];
                SellDetialViewController *sellvc=[[SellDetialViewController alloc]initWithUid:model];
                [self.navigationController pushViewController:sellvc animated:YES];
                return;
            }
        }else
        {
            
            HotSellModel *model=self.sellDataAry[indexPath.row];
            model.uid=model.supplybuyNurseryUid;
            SellDetialViewController *sellvc=[[SellDetialViewController alloc]initWithUid:model];
            [self.navigationController pushViewController:sellvc animated:YES];
            return;
        }
    }
    
    
    if (tableView.tag==456) {
        if (self.buyDataAry.count==0)
        {
            if (indexPath.row==0) {
                return;
            }else
            {
                HotBuyModel *model=self.buyLikeAry[indexPath.row-1];
                BuyDetialInfoViewController *buyVC=[[BuyDetialInfoViewController alloc]initWithSaercherInfo:model.uid];
                [self.navigationController pushViewController:buyVC animated:YES];
            }
        }else
        {
            HotBuyModel *model=self.buyDataAry[indexPath.row];
            //NSLog(@"%@",model.uid);
            BuyDetialInfoViewController *buyVC=[[BuyDetialInfoViewController alloc]initWithSaercherInfo:model.supplybuyUid];
            [self.navigationController pushViewController:buyVC animated:YES];
        }

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
