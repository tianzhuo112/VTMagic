//
//  GridViewController.m
//  VTMagicView
//
//  Created by tianzhuo on 14/12/30.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import "VTGridViewController.h"
#import "VTGridViewCell.h"
#import "VTMagic.h"

#define IPHONELESS6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? 640 == [[UIScreen mainScreen] currentMode].size.width : NO)
static NSString *reuseIdentifier = @"grid.reuse.identifier";

@interface VTGridViewController()

@property (nonatomic, strong) NSMutableArray *infoList;

@end

@implementation VTGridViewController

- (instancetype)init
{
    BOOL iPhoneDevice = kiPhoneDevice;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = iPhoneDevice ?UIEdgeInsetsMake(10, 10, 10, 10) : UIEdgeInsetsMake(20, 20, 20, 20);
    layout.itemSize = iPhoneDevice ? (IPHONELESS6 ? CGSizeMake(140, 175) : CGSizeMake(115, 170)) : CGSizeMake(188, 188);
    layout.minimumInteritemSpacing = iPhoneDevice ? 2 : 11;
    layout.minimumLineSpacing = iPhoneDevice ? 10 : 11;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self generateData];
    self.collectionView.scrollsToTop = NO;
    self.collectionView.backgroundColor = RGBCOLOR(239, 239, 239);
    [self.collectionView registerClass:[VTGridViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    VTPRINT_METHOD
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.collectionView.scrollsToTop = YES;
    VTPRINT_METHOD
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.collectionView.scrollsToTop = NO;
    VTPRINT_METHOD
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    VTPRINT_METHOD
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _infoList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VTGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    NSString *imageName = [NSString stringWithFormat:@"image_%ld", (long)indexPath.row%13];
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
    cell.commentLabel.text = [NSString stringWithFormat:@"%d人出游", arc4random_uniform(9999)];
    cell.titleLabel.text = @"景点介绍，景点介绍，景点介绍。。";
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentPage = self.magicController.currentPage;
    NSLog(@"==didSelectItemAtIndexPath%@ \n current page is: %ld==", indexPath, (long)currentPage);
}

#pragma mark - VTMagicReuseProtocol
- (void)vtm_prepareForReuse
{
    // reset content offset
    NSLog(@"clear old data if needed:%@", self);
    [self.collectionView setContentOffset:CGPointZero];
}

#pragma functional methods
- (void)generateData
{
    _infoList = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < 50; index++) {
        [_infoList addObject:[NSString stringWithFormat:@"消息%ld", (long)index]];
    }
}

@end
