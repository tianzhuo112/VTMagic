//
//  VTMagicView.m
//  VTMagicView
//
//  Created by tianzhuo on 14-11-11.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import "VTMagicView.h"
#import "VTHeaderView.h"
#import "VTContentView.h"
#import "VTMagicViewController.h"

@interface VTMagicView()<UIScrollViewDelegate,VTContentViewDataSource,VTHeaderDatasource,VTHeaderDelegate>

@property (nonatomic, strong) VTHeaderView *headerView; // 顶部导航视图内的滚动视图
@property (nonatomic, strong) VTContentView *contentView; // 容器视图
@property (nonatomic, strong) UIView *shadowView; // 顶部下划线
@property (nonatomic, strong) UIView *separatorLine; // 导航模块底部分割线
@property (nonatomic, strong) UIButton *originalButton;
@property (nonatomic, strong) NSArray *headerList; //顶部item内容数组
@property (nonatomic, assign) NSInteger nextIndex; // 下一个页面的索引
@property (nonatomic, assign) NSInteger currentIndex; //当前页面的索引
@property (nonatomic, assign) BOOL isViewWillAppeare;
@property (nonatomic, assign) BOOL isRotateAnimating;
@property (nonatomic, assign) BOOL needSkipUpdate; // 是否是跳页切换

@end

@implementation VTMagicView
@synthesize navigationView = _navigationView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemHeight = 44;
        _dependStatusBar = YES;
        _navigationHeight = 44;
        [self addSubviews];
    }
    return self;
}

#pragma mark - layout subviews
- (void)addSubviews
{
    [self addSubview:self.navigationView];
    [_navigationView addSubview:self.separatorLine];
    [_navigationView addSubview:self.headerView];
    [_headerView addSubview:self.shadowView];
    [self addSubview:self.contentView];
    [self updateFrameForSubviews];
}

- (void)updateFrameForSubviews
{
    CGFloat topY = _dependStatusBar ? 20 : 0;
    CGSize size = self.frame.size;
    _navigationView.frame = CGRectMake(0, topY, size.width, _navigationHeight);
    
    CGFloat separatorH = 0.5;
    _separatorLine.frame = CGRectMake(0, CGRectGetHeight(_navigationView.frame) - separatorH, size.width, separatorH);
    
    CGFloat headerX = CGRectGetWidth(_leftHeaderView.frame);
    CGFloat headerY = (_navigationHeight - _itemHeight) * 0.5;
    CGFloat headerWidth = size.width - headerX - CGRectGetWidth(_rightHeaderView.frame);
    _headerView.frame = CGRectMake(headerX, headerY, headerWidth, _itemHeight);
    
    CGRect shadowFrame = _shadowView.frame;
    shadowFrame.origin.y = CGRectGetHeight(_navigationView.frame) - 2;
    _shadowView.frame = shadowFrame;
    
    CGFloat contentY = CGRectGetMaxY(_navigationView.frame);
    CGFloat contentH = size.height - contentY + (_needExtendedBottom ? TABBAR_HEIGHT : 0);
    _contentView.frame = CGRectMake(0, contentY, size.width, contentH);
    [_contentView reloadData];
}

- (void)resetFrameForHeaderView
{
    CGRect headerFrame = _headerView.frame;
    headerFrame.origin.x = CGRectGetMaxX(_leftHeaderView.frame);
    CGFloat headerWidth = self.frame.size.width - CGRectGetWidth(_leftHeaderView.frame) - CGRectGetWidth(_rightHeaderView.frame);
    headerFrame.size.width = headerWidth;
    _headerView.frame = headerFrame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateHeaderView];
}

#pragma mark - 重新加载数据
- (void)reloadData
{
    if ([_dataSource respondsToSelector:@selector(headersForMagicView:)]) {
        _headerList = [_dataSource headersForMagicView:self];
        _headerView.headerList = _headerList;
    }
    
    BOOL needReset = _headerList.count <= _currentIndex || !_headerList.count;
    if (needReset && [_delegate respondsToSelector:@selector(currentViewController)]) {
        [(VTMagicViewController *)_delegate setCurrentViewController:nil];
    }
    
    if (needReset) {
        _currentIndex = _headerList.count;
    }
    
    _originalButton = nil;
    _contentView.pageCount = _headerList.count;
    [_contentView reloadData];
    [_headerView reloadData];
    [self setNeedsLayout];
}

#pragma mark - 当前页面控制器改变时触发，传递disappearViewController & appearViewController
- (void)displayViewControllerDidChangedWithIndex:(NSInteger)currentIndex disIndex:(NSInteger)disIndex
{
    _headerView.currentIndex = currentIndex;
    UIViewController *appearViewController = [_contentView viewControllerWithIndex:currentIndex autoCreateForNil:!_needSkipUpdate];
    UIViewController *disappearViewController = [_contentView viewControllerWithIndex:disIndex autoCreateForNil:!_needSkipUpdate];
    
    if (appearViewController && [_delegate respondsToSelector:@selector(currentIndex)]) {
        [(VTMagicViewController *)_delegate setCurrentIndex:currentIndex];
    }
    
    if (disappearViewController && [_delegate respondsToSelector:@selector(magicView:viewControllerDidDisappeare:index:)]) {
        [_delegate magicView:self viewControllerDidDisappeare:disappearViewController index:disIndex];
    }
    
    if (appearViewController && [_delegate respondsToSelector:@selector(currentViewController)]) {
        [_delegate performSelector:@selector(setCurrentViewController:) withObject:appearViewController];
    }
    
    if (appearViewController && [_delegate respondsToSelector:@selector(magicView:viewControllerDidAppeare:index:)]) {
        [_delegate magicView:self viewControllerDidAppeare:appearViewController index:currentIndex];
    }
}

