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

#import "ZIKFunction.h"
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
//    if (n == 1) {
//
//    }
     NSInteger num = 0;
    if (n >= 3) {
        num = 3;
    } else  {
        num = n;
    }
    float imageWidth =  (kWidth - 70) / num * 1.0;
    float imageHeight = 0;
//    if (num == 1) {
//        imageHeight = (kWidth - 50) / 3.0 + 20;
//    } else {
//        imageHeight = (kWidth - 50) / 3.0 ;
//    }
    imageHeight = imageWidth*0.67;

    for (NSInteger i = 0; i < n; i++) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:i]
                                                                 ] options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             CLog(@"progress!!!");
         }
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
         {
             CGRect rect = CGRectMake(25 + (i % num) * (imageWidth + 10) ,  (i / num) * (imageHeight + 10), imageWidth, imageHeight);
             UIButton *imageView = [[UIButton alloc]initWithFrame:rect];
             CLog(@"%@",image);
             if (image == nil) {
                 image = [UIImage imageNamed:@"MoRentu"];
                }

//             imageView.contentMode = UIViewContentModeScaleAspectFit;
//             if (num == 1) {
//                 imageView.frame = CGRectMake(kWidth/2-50, 10, 100, 60);
//             } else {
             imageView.frame = rect;
             //}
             if ([image isEqual:[UIImage imageNamed:@"MoRentu"]] ) {
                 if (num == 1) {
                     imageView.frame = CGRectMake(kWidth/2-65, 10, 130, 85);
                 }
             } else {
                 if (num == 1) {
                     imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width+20, imageView.frame.size.height);
                 }
             }

             [imageView setBackgroundImage:image forState:UIControlStateNormal];
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

- (UIImage*)resizeImage:(UIImage*)image withWidth:(CGFloat)width withHeight:(CGFloat)height
{
    CGSize newSize = CGSizeMake(width, height);
    CGFloat widthRatio = newSize.width/image.size.width;
    CGFloat heightRatio = newSize.height/image.size.height;

    if(widthRatio > heightRatio)
    {
        newSize=CGSizeMake(image.size.width*heightRatio,image.size.height*heightRatio);
    }
    else
    {
        newSize=CGSizeMake(image.size.width*widthRatio,image.size.height*widthRatio);
    }


    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}


-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{

    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

    if(CGSizeEqualToSize(imageSize, size) == NO){

        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;

        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;

        }
        else{

            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;

        if(widthFactor > heightFactor){

            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){

            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }

    UIGraphicsBeginImageContext(size);

    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [sourceImage drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

@end
