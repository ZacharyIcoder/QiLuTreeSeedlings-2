//
//  ZIKMyHonorViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMyHonorViewController.h"
#import "ZIKMyHonorCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
NSString *kHonorCellID = @"honorcellID";

@interface ZIKMyHonorViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)    NSMutableArray     *honorData;

@property (weak, nonatomic) IBOutlet UICollectionView *honorCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *honorCollectionViewFlowLayout;
@end

@implementation ZIKMyHonorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = BGColor;
    self.vcTitle = self.vctitle;
    if ([self.vctitle isEqualToString:@"公司资质"]) {
        [self.navBackView setBackgroundColor:NavYellowColor];
    }
    self.rightBarBtnTitleString = @"添加";
//    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{
        NSLog(@"添加点击");
    };
    self.honorCollectionView.delegate = self;
    self.honorCollectionView.dataSource = self;
}

/**
 *  懒加载获取plist中对应的数据源
 *
 */
- (NSMutableArray *)honorData
{
    if (_honorData == nil) {

        NSString * honorPath = [[NSBundle mainBundle] pathForResource:@"honor" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:honorPath];
        NSMutableArray *array = [dic objectForKey:@"honorList"];
//        NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:honorPath];

        _honorData = array;
    }

    return _honorData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return self.honorData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UINib *nib = [UINib nibWithNibName:@"ZIKMyHonorCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [cv registerNib:nib forCellWithReuseIdentifier:kHonorCellID];
    //ZIKIntegralCollectionViewCell *cell = [[ZIKIntegralCollectionViewCell alloc] init];
    ZIKMyHonorCollectionViewCell * cell = [cv dequeueReusableCellWithReuseIdentifier:kHonorCellID
                                                                         forIndexPath:indexPath];
    if (self.honorData.count > 0) {
       // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.honorData[indexPath.row] objectForKey:@"url"]]];
        NSString *myurlstr = [NSString stringWithFormat:@"%@",[self.honorData[indexPath.row] objectForKey:@"url"]];
        NSURL *honorUrl = [NSURL URLWithString:myurlstr];
        NSURL *myurl    = [[NSURL alloc] initWithString:myurlstr];
        NSLog(@"%@",myurl);
        [cell.honorImageView setImageWithURL:honorUrl placeholderImage:[UIImage imageNamed:@"MoRentu"]];
        cell.honorTitleLabel.text = [self.honorData[indexPath.row] objectForKey:@"title"];
        cell.honorTimeLabel.text  = [self.honorData[indexPath.row] objectForKey:@"time"];
    }
    return cell;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
      
}

@end
