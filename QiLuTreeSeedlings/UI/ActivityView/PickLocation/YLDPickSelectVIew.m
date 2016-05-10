//
//  YLDPickSelectVIew.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/10.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "YLDPickSelectVIew.h"

#import "CityTableViewCell.h"
#import "GetCityDao.h"
@interface YLDPickSelectVIew ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataAry;
@end

@implementation YLDPickSelectVIew
-(id)initWithFrame:(CGRect)frame andCode:(NSString *)code andLeve:(NSString *)leve
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        UITableView  *tableView=[[UITableView alloc]initWithFrame:self.bounds];
        [self addSubview:tableView];
        tableView.delegate=self;
        tableView.dataSource=self;
        self.tableView=tableView;
        GetCityDao *dao = [[GetCityDao alloc] init];
        [dao openDataBase];
        NSArray *allTown;
        if (code==nil) {
            allTown = [dao getCityByLeve:leve];
        }else
        {
            NSInteger k=[leve integerValue];
            k=k+1;
           allTown = [dao getCityByLeve:[NSString stringWithFormat:@"%ld",k] andParent_code:code];
        }
        self.dataAry=[CityModel creatCityAryByAry:allTown];
        [dao closeDataBase];
        [tableView reloadData];
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CityTableViewCell"];
    if (!cell) {
        cell=[CityTableViewCell CityTableViewCell];
    }
    CityModel *model=self.dataAry[indexPath.row];
    cell.model=model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityModel *model=self.dataAry[indexPath.row];
    if (self.delegate) {
        [self.delegate selectWithCtiyModel:model andYLDPickSelectVIew:self];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
