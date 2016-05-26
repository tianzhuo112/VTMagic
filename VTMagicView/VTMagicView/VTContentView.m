//
//  VTContentView.m
//  VTMagicView
//
//  Created by tianzhuo on 14/12/29.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import "VTContentView.h"

@interface VTContentView()

@property (nonatomic, strong) NSMutableDictionary *visibleDict; // 屏幕上可见的控制器
@property (nonatomic, strong) NSMutableArray *indexList; // 索引集合
@property (nonatomic, strong) NSMutableDictionary *cacheDict; // 缓存池
@property (nonatomic, strong) NSMutableSet *reusableSet; // 缓存池
@property (nonatomic, strong) NSMutableArray *frameList; // 控制器的坐标集合
@property (nonatomic, strong) NSString *identifier; // 重用标识符

@end

@implementation VTContentView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //方案一，有空白页面出现
    UIViewController *viewController = nil;
    for (NSIndexPath *indexPath in _indexList) {
        viewController = _visibleDict[indexPath];
//        for (UIViewController *aViewController in _visibleList) {
//            if (aViewController.view.frame.origin.x/self.frame.size.width == indexPath.row) {
//                viewController = aViewController;
//                break;
//            }
//        }
        
        CGRect frame = [_frameList[indexPath.row] CGRectValue];
        if (!viewController) {
            if ([self isNeedDisplayWithFrame:frame]) {
                viewController = [_dataSource contentView:self viewControllerForIndex:indexPath.row];
                if (!viewController) continue;
//                if ([viewController.view.superview isEqual:self]) continue;
                viewController.view.frame = frame;
                viewController.restorationIdentifier = _identifier;
                [self addSubview:viewController.view];
                [_visibleDict setObject:viewController forKey:indexPath];
                if (NSNotFound == [_visibleList indexOfObject:viewController]) {
                    [_visibleList addObject:viewController];
                }
            }
        } else {
            // 控制器若移出屏幕则将其视图从父类中移除，并添加到缓存池中
            if (![self isNeedDisplayWithFrame:frame]) {
                [viewController.view removeFromSuperview];
                [_reusableSet addObject:viewController];
                [_visibleDict removeObjectForKey:indexPath];
                [_visibleList removeObject:viewController];
                
                // 添加到缓存池
                NSMutableSet *cacheSet = _cacheDict[viewController.restorationIdentifier];
                if (!cacheSet) cacheSet = [[NSMutableSet alloc] init];
                [cacheSet addObject:viewController];
                [_cacheDict setValue:cacheSet forKey:viewController.restorationIdentifier];
            } else {
                viewController.view.frame = frame;
            }
        }
    }
}

#pragma mark 判断指定frame是否在屏幕范围之内
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

#pragma mark - 加载数据
- (void)reloadData
{
    [self resetCacheData];
    [self resetFrames];
    [self setNeedsLayout];
}

- (void)layoutSubviewsWhenRotated
{
    [self resetFrames];
}

#pragma mark - 重置缓存信息
-(void)resetCacheData
{
    if (!_frameList) {
        _frameList = [[NSMutableArray alloc] initWithCapacity:_dataCount];
    } else {
        [_frameList removeAllObjects];
    }
    
#warning mark 这个逻辑尚需优化，直接用NSNumber作为key即可
    if (!_indexList) {
        _indexList = [[NSMutableArray alloc] initWithCapacity:_dataCount];
    } else {
        [_indexList removeAllObjects];
    }
    
    for (NSInteger i = 0; i < _dataCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [_indexList addObject:indexPath];
    }
    
    if (!_reusableSet) {
        _reusableSet = [[NSMutableSet alloc] initWithCapacity:_dataCount];
    }
    
    if (!_cacheDict) {
        _cacheDict = [[NSMutableDictionary alloc] initWithCapacity:_dataCount];
    }
    
    if (!_visibleDict) {
        _visibleDict = [[NSMutableDictionary alloc] initWithCapacity:_dataCount];
    }
    
    if (!_visibleList) {
        _visibleList = [[NSMutableArray alloc] initWithCapacity:_dataCount];
    }
}

- (void)resetFrames
{
    CGFloat viewX = 0;
    CGFloat height = self.frame.size.height - self.frame.origin.y;
    CGRect frame = CGRectMake(viewX, 0, self.frame.size.width, height);
#warning mark 这个地方有问题x、y设置有误
    [_frameList removeAllObjects];
    for (NSIndexPath *indexPath in _indexList) {
        viewX = indexPath.row * frame.size.width;
        frame.origin.x = viewX;
        [_frameList addObject:[NSValue valueWithCGRect:frame]];
    }
}

#pragma mark - 根据缓存标识查询可重用的视图控制器
- (id)dequeueReusableViewControllerWithIdentifier:(NSString *)identifier
{
    _identifier = identifier;
    NSMutableSet *cacheSet = _cacheDict[identifier];
    UIViewController *viewController = [cacheSet anyObject];
    if (viewController) {
        [cacheSet removeObject:viewController];
        [_cacheDict setValue:cacheSet forKey:identifier];
    }
    return viewController;
}

@end
