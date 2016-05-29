//
//  VTMagicView.m
//  VTMagicView
//
//  Created by tianzhuo on 14-11-11.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import "VTMagicView.h"
#import "VTCategoryBar.h"
#import "VTContentView.h"
#import "VTMagicViewController.h"
#import "VTExtensionProtocal.h"

@interface VTMagicView()<UIScrollViewDelegate,VTContentViewDataSource,VTCategoryBarDatasource,VTCagetoryBarDelegate>

@property (nonatomic, strong) VTCategoryBar *categoryBar; // 顶部导航分类视图
@property (nonatomic, strong) VTContentView *contentView; // 容器视图
@property (nonatomic, strong) UIView *shadowView; // 顶部下划线
@property (nonatomic, strong) UIView *separatorLine; // 导航模块底部分割线
@property (nonatomic, strong) UIButton *originalButton;
@property (nonatomic, strong) NSArray *catNames; // 顶部分类名数组
@property (nonatomic, assign) NSInteger nextIndex; // 下一个页面的索引
@property (nonatomic, assign) NSInteger currentIndex; //当前页面的索引
@property (nonatomic, assign) BOOL isViewWillAppeare;
@property (nonatomic, assign) BOOL isRotateAnimating;
@property (nonatomic, assign) BOOL needSkipUpdate; // 是否是跳页切换

@end

@implementation VTMagicView
@synthesize navigationView = _navigationView;
@synthesize headerView = _headerView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemHeight = 44;
        _headerHeight = 64;
        _dependStatusBar = YES;
        _navigationHeight = 44;
        [self addSubviews];
    }
    return self;
}

#pragma mark - layout subviews
- (void)addSubviews
{
    [self addSubview:self.headerView];
    [self addSubview:self.navigationView];
    [_navigationView addSubview:self.separatorLine];
    [_navigationView addSubview:self.categoryBar];
    [_categoryBar addSubview:self.shadowView];
    [self addSubview:self.contentView];
    [self updateFrameForSubviews];
}

- (void)updateFramesWithAnimated:(BOOL)animated
{
    CGFloat duration = animated ? 0.3 : 0;
    [UIView animateWithDuration:duration animations:^{
        [self updateFrameForSubviews];
    } completion:^(BOOL finished) {
        _headerView.hidden = _headerHidden;
    }];
}

- (void)updateFrameForSubviews
{
    CGFloat topY = _dependStatusBar ? 20 : 0;
    CGSize size = self.frame.size;
    
    CGFloat headerY = _headerHidden ? -_headerHeight : topY;
    _headerView.frame = CGRectMake(0, headerY, size.width, _headerHeight);
    
    CGFloat navigationY = _headerHidden ? topY : CGRectGetMaxY(_headerView.frame);
    _navigationView.frame = CGRectMake(0, navigationY, size.width, _navigationHeight);
    
    CGFloat separatorH = 0.5;
    _separatorLine.frame = CGRectMake(0, CGRectGetHeight(_navigationView.frame) - separatorH, size.width, separatorH);
    
    CGFloat catX = CGRectGetWidth(_leftHeaderView.frame);
    CGFloat catY = (_navigationHeight - _itemHeight) * 0.5;
    CGFloat catWidth = size.width - catX - CGRectGetWidth(_rightHeaderView.frame);
    _categoryBar.frame = CGRectMake(catX, catY, catWidth, _itemHeight);
    
    CGRect shadowFrame = _shadowView.frame;
    shadowFrame.origin.y = CGRectGetHeight(_navigationView.frame) - 2;
    _shadowView.frame = shadowFrame;
    
    CGFloat contentY = CGRectGetMaxY(_navigationView.frame);
    CGFloat contentH = size.height - contentY + (_needExtendedBottom ? TABBAR_HEIGHT_VT : 0);
    _contentView.frame = CGRectMake(0, contentY, size.width, contentH);
    [_contentView reloadData];
}

