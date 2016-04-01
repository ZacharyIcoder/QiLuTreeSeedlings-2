//
//  SearchSuccessView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/1.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "SearchSuccessView.h"
#import "PullTableView.h"
#import "SellSearchTableViewCell.h"
#import "HttpClient.h"
#import "UIDefines.h"
#import "HotSellModel.h"
#import "HotBuyModel.h"
#import "BuySearchTableViewCell.h"

@interface SearchSuccessView()<PullTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)PullTableView *selfTableView;
@property (nonatomic,strong)NSMutableArray *sellDataAry;
@property (nonatomic,strong)NSMutableArray *buyDataAry;
@property (nonatomic)NSInteger PageCount;

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
        PullTableView *pullTableView =[[PullTableView alloc]initWithFrame:self.bounds];
        pullTableView.delegate=self;
        pullTableView.dataSource=self;
        pullTableView.pullDelegate=self;
        self.selfTableView=pullTableView;
        [pullTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:pullTableView];
        self.sellDataAry=[NSMutableArray array];
        self.buyDataAry=[NSMutableArray array];
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
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.sellDataAry.count>=indexPath.row+1) {
            cell.hotSellModel=self.sellDataAry[indexPath.row];
        }
        
        return cell;
    }else
    {
        BuySearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[BuySearchTableViewCell IDStr]];
        if (!cell) {
            cell=[[BuySearchTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 70)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        return 70;
    }
 
}
-(void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    self.PageCount++;
    if (self.searchBAT==1) {
        [self getListData];
        return;
    }
    if (self.searchBAT==2) {
        [self searchByScringList];
    }
    
}
-(void)loadMoreAction
{   [self.selfTableView reloadData];
    self.selfTableView.pullTableIsLoadingMore=NO;
}
-(void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    self.PageCount=1;
    [self.sellDataAry removeAllObjects];
    [self.buyDataAry removeAllObjects];
    if (self.searchBAT==1) {
        
        [self getListData];
        return;
    }
    if (self.searchBAT==2) {
        [self searchByScringList];
    }
}
-(void)triggerRefresh
{    [self.selfTableView reloadData];
    self.selfTableView.pullTableIsRefreshing=NO;
}
- (void)getListData
{
    
    if (self.searchType==1) {
        [HTTPCLIENT SellListWithWithPageSize:@"15" WithPage:[NSString stringWithFormat:@"%ld",(long)self.PageCount] Success:^(id responseObject) {
             //NSLog(@"%@",responseObject);
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
            [self.buyDataAry removeAllObjects];
            [self.selfTableView reloadData];
            self.selfTableView.pullTableIsLoadingMore=NO;
            self.selfTableView.pullTableIsRefreshing=NO;
        } failure:^(NSError *error) {
            
        }];
    }
    if (self.searchType==2) {
        [HTTPCLIENT BuyListWithWithPageSize:@"15" WithStatus:[NSString stringWithFormat:@"%ld",(long)self.PageCount] WithStartNumber:@"" Success:^(id responseObject) {
           // NSLog(@"%@",responseObject);
            NSDictionary *dic=[responseObject objectForKey:@"result"];
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
            
            
            [self.sellDataAry removeAllObjects];;
            [self.selfTableView reloadData];
            self.selfTableView.pullTableIsLoadingMore=NO;
             self.selfTableView.pullTableIsRefreshing=NO;
        } failure:^(NSError *error) {
            
        }];
    }
}

-(void)searchViewActionWithSearchType:(NSInteger)type
{
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
    [self searchByScringList];
    
}
- (void)searchByScringList
{
    // HttpClient *httpClient=[HttpClient sharedClient];
    if (self.searchType==1) {
        [HTTPCLIENT sellSearchWithPage:[NSString stringWithFormat:@"%ld",(long)self.PageCount] WithPageSize:@"15" Withgoldsupplier:self.goldsupplier WithProductUid:self.productUid WithProductName:self.searchStr WithProvince:self.province WithCity:self.City WithCounty:self.county WithAry:self.shaixuanAry Success:^(id responseObject) {
            // NSLog(@"%@",responseObject);
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
            
            [self.buyDataAry removeAllObjects];
            [self.selfTableView reloadData];
            self.selfTableView.pullTableIsLoadingMore=NO;
             self.selfTableView.pullTableIsRefreshing=NO;
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }
    if (self.searchType==2) {
        [HTTPCLIENT buySearchWithPage:[NSString stringWithFormat:@"%ld",(long)self.PageCount] WithPageSize:@"15" Withgoldsupplier:self.goldsupplier WithproductUid:self.productUid WithproductName:self.searchStr WithProvince:self.province WithCity:self.City WithCounty:self.county WithAry:self.shaixuanAry Success:^(id responseObject) {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
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

                }else{
                    [ToastView showTopToast:@"已无更多信息"];
                    self.PageCount--;

                }
               [self.sellDataAry removeAllObjects];
                self.selfTableView.pullTableIsLoadingMore=NO;
                self.selfTableView.pullTableIsRefreshing=NO;
            }
            [self.selfTableView reloadData];
        } failure:^(NSError *error) {
            
        }];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchType==1&&self.delegate) {
         HotSellModel *model = self.sellDataAry[indexPath.row];
        [self.delegate SearchSuccessViewPushSellDetial:model];
        
    }
    if (self.searchType==2&&self.delegate) {
        HotBuyModel *model=self.buyDataAry[indexPath.row];
        [self.delegate SearchSuccessViewPushBuyDetial:model.uid];
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
