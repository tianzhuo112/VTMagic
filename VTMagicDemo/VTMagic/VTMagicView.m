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
#import "UIColor+Magic.h"
#import <objc/runtime.h>

typedef struct {
    unsigned int dataSourceCategoryNames : 1;
    unsigned int dataSourceCategoryItem : 1;
    unsigned int dataSourceViewController : 1;
    unsigned int viewControllerDidAppeare : 1;
    unsigned int viewControllerDidDisappeare : 1;
    unsigned int shouldManualForwardAppearanceMethods : 1;
} MagicFlags;

static const void *kVTMagicView = &kVTMagicView;
@implementation UIViewController (VTMagicPrivate)

- (void)setMagicView:(VTMagicView *)magicView
{
    objc_setAssociatedObject(self, kVTMagicView, magicView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (VTMagicView *)magicView
{
    return objc_getAssociatedObject(self, kVTMagicView);
}

@end


@interface VTMagicView()<UIScrollViewDelegate,VTContentViewDataSource,VTCategoryBarDatasource,VTCagetoryBarDelegate>

@property (nonatomic, strong) VTCategoryBar *categoryBar; // 顶部导航分类视图
@property (nonatomic, strong) VTContentView *contentView; // 容器视图
@property (nonatomic, strong) UIView *sliderView; // 顶部导航栏滑块
@property (nonatomic, strong) UIView *separatorLine; // 导航模块底部分割线
@property (nonatomic, strong) NSArray *catNames; // 顶部分类名数组
@property (nonatomic, assign) NSInteger nextIndex; // 下一个页面的索引
@property (nonatomic, assign) NSInteger currentIndex; //当前页面的索引
@property (nonatomic, assign) NSInteger previousIndex; // 上一个页面的索引
@property (nonatomic, assign) BOOL isViewWillAppeare;
@property (nonatomic, assign) BOOL needSkipUpdate; // 是否是跳页切换
@property (nonatomic, assign) MagicFlags magicFlags;
@property (nonatomic, assign) VTColor normalVTColor;
@property (nonatomic, assign) VTColor selectedVTColor;
@property (nonatomic, strong) UIColor *normalColor; // 顶部item正常的文本颜色
@property (nonatomic, strong) UIColor *selectedColor; // 顶部item被选中时的文本颜色
@property (nonatomic, assign) BOOL isPanValid;

@end

@implementation VTMagicView
@synthesize navigationView = _navigationView;
@synthesize headerView = _headerView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _naviHeight = 44;
        _itemHeight = 44;
        _previewItems = 1;
        _sliderHeight = 2;
        _headerHeight = 64;
        _separatorHeight = 0.5;
        _scrollEnabled = YES;
        _switchEnabled = YES;
        _switchAnimated = YES;
        [self addMagicSubviews];
        [self addNotification];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - layout subviews
- (void)addMagicSubviews
{
    [self addSubview:self.headerView];
    [self addSubview:self.navigationView];
    [_navigationView addSubview:self.separatorLine];
    [_navigationView addSubview:self.categoryBar];
    [_categoryBar addSubview:self.sliderView];
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
    CGSize size = self.frame.size;
    CGFloat topY = _dependStatusBar ? VTSTATUSBAR_HEIGHT : 0;
    CGFloat headerY = _headerHidden ? -_headerHeight : topY;
    _headerView.frame = CGRectMake(0, headerY, size.width, _headerHeight);
    
    CGFloat navigationY = _headerHidden ? 0 : CGRectGetMaxY(_headerView.frame);
    _navigationView.frame = CGRectMake(0, navigationY, size.width, _naviHeight + topY);
    
    CGFloat separatorY = CGRectGetHeight(_navigationView.frame) - _separatorHeight;
    _separatorLine.frame = CGRectMake(0, separatorY, size.width, _separatorHeight);
    
    CGRect originalCatFrame = _categoryBar.frame;
    CGFloat leftItemWidth = CGRectGetWidth(_leftHeaderView.frame);
    CGFloat rightItemWidth = CGRectGetWidth(_rightHeaderView.frame);
    CGFloat catWidth = size.width - leftItemWidth - rightItemWidth;
    _categoryBar.frame = CGRectMake(leftItemWidth, topY, catWidth, _naviHeight);
    if (!CGRectEqualToRect(_categoryBar.frame, originalCatFrame)) {
        [_categoryBar resetFrames];
    }
    
    CGRect sliderFrame = _sliderView.frame;
    sliderFrame.size.height = _sliderHeight;
    sliderFrame.origin.y = (_naviHeight + _itemHeight) * 0.5 - _sliderHeight;
    CGRect itemFrame = [_categoryBar itemFrameWithIndex:_currentIndex];
    if (!_sliderWidth) sliderFrame.size.width = itemFrame.size.width;
    _sliderView.frame = sliderFrame;
    
    self.needSkipUpdate = YES;
    CGFloat contentY = CGRectGetMaxY(_navigationView.frame);
    CGFloat contentH = size.height - contentY + (_needExtendedBottom ? VTTABBAR_HEIGHT : 0);
    CGRect originalContentFrame = _contentView.frame;
    _contentView.frame = CGRectMake(0, contentY, size.width, contentH);
    if (!CGRectEqualToRect(_contentView.frame, originalContentFrame)) {
        [_contentView resetFrames];
    }
    self.needSkipUpdate = NO;
}

- (void)updateFrameForCategoryBar
{
    CGRect catFrame = _categoryBar.frame;
    catFrame.origin.x = CGRectGetMaxX(_leftHeaderView.frame);
    CGFloat leftWidth = CGRectGetWidth(_leftHeaderView.frame);
    CGFloat rightWidth = CGRectGetWidth(_rightHeaderView.frame);
    CGFloat catWidth = self.frame.size.width - leftWidth - rightWidth;
    catFrame.size.width = catWidth;
    _categoryBar.frame = catFrame;
}

- (void)updateFrameForLeftHeader
{
    CGRect leftFrame = _leftHeaderView.bounds;
    CGFloat maxNavY = _naviHeight + (_dependStatusBar ? 20 : 0);
    leftFrame.size.height = _navigationView.frame.size.height;
    leftFrame.origin.y = (maxNavY - leftFrame.size.height) * 0.5;
    if (_dependStatusBar) leftFrame.origin.y += 10;
    _leftHeaderView.frame = leftFrame;
}

- (void)updateFrameForRightHeader
{
    CGRect rightFrame = _rightHeaderView.bounds;
    CGFloat maxNavY = _naviHeight + (_dependStatusBar ? 20 : 0);
    rightFrame.origin.x = _navigationView.frame.size.width - rightFrame.size.width;
    rightFrame.origin.y = (maxNavY - rightFrame.size.height) * 0.5;
    if (_dependStatusBar) rightFrame.origin.y += 10;
    _rightHeaderView.frame = rightFrame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_categoryBar.isDragging) {
        [self updateFrameForSubviews];
    }
    
    if (CGRectIsEmpty(_sliderView.frame)) {
        [self updateCategoryBar];
    }
}

#pragma mark - NSNotification
- (void)addNotification
{
    [self removeNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarOrientationChange:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    self.needSkipUpdate = YES;
    [self updateFrameForSubviews];
    [self updateCategoryBar];
    self.needSkipUpdate = NO;
    [self reviseLayout];
}

- (void)reviseLayout
{
    if ([_magicViewController isKindOfClass:[VTMagicViewController class]]) return;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self setNeedsLayout];
    });
}