- (void)resetFrameForCategoryBar
{
    CGRect catFrame = _categoryBar.frame;
    catFrame.origin.x = CGRectGetMaxX(_leftHeaderView.frame);
    CGFloat catWidth = self.frame.size.width - CGRectGetWidth(_leftHeaderView.frame) - CGRectGetWidth(_rightHeaderView.frame);
    catFrame.size.width = catWidth;
    _categoryBar.frame = catFrame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateFrameForSubviews];
    [self updateCategoryBar];
}

#pragma mark - 重新加载数据
- (void)reloadData
{
    if ([_dataSource respondsToSelector:@selector(categoryNamesForMagicView:)]) {
        _catNames = [_dataSource categoryNamesForMagicView:self];
        _categoryBar.catNames = _catNames;
    }
    
    BOOL needReset = _catNames.count <= _currentIndex || !_catNames.count;
    if (needReset && [_delegate respondsToSelector:@selector(displayViewControllerDidChanged:index:)]) {
        [_delegate displayViewControllerDidChanged:nil index:_catNames.count];
    }
    
    if (needReset) {
        _currentIndex = _catNames.count;
    }
    
    _originalButton = nil;
    _contentView.pageCount = _catNames.count;
    [_contentView reloadData];
    [_categoryBar reloadData];
    [self setNeedsLayout];
}

#pragma mark - 当前页面控制器改变时触发，传递disappearViewController & appearViewController
- (void)displayViewControllerDidChangedWithIndex:(NSInteger)currentIndex disIndex:(NSInteger)disIndex
{
    _categoryBar.currentIndex = currentIndex;
    UIViewController *appearViewController = [_contentView viewControllerWithIndex:currentIndex autoCreateForNil:!_needSkipUpdate];
    UIViewController *disappearViewController = [_contentView viewControllerWithIndex:disIndex autoCreateForNil:!_needSkipUpdate];
    
    if (appearViewController && [_delegate respondsToSelector:@selector(displayViewControllerDidChanged:index:)]) {
        [_delegate displayViewControllerDidChanged:appearViewController index:currentIndex];
    }
    
    if (disappearViewController && [_delegate respondsToSelector:@selector(magicView:viewControllerDidDisappeare:index:)]) {
        [_delegate magicView:self viewControllerDidDisappeare:disappearViewController index:disIndex];
    }
    
    if (appearViewController && [_delegate respondsToSelector:@selector(magicView:viewControllerDidAppeare:index:)]) {
        [_delegate magicView:self viewControllerDidAppeare:appearViewController index:currentIndex];
    }
}

#pragma mark - VTCategoryBarDatasource & VTCagetoryBarDelegate
- (UIButton *)categoryBar:(VTCategoryBar *)catBar categoryItemForIndex:(NSInteger)index
{
    if ([_dataSource respondsToSelector:@selector(magicView:categoryItemForIndex:)]) {
        UIButton *catItem = [_dataSource magicView:self categoryItemForIndex:index];
        if (!_originalButton) _originalButton = catItem;
        return catItem;
    }
    return nil;
}

