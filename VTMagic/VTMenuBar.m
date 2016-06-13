//
//  VTMenuBar.m
//  VTMagicView
//
//  Created by tianzhuo on 15/1/6.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//

#import "VTMenuBar.h"
#import "UIScrollView+Magic.h"
#import "VTCommon.h"

static NSInteger const kVTMenuBarTag = 1000;

@interface VTMenuBar()

@property (nonatomic, strong) NSMutableArray *frameList; // frame数组
@property (nonatomic, strong) NSMutableArray *sliderList;   // slider frames
@property (nonatomic, strong) NSMutableDictionary *visibleDict; // 屏幕上可见的items
@property (nonatomic, strong) NSMutableSet *cacheSet; // 缓存池
@property (nonatomic, strong) NSMutableDictionary *cacheDict; // 缓存池
@property (nonatomic, strong) NSString *identifier; // 重用标识符
@property (nonatomic, strong) NSMutableArray *indexList; // 索引集合
@property (nonatomic, strong) UIFont *itemFont;

@end

@implementation VTMenuBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemSpacing = 25.f;
        _sliderHeight = 2.0f;
        _sliderExtension = CGFLOAT_MAX;
        _bubbleInset = UIEdgeInsetsMake(2, 5, 2, 5);
        _indexList = [[NSMutableArray alloc] init];
        _frameList = [[NSMutableArray alloc] init];
        _sliderList = [[NSMutableArray alloc] init];
        _visibleDict = [[NSMutableDictionary alloc] init];
        _cacheSet = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIButton *itemBtn = nil;
    CGRect frame = CGRectZero;
    NSArray *indexList = [_visibleDict allKeys];
    for (NSNumber *index in indexList) {
        itemBtn = _visibleDict[index];
        frame = [_frameList[[index integerValue]] CGRectValue];
        if (![self vtm_isNeedDisplayWithFrame:frame]) {
            [itemBtn setSelected:NO];
            [itemBtn removeFromSuperview];
            [_visibleDict removeObjectForKey:index];
            [_cacheSet addObject:itemBtn];
        } else {
            itemBtn.selected = NO;
            itemBtn.frame = frame;
        }
    }
    
    NSMutableArray *leftIndexList = [_indexList mutableCopy];
    [leftIndexList removeObjectsInArray:indexList];
    for (NSNumber *index in leftIndexList) {
        frame = [_frameList[[index integerValue]] CGRectValue];
        if ([self vtm_isNeedDisplayWithFrame:frame]) {
            [self loadItemAtIndex:[index integerValue]];
        }
    }
    
    [self updateSelectedItem];
}

#pragma mark - update menuItem state
- (void)updateSelectedItem
{
    _selectedItem.selected = NO;
    _selectedItem = _visibleDict[@(_currentIndex)];
    _selectedItem.selected = _deselected ? NO : YES;
}

- (void)deselectMenuItem
{
    self.deselected = YES;
    _selectedItem.selected = NO;
}

- (void)reselectMenuItem
{
    self.deselected = NO;
    _selectedItem.selected = YES;
}

#pragma mark - functional methods
- (void)reloadData
{
    [self resetCacheData];
    [self resetItemFrames];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)resetCacheData
{
    [_indexList removeAllObjects];
    NSInteger pageCount = _menuTitles.count;
    for (NSInteger index = 0; index < pageCount; index++) {
        [_indexList addObject:@(index)];
    }
    
    NSArray *visibleItems = [_visibleDict allValues];
    for (UIButton *itemBtn in visibleItems) {
        [itemBtn setSelected:NO];
        [itemBtn removeFromSuperview];
        [_cacheSet addObject:itemBtn];
    }
    [_visibleDict removeAllObjects];
}

