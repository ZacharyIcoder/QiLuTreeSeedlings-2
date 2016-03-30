//
//  SearchRecommendView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "SearchRecommendView.h"
#import "searchHistoryViewCell.h"
#import "UIDefines.h"
@implementation SearchRecommendView
-(id)initWithFrame:(CGRect)frame WithAry:(NSArray *)ary
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataAry=ary;
        self.backScrollView=[[UIScrollView alloc]initWithFrame:self.bounds];
        [self addSubview:self.backScrollView];
    
        UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0)];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
        [titleLab setText:@"热门搜索"];
        [titleLab setTextColor:[UIColor blackColor]];
        [topView addSubview:titleLab];
        [topView setBackgroundColor:BGColor];
       
        int tempX=10;
         CGRect tempFrame=CGRectMake(10, CGRectGetMaxY(titleLab.frame)+10, 0, 20);
        for (int i=0; i<ary.count; i++) {
            
            NSString *nameStr=[ary[i] objectForKey:@"productName"];
            UIButton *likeBtn=[[UIButton alloc]init];
            likeBtn.layer.masksToBounds=YES;
            likeBtn.layer.cornerRadius=3;
            likeBtn.tag=i;
            //[likeBtn setBackgroundColor:[UIColor grayColor]];
            [likeBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [likeBtn setTitle:nameStr forState:UIControlStateNormal];
            CGSize strSize=[self boundingRectWithSize:likeBtn.titleLabel.frame.size whithLab:likeBtn.titleLabel];
            [likeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            // NSLog(@"%f",strSize.width);
             [likeBtn.layer setBorderWidth:0.5];
            [likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [likeBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            tempFrame.size.width=strSize.width+10.0;
            tempFrame.origin.x=tempX;
         
            if (CGRectGetMaxX(tempFrame)>=kWidth-10) {
                tempFrame.origin.x=tempX=10;
                tempFrame.origin.y+=25;
            }
            tempX=CGRectGetMaxX(tempFrame)+5;
            [likeBtn setFrame:tempFrame];
            [topView addSubview:likeBtn];
            
        }
        CGRect  topViewFram=topView.frame;
        topViewFram.size.height=CGRectGetMaxY(tempFrame)+10;
        [topView setFrame:topViewFram];
        [self.backScrollView addSubview:topView];
        UIView *historyView=[self ViewWithSearchHistoryWithFram:CGRectMake(0, CGRectGetMaxY(topViewFram), kWidth, 0)];
        self.histroyView=historyView;
        [self.backScrollView addSubview:historyView];
//       CGRect 
    }
    return self;
}
-(void)likeBtnAction:(UIButton *)sender
{
    if(self.delegate)
    {
        [self.delegate SearchRecommendViewSearchDIC:self.dataAry[sender.tag]];
    }
}
-(UIView *)ViewWithSearchHistoryWithFram:(CGRect )fram
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *searchHistoryAry=[userDefaults objectForKey:@"searchHistoryAry"];
    UIView *view=[[UIView alloc]initWithFrame:fram];
    view.userInteractionEnabled=YES;
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 20)];
    [titleLab setText:@"搜索历史"];
    [titleLab setFont:[UIFont systemFontOfSize:15]];
    [titleLab setTextColor:[UIColor blackColor]];
    [view addSubview:titleLab];
    CGRect tempFrame=CGRectMake(20, CGRectGetMaxY(titleLab.frame)-30, kWidth-20, 44);
    for (int i=0; i<searchHistoryAry.count; i++) {
        tempFrame.origin.y+=44;
        NSDictionary *dic=[NSDictionary dictionaryWithObject:searchHistoryAry[i] forKey:@"title"];
        searchHistoryViewCell *cell=[[searchHistoryViewCell alloc]initWithFrame:tempFrame WithDic:dic];
        cell.actionBtn.tag=10+i;
       [cell.actionBtn addTarget:self action:@selector(HistoryCellActionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.deleteBtn.tag=50+i;
        [cell.deleteBtn addTarget:self action:@selector(HistoryCellDeleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cell];
    }
    tempFrame.origin.y+=44;
    
    UIButton *clearHistoryBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-60, tempFrame.origin.y+20, 120, 25)];
    [clearHistoryBtn setTitle:@"删除搜索历史" forState:UIControlStateNormal];
    [clearHistoryBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [clearHistoryBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
   // [clearHistoryBtn.layer setBorderWidth:0.5];
    //[clearHistoryBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [clearHistoryBtn addTarget:self action:@selector(clearHistoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    clearHistoryBtn.layer.masksToBounds=YES;
//    clearHistoryBtn.layer.cornerRadius=3;
    [view addSubview:clearHistoryBtn];
    CGRect frame=view.frame;
    frame.size.height=CGRectGetMaxY(clearHistoryBtn.frame)+10;
    [view setFrame:frame];
     return view;
}
- (CGSize)boundingRectWithSize:(CGSize)size whithLab:(UILabel *)lab
{
    NSDictionary *attribute = @{NSFontAttributeName: lab.font};
    
    CGSize retSize = [lab.text boundingRectWithSize:size
                                            options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                         attributes:attribute
                                            context:nil].size;
    
    return retSize;
}
-(void)HistoryCellActionBtnAction:(UIButton *)sender
{
    NSLog(@"HistoryCellActionBtnAction :%ld",(long)sender.tag);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *searchHistoryAry=[userDefaults objectForKey:@"searchHistoryAry"];
    int xx=sender.tag%10;
   NSString *searchStr = [searchHistoryAry objectAtIndex:xx];
    if (self.delegate) {
        [self.delegate SearchRecommendViewSearch:searchStr];
    }

}
-(void)HistoryCellDeleteBtnAction:(UIButton *)sender
{
     NSLog(@"HistoryCellDeleteBtnAction :%ld",(long)sender.tag);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *searchHistoryAry=[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"searchHistoryAry"]];
    if (searchHistoryAry.count==1) {
        [self.histroyView removeFromSuperview];
        [searchHistoryAry removeAllObjects];
        [userDefaults setObject:searchHistoryAry forKey:@"searchHistoryAry"];
        [userDefaults synchronize];
        return;
    }
    if (searchHistoryAry!=nil) {
        //NSLog(@"%lu",(unsigned long)searchHistoryAry.count);
        
        int xx=sender.tag%50;
        [searchHistoryAry removeObjectAtIndex:xx];
        [userDefaults setObject:searchHistoryAry forKey:@"searchHistoryAry"];
       
    }
    CGRect tempFrame=self.histroyView.frame;
  [self.histroyView removeFromSuperview];
    UIView *historyView=[self ViewWithSearchHistoryWithFram:CGRectMake(0, tempFrame.origin.y, kWidth, 0)];
    self.histroyView=historyView;
    [self.backScrollView addSubview:historyView];

    
}
-(void)clearHistoryBtnAction:(UIButton *)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *searchHistoryAry=[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"searchHistoryAry"]];
    [searchHistoryAry removeAllObjects];
    [userDefaults setObject:searchHistoryAry forKey:@"searchHistoryAry"];
    [userDefaults synchronize];
    [self.histroyView removeFromSuperview];
}
-(void)hotSaerchBtnAction:(UIButton *)sender
{
    NSString *searchStr=[sender.titleLabel text];
    if (searchStr.length==0) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *searchHistoryAry=[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"searchHistoryAry"]];
    if (![searchHistoryAry containsObject:searchStr]) {
        if (searchHistoryAry.count<10) {
            [searchHistoryAry addObject:searchStr];
            [userDefaults setObject:searchHistoryAry forKey:@"searchHistoryAry"];
            [userDefaults synchronize];
        }else
        {
            [searchHistoryAry addObject:searchStr];
            [searchHistoryAry removeObjectAtIndex:0];
             [userDefaults setObject:searchHistoryAry forKey:@"searchHistoryAry"];
            [userDefaults synchronize];
        }
    }
    if (self.delegate) {
        [self.delegate SearchRecommendViewSearch:searchStr];
    }
}
@end