#pragma mark - 重新加载数据
- (void)reloadData
{
    UIViewController *viewController = [self viewControllerWithIndex:_currentIndex];
    if (viewController && _magicFlags.viewControllerDidDisappeare) {
        [_delegate magicView:self viewControllerDidDisappeare:viewController index:_currentIndex];
    }
    [self viewControllerWillDisappear:_currentIndex];
    [self viewControllerDidDisappear:_currentIndex];
    
    if (_magicFlags.dataSourceCategoryNames) {
        _catNames = [_dataSource categoryNamesForMagicView:self];
        _categoryBar.catNames = _catNames;
    }
    
    BOOL needReset = _catNames.count <= _currentIndex;
    if (needReset) {
        _currentIndex = 0;
        _nextIndex = _currentIndex;
        _previousIndex = _currentIndex;
        _categoryBar.currentIndex = _currentIndex;
        _contentView.currentIndex = _currentIndex;
        [_magicViewController setCurrentViewController:nil];
        [_magicViewController setCurrentPage:_currentIndex];
    }
    
    _switchEvent = VTSwitchEventLoad;
    _contentView.pageCount = _catNames.count;
    [_contentView reloadData];
    [_categoryBar reloadData];
    [self updateCategoryBar];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)updateCategoryNames
{
    if (_magicFlags.dataSourceCategoryNames) {
        _catNames = [_dataSource categoryNamesForMagicView:self];
        _categoryBar.catNames = _catNames;
    }
    [_categoryBar reloadData];
    if (!_contentView.isDragging) {
        [self updateCategoryBar];
    }
}

