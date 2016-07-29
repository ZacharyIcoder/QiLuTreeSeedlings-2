//
//  ZIKStationCenterTableViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/18.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationCenterTableViewController.h"
#import "ZIKStationCenterTableViewHeaderView.h"
#import "ZIKStationCenterContentTableViewCell.h"
#import "UIDefines.h"
#import "ZIKMyHonorViewController.h"
#import "MasterInfoModel.h"
#import "YYModel.h"//类型转换
#import "ZIKStationCenterInfoViewController.h"
#import "ZIKMyTeamViewController.h"//我的团队
//友盟
#import "UMSocialControllerService.h"
#import "UMSocial.h"
static NSString *SectionHeaderViewIdentifier = @"StationCenterSectionHeaderViewIdentifier";

@interface ZIKStationCenterTableViewController ()<UMSocialUIDelegate>
@property (nonatomic, strong) MasterInfoModel *masterModel;

@property (nonatomic, strong) NSString       *shareText; //分享文字
@property (nonatomic, strong) NSString       *shareTitle;//分享标题
@property (nonatomic, strong) UIImage        *shareImage;//分享图片
@property (nonatomic, strong) NSString       *shareUrl;  //分享url
@end

#pragma mark -

#define DEFAULT_ROW_HEIGHT 44
#define HEADER_HEIGHT 240
#define FOOTER_HEIGHT (kHeight-HEADER_HEIGHT-44-44-130-60)

@implementation ZIKStationCenterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.sectionHeaderHeight    = HEADER_HEIGHT;
    if (self.view.frame.size.height>480) {
        self.tableView.scrollEnabled  = NO; //设置tableview 不能滚动
    } else {
        self.tableView.scrollEnabled  = YES; //设置tableview 不能滚动
    }
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ZIKStationCenterTableViewHeaderView" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    UIView *view = [UIView new];
    view.backgroundColor = BGColor;
    [self.tableView setTableFooterView:view];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushChangeMasterInfo) name:@"ZIKChangeMasterInfo" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestShare) name:@"ZIKUMShare" object:nil];

}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZIKChangeMasterInfo" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZIKUMShare" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self requestData];
}

