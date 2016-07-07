//
//  YLDShengJiViewViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/22.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDShengJiViewViewController.h"
#import "UIDefines.h"
#import "YLDShenFenShuoMingCell.h"
#import "YLDGCGSZiZhiTiJiaoViewController.h"
@interface YLDShengJiViewViewController ()<UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic,strong)UITableView *tableView;
@end

@implementation YLDShengJiViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"身份升级";
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return [self getHeightWithContent:@"工作站是齐鲁苗木网以乡镇为单位在全国招募一批有诚信的苗木企业，一起做诚信的事，尽而带动整个苗木行业的健康发展。其主要服务有：\n1. 推送大量工程采购订单，以保障工作站站长收益；\n2. 按企业自己需求定制精准求购；\n3. 美企业商铺；\n4. 站长圈，保障站长间的信息互通，促成站长间的交易；\n5. 园林资材商城利润分成；" width:kWidth-55 font:15]+136;
    }
    if (indexPath.row==1) {
          return [self getHeightWithContent:@"工程公司是通过齐鲁苗木网资质审核的苗木采购方，可免费发布工程采购订单，免费发布询价订单，免费查看苗农苗企的苗源信息，展示工程案例。" width:kWidth-55 font:15]+136;
    }
    return 180;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDShenFenShuoMingCell *cell=[YLDShenFenShuoMingCell yldShenFenShuoMingCell];
    if (indexPath.row==0) {
        NSMutableDictionary *dic=[NSMutableDictionary new];
        dic[@"title"]=@"工作站身份简介";
        dic[@"detial"]=@"工作站是齐鲁苗木网以乡镇为单位在全国招募一批有诚信的苗木企业，一起做诚信的事，尽而带动整个苗木行业的健康发展。其主要服务有：\n1. 推送大量工程采购订单，以保障工作站站长收益；\n2. 按企业自己需求定制精准求购；\n3. 美企业商铺；\n4. 站长圈，保障站长间的信息互通，促成站长间的交易；\n5. 园林资材商城利润分成；";
        cell.dic=dic;
        cell.shengjiBtn.tag=0;
       
        [cell.shengjiBtn addTarget:self action:@selector(shengjiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (indexPath.row==1) {
        NSMutableDictionary *dic=[NSMutableDictionary new];
        dic[@"title"]=@"工作站身份简介";
        dic[@"detial"]=@"工程公司是通过齐鲁苗木网资质审核的苗木采购方，可免费发布工程采购订单，免费发布询价订单，免费查看苗农苗企的苗源信息，展示工程案例。";
        cell.dic=dic;
        cell.shengjiBtn.tag=1;
        [cell.shengjiBtn addTarget:self action:@selector(shengjiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)shengjiBtnAction:(UIButton *)sender
{
    if (sender.tag==0) {
        [ToastView showTopToast:@"暂未开放此功能"];
    }
    if (sender.tag==1) {
        YLDGCGSZiZhiTiJiaoViewController *yldVC=[[YLDGCGSZiZhiTiJiaoViewController alloc]init];
        [self.navigationController pushViewController:yldVC animated:YES];
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
