//
//  ZIKCityListViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKCityListViewController.h"
#import "ZIKCityModel.h"
#import "ZIKCityTableViewCell.h"
#import "ZIKCitySectionHeaderView.h"
#import "ZIKSectionInfo.h"
#import "StringAttributeHelper.h"
static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

@interface ZIKCityListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *cityTableView;
@property (nonatomic) NSMutableArray *sectionInfoArray;
@property (nonatomic) NSIndexPath *pinchedIndexPath;
@property (nonatomic) NSInteger openSectionIndex;
@property (nonatomic) CGFloat initialPinchHeight;

@property (nonatomic) IBOutlet ZIKCitySectionHeaderView *sectionHeaderView;

// use the uniformRowHeight property if the pinch gesture should change all row heights simultaneously
@property (nonatomic) NSInteger uniformRowHeight;
@end

#pragma mark -

#define DEFAULT_ROW_HEIGHT 44
#define HEADER_HEIGHT 44

@implementation ZIKCityListViewController
{
    NSMutableArray *_selectMArr;
    BOOL _isCanSelect;

}
- (BOOL)canBecomeFirstResponder {

    return YES;
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIView *)makeNavView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(17, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
    [view addSubview:backBtn];
    self.backBtn=backBtn;
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
   UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-160,26, 320, 30)];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    //[titleLab setText:self.vcTitle];
    //titleLab.text = self.vcTitle;
    NSString *str = @"选择地区（最多可选5项）";
    FontAttribute *fullFont = [FontAttribute new];
    fullFont.font = [UIFont systemFontOfSize:14.0f];
    fullFont.effectRange  = NSMakeRange(0, str.length);
    //局部设置
    FontAttribute *partFont = [FontAttribute new];
    partFont.font = [UIFont systemFontOfSize:20.0f];
    partFont.effectRange = NSMakeRange(0, 4);
    titleLab.attributedText = [str mutableAttributedStringWithStringAttributes:@[fullFont,partFont]];

    [view addSubview:titleLab];
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    self.vcTitle = @"选择地区（最多可选5项）";

    self.rightBarBtnTitleString = @"确定";
       _selectMArr = [[NSMutableArray alloc] initWithCapacity:5];
    _isCanSelect = YES;
    UITableView *cityTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStylePlain];
    cityTV.delegate = self;
    cityTV.dataSource = self;
    [self.view addSubview:cityTV];
    self.cityTableView = cityTV;
   // CLog(@"%@",self.citys);
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.cityTableView addGestureRecognizer:pinchRecognizer];

    self.cityTableView.sectionHeaderHeight = HEADER_HEIGHT;
    self.uniformRowHeight = DEFAULT_ROW_HEIGHT;
    self.openSectionIndex = NSNotFound;

    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ZIKCitySectionHeaderView" bundle:nil];
    [self.cityTableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    __weak typeof(_selectMArr) selectMarr = _selectMArr;//解决循环引用的问题
    __weak typeof(self) weakSelf = self;//解决循环引用的问题


    self.rightBarBtnBlock = ^{
        CLog(@"%@",selectMarr);
        if (selectMarr.count == 0) {
            [ToastView showTopToast:@"您还未选择城市"];
            return ;
        }
        __block NSString *cityCodeString = @"";
        [selectMarr enumerateObjectsUsingBlock:^(NSString *code, NSUInteger idx, BOOL * _Nonnull stop) {
            cityCodeString = [cityCodeString stringByAppendingString:[NSString stringWithFormat:@",%@",code]];
        }];
        cityCodeString = [cityCodeString substringFromIndex:1];
        if ([weakSelf.delegate respondsToSelector:@selector(selectCitysInfo:)]) {
            [weakSelf.delegate selectCitysInfo:cityCodeString];
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };


}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    if (_selectMArr.count > 0) {
        [_selectMArr removeAllObjects];
    }
    /*
     Check whether the section info array has been created, and if so whether the section count still matches the current section count. In general, you need to keep the section info synchronized with the rows and section. If you support editing in the table view, you need to appropriately update the section info during editing operations.
     */
    if ((self.sectionInfoArray == nil) ||
        ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.cityTableView])) {

        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
        NSMutableArray *infoArray = [[NSMutableArray alloc] init];

        for (ZIKCityModel *city in self.citys) {

            ZIKSectionInfo *sectionInfo = [[ZIKSectionInfo alloc] init];
            sectionInfo.cityModel = city;
            sectionInfo.open = NO;

            NSNumber *defaultRowHeight = @(DEFAULT_ROW_HEIGHT);
            NSInteger countOfQuotations = [[[sectionInfo.cityModel province] citys] count];
            for (NSInteger i = 0; i < countOfQuotations; i++) {
                [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
            }
            
            [infoArray addObject:sectionInfo];
        }
        
        self.sectionInfoArray = infoArray;
        if (self.selectStyle == SelectStyleMultiSelect) {
            [self.sectionInfoArray enumerateObjectsUsingBlock:^(ZIKSectionInfo *secInfo, NSUInteger idx, BOOL * _Nonnull stop) {
               __block NSInteger count = 0;
                 [secInfo.cityModel.province.citys enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {

                     if ([secInfo.cityModel.province.code isEqualToString:dic[@"code"]] && [dic[@"select"] isEqualToString:@"1"]) {
                         secInfo.isAllSelect = YES;
                         [_selectMArr addObject:dic[@"code"]];
                         return ;
                     }
                     if ([dic[@"select"] isEqualToString:@"1"]) {
                         [_selectMArr addObject:dic[@"code"]];
                         count++;
                     }
                     if ((secInfo.cityModel.province.citys.count-1) == idx) {
                         secInfo.selectNum = count;
                     }
                 }];
            }];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [self.citys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    ZIKSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    NSInteger numStoriesInSection = [[[sectionInfo.cityModel province] citys] count];

    return sectionInfo.open ? numStoriesInSection : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *QuoteCellIdentifier = @"QuoteCellIdentifier";

    ZIKCityTableViewCell *cell = (ZIKCityTableViewCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKCityTableViewCell" owner:self options:nil] lastObject];
    }
    ZIKCityModel *play = (ZIKCityModel *)[(self.sectionInfoArray)[indexPath.section] cityModel];
    cell.city = (play.province.citys)[indexPath.row];

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    ZIKCitySectionHeaderView *sectionHeaderView = [self.cityTableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    ZIKSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    sectionInfo.headerView = sectionHeaderView;
    sectionHeaderView.titleLable.text = sectionInfo.cityModel.province.provinceName;
    sectionHeaderView.section = section;
    sectionHeaderView.delegate = self;

    return sectionHeaderView;
//    ZIKCitySectionHeaderView *sectionHeaderView = [self.cityTableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
//    ZIKSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
//    if (!sectionInfo.headerView) {
//        sectionInfo.headerView = sectionHeaderView;
//        sectionHeaderView.titleLable.text = sectionInfo.cityModel.province.provinceName;
//        sectionHeaderView.section = section;
//        sectionHeaderView.delegate = self;
//
//        return sectionHeaderView;
//    }
//    return sectionInfo.headerView;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    ZIKSectionInfo *sectionInfo = (self.sectionInfoArray)[indexPath.section];
    return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
    // Alternatively, return rowHeight.
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKSectionInfo *sectionInfo = (self.sectionInfoArray)[indexPath.section];
    NSMutableDictionary *dic = sectionInfo.cityModel.province.citys[indexPath.row];
        if ([_selectMArr containsObject:dic[@"code"]]) {
            //[_selectMArr removeObject:dic[@"code"]];
            _isCanSelect = YES;
        }
        else if (_selectMArr.count >= 5) {
            [ToastView showTopToast:@"最多只能选择5项!"];
            _isCanSelect = NO;
        }
        else {
            _isCanSelect = YES;
        }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isCanSelect) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    ZIKSectionInfo *sectionInfo = (self.sectionInfoArray)[indexPath.section];
    NSMutableDictionary *dic = sectionInfo.cityModel.province.citys[indexPath.row];
//    if ([_selectMArr containsObject:dic[@"code"]]) {
//        [_selectMArr removeObject:dic[@"code"]];
//    }
//    else if (_selectMArr.count >= 5) {
//        [ToastView showTopToast:@"55555"];
//        return;
//    }
    [dic setObject:[dic[@"select"] isEqualToString:@"1"] ? @"0" : @"1" forKey:@"select"];
    if (indexPath.row != 0) {
        NSIndexPath *indexOne = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        NSMutableDictionary *dic0 = sectionInfo.cityModel.province.citys[0];
        [dic0 setObject:@"0" forKey:@"select"];
        if ([_selectMArr containsObject:dic0[@"code"]]) {
            [_selectMArr removeObject:dic0[@"code"]];
        }

        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,indexOne,nil] withRowAnimation:UITableViewRowAnimationNone];
        if ([dic[@"select"] isEqualToString:@"0"]) {
            --sectionInfo.selectNum;
            sectionInfo.isAllSelect = NO;
        }
        else if ([dic[@"select"] isEqualToString:@"1"]) {
            ++sectionInfo.selectNum;
            sectionInfo.isAllSelect = NO;
        }
    }
    else if (indexPath.row == 0) {
           [sectionInfo.cityModel.province.citys enumerateObjectsUsingBlock:^(NSMutableDictionary *dicno, NSUInteger idx, BOOL * _Nonnull stop) {
               if (idx == 0) {
                   if ([dic[@"select"] isEqualToString:@"0"]) {
                       sectionInfo.selectNum = 0;
                       sectionInfo.isAllSelect = NO;
                    }
                   else if ([dic[@"select"] isEqualToString:@"1"]) {
                       sectionInfo.selectNum = 0;
                       sectionInfo.isAllSelect = YES;
                   }
               }
               if (idx != 0) {
                   [dicno setObject:@"0" forKey:@"select"];
                   if ([_selectMArr containsObject:dicno[@"code"]]) {
                       [_selectMArr removeObject:dicno[@"code"]];
                   }
               }
           }];

        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:indexPath.section];
        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if ([_selectMArr containsObject:dic[@"code"]]) {
        [_selectMArr removeObject:dic[@"code"]];
    }
    else {
        [_selectMArr addObject:dic[@"code"]];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    ZIKSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    //CLog(@"%d",sectionInfo.isAllSelect);
    //CLog(@"%d",sectionInfo.se)
    sectionInfo.headerView.disclosureButton.selected = sectionInfo.open;
    if (sectionInfo.isAllSelect) {
        sectionInfo.isAllSelect = sectionInfo.isAllSelect;
        return;
    }
    sectionInfo.selectNum = sectionInfo.selectNum;
}

#pragma mark - SectionHeaderViewDelegate

- (void)sectionHeaderView:(ZIKCitySectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {

    ZIKSectionInfo *sectionInfo = (self.sectionInfoArray)[sectionOpened];

    sectionInfo.open = YES;

    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [sectionInfo.cityModel.province.citys count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }

    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];

    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {

        ZIKSectionInfo *previousOpenSection = (self.sectionInfoArray)[previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.cityModel.province.citys count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }

    // style the animation so that there's a smooth flow in either direction
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }

    // apply the updates
    [self.cityTableView beginUpdates];
    [self.cityTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.cityTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.cityTableView endUpdates];

    self.openSectionIndex = sectionOpened;
}

- (void)sectionHeaderView:(ZIKCitySectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {

    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
    ZIKSectionInfo *sectionInfo = (self.sectionInfoArray)[sectionClosed];

    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.cityTableView numberOfRowsInSection:sectionClosed];

    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.cityTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}


#pragma mark - Handling pinches

- (void)handlePinch:(UIPinchGestureRecognizer *)pinchRecognizer {

    /*
     There are different actions to take for the different states of the gesture recognizer.
     * In the Began state, use the pinch location to find the index path of the row with which the pinch is associated, and keep a reference to that in pinchedIndexPath. Then get the current height of that row, and store as the initial pinch height. Finally, update the scale for the pinched row.
     * In the Changed state, update the scale for the pinched row (identified by pinchedIndexPath).
     * In the Ended or Canceled state, set the pinchedIndexPath property to nil.
     */

    if (pinchRecognizer.state == UIGestureRecognizerStateBegan) {

        CGPoint pinchLocation = [pinchRecognizer locationInView:self.cityTableView];
        NSIndexPath *newPinchedIndexPath = [self.cityTableView indexPathForRowAtPoint:pinchLocation];
        self.pinchedIndexPath = newPinchedIndexPath;

        ZIKSectionInfo *sectionInfo = (self.sectionInfoArray)[newPinchedIndexPath.section];
        self.initialPinchHeight = [[sectionInfo objectInRowHeightsAtIndex:newPinchedIndexPath.row] floatValue];
        // Alternatively, set initialPinchHeight = uniformRowHeight.

        [self updateForPinchScale:pinchRecognizer.scale atIndexPath:newPinchedIndexPath];
    }
    else {
        if (pinchRecognizer.state == UIGestureRecognizerStateChanged) {
            [self updateForPinchScale:pinchRecognizer.scale atIndexPath:self.pinchedIndexPath];
        }
        else if ((pinchRecognizer.state == UIGestureRecognizerStateCancelled) || (pinchRecognizer.state == UIGestureRecognizerStateEnded)) {
            self.pinchedIndexPath = nil;
        }
    }
}

- (void)updateForPinchScale:(CGFloat)scale atIndexPath:(NSIndexPath *)indexPath {

    if (indexPath && (indexPath.section != NSNotFound) && (indexPath.row != NSNotFound)) {

        CGFloat newHeight = round(MAX(self.initialPinchHeight * scale, DEFAULT_ROW_HEIGHT));

        ZIKSectionInfo *sectionInfo = (self.sectionInfoArray)[indexPath.section];
        [sectionInfo replaceObjectInRowHeightsAtIndex:indexPath.row withObject:@(newHeight)];
        // Alternatively, set uniformRowHeight = newHeight.

        /*
         Switch off animations during the row height resize, otherwise there is a lag before the user's action is seen.
         */
        BOOL animationsEnabled = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [self.cityTableView beginUpdates];
        [self.cityTableView endUpdates];
        [UIView setAnimationsEnabled:animationsEnabled];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
