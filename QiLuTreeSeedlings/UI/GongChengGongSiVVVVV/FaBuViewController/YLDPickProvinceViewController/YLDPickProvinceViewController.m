//
//  YLDPickProvinceViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/8/26.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDPickProvinceViewController.h"
#import "GetCityDao.h"
#import "ZIKCityTableViewCell.h"

@interface YLDPickProvinceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSArray *cityModelAry;
@property (nonatomic,strong)NSMutableArray *selectAry;
@end

@implementation YLDPickProvinceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectAry=[NSMutableArray array];
    self.vcTitle=@"请选择地区";
    self.rightBarBtnTitleString = @"确定";
    
    GetCityDao *dao=[GetCityDao new];
    [dao openDataBase];
   NSArray *cityAry = [dao getCityByLeve:@"1"];
    [dao closeDataBase];

    self.cityModelAry=[CityModel creatCityAryByAry:cityAry];
    __weak typeof(self) weakSelf = self;
    self.rightBarBtnBlock = ^{
        if (weakSelf.delegate) {
            
//            [weakSelf.delegate selectCitysInfo:@""];
            [weakSelf.delegate selectCityModels:weakSelf.selectAry];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
       
    };
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cityModelAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *QuoteCellIdentifier = @"QuoteCellIdentifier";
    
    ZIKCityTableViewCell *cell = (ZIKCityTableViewCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKCityTableViewCell" owner:self options:nil] lastObject];
    }
    cell.model=self.cityModelAry[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CityModel *model=self.cityModelAry[indexPath.row];
    model.select=!model.select;
    if (model.select) {
        [self.selectAry addObject:model];
    }else{
        [self.selectAry removeObject:model];
    }
    //NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
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