- (void)categoryBar:(VTCategoryBar *)catBar didSelectedItem:(UIButton *)itemBtn
{
    if (_forbiddenSwitching || [_originalButton isEqual:itemBtn]) return;
    NSInteger disIndex = _currentIndex;
    NSInteger newIndex = [itemBtn tag];
    if (abs((int)(_currentIndex - newIndex)) > 1) {// 当前按钮与选中按钮不相邻时
        _needSkipUpdate = YES;
        [self subviewWillAppeareWithIndex:newIndex];
        [self displayViewControllerDidChangedWithIndex:newIndex disIndex:_currentIndex];
        [UIView animateWithDuration:0 animations:^{
            _isViewWillAppeare = YES;
            NSInteger tempIndex = _currentIndex < newIndex ? newIndex - 1 : newIndex + 1;
            _contentView.contentOffset = CGPointMake(_contentView.frame.size.width * tempIndex, 0);
        } completion:^(BOOL finished) {
            _isViewWillAppeare = NO;
        }];
    }
    
    _currentIndex = newIndex;
    [UIView animateWithDuration:0.25 animations:^{
        [_originalButton setSelected:NO];
        [itemBtn setSelected:YES];
        _originalButton = itemBtn;
        [self updateCategoryBar];
        _contentView.contentOffset = CGPointMake(_contentView.frame.size.width * newIndex, 0);
    } completion:^(BOOL finished) {
        [self displayViewControllerDidChangedWithIndex:_currentIndex disIndex:disIndex];
        _needSkipUpdate = NO;
//        self.currentIndex = newIndex;
    }];
}

#pragma mark - 查询可重用cat item
- (id)dequeueReusableCatItemWithIdentifier:(NSString *)identifier
{
    return [_categoryBar dequeueReusableCatItemWithIdentifier:identifier];
}

- (id)dequeueReusableViewControllerWithIdentifier:(NSString *)identifier
{
    return [_contentView dequeueReusableViewControllerWithIdentifier:identifier];
}

#pragma mark - VTContentViewDataSource
- (UIViewController *)contentView:(VTContentView *)contentView viewControllerForIndex:(NSInteger)index
{
    if (![_dataSource respondsToSelector:@selector(magicView:viewControllerForIndex:)]) return nil;
    UIViewController *viewController = [_dataSource magicView:self viewControllerForIndex:index];
    if (viewController && [_delegate respondsToSelector:@selector(viewControllerWillAddToContentView:index:)]) {
        [_delegate viewControllerWillAddToContentView:viewController index:index];
    }
    return viewController;
}

#pragma mark - 分类切换动画
- (void)updateCategoryBar
{
    if (!_originalButton) {
        _originalButton = [_categoryBar itemWithIndex:_currentIndex];
        _originalButton.selected = YES;
    }
    
    CGFloat offsetX = 0;
    CGFloat catWidth = _categoryBar.frame.size.width;
    CGFloat itemMinX = _originalButton.frame.origin.x;
    CGFloat itemMaxX = CGRectGetMaxX(_originalButton.frame);
    CGFloat catOffsetX = _categoryBar.contentOffset.x;
    if (itemMaxX < catOffsetX) {// 位于屏幕左侧
        offsetX = itemMinX - catWidth;
        offsetX = offsetX < 0 ?: 0;
        _categoryBar.contentOffset = CGPointMake(offsetX, 0);
    } else if (catOffsetX + catWidth < itemMinX) {// 位于屏幕右侧
        offsetX = itemMaxX - catWidth;
        _categoryBar.contentOffset = CGPointMake(offsetX, 0);
    }
    
    CGSize itemSize = _originalButton.frame.size;
    CGRect shadowFrame = _shadowView.frame;
    shadowFrame.origin.x = itemMinX;
    shadowFrame.size.width = itemSize.width;
    _shadowView.frame = shadowFrame;//CGRectMake(headerItemMinX, size.height - 2, size.width, 2);
    
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        CGFloat diffX = (CGRectGetMaxX(_originalButton.frame) - catWidth);
        catOffsetX = (diffX < 0 || catOffsetX > diffX) ? catOffsetX : diffX;
    }
    
    if (catWidth + catOffsetX <= itemMaxX) {
        _categoryBar.contentOffset = CGPointMake(itemMaxX - catWidth, 0);
    } else if (itemMinX < catOffsetX) {
        _categoryBar.contentOffset = CGPointMake(itemMinX, 0);
    }
    
    // 原始逻辑，暂时废弃
