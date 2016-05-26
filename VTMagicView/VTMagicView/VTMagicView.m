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

@interface VTMagicView()<UIScrollViewDelegate,VTContentViewDataSource,VTHeaderDelegate>

@property (nonatomic, strong) UIView *navigationView;// 顶部导航视图
@property (nonatomic, strong) UIScrollView *headerView; // 顶部导航视图内的滚动视图
@property (nonatomic, strong) VTContentView *contentView; // 容器视图
@property (nonatomic, strong) UIView *shadowView; // 顶部下划线
@property (nonatomic, assign) NSInteger nextIndex; // 下一个页面的索引
@property (nonatomic, assign) NSInteger currentIndex; //当前页面的索引
@property (nonatomic, assign) BOOL isViewWillAppeare;
@property (nonatomic, assign) BOOL isRotateAnimating;
@property (nonatomic, assign) BOOL isUserSliding; // 是否是用户手动滑动
@property (nonatomic, strong) UIButton *originalButton;

@end

@implementation VTMagicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}

#pragma mark - layout subviews
- (void)addSubviews
{
    CGFloat topY = 20;
    CGSize size = [UIScreen mainScreen].bounds.size;
    _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, topY, size.width, 44)];
    _navigationView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _navigationView.backgroundColor = [UIColor redColor];
    [self addSubview:_navigationView];
    
    _headerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, 44)];
    _headerView.backgroundColor = RGBCOLOR(255, 255, 255);
    _headerView.showsHorizontalScrollIndicator = NO;
    _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_navigationView addSubview:_headerView];
    
    _shadowView = [[UIView alloc] init];
    _shadowView.backgroundColor = RGBCOLOR(194, 39, 39);
    [_headerView addSubview:_shadowView];
    
    CGFloat contentY = CGRectGetMaxY(_navigationView.frame);
    _contentView = [[VTContentView alloc] initWithFrame:CGRectMake(0, contentY, 320, size.height - contentY)];
    _contentView.contentSize = CGSizeMake(_headerList.count * size.width, 0);
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.pagingEnabled = YES;
    _contentView.delegate = self;
    _contentView.dataSource = self;
    _contentView.bounces = NO;
    [self addSubview:_contentView];}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = self.window.bounds;
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (_originalButton) _currentIndex = -(_originalButton.tag + 1);
    _isRotateAnimating = YES;
    _contentView.contentOffset = CGPointMake(size.width * _currentIndex, 0);
    _contentView.contentSize = CGSizeMake(_headerList.count * size.width, 0);
    _contentView.frame = CGRectMake(0, CGRectGetMaxY(_navigationView.frame), size.width, size.height);
    [self updateHeaderView];
    _isRotateAnimating = NO;

    CGSize viewSize = CGSizeZero;
    BOOL isLandscape = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    if (isLandscape) {
        if (0 == _currentIndex) {
            _navigationView.hidden = YES;
            viewSize = CGSizeMake(size.width, _contentView.frame.size.height);
            _contentView.contentSize = CGSizeMake(viewSize.width, 0);
            _contentView.frame = (CGRect){CGPointZero,viewSize};
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        } else {
            viewSize = CGSizeMake(size.width, _contentView.frame.size.height - _contentView.frame.origin.y);
        }
    } else {
        _navigationView.hidden = NO;
        viewSize = _contentView.frame.size;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        if (0 == _currentIndex) {
            _contentView.contentSize = CGSizeMake(viewSize.width * _headerList.count, 0);
            _contentView.frame = (CGRect){CGPointMake(0, CGRectGetMaxY(_navigationView.frame)),viewSize};
        }
    }
    
    // 横竖屏切换适配
    [_contentView layoutSubviewsWhenRotated];
}

#pragma mark - 加载数据
- (void)reloadData
{
    if ([_dataSource respondsToSelector:@selector(headersForMagicView:)]) {
#warning mark 待优化，每次reloadData都会走这里
//        self.headerList = [_dataSource headersForMagicView:self];
    }
    
    NSInteger count = _headerList.count;//[_dataSource numberOfViewControllersInMagicView:self];
    _contentView.dataCount = count;
    [_contentView reloadData];
}

#pragma mark - 查询可重用单元格
- (id)dequeueReusableViewControllerWithIdentifier:(NSString *)identifier
{
    return [_contentView dequeueReusableViewControllerWithIdentifier:identifier];
}