#pragma mark - 当前页面控制器改变时触发，传递disappearViewController & appearViewController
- (void)displayPageHasChanged:(NSInteger)pageIndex disIndex:(NSInteger)disIndex
{
    _categoryBar.currentIndex = pageIndex;
    UIViewController *appearViewController = [_contentView viewControllerWithIndex:pageIndex autoCreateForNil:!_needSkipUpdate];
    UIViewController *disappearViewController = [_contentView viewControllerWithIndex:disIndex autoCreateForNil:!_needSkipUpdate];
    
    if (appearViewController) {
        [_magicViewController setCurrentPage:pageIndex];
        [_magicViewController setCurrentViewController:appearViewController];
    }
    
    if (disappearViewController && _magicFlags.viewControllerDidDisappeare) {
        [_delegate magicView:self viewControllerDidDisappeare:disappearViewController index:disIndex];
    }
    
    if (appearViewController && _magicFlags.viewControllerDidAppeare) {
        [_delegate magicView:self viewControllerDidAppeare:appearViewController index:pageIndex];
    }
}

#pragma mark - VTCategoryBarDatasource & VTCagetoryBarDelegate
- (UIButton *)categoryBar:(VTCategoryBar *)catBar categoryItemForIndex:(NSUInteger)index
{
    if (!_magicFlags.dataSourceCategoryItem) return nil;
    UIButton *catItem = [_dataSource magicView:self categoryItemForIndex:index];
    [catItem setTitle:_catNames[index] forState:UIControlStateNormal];
    if (VTColorIsZero(_normalVTColor)) {
        _normalColor = [catItem titleColorForState:UIControlStateNormal];
        _normalVTColor = [_normalColor vtm_changeToVTColor];
    }
    if (VTColorIsZero(_selectedVTColor)) {
        _selectedColor = [catItem titleColorForState:UIControlStateSelected];
        _selectedVTColor = [_selectedColor vtm_changeToVTColor];
    }
    return catItem;
}

- (void)categoryBar:(VTCategoryBar *)catBar didSelectedItemAtIndex:(NSUInteger)itemIndex
{
    if (!_switchEnabled) return;
    if ([_delegate respondsToSelector:@selector(magicView:didSelectedItemAtIndex:)]) {
        [_delegate magicView:self didSelectedItemAtIndex:itemIndex];
    }
    
    if (itemIndex == _categoryBar.currentIndex) return;
    [self resetCategoryItemColor];
    _switchEvent = VTSwitchEventClick;
    if (_switchAnimated) {
        [self switchAnimation:itemIndex];
    } else {
        [self switchWithoutAnimation:itemIndex];
    }
}

#pragma mark - VTContentViewDataSource
- (UIViewController *)contentView:(VTContentView *)contentView viewControllerForIndex:(NSUInteger)index
{
    if (!_magicFlags.dataSourceViewController) return nil;
    UIViewController *viewController = [_dataSource magicView:self viewControllerForIndex:index];
    if (viewController && ![viewController.parentViewController isEqual:_magicViewController]) {
        [_magicViewController addChildViewController:viewController];
        [contentView addSubview:viewController.view];
        [viewController didMoveToParentViewController:_magicViewController];
        // 设置默认的currentViewController，并触发viewControllerDidAppeare
        if (index == _currentIndex && VTSwitchEventLoad == _switchEvent) {
            [_magicViewController setCurrentViewController:viewController];
            if (_magicFlags.viewControllerDidAppeare) {
                [_delegate magicView:self viewControllerDidAppeare:viewController index:_currentIndex];
            }
            if (_magicFlags.shouldManualForwardAppearanceMethods) {
                [viewController beginAppearanceTransition:YES animated:YES];
                [viewController endAppearanceTransition];
            }
        }
    }
    return viewController;
}

