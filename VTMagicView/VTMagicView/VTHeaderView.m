//
//  VTHeaderView.m
//  VTMagicView
//
//  Created by tianzhuo on 15/1/6.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//

#import "VTHeaderView.h"
#import "VTCommon.h"

@interface VTHeaderView()

@property (nonatomic, strong) NSMutableArray *frameList; // frame数组
@property (nonatomic, strong) NSMutableDictionary *visibleDict; // 屏幕上可见的header item
@property (nonatomic, strong) NSMutableSet *cacheSet; // 缓存池

@end

@implementation VTHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemBorder = 25.f;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 暂不支持旋转
    BOOL isLandscape = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    if (isLandscape) return;
    
    CGRect frame = CGRectZero;
    NSInteger count = _frameList.count;
    for (NSInteger index = 0; index < count; index++) {
        if (!_visibleDict) {
            _visibleDict = [[NSMutableDictionary alloc] initWithCapacity:_headerList.count];
        }
        
        frame = [_frameList[index] CGRectValue];
        UIButton *itemBtn = _visibleDict[@(index)];
        if (!itemBtn) {
            if ([self isNeedDisplayWithFrame:frame]) {
                itemBtn = [_cacheSet anyObject];
                if (itemBtn) [_cacheSet removeObject:itemBtn];
                if (!itemBtn) {
                    itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [itemBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
                    if (_headerItem) {
                        itemBtn.titleLabel.font = _headerItem.titleLabel.font;
                        [itemBtn setTitleColor:[_headerItem titleColorForState:UIControlStateNormal]
                                      forState:UIControlStateNormal];
                        [itemBtn setTitleColor:[_headerItem titleColorForState:UIControlStateSelected]
                                      forState:UIControlStateSelected];
                        [itemBtn setTitleColor:[_headerItem titleColorForState:UIControlStateHighlighted]
                                      forState:UIControlStateHighlighted];
                    } else {
                        itemBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18];;
                        [itemBtn setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
                        [itemBtn setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
                        [itemBtn setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateHighlighted];
                    }
                }
                
                itemBtn.tag = index;
                itemBtn.frame = frame;
                if (_currentIndex == index) itemBtn.selected = YES;
                [itemBtn setTitle:_headerList[index] forState:UIControlStateNormal];
                [self addSubview:itemBtn];
                [_visibleDict setObject:itemBtn forKey:@(index)];
            }
        } else {
            if (![self isNeedDisplayWithFrame:frame]) {
                if (itemBtn.selected) _currentIndex = itemBtn.tag;
                [itemBtn setSelected:NO];
                [itemBtn removeFromSuperview];
                [_visibleDict removeObjectForKey:@(index)];
                if (!_cacheSet) {
                    _cacheSet = [[NSMutableSet alloc] initWithCapacity:_headerList.count];
                }
                [_cacheSet addObject:itemBtn];
            }
        }
        
    }
}

#pragma mark - 是否需要显示在当前屏幕上
- (BOOL)isNeedDisplayWithFrame:(CGRect)frame
{
    CGFloat referenceMinX = self.contentOffset.x;
    CGFloat referenceMaxX = referenceMinX + self.frame.size.width;
    CGFloat viewMinX = frame.origin.x;
    CGFloat viewMaxX = viewMinX + frame.size.width;
    BOOL isLeftBorderInScreen = referenceMinX <= viewMinX && viewMinX <= referenceMaxX;
    BOOL isRightBorderInScreen = referenceMinX <= viewMaxX && viewMaxX <= referenceMaxX;
    BOOL isInScreen = isLeftBorderInScreen || isRightBorderInScreen;
    return isInScreen;
}

#pragma mark - set 方法
- (void)setHeaderList:(NSArray *)headerList
{
    _headerList = headerList;
    [self resetFrameList];
}

- (void)setHeaderItem:(UIButton *)headerItem
{
    _headerItem = headerItem;
    
    NSArray *itemList = [_visibleDict allValues];
    [_cacheSet removeAllObjects];
    [_visibleDict removeAllObjects];
    for (UIButton *item in itemList) {
        [item removeFromSuperview];
    }
    
    [self resetFrameList];
}

- (void)setItemBorder:(CGFloat)itemBorder
{
    _itemBorder = itemBorder;
    [self resetFrameList];
}

#pragma mark - 重置所有frame
- (void)resetFrameList
{
    CGSize size = CGSizeZero;
    UIFont *font = _headerItem.titleLabel.font ?: [UIFont fontWithName:@"Helvetica" size:18];
    if (!_frameList) {
        _frameList = [[NSMutableArray alloc] initWithCapacity:_headerList.count];
    }
    
    [_frameList removeAllObjects];
    NSInteger count = _headerList.count;
    CGRect frame = CGRectZero;
    CGFloat itemX = 0;
    for (int index = 0; index < count; index++) {
        if (IOS7_OR_LATER) {
            size = [_headerList[index] sizeWithAttributes:@{NSFontAttributeName : font}];
        } else {
            size = [_headerList[index] sizeWithFont:font];
        }
        
        frame = CGRectMake(itemX, 0, size.width + _itemBorder, 44);
        [_frameList addObject:[NSValue valueWithCGRect:frame]];
        itemX += frame.size.width;
    }
    
    self.contentSize = CGSizeMake(itemX, 0);
    [self setNeedsLayout];
}

- (UIButton *)itemWithIndex:(NSInteger)index
{
    return _visibleDict[@(index)];
}

#pragma mark - item 点击事件
- (void)itemClick:(id)sender
{
    if ([_headerDelegate respondsToSelector:@selector(headerView:didSelectedItem:)]) {
        [_headerDelegate headerView:self didSelectedItem:sender];
    }
}

@end