//    if (catWidth + catOffsetX <= itemMinX + itemSize.width * 0.5) {
//        CGFloat totleWidth = _categoryBar.contentSize.width;
//        catOffsetX += itemSize.width;
//        if (catWidth + catOffsetX > totleWidth) {
//            catOffsetX = (totleWidth - catWidth);
//        }
//        _categoryBar.contentOffset = CGPointMake(catOffsetX, 0);
//    } else if ((itemMinX - itemSize.width * 0.5) <= catOffsetX) {
//        catOffsetX -= itemSize.width;
//        if (catOffsetX < 0) catOffsetX = 0;
//        _categoryBar.contentOffset = CGPointMake(catOffsetX, 0);
//    }
}

- (void)updateCategoryBarWhenUserScrolled
{
    UIButton *catItem = [_categoryBar itemWithIndex:_currentIndex];
    [UIView animateWithDuration:0.25 animations:^{
        [_originalButton setSelected:NO];
        [catItem setSelected:YES];
        _originalButton = catItem;
        [self updateCategoryBar];
//        CGSize size = catItem.frame.size;
//        _shadowView.frame = CGRectMake(catItem.frame.origin.x, size.height - 2, size.width, 2);
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isViewWillAppeare = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger newIndex;
    NSInteger tempIndex;
    if (_isRotateAnimating) return;
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat scrollWidth = scrollView.frame.size.width;
    BOOL isSwipeToLeft = scrollWidth * _currentIndex < offsetX;
    if (isSwipeToLeft) { // 向左滑动
        newIndex = floorf(offsetX/scrollWidth);
        tempIndex = (int)((offsetX + scrollWidth - 0.1)/scrollWidth);
    } else {
        newIndex = ceilf(offsetX/scrollWidth);
        tempIndex = (int)(offsetX/scrollWidth);
    }
    
    if (_nextIndex != tempIndex) _isViewWillAppeare = NO;
    if (!_isViewWillAppeare && newIndex != tempIndex) {
        _isViewWillAppeare = YES;
        //TODO:view will appeare delegate
        NSInteger nextIndex = isSwipeToLeft ? (newIndex + 1) : (newIndex - 1);
        [self subviewWillAppeareWithIndex:nextIndex];
    }
    
    if (!_needSkipUpdate && newIndex != _currentIndex) {
        self.currentIndex = newIndex;
        [self updateCategoryBarWhenUserScrolled];
    }
    
    if (tempIndex == _currentIndex) { // 重置_nextIndex
        _nextIndex = _currentIndex;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
//    _isViewWillAppeare = NO;
//    _nextIndex = _currentIndex; // 左右来回滑动有问题，只发送一次subviewWillAppeareWithIndex:
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
//        VTLog(@"scrollViewDidEndDragging");
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//    VTLog(@"scrollViewDidEndScrollingAnimation ");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    VTLog(@"scrollViewDidEndDecelerating");
}

#pragma mark - 视图即将显示
- (void)subviewWillAppeareWithIndex:(NSInteger)index
{
    if (_nextIndex == index) return;
    _nextIndex = index;
//    VTLog(@"subviewWillAppeare current index:%d",index);
}

#pragma mark - accessor 方法
- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor clearColor];
        _headerView.hidden = _headerHidden = YES;
    }
    return _headerView;
}

- (UIView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [[UIView alloc] init];
        _navigationView.backgroundColor = [UIColor clearColor];
    }
    return _navigationView;
}

- (UIView *)separatorLine
{
    if (!_separatorLine) {
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = RGBCOLOR(188, 188, 188);
    }
    return _separatorLine;
}

- (UIView *)shadowView
{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 2)];
        _shadowView.backgroundColor = RGBCOLOR(194, 39, 39);
    }
    return _shadowView;
}

- (VTCategoryBar *)categoryBar
{
    if (!_categoryBar) {
        _categoryBar = [[VTCategoryBar alloc] init];
        _categoryBar.backgroundColor = [UIColor clearColor];
        _categoryBar.showsHorizontalScrollIndicator = NO;
        _categoryBar.catDelegate = self;
        _categoryBar.datasource = self;
    }
    return _categoryBar;
}

