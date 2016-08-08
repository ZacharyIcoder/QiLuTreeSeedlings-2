//
//  SearchSuccessView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/1.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "SearchSuccessView.h"
#import "MJRefresh.h"
#import "SellSearchTableViewCell.h"
#import "HttpClient.h"
#import "UIDefines.h"
#import "HotSellModel.h"
#import "HotBuyModel.h"
#import "BuySearchTableViewCell.h"

#import "ZIKQiugouMoreShareView.h"//分组分享view

@interface SearchSuccessView()<UITableViewDataSource,UITableViewDelegate,ZIKQiugouMoreShareViewDelegate>//ZIKQiugouMoreShareViewDelegate分组分享代理
@property (nonatomic,strong)UITableView *selfTableView;
@property (nonatomic,strong)NSMutableArray *sellDataAry;
@property (nonatomic,strong)NSMutableArray *buyDataAry;
@property (nonatomic)NSInteger PageCount;
@property (nonatomic) NSInteger status;

@property (nonatomic, strong) ZIKQiugouMoreShareView *shareView;//分组分享新增



@end
@implementation SearchSuccessView
-(void)dealloc
{
    self.selfTableView=nil;
    self.searchStr=nil;
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.searchType=1;
        self.PageCount=1;
        self.searchBAT=1;
        self.status=1;
        UITableView *pullTableView =[[UITableView alloc]initWithFrame:self.bounds];
        pullTableView.delegate=self;
        pullTableView.dataSource=self;
       // pullTableView.pullDelegate=self;
        self.selfTableView=pullTableView;
        __weak typeof(self) weakSelf=self;
        [pullTableView addHeaderWithCallback:^{
            weakSelf.PageCount=1;
    
            if (weakSelf.searchBAT==1) {
                
                [weakSelf getListData];
                weakSelf.status=1;
                return;
            }
            if (weakSelf.searchBAT==2) {
                [weakSelf searchByScringList];
            }
        }];
        [pullTableView addFooterWithCallback:^{
            weakSelf.PageCount++;
            if (weakSelf.searchBAT==1) {
                [weakSelf getListData];
               
            }
            if (weakSelf.searchBAT==2) {
                [weakSelf searchByScringList];
            }
        }];
        [pullTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:pullTableView];
        self.sellDataAry=[NSMutableArray array];
        self.buyDataAry=[NSMutableArray array];

        //新增代码（分组分享）
        self.backgroundColor = [UIColor whiteColor];
        ZIKQiugouMoreShareView *shareView = [ZIKQiugouMoreShareView instanceShowShareView];
        shareView.frame = CGRectMake(0, self.frame.size.height-50, kWidth, 50);
        shareView.delegate = self;
        [self addSubview:shareView];
        self.shareView = shareView;
        self.shareView.hidden = YES;
         //新增代码（分组分享）end
         

    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchType==1) {
       return self.sellDataAry.count;
    }else
    {
        return self.buyDataAry.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchType==1) {
        SellSearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[SellSearchTableViewCell IDStr]];
        if (!cell) {
            cell=[[SellSearchTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 100)];
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.sellDataAry.count>=indexPath.row+1) {
            cell.hotSellModel=self.sellDataAry[indexPath.row];
        }
        
        return cell;
    }else
    {
        BuySearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[BuySearchTableViewCell IDStr]];
        if (!cell) {
           cell=[[BuySearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[BuySearchTableViewCell IDStr] WithFrame:CGRectMake(0, 0, kWidth, 60)];;
           // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.buyDataAry.count>=indexPath.row+1) {
            cell.hotBuyModel=self.buyDataAry[indexPath.row];
        }
        //cell.hotBuyModel=self.buyDataAry[indexPath.row];
        return cell;
    }
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchType==1) {
           return 100;
    }else
    {
        return 60;
    }
}



