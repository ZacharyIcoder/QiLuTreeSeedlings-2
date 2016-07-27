//
//  SellSearchTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/1.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "SellSearchTableViewCell.h"
#import "UIDefines.h"
#import "UIImageView+AFNetworking.h"
#import "StringAttributeHelper.h"
#define kSCREEN_EDGE_DISTANCE 15 //距离屏幕边缘距离

@interface SellSearchTableViewCell()
@property (nonatomic,strong)UIImageView *imageV;
@property (nonatomic,strong)UILabel *priceLab;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *cityLab;
@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic,strong)UILabel *numLab;
@property (nonatomic,strong)UIImageView *goldImageView;
@end
@implementation SellSearchTableViewCell
{
    UIImageView *timeImagV;
}
@synthesize imageV,titleLab,cityLab,timeLab,numLab,priceLab,goldImageView;
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
      [self setAccessibilityIdentifier:@"SellSearchTableViewCell1"];
        imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 80, frame.size.height-30)];
        [imageV setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:imageV];
        goldImageView = [[UIImageView alloc] initWithFrame:CGRectMake(97, 15, 20, 20)];
        [self addSubview:goldImageView];
        titleLab=[[UILabel alloc]initWithFrame:CGRectMake(100+20, 15, frame.size.width-100-20-10, 20)];
        [titleLab setFont:[UIFont systemFontOfSize:15]];
        [titleLab setText:@"标题"];
        [titleLab setTextColor:titleLabColor];
        [self addSubview:titleLab];
        UIImageView *dingweiImageV=[[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.11+90, 42, 15, 15)];
        [dingweiImageV setImage:[UIImage imageNamed:@"region"]];
        [self addSubview:dingweiImageV];
        cityLab=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.11+20+87, 40, 100, 20)];
        [cityLab setFont:[UIFont systemFontOfSize:14]];
        cityLab.text=@"山东 临沂";
        [cityLab setTextColor:detialLabColor];
        [self addSubview:cityLab];
         timeLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-70-kSCREEN_EDGE_DISTANCE, 40, 70, 20)];
        [timeLab setFont:[UIFont systemFontOfSize:14]];
        timeLab.text=@"今天";
        timeLab.textAlignment = NSTextAlignmentRight;
         [timeLab setTextColor:detialLabColor];
        [self addSubview:timeLab];
        timeImagV=[[UIImageView alloc]initWithFrame:CGRectMake(timeLab.frame.origin.x-15, 40, 15, 15)];
        [timeImagV setImage:[UIImage imageNamed:@"listtime"]];
        [self addSubview:timeImagV];

        UIImageView *numImage=[[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.11+87, 72, 15, 15)];
        [numImage setImage:[UIImage imageNamed:@"LISTtreeNumber"]];
        [self addSubview:numImage];
        numLab=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.11+20+87, 70, 88, 20)];
        [numLab setFont:[UIFont systemFontOfSize:14]];
        numLab.text=@"599棵(株)";
        [numLab setTextColor:detialLabColor];
        [self addSubview:numLab];
//        UILabel *shangcheLab=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.65-10+77, 70, 50, 20)];
//        [shangcheLab setFont:[UIFont systemFontOfSize:14]];
//        shangcheLab.text=@"上车价";
//         [shangcheLab setTextColor:titleLabColor];
//        [self addSubview:shangcheLab];
        priceLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2, 68, kWidth/2-kSCREEN_EDGE_DISTANCE, 20)];
        [priceLab setFont:[UIFont systemFontOfSize:18]];