- (void)pushChangeMasterInfo {
    ZIKStationCenterInfoViewController *changeInfoVC = [[ZIKStationCenterInfoViewController alloc] init];
    changeInfoVC.hidesBottomBarWhenPushed = YES;
    changeInfoVC.masterModel = self.masterModel;
    [self.navigationController pushViewController:changeInfoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求数据
- (void)requestData {
   [HTTPCLIENT stationMasterSuccess:^(id responseObject) {
       //CLog(@"%@",responseObject);
       if ([responseObject[@"success"] integerValue] == 0) {
           [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
           return ;
       }
       if (self.masterModel) {
           self.masterModel = nil;
       }
       NSDictionary *result = responseObject[@"result"];
       NSDictionary *masterInfo = result[@"masterInfo"];
       self.masterModel = [MasterInfoModel yy_modelWithDictionary:masterInfo];
       [self.tableView reloadData];

   } failure:^(NSError *error) {
       ;
   }];
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10.0f;
    }
    return HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 130;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return FOOTER_HEIGHT;
    }
    return 0.01f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZIKStationCenterContentTableViewCell *cell = [ZIKStationCenterContentTableViewCell cellWithTableView:tableView];
        if (self.masterModel) {
            [cell configureCell:self.masterModel];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1) {
      static NSString *cellID = @"cellID";
        UITableViewCell *twocell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (twocell == nil) {
            twocell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        if (indexPath.row == 0) {
            twocell.textLabel.text = @"我的荣誉";
            twocell.textLabel.textColor = [UIColor darkGrayColor];
            twocell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            twocell.imageView.image = [UIImage imageNamed:@"站长中心-我的荣誉"];
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(15, 43, kWidth-15, 1);
            lineView.backgroundColor = kLineColor;
            [twocell addSubview:lineView];
        } else if (indexPath.row == 1) {
            twocell.textLabel.text = @"我的团队";
            twocell.textLabel.textColor = [UIColor darkGrayColor];
            twocell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            twocell.imageView.image = [UIImage imageNamed:@"站长中心-我的团队"];
        }

        float sw=23/twocell.imageView.image.size.width;
        float sh=25/twocell.imageView.image.size.height;
        twocell.imageView.transform=CGAffineTransformMakeScale(sw,sh);

        twocell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        twocell.selectionStyle = UITableViewCellSelectionStyleNone;

        return twocell;
    }
        return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        ZIKStationCenterTableViewHeaderView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
        if (self.masterModel) {
            [sectionHeaderView configWithModel:self.masterModel];
        }
        return sectionHeaderView;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = BGColor;
}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (section == 1) {
//        UIView *bottomView = [[UIView alloc] init];
//        bottomView.frame = CGRectMake(0, 0, kWidth, FOOTER_HEIGHT);
//        bottomView.backgroundColor = BGColor;
//        return bottomView;
//    }
//    return nil;
//}

#pragma mark - Table view delegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ZIKMyHonorViewController *honorVC = [[ZIKMyHonorViewController alloc] initWithNibName:@"ZIKMyHonorViewController" bundle:nil];
            honorVC.hidesBottomBarWhenPushed  = YES;
            honorVC.type = TypeHonor;
            honorVC.workstationUid = self.masterModel.uid;
            [self.navigationController pushViewController:honorVC animated:YES];
        } else if (indexPath.row == 1) {
            ZIKMyTeamViewController *teamVC = [[ZIKMyTeamViewController  alloc] initWithNibName:@"ZIKMyTeamViewController" bundle:nil];
            teamVC.hidesBottomBarWhenPushed = YES;
            teamVC.uid = self.masterModel.uid;
            [self.navigationController pushViewController:teamVC animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)requestShare {
    //ShowActionV();
    [HTTPCLIENT stationShareSuccess:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            //RemoveActionV();
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:kWidth/2 withSuperView:self.view];
            return ;
        }
        NSDictionary *shareDic = [responseObject[@"result"] objectForKey:@"share"];
        self.shareText   = shareDic[@"text"];
        self.shareTitle  = shareDic[@"title"];
        NSString *urlStr = shareDic[@"pic"];
        NSData * data    = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr]];
        self.shareImage  = [[UIImage alloc] initWithData:data];
        self.shareUrl    = shareDic[@"url"];
        //RemoveActionV();
        [self umengShare];

    } failure:^(NSError *error) {
        //RemoveActionV();
    }];

}

- (void)umengShare {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"56fde8aae0f55a1cd300047c"
                                      shareText:self.shareText
                                     shareImage:self.shareImage
                                shareToSnsNames:@[UMShareToWechatTimeline,UMShareToQzone,UMShareToWechatSession,UMShareToQQ]
                                       delegate:self];

    NSString *urlString = self.shareUrl;


    [UMSocialData defaultData].extConfig.wechatSessionData.url = urlString;

    //如果是朋友圈，则替换平台参数名即可

    [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlString;

    [UMSocialData defaultData].extConfig.qqData.url    = urlString;
    [UMSocialData defaultData].extConfig.qzoneData.url = urlString;
    //设置微信好友title方法为
    NSString *titleString = self.shareTitle;

    [UMSocialData defaultData].extConfig.wechatSessionData.title = titleString;

    //设置微信朋友圈title方法替换平台参数名即可

    [UMSocialData defaultData].extConfig.wechatTimelineData.title = titleString;

    //QQ设置title方法为

    [UMSocialData defaultData].extConfig.qqData.title = titleString;

    //Qzone设置title方法将平台参数名替换即可

    [UMSocialData defaultData].extConfig.qzoneData.title = titleString;

}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    //NSLog(@"didClose is %d",fromViewControllerType);
}

//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //NSLog(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        //NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

-(void)didFinishShareInShakeView:(UMSocialResponseEntity *)response
{
    //NSLog(@"finish share with response is %@",response);
}


@end