- (void)getListData
{
    
    if (self.searchType==1) {
        ShowActionV();
        HotSellModel *model=[self.sellDataAry lastObject];
        NSString *searhTimeStr;
        if (self.PageCount>1) {
            searhTimeStr=model.searchtime;
        }
        [HTTPCLIENT SellListWithWithPageSize:@"15" WithPage:[NSString stringWithFormat:@"%ld",(long)self.PageCount] Withgoldsupplier:@"0" WithSerachTime:searhTimeStr  Success:^(id responseObject) {
             //NSLog(@"%@",responseObject);
            if(self.PageCount==1)
            {
                [self.sellDataAry removeAllObjects];
                [self.buyDataAry removeAllObjects];
            }
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            NSArray *ary=[dic objectForKey:@"list"];
            NSArray *aryzz=[HotSellModel hotSellAryByAry:ary];
            HotSellModel *aryzzLast =  [aryzz lastObject];
            HotSellModel *dataLast =  [self.sellDataAry lastObject];
            
            //NSLog(@"%@---%@",dataLast.uid,aryzzLast.uid);
            if (aryzz.count > 0) {
                if ([dataLast.uid isEqualToString: aryzzLast.uid]) {
                    [ToastView showTopToast:@"已无更多信息"];
                    self.PageCount--;
                }else{
                    
                    [self.sellDataAry addObjectsFromArray:aryzz];
                }

            }else{
                [ToastView showTopToast:@"已无更多信息"];
                self.PageCount--;
            }
            RemoveActionV();
            [self.buyDataAry removeAllObjects];
            [self.selfTableView reloadData];
            [self.selfTableView headerEndRefreshing];
            [self.selfTableView footerEndRefreshing];
        } failure:^(NSError *error) {
            RemoveActionV();
            [self.selfTableView headerEndRefreshing];
            [self.selfTableView footerEndRefreshing];
        }];
    }
    if (self.searchType==2) {
        ShowActionV();
        HotBuyModel *model=[self.buyDataAry lastObject];
        NSString *searhTimeStr;
        if (self.PageCount>1) {
            searhTimeStr=model.searchTime;
        }
        [HTTPCLIENT BuyListWithWithPageSize:@"15" WithStatus:[NSString stringWithFormat:@"%ld",(long)self.status]WithStartNumber:[NSString stringWithFormat:@"%ld",(long)self.PageCount] withSearchTime:searhTimeStr  Success:^(id responseObject) {
           // NSLog(@"%@",responseObject);
            if(self.PageCount==1)
            {
                [self.sellDataAry removeAllObjects];
                [self.buyDataAry removeAllObjects];
            }
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            self.status= [[dic objectForKey:@"status"] integerValue];
            NSArray *ary=[dic objectForKey:@"list"];
            NSArray *aryzz=[HotBuyModel creathotBuyModelAryByAry:ary];
            HotBuyModel *aryzzLast =  [aryzz lastObject];
            HotBuyModel *dataLast =  [self.buyDataAry lastObject];
            if (aryzz.count>0) {
                if ([dataLast.uid isEqualToString: aryzzLast.uid]) {
                    [ToastView showTopToast:@"已无更多信息"];
                    self.PageCount--;
                }else{
                    [self.buyDataAry addObjectsFromArray:aryzz];
                }
            }else{
                [ToastView showTopToast:@"已无更多信息"];
                self.PageCount--;
            }
            
            RemoveActionV();
            [self.sellDataAry removeAllObjects];;
            [self.selfTableView reloadData];
            [self.selfTableView headerEndRefreshing];
            [self.selfTableView footerEndRefreshing];
        } failure:^(NSError *error) {
            RemoveActionV();
            [self.selfTableView headerEndRefreshing];
            [self.selfTableView footerEndRefreshing];
        }];
    }
}

-(void)searchViewActionWithSearchType:(NSInteger)type
{
    //新增代码（分组分享）
    if (type == 2) {
        self.selfTableView.frame = CGRectMake(self.selfTableView.frame.origin.x, self.selfTableView.frame.origin.y, self.selfTableView.frame.size.width, self.selfTableView.frame.size.height-50);
        self.shareView.hidden = NO;
    }
    //新增代码（分组分享）end

    self.searchType=type;
    self.PageCount=1;
    self.searchBAT=1;
    [self getListData];

}