//        priceLab.text=@"50";
        priceLab.textAlignment = NSTextAlignmentRight;
        [priceLab setTextColor:yellowButtonColor];
        [self addSubview:priceLab];
        
        UIImageView *lineImageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5)];
        [lineImageV setBackgroundColor:kLineColor];
        [self addSubview:lineImageV];

    }
    return self;
}
+(NSString *)IDStr
{
    return @"SellSearchTableViewCell1";
}
-(void)setHotSellModel:(HotSellModel *)hotSellModel
{
    _hotSellModel=hotSellModel;
    [self.imageV setImageWithURL:[NSURL URLWithString:hotSellModel.iamge] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
    //NSArray *priceAry=[hotSellModel.price componentsSeparatedByString:@"."];
//    self.priceLab.text=[priceAry firstObject];
    NSString *priceString = [NSString stringWithFormat:@"上车价 ¥%@", hotSellModel.price];
    FontAttribute *fullFont = [FontAttribute new];
    fullFont.font = [UIFont systemFontOfSize:18.0f];
    fullFont.effectRange  = NSMakeRange(0, priceString.length);
    ForegroundColorAttribute *fullColor = [ForegroundColorAttribute new];
    fullColor.color = yellowButtonColor;
    fullColor.effectRange = NSMakeRange(0,priceString.length);
    //局部设置
    FontAttribute *partFont = [FontAttribute new];
    partFont.font = [UIFont systemFontOfSize:14.0f];
    partFont.effectRange = NSMakeRange(0, 5);
    ForegroundColorAttribute *darkColor = [ForegroundColorAttribute new];
    darkColor.color = detialLabColor;
    darkColor.effectRange = NSMakeRange(0, 4);

    self.priceLab.attributedText = [priceString mutableAttributedStringWithStringAttributes:@[fullFont,partFont,fullColor,darkColor]];

    self.titleLab.text=hotSellModel.title;
    self.numLab.text=[NSString stringWithFormat:@"%@ 棵(株)",hotSellModel.count];
    self.cityLab.text=hotSellModel.area;
    self.timeLab.text=  hotSellModel.timeAger;
//    self.timeLab.text=  @"24小时前";

    [timeLab setNumberOfLines:1];
    timeLab.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize size = [hotSellModel.timeAger boundingRectWithSize:CGSizeMake(70, 20) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    [timeLab setFrame:CGRectMake(kWidth-kSCREEN_EDGE_DISTANCE-size.width, timeLab.frame.origin.y, size.width, size.height)];
    [timeImagV setFrame:CGRectMake(timeLab.frame.origin.x-17, timeImagV.frame.origin.y, timeImagV.frame.size.width, timeImagV.frame.size.height)];
    cityLab.frame = CGRectMake(cityLab.frame.origin.x, 40, timeImagV.frame.origin.x-cityLab.frame.origin.x, 20);
    //cityLab.backgroundColor = [UIColor yellowColor];
    if (hotSellModel.goldsupplier == 0 || hotSellModel.goldsupplier == 10) {
        goldImageView.hidden=YES;
        CGRect frame=self.titleLab.frame;
        frame.origin.x=100;
        self.titleLab.frame=frame;
    } else if (hotSellModel.goldsupplier == 1) {
        goldImageView.hidden=NO;
        CGRect frame=self.titleLab.frame;
        frame.origin.x=120;
        self.titleLab.frame=frame;
        goldImageView.image = [UIImage imageNamed:@"列表-金牌供应商"];
    } else if (hotSellModel.goldsupplier == 2) {
        goldImageView.hidden=NO;
        CGRect frame=self.titleLab.frame;
        frame.origin.x=120;
        self.titleLab.frame=frame;
        goldImageView.image = [UIImage imageNamed:@"列表-银牌供应商"];
    } else if (hotSellModel.goldsupplier == 3) {
        goldImageView.hidden=NO;
        CGRect frame=self.titleLab.frame;
        frame.origin.x=120;
        self.titleLab.frame=frame;
        goldImageView.image = [UIImage imageNamed:@"列表-铜牌牌供应商"];
    } else if (hotSellModel.goldsupplier == 4) {
        goldImageView.hidden=NO;
        CGRect frame=self.titleLab.frame;
        frame.origin.x=120;
        self.titleLab.frame=frame;
        goldImageView.image = [UIImage imageNamed:@"列表-认证供应商"];
    } else if (hotSellModel.goldsupplier == 5) {
        goldImageView.hidden=NO;
        CGRect frame=self.titleLab.frame;
        frame.origin.x=120;
        self.titleLab.frame=frame;
        goldImageView.image = [UIImage imageNamed:@"列表-总站"];
    } else if (hotSellModel.goldsupplier == 6) {
        goldImageView.hidden=NO;
        CGRect frame=self.titleLab.frame;
        frame.origin.x=120;
        self.titleLab.frame=frame;
        goldImageView.image = [UIImage imageNamed:@"列表-分站"];
    } else if (hotSellModel.goldsupplier == 7) {
        goldImageView.hidden=NO;
        CGRect frame=self.titleLab.frame;
        frame.origin.x=120;
        self.titleLab.frame=frame;
        goldImageView.image = [UIImage imageNamed:@"列表-工程公司"];
    }

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