#pragma mark - headerView datasource & deleagte
- (UIButton *)headerView:(VTHeaderView *)headerView headerItemForIndex:(NSInteger)index
{
    if ([_dataSource respondsToSelector:@selector(magicView:headerItemForIndex:)]) {
        UIButton *headerItem = [_dataSource magicView:self headerItemForIndex:index];
        if (!_originalButton) _originalButton = headerItem;
        return headerItem;
    }
    return nil;
}

- (void)headerView:(VTHeaderView *)headerView didSelectedItem:(UIButton *)itemBtn
{
    [self headerItemClick:itemBtn];
}

#pragma mark - 查询可重用header item
- (id)dequeueReusableHeaderItemWithIdentifier:(NSString *)identifier
{
    return [_headerView dequeueReusableHeaderItemWithIdentifier:identifier];
}

- (id)dequeueReusableViewControllerWithIdentifier:(NSString *)identifier
{
    return [_contentView dequeueReusableViewControllerWithIdentifier:identifier];
}

#pragma mark - VTContentViewDataSource
- (UIViewController *)contentView:(VTContentView *)contentView viewControllerForIndex:(NSInteger)index
{
    if ([_dataSource respondsToSelector:@selector(magicView:viewControllerForIndex:)]) {
        UIViewController *viewController = [_dataSource magicView:self viewControllerForIndex:index];
        if (viewController && ![viewController.parentViewController isEqual:_delegate]) {
            [(UIViewController *)_delegate addChildViewController:viewController];
            // 设置默认的currentViewController，并触发viewControllerDidAppeare
            if (index == _currentIndex && [_delegate respondsToSelector:@selector(currentViewController)] && ![(VTMagicViewController *)_delegate currentViewController]) {
                [(VTMagicViewController *)_delegate setCurrentViewController:viewController];
                if ([_delegate respondsToSelector:@selector(magicView:viewControllerDidAppeare:index:)]) {
                    [_delegate magicView:self viewControllerDidAppeare:viewController index:_currentIndex];
                }
            }
        }
        return viewController;
    }
    return nil;
}


#pragma mark - header切换动画
- (void)headerItemClick:(id)sender
{
    if ([_originalButton isEqual:sender]) return;
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]){
        sender = (UIButton *)[(UITapGestureRecognizer *)sender view];
    }
    
    NSInteger disIndex = _currentIndex;
    NSInteger newIndex = [(UIButton *)sender tag];
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
        [sender setSelected:YES];
        _originalButton = sender;
        [self updateHeaderView];
        _contentView.contentOffset = CGPointMake(_contentView.frame.size.width * newIndex, 0);
    } completion:^(BOOL finished) {
        [self displayViewControllerDidChangedWithIndex:_currentIndex disIndex:disIndex];
        _needSkipUpdate = NO;
//        self.currentIndex = newIndex;
    }];
}

- (void)updateHeaderView
{
    if (!_originalButton) {
        _originalButton = [_headerView itemWithIndex:_currentIndex];
        _originalButton.selected = YES;
    }
    
    CGFloat offsetX = 0;
    CGFloat headerWidth = _headerView.frame.size.width;
    CGFloat itemMinX = _originalButton.frame.origin.x;
    CGFloat itemMaxX = CGRectGetMaxX(_originalButton.frame);
    CGFloat headerOffsetX = _headerView.contentOffset.x;
    if (itemMaxX < headerOffsetX) {// 位于屏幕左侧
        offsetX = itemMinX - headerWidth;
        offsetX = offsetX < 0 ?: 0;
        _headerView.contentOffset = CGPointMake(offsetX, 0);
    } else if (headerOffsetX + headerWidth < itemMinX) {// 位于屏幕右侧
        offsetX = itemMaxX - headerWidth;
        _headerView.contentOffset = CGPointMake(offsetX, 0);
    }
    
    CGSize itemSize = _originalButton.frame.size;
    CGRect shadowFrame = _shadowView.frame;
    shadowFrame.origin.x = itemMinX;
    shadowFrame.size.width = itemSize.width;
    _shadowView.frame = shadowFrame;//CGRectMake(headerItemMinX, size.height - 2, size.width, 2);
    
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        CGFloat diffX = (CGRectGetMaxX(_originalButton.frame) - headerWidth);
        headerOffsetX = (diffX < 0 || headerOffsetX > diffX) ? headerOffsetX : diffX;
    }
    
    if (headerWidth + headerOffsetX <= itemMaxX) {
        _headerView.contentOffset = CGPointMake(itemMaxX - headerWidth, 0);
    } else if (itemMinX < headerOffsetX) {
        _headerView.contentOffset = CGPointMake(itemMinX, 0);
    }
    
    // 原始逻辑，暂时废弃
