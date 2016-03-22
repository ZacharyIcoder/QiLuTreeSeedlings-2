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
@property (nonatomic,strong)NSArray *sellDataAry;
@property (nonatomic,strong)NSArray *buyDataAry;
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
        PullTableView *pullTableView =[[PullTableView alloc]initWithFrame:self.bounds];
        pullTableView.delegate=self;
        pullTableView.dataSource=self;
        pullTableView.pullDelegate=self;
        self.selfTableView=pullTableView;
        [pullTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:pullTableView];
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
        cell.hotSellModel=self.sellDataAry[indexPath.row];
        return cell;
    }else
    {
        BuySearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[BuySearchTableViewCell IDStr]];
        if (!cell) {
            cell=[[BuySearchTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 70)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.hotBuyModel=self.buyDataAry[indexPath.row];
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
    
}
-(void)loadMoreAction
{   [self.selfTableView reloadData];
    self.selfTableView.pullTableIsLoadingMore=NO;
}
-(void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
}
-(void)triggerRefresh
{    [self.selfTableView reloadData];
    self.selfTableView.pullTableIsRefreshing=NO;
}
- (void)getListData
{
     self.PageCount=1;
    if (self.searchType==1) {
        [HTTPCLIENT SellListWithWithPageSize:@"15" WithPage:[NSString stringWithFormat:@"%ld",(long)self.PageCount] Success:^(id responseObject) {
             //NSLog(@"%@",responseObject);
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            NSArray *ary=[dic objectForKey:@"list"];
            self.sellDataAry=[HotSellModel hotSellAryByAry:ary];
            self.buyDataAry=@[];
            [self.selfTableView reloadData];
        } failure:^(NSError *error) {
            
        }];
    }
    if (self.searchType==2) {
        [HTTPCLIENT BuyListWithWithPageSize:@"15" WithStatus:[NSString stringWithFormat:@"%ld",(long)self.PageCount] WithStartNumber:@"" Success:^(id responseObject) {
           // NSLog(@"%@",responseObject);
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            NSArray *ary=[dic objectForKey:@"list"];
            self.buyDataAry=[HotBuyModel creathotBuyModelAryByAry:ary];
            self.sellDataAry=@[];
            [self.selfTableView reloadData];

        } failure:^(NSError *error) {
            
        }];
    }
}

-(void)searchViewActionWithSearchType:(NSInteger)type
{
    self.searchType=type;
    [self getListData];

}
-(void)searchViewActionWith:(NSString *)searchStr AndSearchType:(NSInteger)type
{
       if (searchStr.length==0) {
           
        return;
    }
     self.PageCount=1;
    self.searchStr=searchStr;
    self.searchType=type;
   // HttpClient *httpClient=[HttpClient sharedClient];
    if (self.searchType==1) {
       [HTTPCLIENT sellSearchWithPage:[NSString stringWithFormat:@"%ld",(long)self.PageCount] WithPageSize:@"15" Withgoldsupplier:self.goldsupplier WithProductUid:self.productUid WithProductName:self.searchStr WithProvince:self.province WithCity:self.City WithCounty:self.county WithAry:self.shaixuanAry Success:^(id responseObject) {
           // NSLog(@"%@",responseObject);
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            NSArray *ary=[dic objectForKey:@"list"];
            self.sellDataAry=[HotSellModel hotSellAryByAry:ary];
            self.buyDataAry=@[];
            [self.selfTableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
 
    }
    if (self.searchType==2) {
        [HTTPCLIENT buySearchWithPage:[NSString stringWithFormat:@"%ld",(long)self.PageCount] WithPageSize:@"15" Withgoldsupplier:self.goldsupplier WithproductUid:self.productUid WithproductName:self.searchStr WithProvince:self.province WithCity:self.City WithCounty:self.county WithAry:self.shaixuanAry Success:^(id responseObject) {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            if (dic) {
                NSArray *Ary=[dic objectForKey:@"list"];
                self.buyDataAry=[HotBuyModel creathotBuyModelAryByAry:Ary];
                
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
