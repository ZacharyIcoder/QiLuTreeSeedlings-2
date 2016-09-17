//
//  ZIKShaiDanDetailPictureTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKShaiDanDetailPictureTableViewCell.h"
#import "UIDefines.h"
#import "SDImageCache.h"      //缓存相关
#import "SDWebImageCompat.h"  //组件相关
#import "SDWebImageDecoder.h" //解码相关

//图片下载以及下载管理器
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloaderOperation.h"
//#import "WeiboDefine.h"
#import "WeiboImageView.h"
#import "WeiboImageBrowser.h"


@implementation ZIKShaiDanDetailPictureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setImageArray:(NSArray *)imageArray {
//    CLog(@"%@",self.contentView.description);
    while ([self.contentView.subviews lastObject] != nil) {
        [(UIView *)[self.contentView.subviews lastObject] removeFromSuperview];
    }
//    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CLog(@"%@",obj.description);
//    }];
    _imageArray = imageArray;

    NSInteger n = _imageArray.count;
    if (n == 0) {
        return;
    }
    NSInteger num = 0;
    if (n >= 3) {
        num = 3;
    } else  {
        num = n;
    }
    float imageWidth =  (kWidth - 50) / num * 1.0;
    float imageHeight = 0;
    if (num == 1) {
        imageHeight = (kWidth - 50) / 3.0 + 20;
    } else {
        imageHeight = (kWidth - 50) / 3.0;
    }

    for (NSInteger i = 0; i < n; i++) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:i]
                                                                 ] options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             NSLog(@"progress!!!");
         }
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
         {
             CGRect rect = CGRectMake(15 + (i % num) * (imageWidth + 10) ,  (i / num) * (imageWidth + 10), imageWidth, imageHeight);
             UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
             CLog(@"%@",image);
             if (image == nil) {
                 image = [UIImage imageNamed:@"MoRentu"];
                }
             imageView.image = image;
//             if (num == 1) {
//                 imageView.frame = CGRectMake(kWidth/2-50, 10, 100, 60);
//             } else {
             imageView.frame = rect;
             //}
             if ([image isEqual:[UIImage imageNamed:@"MoRentu"]] ) {
                 if (num == 1) {
                     imageView.frame = CGRectMake(kWidth/2-50, 10, 100, 60);
                 }
             }
             imageView.clipsToBounds = YES;
             imageView.contentMode = UIViewContentModeScaleAspectFill;
             imageView.tag = i;
             imageView.userInteractionEnabled = YES;
             UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
             [imageView addGestureRecognizer:tap];
             [self.contentView addSubview:imageView];

         }];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *kZIKShaiDanDetailPictureTableViewCellID = @"kZIKShaiDanDetailPictureTableViewCellID";

    ZIKShaiDanDetailPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKShaiDanDetailPictureTableViewCellID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kZIKShaiDanDetailPictureTableViewCellID];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self setupTopView];
    }

    return self;
}

- (void)setupTopView {

}

-(void)imageTap:(UITapGestureRecognizer *)tap
{
    WeiboImageBrowser *imageBrowser = [[WeiboImageBrowser alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    imageBrowser.currentSelectedIamge = (int)tap.view.tag;
    imageBrowser.bigImageArray = /*weiboInformation.pic_urls*/_imageArray;
    [imageBrowser showWeiboImages];
}

@end
