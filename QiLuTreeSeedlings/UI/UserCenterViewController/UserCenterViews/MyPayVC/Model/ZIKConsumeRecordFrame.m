//
//  ZIKConsumeRecordFrame.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/27.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKConsumeRecordFrame.h"
#import "ZIKConsumeRecordModel.h"

#define kHeight [UIScreen mainScreen].bounds.size.height
#define kWidth [UIScreen mainScreen].bounds.size.width

#define StatasCellBorder 15

@implementation ZIKConsumeRecordFrame

-(void)setRecordModel:(ZIKConsumeRecordModel *)recordModel {
    _recordModel = recordModel;

    //cell 的宽度
    CGFloat cellW = kWidth - 2*StatasCellBorder;

    //1.icon
    _iconF = CGRectMake(StatasCellBorder, 10, 25, 25);

    //2.reson
    CGFloat contentLabelX = CGRectGetMaxX(_iconF)+8;
    CGFloat contentLabelY = _iconF.origin.y;
    CGFloat contentLabelMaxW = cellW - _iconF.size.width -100;


    CGSize contentLabelSize = CGSizeMake(contentLabelMaxW, CGFLOAT_MAX);
    CGSize requiredSize = CGSizeZero;
    NSDictionary *attribute = @{NSFontAttributeName: StatusReasonFont };
    requiredSize = [_recordModel.reason boundingRectWithSize:contentLabelSize options:
                        NSStringDrawingTruncatesLastVisibleLine |
                        NSStringDrawingUsesLineFragmentOrigin |
                        NSStringDrawingUsesFontLeading
                        attributes:attribute context:nil].size;

    //CGFloat requiredHeight = requiredSize.height;

//    CGSize contentLabelSize = [_recordModel.reason sizeWithFont:StatusReasonFont constrainedToSize:CGSizeMake(contentLabelMaxW, MAXFLOAT)];

    if (requiredSize.height > 18.1 * 3) {
        requiredSize.height = 18.1 * 3;
    }
     _reasonF = (CGRect){{contentLabelX,contentLabelY},requiredSize};
    //NSLog(@"=====================================_reasonF:%@",NSStringFromCGRect(_reasonF));
    //3.time
    _timeF = CGRectMake(_reasonF.origin.x - 3, CGRectGetMaxY(_reasonF)+10, 120, 16);



    _cellHeight = CGRectGetMaxY(_timeF)+10;

    _iconF = CGRectMake(StatasCellBorder, CGRectGetMidY(_reasonF)-10, 25, 25);

    //4.price
    _priceF = CGRectMake(kWidth-StatasCellBorder-100, _iconF.origin.y+3, 100, 21);

}

@end