#pragma mark - 查询可重用cat item
- (UIButton *)dequeueReusableCatItemWithIdentifier:(NSString *)identifier
{
    return [_categoryBar dequeueReusableCatItemWithIdentifier:identifier];
}

- (UIViewController *)dequeueReusableViewControllerWithIdentifier:(NSString *)identifier
{
    return [_contentView dequeueReusableViewControllerWithIdentifier:identifier];
}

- (UIButton *)categoryItemWithIndex:(NSUInteger)index
{
    return [_categoryBar itemWithIndex:index];
}

- (UIViewController *)viewControllerWithIndex:(NSUInteger)index
{
    return [_contentView viewControllerWithIndex:index];
}

#pragma mark - 频道分类切换
- (void)switchToPage:(NSUInteger)pageIndex animated:(BOOL)animated
{
    if (pageIndex == _currentIndex || _catNames.count <= pageIndex) return;
    _contentView.currentIndex = pageIndex;
    _switchEvent = VTSwitchEventSroll;
    if (animated) {
        [self switchAnimation:pageIndex];
    } else {
        [self switchWithoutAnimation:pageIndex];
    }
}

- (void)switchWithoutAnimation:(NSUInteger)pageIndex
{
    if (_catNames.count <= pageIndex) return;
    [_contentView creatViewControllerWithIndex:_currentIndex];
    [_contentView creatViewControllerWithIndex:pageIndex];
    [self subviewWillAppeareWithIndex:pageIndex];
    CGFloat offset = _contentView.frame.size.width * pageIndex;
    _contentView.contentOffset = CGPointMake(offset, 0);
    _categoryBar.currentIndex = pageIndex;
    [self updateCategoryBar];
}

- (void)switchAnimation:(NSUInteger)pageIndex
{
    if (_catNames.count <= pageIndex) return;
    NSInteger disIndex = _currentIndex;
    CGFloat contentWidth = CGRectGetWidth(_contentView.frame);
    BOOL isNotAdjacent = abs((int)(_currentIndex - pageIndex)) > 1;
    if (isNotAdjacent) {// 当前按钮与选中按钮不相邻时
        self.needSkipUpdate = YES;
        _isViewWillAppeare = YES;
        [self displayPageHasChanged:pageIndex disIndex:_currentIndex];
        [self subviewWillAppeareWithIndex:pageIndex];
        [self viewControllerDidDisappear:disIndex];
        [_magicViewController setCurrentViewController:nil];
        NSInteger tempIndex = pageIndex + (_currentIndex < pageIndex ? -1 : 1);
        _contentView.contentOffset = CGPointMake(contentWidth * tempIndex, 0);
        _isViewWillAppeare = NO;
    } else {
        [self viewControllerWillDisappear:disIndex];
        [self viewControllerWillAppear:pageIndex];
    }
    
    _currentIndex = pageIndex;
    _previousIndex = disIndex;
    _categoryBar.currentIndex = pageIndex;
    [UIView animateWithDuration:0.25 animations:^{
        [_categoryBar updateSelectedItem];
        [self updateCategoryBar];
        _contentView.contentOffset = CGPointMake(contentWidth * pageIndex, 0);
    } completion:^(BOOL finished) {
        [self displayPageHasChanged:_currentIndex disIndex:disIndex];
        if (!isNotAdjacent && _currentIndex != disIndex) {
            [self viewControllerDidDisappear:disIndex];
        }
        if (pageIndex == _currentIndex) {
            [self viewControllerDidAppear:pageIndex];
        }
        self.needSkipUpdate = NO;
    }];
}