#pragma mark reset item frames
- (void)resetItemFrames
{
    [_frameList removeAllObjects];
    if (!_menuTitles.count) return;
    
    UIButton *menuItem = nil;
    if (!_itemFont) {
        menuItem = [self createItemAtIndex:_currentIndex];
        _itemFont = menuItem.titleLabel.font;
        NSAssert(_itemFont != nil, @"item shouldn't be nil, you must conform VTMagicViewDataSource");
    }
    
    switch (_layoutStyle) {
        case VTLayoutStyleDivide:
            [self resetFramesForDivide];
            break;
        case VTLayoutStyleCenter:
            [self resetFramesForCenter];
            break;
        case VTLayoutStyleCustom:
            [self resetFramesForCustom];
            break;
        default:
            [self resetFramesForDefault];
            break;
    }
    
    [self resetSliderFrames];
    CGFloat contentWidth = CGRectGetMaxX([[_frameList lastObject] CGRectValue]);
    contentWidth += _menuInset.right;
    self.contentSize = CGSizeMake(contentWidth, 0);
    if (menuItem && _currentIndex < _frameList.count) {
        menuItem.frame = [_frameList[_currentIndex] CGRectValue];
    }
}

- (void)resetFramesForDefault
{
    CGSize size = CGSizeZero;
    CGRect frame = CGRectZero;
    CGFloat itemX = _menuInset.left;
    CGFloat height = self.frame.size.height;
    height -= _menuInset.top + _menuInset.bottom;
    for (NSString *title in _menuTitles) {
        size = [self sizeWithTitle:title];
        frame = CGRectMake(itemX, _menuInset.top, size.width + _itemSpacing, height);
        [_frameList addObject:[NSValue valueWithCGRect:frame]];
        itemX += frame.size.width;
    }
}

- (void)resetFramesForDivide
{
    CGRect frame = CGRectZero;
    NSInteger count = _menuTitles.count;
    CGFloat height = self.frame.size.height;
    height -= _menuInset.top + _menuInset.bottom;
    CGFloat totalSpace = _menuInset.left + _menuInset.right;
    CGFloat itemWidth = (CGRectGetWidth(self.frame) - totalSpace)/count;
    frame.origin = CGPointMake(_menuInset.left, _menuInset.top);
    frame.size = CGSizeMake(itemWidth, height);
    for (int index = 0; index < count; index++) {
        [_frameList addObject:[NSValue valueWithCGRect:frame]];
        frame.origin.x += itemWidth;
    }
}

- (void)resetFramesForCenter
{
    [self resetFramesForDefault];
    CGFloat menuWidth = CGRectGetWidth(self.frame);
    CGRect lastFame = [[_frameList lastObject] CGRectValue];
    CGFloat contentWidth = menuWidth - _menuInset.right;
    CGFloat itemOffset = (contentWidth - CGRectGetMaxX(lastFame))/2;
    if (itemOffset <= 0) return;
    CGRect frame = CGRectZero;
    NSArray *frames = [NSArray arrayWithArray:_frameList];
    [_frameList removeAllObjects];
    for (NSValue *value in frames) {
        frame = [value CGRectValue];
        frame.origin.x += itemOffset;
        [_frameList addObject:[NSValue valueWithCGRect:frame]];
    }
}

- (void)resetFramesForCustom
{
    CGRect frame = CGRectZero;
    NSInteger count = _menuTitles.count;
    CGFloat height = self.frame.size.height;
    height -= _menuInset.top + _menuInset.bottom;
    frame.origin = CGPointMake(_menuInset.left, _menuInset.top);
    frame.size = CGSizeMake(_itemWidth, height);
    for (int index = 0; index < count; index++) {
        [_frameList addObject:[NSValue valueWithCGRect:frame]];
        frame.origin.x += _itemWidth;
    }
}

#pragma mark reset slider frames
- (void)resetSliderFrames
{
    [_sliderList removeAllObjects];
    if (!_menuTitles.count) return;
    switch (_sliderStyle) {
        case VTSliderStyleBubble:
            [self resetSliderForBubble];
            break;
        default:
            [self resetSliderForDefault];
            break;
    }
}

- (void)resetSliderForDefault
{
    NSInteger index = 0;
    CGRect itemFrame = CGRectZero;
    CGFloat sliderY = CGRectGetHeight(self.frame) - _sliderHeight + _sliderOffset;
    CGRect frame = CGRectMake(0, sliderY, 0, _sliderHeight);
    for (NSString *title in _menuTitles) {
        index = [_menuTitles indexOfObject:title];
        itemFrame = [self itemFrameAtIndex:index];
        if (_sliderWidth) {
            frame.size.width = _sliderWidth;
        } else if (CGFLOAT_MAX != _sliderExtension) {
            frame.size.width = [self sizeWithTitle:title].width;
            frame.size.width += _sliderExtension * 2;
        } else {
            frame.size.width = itemFrame.size.width;
        }
        frame.origin.x = CGRectGetMidX(itemFrame) - frame.size.width/2;
        [_sliderList addObject:[NSValue valueWithCGRect:frame]];
    }
}

