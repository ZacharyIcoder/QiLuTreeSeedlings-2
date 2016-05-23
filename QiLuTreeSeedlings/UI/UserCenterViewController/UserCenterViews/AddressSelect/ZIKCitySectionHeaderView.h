//
//  ZIKCitySectionHeaderView.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDefines.h"

@protocol ZIKCitySectionHeaderViewDelegate;
@interface ZIKCitySectionHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *selectHintLabel;
@property (weak, nonatomic) IBOutlet UIButton *disclosureButton;
@property (weak, nonatomic) IBOutlet UIView *lineview;
@property (weak, nonatomic) IBOutlet id <ZIKCitySectionHeaderViewDelegate> delegate;
@property (nonatomic) NSInteger section;

- (void)toggleOpenWithUserAction:(BOOL)userAction;

@end


#pragma mark -

/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol ZIKCitySectionHeaderViewDelegate <NSObject>

@optional
- (void)sectionHeaderView:(ZIKCitySectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)section;
- (void)sectionHeaderView:(ZIKCitySectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)section;

@end