- (VTContentView *)contentView
{
    if (!_contentView) {
        _contentView = [[VTContentView alloc] init];
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.pagingEnabled = YES;
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.bounces = NO;
    }
    return _contentView;
}

- (void)setNeedExtendedBottom:(BOOL)needExtendedBottom
{
    _needExtendedBottom = needExtendedBottom;
    [self updateFrameForSubviews];
}

- (void)setForbiddenSwitching:(BOOL)forbiddenSwitching
{
    _forbiddenSwitching = forbiddenSwitching;
    _contentView.scrollEnabled = !forbiddenSwitching;
}

- (void)setDependStatusBar:(BOOL)dependStatusBar
{
    [self setDependStatusBar:dependStatusBar animated:NO];
}

- (void)setDependStatusBar:(BOOL)dependStatusBar animated:(BOOL)animated
{
    _dependStatusBar = dependStatusBar;
    [self updateFramesWithAnimated:animated];
}

- (void)setHeaderHidden:(BOOL)headerHidden
{
    [self setHeaderHidden:headerHidden animated:NO];
}

- (void)setHeaderHidden:(BOOL)headerHidden animated:(BOOL)animated
{
    _headerView.hidden = NO;
    _headerHidden = headerHidden;
    [self updateFramesWithAnimated:animated];
}

- (void)setLeftHeaderView:(UIView *)leftHeaderView
{
    _leftHeaderView = leftHeaderView;
    
    CGRect leftFrame = leftHeaderView.bounds;
    leftFrame.size.height = _navigationView.frame.size.height;
    leftHeaderView.frame = leftFrame;
    leftHeaderView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [_navigationView addSubview:leftHeaderView];
    [self resetFrameForCategoryBar];
}

- (void)setRightHeaderView:(UIView *)rightHeaderView
{
    _rightHeaderView = rightHeaderView;
    
    CGRect rightFrame = rightHeaderView.bounds;
    rightFrame.origin.x = _navigationView.frame.size.width - rightFrame.size.width;
    rightFrame.origin.y = (_navigationView.frame.size.height - rightFrame.size.height) * 0.5;
    rightHeaderView.frame = rightFrame;
    rightHeaderView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_navigationView addSubview:rightHeaderView];
    [self resetFrameForCategoryBar];
}

- (void)setNavigationColor:(UIColor *)navigationColor
{
    _navigationColor = navigationColor;
    _navigationView.backgroundColor = navigationColor;
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    _separatorColor = separatorColor;
    _separatorLine.backgroundColor = separatorColor;
}

- (void)setSlideColor:(UIColor *)slideColor
{
    _slideColor = slideColor;
    _shadowView.backgroundColor = slideColor;
}

- (void)setNavigationHeight:(CGFloat)navigationHeight
{
    _itemHeight = navigationHeight;
    _navigationHeight = navigationHeight;
    [self updateFrameForSubviews];
}

- (void)setItemHeight:(CGFloat)itemHeight
{
    _itemHeight = itemHeight;
    [self updateFrameForSubviews];
    [_categoryBar reloadData];
}

- (void)setItemBorder:(CGFloat)itemBorder
{
    _itemBorder = itemBorder;
    _categoryBar.itemBorder = itemBorder;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
//    if (_currentIndex == _nextIndex) return;
    NSInteger disIndex = _currentIndex;
    _currentIndex = currentIndex;
    
    [self displayViewControllerDidChangedWithIndex:currentIndex disIndex:disIndex];
}

- (void)setNormalFont:(UIFont *)normalFont
{
    _normalFont = normalFont;
    _categoryBar.normalFont = normalFont;
}

- (void)setSelectedFont:(UIFont *)selectedFont
{
    _selectedFont = selectedFont;
    _categoryBar.selectedFont = selectedFont;
}

@end
