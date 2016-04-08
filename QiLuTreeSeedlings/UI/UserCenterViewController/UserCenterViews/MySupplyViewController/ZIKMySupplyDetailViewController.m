//
//  ZIKMySupplyDetailViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKMySupplyDetailViewController.h"
#import "SupplyDetialMode.h"
#import "SellBanderTableViewCell.h"
#import "BuyOtherInfoTableViewCell.h"
#import "MySupplyOtherInfoTableViewCell.h"
#import "HotSellModel.h"
#import "ZIKSupplyPublishVC.h"
@interface ZIKMySupplyDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSString                        *uid;
@property (nonatomic, strong) SupplyDetialMode                *model;
@property (nonatomic,strong ) UITableView                     *tableView;
@property (nonatomic, strong) NSArray *nurseryDateArray;
@property (nonatomic, strong) HotSellModel *hotSellModel;
@end

@implementation ZIKMySupplyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNav];
    [self initData];
    [self initUI];
}

- (void)configNav {
    self.vcTitle = @"供应详情";
    self.rightBarBtnTitleString = @"编辑";
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{
//        NSLog(@"编辑");
        ZIKSupplyPublishVC *zikSupplyPVC=[[ZIKSupplyPublishVC alloc]initWithModel:weakSelf.model];
        [weakSelf.navigationController pushViewController:zikSupplyPVC animated:YES];
    };
}

-(id)initMySupplyDetialWithUid:(ZIKSupplyModel *)ZIKSupplyModel{
    self = [super init];
    if (self) {
        self.uid = ZIKSupplyModel.uid;
        self.hotSellModel =[HotSellModel new];
        self.hotSellModel.area=ZIKSupplyModel.area;
        self.hotSellModel.title=ZIKSupplyModel.title;
        [HTTPCLIENT getMySupplyDetailInfoWithAccessToken:nil accessId:nil clientId:nil clientSecret:nil deviceId:nil uid:ZIKSupplyModel.uid Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *dic = [responseObject objectForKey:@"result"];
                SupplyDetialMode *model = [SupplyDetialMode creatSupplyDetialModelByDic:[dic objectForKey:@"detail"]];
                model.supplybuyName=APPDELEGATE.userModel.name;
                model.phone=APPDELEGATE.userModel.phone;
                self.model = model;
                self.nurseryDateArray = dic[@"nurseryNames"];
                [self.tableView reloadData];
            }

        } failure:^(NSError *error) {

        }];
    }
    return self;
    
}

- (void)initData {

}

- (void)initUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    self.tableView = tableView;
    tableView.delegate   = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 330;
    }
    if (indexPath.section==1) {
        return self.model.spec.count*30+10;
    }
    if (indexPath.section==2) {
        return self.nurseryDateArray.count*30+100;
    }
    if (indexPath.section==3) {
        NSString *labelText=self.model.descriptions;

        if (labelText.length==0) {
            labelText=@"暂无";
        }
        return [self getHeightWithContent:labelText width:kWidth-40 font:13]+20;
    }
    if (indexPath.section==4) {
        return 100;
    }
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.01;
    }
    if(section==4)
    {
        return 50;
    }else
    {
        return 30;
    }

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view=[[UIView alloc]init];
        return view;
    }
    if (section==4) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
        [view setBackgroundColor:BGColor];
        UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 24.25, kWidth, 0.5)];
        [lineView setBackgroundColor:kLineColor];
        [view addSubview:lineView];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-35, 0, 70, 50)];
        [titleLab setTextColor:titleLabColor];
        [titleLab setBackgroundColor:BGColor];
        [titleLab setTextAlignment:NSTextAlignmentCenter];
        [titleLab setText:@"猜你喜欢"];
        [view addSubview:titleLab];
        return view;
    }
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    [view setBackgroundColor:BGColor];
    UIImageView *linImag=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 2.3, 16)];
    [linImag setBackgroundColor:NavColor];
    [view addSubview:linImag];
    UILabel *messageLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, 60, 20)];
    [messageLab setFont:[UIFont systemFontOfSize:13]];
    [messageLab setTextColor:detialLabColor];
    [view addSubview:messageLab];
    if (section==1) {
        messageLab.text=@"苗木要求";
    }else if (section==2){
        messageLab.text=@"其他信息";
    }else if (section==3){
        messageLab.text=@"产品描述";
    }
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.model) {
        if (indexPath.section==0) {
            SellBanderTableViewCell *cell = [[SellBanderTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 330) andModel:self.model andHotSellModel:self.hotSellModel];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.section==1) {
            BuyOtherInfoTableViewCell *cell=[[BuyOtherInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, self.model.spec.count*30+10)];
            cell.ary=self.model.spec;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if(indexPath.section==2)
        {
            MySupplyOtherInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[MySupplyOtherInfoTableViewCell IDStr]];
            if (!cell) {
                cell = [[MySupplyOtherInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 30*4+10)];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            
            cell.model=self.model;
            cell.nuseryAry=self.nurseryDateArray;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }

    if(indexPath.section==3)
    {

        NSString *labelText=self.model.descriptions;
        if (labelText.length==0) {
            labelText=@"暂无";
        }
        CGFloat height = [self getHeightWithContent:labelText width:kWidth-40 font:13];
        //NSLog(@"%f",height);
        UITableViewCell *cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kWidth, height+20)];
        UILabel *cellLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, kWidth-40, height)];
        [cellLab setFont:[UIFont systemFontOfSize:13]];
        cellLab.numberOfLines=0;
        [cell addSubview:cellLab];
        [cellLab setText:labelText];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;

    }
    UITableViewCell *cell = [UITableViewCell new];
    return cell;
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


@end