- (void)updateCategoryBar
{
    __block CGFloat itemMinX = 0;
    __block CGFloat itemMaxX = 0;
    __block CGRect itemFrame = CGRectZero;
    void (^updateBlock) (NSInteger) = ^(NSInteger itemIndex) {
        if (itemIndex < 0) itemIndex = 0;
        if (_catNames.count <= itemIndex) itemIndex = _catNames.count - 1;
        itemFrame = [_categoryBar itemFrameWithIndex:itemIndex];
        itemMinX = itemFrame.origin.x;
        itemMaxX = CGRectGetMaxX(itemFrame);
    };
    
    updateBlock(_currentIndex);
    CGRect sliderFrame = _sliderView.frame;
    if (_sliderWidth) {
        sliderFrame.origin.x = itemMinX + (itemFrame.size.width - _sliderWidth) * 0.5;
        sliderFrame.size.width = _sliderWidth;
    } else {
        sliderFrame.origin.x = itemMinX;
        sliderFrame.size.width = itemFrame.size.width;
    }
    _sliderView.frame = sliderFrame;
    
    // update contentOffset
    CGFloat catWidth = _categoryBar.frame.size.width;
    CGFloat offsetX = _categoryBar.contentOffset.x;
    CGFloat catOffsetX = offsetX;
    if (itemMaxX < catOffsetX) {// 位于屏幕左侧
        updateBlock(_currentIndex - _previewItems);
        offsetX = itemMinX - catWidth;
        offsetX = offsetX < 0 ?: 0;
    } else if (catOffsetX + catWidth < itemMinX) {// 位于屏幕右侧
        updateBlock(_currentIndex + _previewItems);
        offsetX = itemMaxX - catWidth;
    } else {
        NSInteger itemIndex = _currentIndex;
        BOOL needAddition = _previousIndex <= _currentIndex;
        if (catWidth + catOffsetX <= itemMaxX) needAddition = YES;
        if (itemMinX < catOffsetX) needAddition = NO;
        itemIndex += needAddition ? _previewItems : -_previewItems;
        updateBlock(itemIndex);
    }
    
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        CGFloat diffX = (CGRectGetMaxX(itemFrame) - catWidth);
        catOffsetX = (diffX < 0 || catOffsetX > diffX) ? catOffsetX : diffX;
    }
    
    if (catWidth + catOffsetX <= itemMaxX) {
        offsetX = itemMaxX - catWidth;
    } else if (itemMinX < catOffsetX) {
        offsetX = itemMinX;
    }
    _categoryBar.contentOffset = CGPointMake(offsetX, 0);
}

- (void)updateCategoryBarWhenUserScrolled
{
    [UIView animateWithDuration:0.25 animations:^{
        [_categoryBar updateSelectedItem];
        [self updateCategoryBar];
    }];
}

- (void)updateItemStateForDefaultStyle
{
    UIButton *seletedItem = [_categoryBar selectedItem];
    UIButton *catItem = [_categoryBar itemWithIndex:_currentIndex];
    [catItem setTitleColor:_normalColor forState:UIControlStateNormal];
    [seletedItem setTitleColor:_selectedColor forState:UIControlStateSelected];
    [_categoryBar updateSelectedItem];
}

#pragma mark - change color
- (void)graduallyChangeColor
{
    if (VTColorIsZero(_normalVTColor) && VTColorIsZero(_selectedVTColor)) return;
    CGFloat scale = _contentView.contentOffset.x/_contentView.frame.size.width - _currentIndex;
    CGFloat absScale = ABS(scale);
    UIColor *nextColor = [UIColor vtm_compositeColor:_normalVTColor anoColor:_selectedVTColor scale:absScale];
    UIColor *selectedColor = [UIColor vtm_compositeColor:_selectedVTColor anoColor:_normalVTColor scale:absScale];
    UIButton *currentItem = [_categoryBar itemWithIndex:_currentIndex];
    [currentItem setTitleColor:selectedColor forState:UIControlStateSelected];
    CGRect currentFrame = [_categoryBar itemFrameWithIndex:_currentIndex];
    UIButton *nextItem = [_categoryBar itemWithIndex:_nextIndex];
    [nextItem setTitleColor:nextColor forState:UIControlStateNormal];
    CGRect nextFrame  = [_categoryBar itemFrameWithIndex:_nextIndex];
    
    if (_sliderWidth) {
        CGFloat nextCenterX = CGRectGetMidX(nextFrame);
        CGFloat currentCenterX = CGRectGetMidX(currentFrame);
        CGPoint center = _sliderView.center;
        center.x = currentCenterX + (nextCenterX - currentCenterX) * absScale;
        _sliderView.center = center;
    } else {
        CGRect sliderFrame = _sliderView.frame;
        CGFloat nextWidth = nextFrame.size.width;
        CGFloat currentWidth = currentFrame.size.width;
        CGFloat offset = (scale > 0 ? currentWidth : nextWidth) * scale;
        sliderFrame.origin.x = currentFrame.origin.x + offset;
        sliderFrame.size.width = currentWidth - (currentWidth - nextWidth) * absScale;
        _sliderView.frame = sliderFrame;
    }
}

