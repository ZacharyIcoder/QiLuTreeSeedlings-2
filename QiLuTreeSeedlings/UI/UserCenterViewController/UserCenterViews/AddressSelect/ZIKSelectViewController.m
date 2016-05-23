//
//  ZIKSelectViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKSelectViewController.h"
#import "ZIKCityListViewController.h"
#import "GetCityDao.h"
#import "CityModel.h"
#import "ZIKCityModel.h"
@interface ZIKSelectViewController ()<ZIKCityListViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic, strong) NSMutableArray *citys;
@property (nonatomic, strong) NSString       *citysStr;//地址的code string “，，”
@property (nonatomic) SelectStyle selectStyle;
@end

@implementation ZIKSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = @"选择详情";
}

#pragma mark - 确定返回后，传回地址执行协议
- (void)selectCitysInfo:(NSString *)citysStr {
    _citysStr = citysStr;
    GetCityDao *citydao = [GetCityDao new];
    [citydao openDataBase];
   __block NSString *str = @"";
    NSArray *cityArray = [_citysStr componentsSeparatedByString:@","];
    [cityArray enumerateObjectsUsingBlock:^(NSString *cityCode, NSUInteger idx, BOOL * _Nonnull stop) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[citydao getCityNameByCityUid:cityCode]]];
    }];
    [citydao closeDataBase];

    [self.selectBtn setTitle:str forState:UIControlStateNormal];
}

- (IBAction)selectBtnClick:(id)sender {
    //self.citys = nil;
    ZIKCityListViewController *cityVC = [[ZIKCityListViewController alloc] init];
    cityVC.selectStyle = SelectStyleMultiSelect;
    self.selectStyle = SelectStyleMultiSelect;
    cityVC.delegate = self;
    [self.navigationController pushViewController:cityVC animated:YES];
    cityVC.citys = self.citys;
}

- (NSArray *)citys {
    //if (_citys == nil) {
        _citys = [[NSMutableArray alloc] init];
        GetCityDao *dao = [[GetCityDao alloc] init];
        [dao openDataBase];
         NSArray *allProvince = [dao getCityByLeve:@"1"];
         [allProvince enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
             ZIKCityModel *cityModel = [ZIKCityModel initCityModelWithDic:dic];
//             cityModel.province.citys = [dao getCityByLeve:@"2" andParent_code:cityModel.province.code];
             NSMutableArray *cityMArr = [dao getCityByLeve:@"2" andParent_code:cityModel.province.code];


             NSMutableDictionary *dicionary = [NSMutableDictionary dictionary];
             [dicionary setObject:cityModel.province.provinceID forKey:@"id"];
             [dicionary setObject:cityModel.province.code forKey:@"code"];
             [dicionary setObject:cityModel.province.parent_code forKey:@"parent_code"];
             [dicionary setObject:@"全省" forKey:@"name"];
             [dicionary setObject:cityModel.province.level forKey:@"level"];
             [cityMArr insertObject:dicionary atIndex:0];
             cityModel.province.citys = cityMArr;

             [_citys addObject:cityModel];
             
         }];
        //self.dataAry = [CityModel creatCityAryByAry:allTown];
        [dao closeDataBase];
    if (![[self.selectBtn currentTitle] isEqualToString:@"选择地址"]) {
         NSArray *cityArray = [_citysStr componentsSeparatedByString:@","];
        __block NSInteger numcount = 0;
        [_citys enumerateObjectsUsingBlock:^(ZIKCityModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            [model.province.citys enumerateObjectsUsingBlock:^(NSMutableDictionary *cityDic, NSUInteger idx, BOOL * _Nonnull stop) {
                [cityArray enumerateObjectsUsingBlock:^(NSString *cityCode, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([cityDic[@"code"] isEqualToString:cityCode]) {
                        cityDic[@"select"] = @"1";
                        if (++numcount == cityArray.count) {
                            *stop = YES;
                        }
                    }
                }];
            }];
        }];
    }

    //}
    return _citys;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