- (void)resetSliderForBubble
{
    NSInteger index = 0;
    CGSize size = CGSizeZero;
    CGRect frame = CGRectZero;
    CGRect itemFrame = CGRectZero;
    CGPoint bubblePoint = CGPointZero;
    for (NSString *title in _menuTitles) {
        size = [self sizeWithTitle:title];
        index = [_menuTitles indexOfObject:title];
        itemFrame = [self itemFrameAtIndex:index];
        size.width += _bubbleInset.left + _bubbleInset.right;
        size.height += _bubbleInset.top + _bubbleInset.bottom;
        bubblePoint.x = CGRectGetMidX(itemFrame) - size.width/2;
        bubblePoint.y = CGRectGetMidY(itemFrame) - size.height/2;
        frame = (CGRect){bubblePoint, size};
        [_sliderList addObject:[NSValue valueWithCGRect:frame]];
    }
}

- (CGSize)sizeWithTitle:(NSString *)title
{
    CGSize size = CGSizeZero;
    if ([title respondsToSelector:@selector(sizeWithAttributes:)]) {
        size = [title sizeWithAttributes:@{NSFontAttributeName : _itemFont}];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [title sizeWithFont:_itemFont];
#pragma clang diagnostic pop
    }
    return size;
}

#pragma mark - 查询
- (CGRect)itemFrameAtIndex:(NSUInteger)index
{
    if (_frameList.count <= index) return CGRectZero;
    return [_frameList[index] CGRectValue];
}

- (UIButton *)itemAtIndex:(NSUInteger)index
{
    return [self itemAtIndex:index autoCreate:NO];
}

- (UIButton *)createItemAtIndex:(NSUInteger)index
{
    return [self itemAtIndex:index autoCreate:YES];
}

- (UIButton *)itemAtIndex:(NSUInteger)index autoCreate:(BOOL)autoCreate
{
    if (_menuTitles.count <= index) return nil;
    UIButton *menuItem = _visibleDict[@(index)];
    if (autoCreate && !menuItem) {
        menuItem = [self loadItemAtIndex:index];
    }
    return menuItem;
}

- (UIButton *)loadItemAtIndex:(NSInteger)index
{
    UIButton *itemBtn = [_datasource menuBar:self menuItemAtIndex:index];
    NSAssert([itemBtn isKindOfClass:[UIButton class]], @"item:%@ must be a kind of UIButton", itemBtn);
    if (itemBtn) {
        [itemBtn addTarget:self action:@selector(menuItemClick:) forControlEvents:UIControlEventTouchUpInside];
        itemBtn.tag = index + kVTMenuBarTag;
        if (index < _frameList.count) {
            itemBtn.frame = [_frameList[index] CGRectValue];
        }
        [itemBtn setSelected:NO];
        [self addSubview:itemBtn];
        [_visibleDict setObject:itemBtn forKey:@(index)];
    }
    return itemBtn;
}

- (CGRect)sliderFrameAtIndex:(NSUInteger)index
{
    if (_sliderList.count <= index) return CGRectZero;
    return [_sliderList[index] CGRectValue];
}

- (UIButton *)dequeueReusableItemWithIdentifier:(NSString *)identifier
{
    _identifier = identifier;
    UIButton *menuItem = [_cacheSet anyObject];
    if (menuItem) {
        [_cacheSet removeObject:menuItem];
    }
    return menuItem;
}

#pragma mark - item 点击事件
- (void)menuItemClick:(id)sender
{
    NSInteger itemIndex = [(UIButton *)sender tag] - kVTMenuBarTag;
    if ([_menuDelegate respondsToSelector:@selector(menuBar:didSelectItemAtIndex:)]) {
        [_menuDelegate menuBar:self didSelectItemAtIndex:itemIndex];
    }
}

@end
