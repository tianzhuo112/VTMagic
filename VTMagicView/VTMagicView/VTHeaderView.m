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
@property (nonatomic, strong) NSMutableDictionary *cacheDict; // 缓存池
@property (nonatomic, strong) NSString *identifier; // 重用标识符
@property (nonatomic, strong) NSMutableArray *indexList; // 索引集合

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
    
    BOOL isSelected = NO;
    UIButton *itemBtn = nil;
    CGRect frame = CGRectZero;
    NSArray *indexList = [_visibleDict allKeys];
    for (NSNumber *index in indexList) {
        itemBtn = _visibleDict[index];
        frame = [_frameList[[index integerValue]] CGRectValue];
        if (![self isNeedDisplayWithFrame:frame]) {
            if (itemBtn.selected) _currentIndex = itemBtn.tag;
            [itemBtn setSelected:NO];
            [itemBtn removeFromSuperview];
            [_visibleDict removeObjectForKey:index];
            [_cacheSet addObject:itemBtn];
        } else {
            isSelected = [index integerValue] == _currentIndex;
            itemBtn.selected = isSelected;
        }
    }
    
    NSMutableArray *leftIndexList = [_indexList mutableCopy];
    [leftIndexList removeObjectsInArray:indexList];
    for (NSNumber *index in leftIndexList) {
        frame = [_frameList[[index integerValue]] CGRectValue];
        if ([self isNeedDisplayWithFrame:frame]) {
            itemBtn = [_datasource headerView:self headerItemForIndex:[index integerValue]];
            if (![itemBtn isKindOfClass:[UIButton class]]) continue;
            [itemBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            itemBtn.tag = [index integerValue];
            itemBtn.frame = frame;
            [_visibleDict setObject:itemBtn forKey:index];
            [self addSubview:itemBtn];
            isSelected = [index integerValue] == _currentIndex;
            itemBtn.selected = isSelected;
        }
    }
    
    _selectedItem = _visibleDict[@(_currentIndex)];
}

- (id)dequeueReusableHeaderItemWithIdentifier:(NSString *)identifier
{
    _identifier = identifier;
    NSMutableSet *cacheSet = _cacheDict[identifier];
    UIButton *item = [cacheSet anyObject];
    if (item) {
        [cacheSet removeObject:item];
        [_cacheDict setValue:cacheSet forKey:identifier];
    }
    return item;
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
    [self resetFrameForAllItems];
}

- (void)setItemBorder:(CGFloat)itemBorder
{
    _itemBorder = itemBorder;
    [self resetFrameForAllItems];
}

#pragma mark - 重新加载数据
- (void)reloadData
{
    [self resetCacheData];
    [self resetFrameForAllItems];
    [self setNeedsLayout];
}

-(void)resetCacheData
{
    NSInteger pageCount = _headerList.count;
    if (!_indexList) {
        _indexList = [[NSMutableArray alloc] initWithCapacity:pageCount];
    } else {
        [_indexList removeAllObjects];
    }
    
    for (NSInteger index = 0; index < pageCount; index++) {
        [_indexList addObject:@(index)];
    }
    
    if (!_cacheSet) {
        _cacheSet = [[NSMutableSet alloc] initWithCapacity:_headerList.count];
    }
    
    if (!_visibleDict) {
        _visibleDict = [[NSMutableDictionary alloc] initWithCapacity:_headerList.count];
    } else {
        NSArray *visibleItems = [_visibleDict allValues];
        for (UIButton *itemBtn in visibleItems) {
            [itemBtn setSelected:NO];
            [itemBtn removeFromSuperview];
            [_cacheSet addObject:itemBtn];
        }
        [_visibleDict removeAllObjects];
    }
}

#pragma mark - 重置所有frame
- (void)resetFrameForAllItems
{
    if (!_frameList) {
        _frameList = [[NSMutableArray alloc] initWithCapacity:_headerList.count];
    }
    
    CGFloat itemX = 0;
    CGSize size = CGSizeZero;
    CGRect frame = CGRectZero;
    [_frameList removeAllObjects];
    NSInteger count = _headerList.count;
    CGFloat height = self.frame.size.height;
    _normalFont = _normalFont ?: [UIFont fontWithName:@"Helvetica" size:16];
    for (int index = 0; index < count; index++) {
        if (IOS7_OR_LATER) {
            size = [_headerList[index] sizeWithAttributes:@{NSFontAttributeName : _normalFont}];
        } else {
            size = [_headerList[index] sizeWithFont:_normalFont];
        }
        
        frame = CGRectMake(itemX, 0, size.width + _itemBorder, height);
        [_frameList addObject:[NSValue valueWithCGRect:frame]];
        itemX += frame.size.width;
    }
    
    self.contentSize = CGSizeMake(itemX, 0);
}

- (UIButton *)itemWithIndex:(NSInteger)index
{
    if (!_headerList.count) return nil;
    UIButton *headerItem = _visibleDict[@(index)];
    if (!headerItem) {
        headerItem = [_datasource headerView:self headerItemForIndex:index];
    }
    headerItem.tag = index;
    [self addSubview:headerItem];
    [_visibleDict setObject:headerItem forKey:@(index)];
    headerItem.frame = [_frameList[index] CGRectValue];
    [headerItem addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    return headerItem;
}

#pragma mark - item 点击事件
- (void)itemClick:(id)sender
{
    if ([_headerDelegate respondsToSelector:@selector(headerView:didSelectedItem:)]) {
        _selectedItem.selected = NO;
        _currentIndex = [(UIButton *)sender tag];
        [_headerDelegate headerView:self didSelectedItem:sender];
    }
}

@end
