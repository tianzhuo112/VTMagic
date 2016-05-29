//
//  VTCategoryBar.m
//  VTMagicView
//
//  Created by tianzhuo on 15/1/6.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//

#import "VTCategoryBar.h"
#import "UIScrollView+Magic.h"
#import "VTCommon.h"

@interface VTCategoryBar()

@property (nonatomic, strong) NSMutableArray *frameList; // frame数组
@property (nonatomic, strong) NSMutableDictionary *visibleDict; // 屏幕上可见的cat item
@property (nonatomic, strong) NSMutableSet *cacheSet; // 缓存池
@property (nonatomic, strong) NSMutableDictionary *cacheDict; // 缓存池
@property (nonatomic, strong) NSString *identifier; // 重用标识符
@property (nonatomic, strong) NSMutableArray *indexList; // 索引集合

@end

@implementation VTCategoryBar

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
    
    UIButton *itemBtn = nil;
    CGRect frame = CGRectZero;
    NSArray *indexList = [_visibleDict allKeys];
    for (NSNumber *index in indexList) {
        itemBtn = _visibleDict[index];
        frame = [_frameList[[index integerValue]] CGRectValue];
        if (![self vtm_isNeedDisplayWithFrame:frame]) {
            if (itemBtn.selected) _currentIndex = itemBtn.tag;
            [itemBtn setSelected:NO];
            [itemBtn removeFromSuperview];
            [_visibleDict removeObjectForKey:index];
            [_cacheSet addObject:itemBtn];
        } else {
            itemBtn.selected = NO;
        }
    }
    
    NSMutableArray *leftIndexList = [_indexList mutableCopy];
    [leftIndexList removeObjectsInArray:indexList];
    for (NSNumber *index in leftIndexList) {
        frame = [_frameList[[index integerValue]] CGRectValue];
        if ([self vtm_isNeedDisplayWithFrame:frame]) {
            itemBtn = [_datasource categoryBar:self categoryItemForIndex:[index integerValue]];
            if (![itemBtn isKindOfClass:[UIButton class]]) continue;
            [itemBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            itemBtn.tag = [index integerValue];
            itemBtn.frame = frame;
            [_visibleDict setObject:itemBtn forKey:index];
            [self addSubview:itemBtn];
            itemBtn.selected = NO;
        }
    }
    
    _selectedItem = _visibleDict[@(_currentIndex)];
    _selectedItem.selected = YES;
}

- (id)dequeueReusableCatItemWithIdentifier:(NSString *)identifier
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

#pragma mark - set 方法
- (void)setCatNames:(NSArray *)catNames
{
    _catNames = catNames;
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
    NSInteger pageCount = _catNames.count;
    if (!_indexList) {
        _indexList = [[NSMutableArray alloc] initWithCapacity:pageCount];
    } else {
        [_indexList removeAllObjects];
    }
    
    for (NSInteger index = 0; index < pageCount; index++) {
        [_indexList addObject:@(index)];
    }
    
    if (!_cacheSet) {
        _cacheSet = [[NSMutableSet alloc] initWithCapacity:_catNames.count];
    }
    
    if (!_visibleDict) {
        _visibleDict = [[NSMutableDictionary alloc] initWithCapacity:_catNames.count];
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
        _frameList = [[NSMutableArray alloc] initWithCapacity:_catNames.count];
    }
    
    CGFloat itemX = 0;
    CGSize size = CGSizeZero;
    CGRect frame = CGRectZero;
    [_frameList removeAllObjects];
    NSInteger count = _catNames.count;
    CGFloat height = self.frame.size.height;
    _normalFont = _normalFont ?: [UIFont fontWithName:@"Helvetica" size:16];
    for (int index = 0; index < count; index++) {
        if (IOS7_OR_LATER) {
            size = [_catNames[index] sizeWithAttributes:@{NSFontAttributeName : _normalFont}];
        } else {
            size = [_catNames[index] sizeWithFont:_normalFont];
        }
        
        frame = CGRectMake(itemX, 0, size.width + _itemBorder, height);
        [_frameList addObject:[NSValue valueWithCGRect:frame]];
        itemX += frame.size.width;
    }
    
    self.contentSize = CGSizeMake(itemX, 0);
}

- (UIButton *)itemWithIndex:(NSInteger)index
{
    if (!_catNames.count) return nil;
    UIButton *catItem = _visibleDict[@(index)];
    if (!catItem && [_datasource respondsToSelector:@selector(categoryBar:categoryItemForIndex:)]) {
        catItem = [_datasource categoryBar:self categoryItemForIndex:index];
    }
    
    catItem.tag = index;
    if (!catItem) return nil;
    [self addSubview:catItem];
    [_visibleDict setObject:catItem forKey:@(index)];
    catItem.frame = [_frameList[index] CGRectValue];
    [catItem addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    return catItem;
}

#pragma mark - item 点击事件
- (void)itemClick:(id)sender
{
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]){
        sender = (UIButton *)[(UITapGestureRecognizer *)sender view];
    }
    
    NSInteger newIndex = [(UIButton *)sender tag];
    if (newIndex == _currentIndex) return;
    if ([_catDelegate respondsToSelector:@selector(categoryBar:didSelectedItem:)]) {
        _currentIndex = newIndex;
        _selectedItem.selected = NO;
        [_catDelegate categoryBar:self didSelectedItem:sender];
    }
}

@end