- (void)resetCategoryItemColor
{
    UIButton *currentItem = [_categoryBar itemWithIndex:_currentIndex];
    [currentItem setTitleColor:_selectedColor forState:UIControlStateSelected];
    UIButton *nextItem = [_categoryBar itemWithIndex:_nextIndex];
    [nextItem setTitleColor:_normalColor forState:UIControlStateNormal];
}

#pragma mark - UIPanGestureRecognizer for webView
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    CGPoint offset = _contentView.contentOffset;
    CGFloat contentWidth = CGRectGetWidth(_contentView.frame);
    CGFloat maxOffset = _contentView.contentSize.width - contentWidth;
    CGPoint translation = [recognizer translationInView:_contentView];
    [recognizer setTranslation:CGPointZero inView:_contentView];
    if (offset.x <= maxOffset) {
        if (UIGestureRecognizerStateBegan == recognizer.state ||
            UIGestureRecognizerStateChanged == recognizer.state) {
            _isPanValid = YES;
            offset.x -= translation.x;
            if (maxOffset < offset.x) offset.x = maxOffset;
            _contentView.contentOffset = offset;
        } else if (UIGestureRecognizerStateFailed == recognizer.state ||
                   UIGestureRecognizerStateEnded == recognizer.state) {
            _isPanValid = NO;
            CGPoint velocity = [recognizer velocityInView:_contentView];
            if (contentWidth < fabs(velocity.x)) {
                [self autoSwitchToNextPage:velocity.x < 0];
            } else {
                [self reviseAnimation];
            }
        }
    } else {
        _isPanValid = NO;
        CGFloat temp = offset.x/contentWidth;
        if (temp != (NSInteger)temp) {
            [self reviseAnimation];
        }
    }
}

- (void)autoSwitchToNextPage:(BOOL)isNextPage
{
    CGFloat offsetX = _contentView.contentOffset.x;
    CGFloat contentWidth = CGRectGetWidth(_contentView.frame);
    NSInteger index = (NSInteger)(offsetX/contentWidth);
    if (!isNextPage) index = ceil(offsetX/contentWidth);
    index += isNextPage ? 1 : -1;
    NSInteger totalCount = _catNames.count;
    if (totalCount <= index) index = totalCount - 1;
    CGPoint offset = CGPointMake(contentWidth*index, 0);
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [_contentView setContentOffset:offset animated:YES];
    });
}

