//
//  GridViewController.m
//  VTMagicView
//
//  Created by tianzhuo on 14/12/30.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import "VTGridViewController.h"
#import "VTDetailViewController.h"
#import <VTMagic/VTMagic.h>
#import "VTGridViewCell.h"
#import "DataManager.h"

#define IPHONELESS6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? 640 == [[UIScreen mainScreen] currentMode].size.width : NO)
static NSString *reuseIdentifier = @"grid.reuse.identifier";

@interface VTGridViewController()

@property (nonatomic, strong) NSMutableArray *infoList;

@end

@implementation VTGridViewController

- (instancetype)init {
    BOOL iPhoneDevice = kiPhoneDevice;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = iPhoneDevice ?UIEdgeInsetsMake(10, 10, 10, 10) : UIEdgeInsetsMake(20, 20, 20, 20);
    layout.itemSize = iPhoneDevice ? (IPHONELESS6 ? CGSizeMake(140, 175) : CGSizeMake(115, 170)) : CGSizeMake(188, 188);
    layout.minimumInteritemSpacing = iPhoneDevice ? 2 : 11;
    layout.minimumLineSpacing = iPhoneDevice ? 10 : 11;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.scrollsToTop = NO;
    self.collectionView.backgroundColor = RGBCOLOR(239, 239, 239);
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, VTTABBAR_HEIGHT, 0);
    [self.collectionView registerClass:[VTGridViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    VTPRINT_METHOD
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refreshPageIfNeeded];
    self.collectionView.scrollsToTop = YES;
    NSInteger pageIndex = [self vtm_pageIndex];
    NSLog(@"current page index is: %ld", (long)pageIndex);
    VTPRINT_METHOD
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self cancelNetworkRequest];
    self.collectionView.scrollsToTop = NO;
    VTPRINT_METHOD
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self savePageInfo];
    VTPRINT_METHOD
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _infoList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VTGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    NSString *imageName = _infoList[indexPath.item];
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
    cell.commentLabel.text = [NSString stringWithFormat:@"%d人出游", arc4random_uniform(9999)];
    cell.titleLabel.text = @"景点介绍，景点介绍，景点介绍。。";
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger currentPage = self.magicController.currentPage;
    NSLog(@"==didSelectItemAtIndexPath%@ \n current page is: %ld==", indexPath, (long)currentPage);
    VTDetailViewController *detailViewController = [[VTDetailViewController alloc] init];
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - VTMagicReuseProtocol
- (void)vtm_prepareForReuse {
    // reset content offset
    NSLog(@"clear old data if needed:%@", self);
    [_infoList removeAllObjects];
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointZero];
}

#pragma mark - functional methods
- (void)refreshPageIfNeeded {
    NSTimeInterval currentStamp = [[NSDate date] timeIntervalSince1970];
    if (self.infoList.count && currentStamp - _menuInfo.lastTime < 60 * 60) {
        return;
    }
    
    // 模拟网络请求延时，根据_menuInfo.menuId请求对应菜单项的相关信息
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _menuInfo.lastTime = currentStamp;
        [self handleNetworkSuccess];
    });
}

- (void)cancelNetworkRequest {
    // 由于页面可能会被重用，需要取消不必要的网络请求
//    NSLog(@"maybe you should cancel network request in here");
}

- (void)handleNetworkSuccess {
    NSLog(@"==模拟网络请求成功后刷新页面==");
    for (NSInteger index = 0; index < 50; index++) {
        [self.infoList addObject:[NSString stringWithFormat:@"image_%d", arc4random_uniform(13)]];
    }
    [self.collectionView reloadData];
}

- (void)savePageInfo {
    [[DataManager sharedInstance] savePageInfo:_infoList menuId:_menuInfo.menuId];
}

- (void)loadLocalData {
    NSArray *cacheList = [[DataManager sharedInstance] pageInfoWithMenuId:_menuInfo.menuId];
    [_infoList addObjectsFromArray:cacheList];
    [self.collectionView reloadData];
}

#pragma mark - accessor methods
- (void)setMenuInfo:(MenuInfo *)menuInfo {
    _menuInfo = menuInfo;
    [self loadLocalData];
}

- (NSMutableArray *)infoList {
    if (!_infoList) {
        _infoList = [[NSMutableArray alloc] init];
    }
    return _infoList;
}

@end