//    if (headerWidth + headerOffsetX <= itemMinX + itemSize.width * 0.5) {
//        CGFloat totleWidth = _headerView.contentSize.width;
//        headerOffsetX += itemSize.width;
//        if (headerWidth + headerOffsetX > totleWidth) {
//            headerOffsetX = (totleWidth - headerWidth);
//        }
//        _headerView.contentOffset = CGPointMake(headerOffsetX, 0);
//    } else if ((itemMinX - itemSize.width * 0.5) <= headerOffsetX) {
//        headerOffsetX -= itemSize.width;
//        if (headerOffsetX < 0) headerOffsetX = 0;
//        _headerView.contentOffset = CGPointMake(headerOffsetX, 0);
//    }
}

- (void)updateHeaderViewWhenUserScrolled
{
    [self canPerformAction:@selector(updateHeaderViewWhenUserScrolled) withSender:nil];
    UIButton *headerButton = [_headerView itemWithIndex:_currentIndex];
    [UIView animateWithDuration:0.25 animations:^{
        [_originalButton setSelected:NO];
        [headerButton setSelected:YES];
        _originalButton = headerButton;
        [self updateHeaderView];
//            CGSize size = headerButton.frame.size;
//            _shadowView.frame = CGRectMake(headerButton.frame.origin.x, size.height - 2, size.width, 2);
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
    BOOL isSwipeToLeft = scrollView.frame.size.width * _currentIndex < scrollView.contentOffset.x;
    if (isSwipeToLeft) { // 向左滑动
        newIndex = floorf(scrollView.contentOffset.x/scrollView.frame.size.width);
        tempIndex = (int)((scrollView.contentOffset.x + scrollView.frame.size.width - 0.1)/scrollView.frame.size.width);
    } else {
        newIndex = ceilf(scrollView.contentOffset.x/scrollView.frame.size.width);
        tempIndex = (int)(scrollView.contentOffset.x/scrollView.frame.size.width);
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
        [self updateHeaderViewWhenUserScrolled];
    }
    
    if (tempIndex == _currentIndex) { // 重置_nextIndex
        _nextIndex = _currentIndex;
    }
}

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
////    _isViewWillAppeare = NO;
////    _nextIndex = _currentIndex; // 左右来回滑动有问题，只发送一次subviewWillAppeareWithIndex:
//}

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
    if (0 != (int)scrollView.contentOffset.x%320) {
//        VTLog(@"scrollViewDidEndDecelerating ERROR: %d",(int)scrollView.contentOffset.x%320);
    }
}

#pragma mark - 视图即将显示
- (void)subviewWillAppeareWithIndex:(NSInteger)index
{
    if (_nextIndex == index) return;
    _nextIndex = index;
//    VTLog(@"subviewWillAppeare current index:%d",index);
}

#pragma mark - accessor 方法
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

- (VTHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[VTHeaderView alloc] init];
        _headerView.backgroundColor = [UIColor clearColor];
        _headerView.showsHorizontalScrollIndicator = NO;
        _headerView.headerDelegate = self;
        _headerView.datasource = self;
    }
    return _headerView;
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

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateFrameForSubviews];
}

- (void)setNeedExtendedBottom:(BOOL)needExtendedBottom
{
    _needExtendedBottom = needExtendedBottom;
    [self updateFrameForSubviews];
}

- (void)setDependStatusBar:(BOOL)dependStatusBar
{
    [self setDependStatusBar:dependStatusBar animated:NO];
}

- (void)setDependStatusBar:(BOOL)dependStatusBar animated:(BOOL)animated
{
    _dependStatusBar = dependStatusBar;
    CGFloat duration = animated ? 0.3 : 0;
    [UIView animateWithDuration:duration animations:^{
        [self updateFrameForSubviews];
    }];
}

- (void)setLeftHeaderView:(UIView *)leftHeaderView
{
    _leftHeaderView = leftHeaderView;
    
    CGRect leftFrame = leftHeaderView.bounds;
    leftFrame.size.height = _navigationView.frame.size.height;
    leftHeaderView.frame = leftFrame;
    leftHeaderView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [_navigationView addSubview:leftHeaderView];
    [self resetFrameForHeaderView];
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
    [self resetFrameForHeaderView];
}

- (void)setNavigationColor:(UIColor *)navigationColor
{
    _navigationColor = navigationColor;
    _navigationView.backgroundColor = navigationColor;
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
    [_headerView reloadData];
}

- (void)setItemBorder:(CGFloat)itemBorder
{
    _itemBorder = itemBorder;
    _headerView.itemBorder = itemBorder;
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
    _headerView.normalFont = normalFont;
}

- (void)setSelectedFont:(UIFont *)selectedFont
{
    _selectedFont = selectedFont;
    _headerView.selectedFont = selectedFont;
}

@end