- (void)reviseAnimation
{
    CGFloat offsetX = _contentView.contentOffset.x;
    CGFloat scrollWidth = CGRectGetWidth(_contentView.frame);
    NSInteger index = nearbyint(offsetX/scrollWidth);
    NSInteger totalCount = _catNames.count;
    if (totalCount <= index) index = totalCount - 1;
    CGFloat contentWidth = CGRectGetWidth(_contentView.frame);
    [_contentView setContentOffset:CGPointMake(contentWidth * index, 0) animated:YES];
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
    if (_needSkipUpdate || CGRectIsEmpty(self.frame)) return;
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
    
    if (!_needSkipUpdate && newIndex != _currentIndex) {
        _switchEvent = VTSwitchEventSroll;
        self.currentIndex = newIndex;
        switch (_switchStyle) {
            case VTSwitchStyleDefault:
                [self updateItemStateForDefaultStyle];
                break;
            case VTSwitchStyleStiff:
                [self updateCategoryBarWhenUserScrolled];
                break;
            case VTSwitchStyleUnknown:
                //TODO:缺失
                VTLog(@"VTSwitchStyleUnknown");
                break;
            default:
                VTLog(@"VTSwitchStyleError");
                break;
        }
    }
    
    if (_nextIndex != tempIndex) _isViewWillAppeare = NO;
    if (!_isViewWillAppeare && newIndex != tempIndex) {
        _isViewWillAppeare = YES;
        NSInteger nextIndex = newIndex + (isSwipeToLeft ? 1 : -1);
        [self subviewWillAppeareWithIndex:nextIndex];
    }
    
    if (tempIndex == _currentIndex) { // 重置_nextIndex
        if (_nextIndex != _currentIndex) {
            [self viewControllerWillDisappear:_nextIndex];
            [self viewControllerWillAppear:_currentIndex];
            [self viewControllerDidDisappear:_nextIndex];
            [self viewControllerDidAppear:_currentIndex];
        }
        _nextIndex = _currentIndex;
    }
    
    if (!_needSkipUpdate && VTSwitchStyleDefault == _switchStyle) {
        [self graduallyChangeColor];
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
    if (VTSwitchEventClick == _switchEvent) {
        CGFloat contentWidth = CGRectGetWidth(_contentView.frame);
        CGPoint offset = CGPointMake(contentWidth * _currentIndex, 0);
        [_contentView setContentOffset:offset animated:YES];
    }
    if (VTSwitchStyleDefault == _switchStyle) {
        if (_isPanValid) return;
        [UIView animateWithDuration:0.25 animations:^{
            [self updateCategoryBar];
        }];
    }
}

#pragma mark - 视图即将显示
- (void)subviewWillAppeareWithIndex:(NSInteger)index
{
    if (_nextIndex == index) return;
    if (_contentView.isDragging && 1 < ABS(_nextIndex - index)) {
        [self viewControllerWillDisappear:_nextIndex];
        [self viewControllerDidDisappear:_nextIndex];
    }
    [self viewControllerWillDisappear:_currentIndex];
    [self viewControllerWillAppear:index];
    _nextIndex = index;
}

#pragma mark - the life cycle of view controller
- (void)viewControllerWillAppear:(NSUInteger)pageIndex
{
    if (!_magicFlags.shouldManualForwardAppearanceMethods) return;
    UIViewController *viewController = [_contentView viewControllerWithIndex:pageIndex autoCreateForNil:YES];
    [viewController beginAppearanceTransition:YES animated:YES];
}

- (void)viewControllerDidAppear:(NSUInteger)pageIndex
{
    if (!_magicFlags.shouldManualForwardAppearanceMethods) return;
    UIViewController *viewController = [self viewControllerWithIndex:pageIndex];
    [viewController endAppearanceTransition];
}

- (void)viewControllerWillDisappear:(NSUInteger)pageIndex
{
    if (!_magicFlags.shouldManualForwardAppearanceMethods) return;
    UIViewController *viewController = [self viewControllerWithIndex:pageIndex];
    [viewController beginAppearanceTransition:NO animated:YES];
}

- (void)viewControllerDidDisappear:(NSUInteger)pageIndex
{
    if (!_magicFlags.shouldManualForwardAppearanceMethods) return;
    UIViewController *viewController = [self viewControllerWithIndex:pageIndex];
    [viewController endAppearanceTransition];
}

#pragma mark - accessors
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
        _navigationView.clipsToBounds = YES;
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

- (UIView *)sliderView
{
    if (!_sliderView) {
        _sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, _sliderHeight)];
        _sliderView.backgroundColor = RGBCOLOR(194, 39, 39);
    }
    return _sliderView;
}

- (VTCategoryBar *)categoryBar
{
    if (!_categoryBar) {
        _categoryBar = [[VTCategoryBar alloc] init];
        _categoryBar.backgroundColor = [UIColor clearColor];
        _categoryBar.showsHorizontalScrollIndicator = NO;
        _categoryBar.clipsToBounds = YES;
        _categoryBar.scrollsToTop = NO;
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
        _contentView.scrollsToTop = NO;
        _contentView.bounces = NO;
    }
    return _contentView;
}

- (NSArray<UIViewController *> *)viewControllers
{
    return _contentView.visibleList;
}

- (void)setDataSource:(id<VTMagicViewDataSource>)dataSource
{
    _dataSource = dataSource;
    _magicFlags.dataSourceCategoryNames = [dataSource respondsToSelector:@selector(categoryNamesForMagicView:)];
    _magicFlags.dataSourceCategoryItem = [dataSource respondsToSelector:@selector(magicView:categoryItemForIndex:)];
    _magicFlags.dataSourceViewController = [dataSource respondsToSelector:@selector(magicView:viewControllerForIndex:)];
}

