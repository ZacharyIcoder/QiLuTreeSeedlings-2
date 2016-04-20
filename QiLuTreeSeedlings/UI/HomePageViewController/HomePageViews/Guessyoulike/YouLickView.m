//
//  YouLickView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/1/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "YouLickView.h"
#import "UIDefines.h"
#import "GusseYourLikeModel.h"
@implementation YouLickView
-(id)initWithFrame:(CGRect)frame WithAry:(NSArray *)dataAry
{
    self=[super initWithFrame:frame];
    
    if (self) {
        self.dataAry=dataAry;
        [self setBackgroundColor:[UIColor whiteColor]];
        int tempX=10;
        CGRect tempFrame=CGRectMake(10, 10, 0, 24);
        for (int i=0; i<dataAry.count; i++) {
            GusseYourLikeModel *model=dataAry[i];
            //NSString *nameStr=[dic objectForKey:@"productName"];
            UIButton *likeBtn=[[UIButton alloc]init];
            likeBtn.layer.masksToBounds=YES;
            likeBtn.layer.cornerRadius=5;
            likeBtn.tag=i;
//            [likeBtn setBackgroundColor:[UIColor grayColor]];
            [likeBtn.layer setBorderWidth:0.3];
            [likeBtn.layer setBorderColor:kLineColor.CGColor];
            [likeBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
            [likeBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [likeBtn setTitle:model.productName forState:UIControlStateNormal];
            [likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            CGSize strSize=[self boundingRectWithSize:likeBtn.titleLabel.frame.size whithLab:likeBtn.titleLabel];
           // NSLog(@"%f",strSize.width);
            tempFrame.size.width=strSize.width+10.0;
            tempFrame.origin.x=tempX;
          
            if (CGRectGetMaxX(tempFrame)>=kWidth-10) {
                tempFrame.origin.x=tempX=10;
                tempFrame.origin.y+=29;
            }
              tempX=CGRectGetMaxX(tempFrame)+5;
            [likeBtn setFrame:tempFrame];
            [self addSubview:likeBtn];
            
        }
        CGRect  selfFram=self.frame;
        selfFram.size.height=CGRectGetMaxY(tempFrame)+10;
        [self setFrame:selfFram];
    }
    return self;
}
-(void)likeBtnAction:(UIButton *)sender
{
    
    if (self.delegate) {
        int xx=(int)sender.tag;
        GusseYourLikeModel *model = self.dataAry[xx];
        [self.delegate YouLickViewsPush:model];
    }
    
}
- (CGSize)boundingRectWithSize:(CGSize)size whithLab:(UILabel *)lab
{
    NSDictionary *attribute = @{NSFontAttributeName: lab.font};
    
    CGSize retSize = [lab.text boundingRectWithSize:size
                                             options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