-(void)searchViewActionWith:(NSString *)searchStr AndSearchType:(NSInteger)type
{
       if (searchStr.length==0) {
           
        return;
    }
     self.PageCount=1;
    self.searchBAT=2;
    self.searchStr=searchStr;
    self.searchType=type;
    [self.sellDataAry removeAllObjects];
    [self.buyDataAry removeAllObjects];
    [self searchByScringList];
    
}
- (void)searchByScringList
{
    // HttpClient *httpClient=[HttpClient sharedClient];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *searchHistoryAry=[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"searchHistoryAry"]];
    if (![searchHistoryAry containsObject:self.searchStr]) {
        if (searchHistoryAry.count<5) {
            [searchHistoryAry addObject:self.searchStr];
            [userDefaults setObject:searchHistoryAry forKey:@"searchHistoryAry"];
            [userDefaults synchronize];
        }else
        {
            [searchHistoryAry addObject:self.searchStr];
            [searchHistoryAry removeObjectAtIndex:0];
            [userDefaults setObject:searchHistoryAry forKey:@"searchHistoryAry"];
            [userDefaults synchronize];
        }
    }else{
        [searchHistoryAry removeObject:self.searchStr];
        [searchHistoryAry addObject:self.searchStr];
        [userDefaults setObject:searchHistoryAry forKey:@"searchHistoryAry"];
        [userDefaults synchronize];
        
    }

    if (self.searchType==1) {
        ShowActionV();
        NSString *saerchTime;
        HotSellModel *model=[self.sellDataAry lastObject];
        if (self.PageCount>1) {
            saerchTime=model.searchtime;
        }
        [HTTPCLIENT sellSearchWithPage:[NSString stringWithFormat:@"%ld",(long)self.PageCount] WithPageSize:@"15" Withgoldsupplier:self.goldsupplier WithProductUid:self.productUid WithProductName:self.searchStr WithProvince:self.province WithCity:self.City WithCounty:self.county WithSearchTime:saerchTime  WithAry:self.shaixuanAry  Success:^(id responseObject) {
            // NSLog(@"%@",responseObject);
            if(self.PageCount==1)
            {
                [self.sellDataAry removeAllObjects];
                [self.buyDataAry removeAllObjects];
            }
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            NSArray *ary=[dic objectForKey:@"list"];
            NSArray *aryzz=[HotSellModel hotSellAryByAry:ary];
            
            HotSellModel *aryzzLast =  [aryzz lastObject];
            HotSellModel *dataLast =  [self.sellDataAry lastObject];
            if (aryzz.count >0) {
                if ([dataLast.uid isEqualToString:aryzzLast.uid]) {
                    [ToastView showTopToast:@"已无更多信息"];
                    self.PageCount--;
                    
                }else{
                    [self.sellDataAry addObjectsFromArray:aryzz];
                }

            }else{
                [ToastView showTopToast:@"已无更多信息"];
                self.PageCount--;

            }
            RemoveActionV();
            [self.buyDataAry removeAllObjects];
            [self.selfTableView reloadData];
            [self.selfTableView headerEndRefreshing];
            [self.selfTableView footerEndRefreshing];
        } failure:^(NSError *error) {
            RemoveActionV();
            [self.selfTableView headerEndRefreshing];
            [self.selfTableView footerEndRefreshing];
        }];
        
    }
    if (self.searchType==2) {
        ShowActionV();
        HotBuyModel *model=[self.buyDataAry lastObject];
        NSString *searhTimeStr;
        if (self.PageCount>1) {
            searhTimeStr=model.searchTime;
        }
        [HTTPCLIENT buySearchWithPage:[NSString stringWithFormat:@"%ld",(long)self.PageCount] WithPageSize:@"15" Withgoldsupplier:self.goldsupplier WithproductUid:self.productUid WithproductName:self.searchStr WithProvince:self.province WithCity:self.City WithCounty:self.county WithsearchTime:searhTimeStr  WithAry:self.shaixuanAry Success:^(id responseObject) {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            if(self.PageCount==1)
            {
                [self.sellDataAry removeAllObjects];
                [self.buyDataAry removeAllObjects];
            }
            if (dic) {
                NSArray *Ary=[dic objectForKey:@"list"];
                NSArray *aryzz=[HotBuyModel creathotBuyModelAryByAry:Ary];
                HotBuyModel *aryzzLast =  [aryzz lastObject];
                HotBuyModel *dataLast =  [self.buyDataAry lastObject];
                if (aryzz.count>0) {
                    if ([dataLast.uid isEqualToString:aryzzLast.uid]) {
                        [ToastView showTopToast:@"已无更多信息"];
                        self.PageCount--;
                        
                    }else{
                        [self.buyDataAry addObjectsFromArray:aryzz];
                    }

                }else {
                    [ToastView showTopToast:@"已无更多信息"];
                    self.PageCount--;

                }
               [self.sellDataAry removeAllObjects];
                [self.selfTableView headerEndRefreshing];
                [self.selfTableView footerEndRefreshing];
            }
            RemoveActionV();
            [self.selfTableView reloadData];
        } failure:^(NSError *error) {
            RemoveActionV();
            [self.selfTableView headerEndRefreshing];
            [self.selfTableView footerEndRefreshing];
        }];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.searchType==1&&self.delegate) {
         HotSellModel *model = self.sellDataAry[indexPath.row];
        [self.delegate SearchSuccessViewPushSellDetial:model];
        
    }
    if (self.searchType==2&&self.delegate) {
        HotBuyModel *model=self.buyDataAry[indexPath.row];
        [self.delegate SearchSuccessViewPushBuyDetial:model.uid];
    }
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

//新增分组分享
-(void)sendTimeInfo:(NSString *)timeStr {
    [HTTPCLIENT groupShareWithProductUid:self.productUid  productName:self.searchStr province:self.province city:self.City county:self.county startTime:timeStr spec_XXXXXX:self.shaixuanAry  Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        }
        NSDictionary *shareDic = responseObject[@"result"];
        NSString *shareText   = shareDic[@"text"];
        NSString *shareTitle  = shareDic[@"title"];
        NSString *urlStr = shareDic[@"pic"];
        NSData * data    = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr]];
        UIImage *shareImage  = [[UIImage alloc] initWithData:data];
        NSString *shareUrl    = shareDic[@"url"];
        if ([self.delegate respondsToSelector:@selector(umshare:title:image:url:)]) {
            [self.delegate umshare:shareText title:shareTitle image:shareImage url:shareUrl];
        }

    } failure:^(NSError *error) {
        ;
    }];
}


@end
