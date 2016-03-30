//
//  SearchRecommendView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchRecommendViewDelegate <NSObject>

- (void)SearchRecommendViewSearch:(NSString *)searchStr;
- (void)SearchRecommendViewSearchDIC:(NSDictionary *)dic;
@end
@interface SearchRecommendView : UIView
@property (nonatomic,strong)UIScrollView *backScrollView;
@property (nonatomic,strong)UIView *histroyView;
@property (nonatomic,strong)NSArray *dataAry;
@property (nonatomic,weak) id<SearchRecommendViewDelegate> delegate;
-(id)initWithFrame:(CGRect)frame WithAry:(NSArray *)ary;
@end