#pragma mark - set 方法
- (void)setHeaderItem:(UIButton *)headerItem
{
    _headerItem = headerItem;
    
    UIButton *headerBtn = nil;
    NSInteger maxCount = _headerList.count;
    for (NSInteger index = -1; index >= -maxCount; index--) {
        headerBtn = (UIButton *)[_headerView viewWithTag:index];
        [headerBtn setTitleColor:[_headerItem titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
        [headerBtn setTitleColor:[_headerItem titleColorForState:UIControlStateSelected] forState:UIControlStateSelected];
        headerBtn.titleLabel.font = _headerItem.titleLabel.font;
    }
}

- (void)setHeaderList:(NSArray *)headerList
{
    _headerList = headerList;
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    _contentView.contentSize = CGSizeMake(headerList.count * size.width, 0);
    
    CGFloat headerX = 0;
    UIButton *headerBtn;
    NSInteger index = -1;
    for (NSString *aHeader in headerList) {
        headerBtn = [self buttonItemWithTitle:aHeader];
        headerBtn.frame = (CGRect){CGPointMake(headerX, 0),headerBtn.frame.size};
        headerBtn.tag = index;
        [headerBtn addTarget:self action:@selector(headerItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:headerBtn];
        headerX += headerBtn.frame.size.width;
        index--;
        
        if ([aHeader isEqualToString:[headerList firstObject]]) {
            headerBtn.selected = YES;
        }
        
        if ([aHeader isEqual:[headerList lastObject]]) {
            CGFloat contentWidth = CGRectGetMaxX(headerBtn.frame);
            _headerView.contentSize = CGSizeMake(contentWidth, 0);
            CGSize size = headerBtn.frame.size;
            if (!_originalButton) _originalButton = (UIButton *)[_headerView viewWithTag:-1];
            _shadowView.frame = CGRectMake(_originalButton.frame.origin.x, size.height - 2, size.width, 2);
        }
    }
    
    [self reloadData];
}

- (UIButton *)buttonItemWithTitle:(NSString *)title
{
    CGSize size = CGSizeZero;
    UIFont *font = _headerItem ? _headerItem.titleLabel.font : [UIFont fontWithName:@"Helvetica" size:18];
    if (IOS7_OR_LATER) {
        size = [title sizeWithAttributes:@{NSFontAttributeName : font}];
    } else {
        size = [title sizeWithFont:font];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (_headerItem) {
        [button setTitleColor:[_headerItem titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
        [button setTitleColor:[_headerItem titleColorForState:UIControlStateSelected] forState:UIControlStateSelected];
    } else {
        [button setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [button setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
    }
    
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    button.bounds = (CGRect){CGPointZero,CGSizeMake(size.width + 25, 44)};
    return button;
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
    rightFrame.size.height = _navigationView.frame.size.height;
    rightHeaderView.frame = rightFrame;
    rightHeaderView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_navigationView addSubview:rightHeaderView];
    [self resetFrameForHeaderView];
}

- (void)resetFrameForHeaderView
{
    CGRect headerFrame = _headerView.frame;
    headerFrame.origin.x = CGRectGetMaxX(_leftHeaderView.frame);
    headerFrame.size.width = _navigationView.frame.size.width - _leftHeaderView.frame.size.width - _rightHeaderView.frame.size.width;
    _headerView.frame = headerFrame;
}

- (void)setNavigationColor:(UIColor *)navigationColor
{
    _navigationColor = navigationColor;
    _navigationView.backgroundColor = navigationColor;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
//    if (_currentIndex == _nextIndex) return;
    NSInteger disIndex = _currentIndex;
    _currentIndex = currentIndex;
    
    [self displayViewControllerDidChangedWithIndex:currentIndex disIndex:disIndex];
}

#pragma mark - header切换动画
- (void)headerItemClick:(id)sender
{
    _isUserSliding = NO;
    if ([_originalButton isEqual:sender]) return;
    
    NSInteger newIndex = -([sender tag] + 1);
    if (abs((int)(_currentIndex - newIndex)) > 1) {// 当前按钮与选中按钮不相邻时
        [self subviewWillAppeareWithIndex:newIndex];
        [self displayViewControllerDidChangedWithIndex:newIndex disIndex:_currentIndex];
        [UIView animateWithDuration:0 animations:^{
            NSInteger tempIndex = _currentIndex < newIndex ? newIndex - 1 : newIndex + 1;
            _isViewWillAppeare = YES;
            _contentView.contentOffset = CGPointMake(_contentView.frame.size.width * tempIndex, 0);
        } completion:^(BOOL finished) {
            _isViewWillAppeare = NO;
        }];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [_originalButton setSelected:NO];
        [sender setSelected:YES];
        _originalButton = sender;
        [self updateHeaderView];
        _contentView.contentOffset = CGPointMake(_contentView.frame.size.width * newIndex, 0);
    } completion:^(BOOL finished) {
        self.currentIndex = newIndex;
    }];
}

#pragma mark 更新顶部header的位置
- (void)updateHeaderView
{
    CGSize size = [_originalButton frame].size;
    _shadowView.frame = CGRectMake(_originalButton.frame.origin.x, size.height - 2, size.width, 2);
    CGFloat headerMinX = [_originalButton frame].origin.x;
    CGFloat headerWidth = _headerView.frame.size.width;
    CGFloat headerOffsetX = _headerView.contentOffset.x;
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        CGFloat diffX = (CGRectGetMaxX(_originalButton.frame) - headerWidth);
        headerOffsetX = (diffX < 0 || headerOffsetX > diffX) ? headerOffsetX : diffX;
    }
    
    if (headerWidth + headerOffsetX <= headerMinX + size.width * 1.5) {
        CGFloat totleWidth = _headerView.contentSize.width;
        headerOffsetX += size.width;
        if (headerWidth + headerOffsetX > totleWidth) {
            headerOffsetX = (totleWidth - headerWidth);
        }
        _headerView.contentOffset = CGPointMake(headerOffsetX, 0);
    } else if ((headerMinX - size.width * 0.5) <= headerOffsetX) {
        headerOffsetX -= size.width;
        if (headerOffsetX < 0) headerOffsetX = 0;
        _headerView.contentOffset = CGPointMake(headerOffsetX, 0);
    }
}

#pragma mark - 当前页面控制器改变时触发，传递disappearViewController & appearViewController
- (void)displayViewControllerDidChangedWithIndex:(NSInteger)currentIndex disIndex:(NSInteger)disIndex
{
    UIViewController *appearViewController = nil;
    UIViewController *disappearViewController = nil;
    NSArray *visiableList = _contentView.visibleList;
    CGFloat disappearX = disIndex * self.frame.size.width;
    CGFloat appearX = currentIndex * self.frame.size.width;
    for (UIViewController *viewController in visiableList) {
        if (viewController.view.frame.origin.x == disappearX) {
            disappearViewController = viewController;
        }
        
        if (viewController.view.frame.origin.x == appearX) {
            appearViewController = viewController;
        }
    }
    
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

#pragma mark - headerView deleagte
- (void)headerView:(VTHeaderView *)headerView didSelectedItem:(UIButton *)itemBtn
{
    [self headerItemClick:itemBtn];
}

#pragma mark - contentView data source
- (UIViewController *)contentView:(VTContentView *)content viewControllerForIndex:(NSInteger)index
{
    if ([_dataSource respondsToSelector:@selector(magicView:viewControllerForIndex:)]) {
        UIViewController *viewController = [_dataSource magicView:self viewControllerForIndex:index];
        if (viewController && ![viewController.parentViewController isEqual:_delegate]) {
            [(UIViewController *)_delegate addChildViewController:viewController];
            if ([_delegate respondsToSelector:@selector(currentViewController)] && ![(VTMagicViewController *)_delegate currentViewController]) {
                // 设置默认的currentViewController
                [(VTMagicViewController *)_delegate setCurrentViewController:viewController];
            }
        }
        return viewController;
    }
    return nil;
}

#pragma mark - UIScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isViewWillAppeare = NO;
    _isUserSliding = YES;
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
    
    if (_isUserSliding && newIndex != _currentIndex) {
        self.currentIndex = newIndex;
        UIButton *headerButton = (UIButton *)[_headerView viewWithTag:-(newIndex + 1)];
        [UIView animateWithDuration:0.25 animations:^{
            [_originalButton setSelected:NO];
            [headerButton setSelected:YES];
            _originalButton = headerButton;
            [self updateHeaderView];
        }];
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
        NSLog(@"scrollViewDidEndDragging");
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView

{
    NSLog(@"scrollViewDidEndScrollingAnimation ");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _isUserSliding = NO;
//    NSLog(@"scrollViewDidEndDecelerating");
    if (0 != (int)scrollView.contentOffset.x%320) {
        NSLog(@"scrollViewDidEndDecelerating ERROR: %d",(int)scrollView.contentOffset.x%320);
    }
}

#pragma mark - 视图即将显示
- (void)subviewWillAppeareWithIndex:(NSInteger)index
{
    if (_nextIndex == index) return;
    _nextIndex = index;
//    NSLog(@"subviewWillAppeare current index:%d",index);
}

@end