- (void)setDelegate:(id<VTMagicViewDelegate>)delegate
{
    _delegate = delegate;
    _magicFlags.viewControllerDidAppeare = [delegate respondsToSelector:@selector(magicView:viewControllerDidAppeare:index:)];
    _magicFlags.viewControllerDidDisappeare = [delegate respondsToSelector:@selector(magicView:viewControllerDidDisappeare:index:)];
    if (!_magicViewController && [_delegate isKindOfClass:[UIViewController class]] && [delegate conformsToProtocol:@protocol(VTExtensionProtocal)]) {
        self.magicViewController = (UIViewController<VTExtensionProtocal> *)delegate;
    }
}

- (void)setMagicViewController:(UIViewController<VTExtensionProtocal> *)magicViewController
{
    _magicViewController = magicViewController;
    if (!_magicViewController.magicView) [_magicViewController setMagicView:self];
    if ([magicViewController respondsToSelector:@selector(shouldAutomaticallyForwardAppearanceMethods)]) {
        _magicFlags.shouldManualForwardAppearanceMethods = ![magicViewController shouldAutomaticallyForwardAppearanceMethods];
    }
}

- (void)setAutoResizing:(BOOL)autoResizing
{
    _autoResizing = autoResizing;
    _categoryBar.autoResizing = autoResizing;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    _contentView.scrollEnabled = scrollEnabled;
}

- (void)setNaviScrollEnabled:(BOOL)naviScrollEnabled
{
    _naviScrollEnabled = naviScrollEnabled;
    _categoryBar.scrollEnabled = naviScrollEnabled;
}

- (void)setSwitchEnabled:(BOOL)switchEnabled
{
    _switchEnabled = switchEnabled;
    _categoryBar.scrollEnabled = switchEnabled;
    self.scrollEnabled = switchEnabled;
}

- (void)setHideSlider:(BOOL)hideSlider
{
    _hideSlider = hideSlider;
    _sliderView.hidden = hideSlider;
}

- (void)setHideSeparator:(BOOL)hideSeparator
{
    _hideSeparator = hideSeparator;
    _separatorLine.hidden = hideSeparator;
}

- (void)setNeedBounces:(BOOL)needBounces
{
    _needBounces = needBounces;
    _contentView.bounces = needBounces;
}

- (void)setNeedExtendedBottom:(BOOL)needExtendedBottom
{
    _needExtendedBottom = needExtendedBottom;
    [self updateFrameForSubviews];
}

- (void)setDependStatusBar:(BOOL)dependStatusBar animated:(BOOL)animated
{
    _dependStatusBar = dependStatusBar;
    [self updateFramesWithAnimated:animated];
}

- (void)setHeaderHidden:(BOOL)headerHidden
{
    _headerHidden = headerHidden;
    _headerView.hidden = headerHidden;
    [self updateFrameForSubviews];
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
    [_navigationView addSubview:leftHeaderView];
    [_navigationView bringSubviewToFront:_separatorLine];
    leftHeaderView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [self updateFrameForLeftHeader];
    [self updateFrameForCategoryBar];
}

- (void)setRightHeaderView:(UIView *)rightHeaderView
{
    _rightHeaderView = rightHeaderView;
    [_navigationView addSubview:rightHeaderView];
    [_navigationView bringSubviewToFront:_separatorLine];
    [_navigationView bringSubviewToFront:_categoryBar];
    rightHeaderView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self updateFrameForRightHeader];
    [self updateFrameForCategoryBar];
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

- (void)setSliderColor:(UIColor *)sliderColor
{
    _sliderColor = sliderColor;
    _sliderView.backgroundColor = sliderColor;
}

- (void)setNaviHeight:(CGFloat)naviHeight
{
    _naviHeight = naviHeight;
    _itemHeight = naviHeight;
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

- (UIEdgeInsets)navigationInset
{
    return _categoryBar.contentInset;
}

- (void)setNavigationInset:(UIEdgeInsets)navigationInset
{
    _categoryBar.contentInset = navigationInset;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
//    if (_currentIndex == _nextIndex) return;
    NSInteger disIndex = _currentIndex;
    _currentIndex = currentIndex;
    _previousIndex = disIndex;
    
    [self displayPageHasChanged:currentIndex disIndex:disIndex];
    [self viewControllerDidDisappear:disIndex];
    [self viewControllerDidAppear:currentIndex];
}

@end
