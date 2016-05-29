//
//  ChildViewController.m
//  VTMagicView
//
//  Created by tianzhuo on 14/12/30.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import "ListViewController.h"
#import "VTListViewCell.h"

static NSString *reuseIdentifier = @"list.reuse.identifier";

@interface ListViewController()

@property (nonatomic, strong) NSMutableArray *infoList;

@end

@implementation ListViewController

- (instancetype)init
{
    BOOL iPhoneDevice = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = iPhoneDevice ?UIEdgeInsetsMake(10, 20, 10, 20) : UIEdgeInsetsMake(20, 20, 20, 20);
    layout.itemSize = iPhoneDevice ? CGSizeMake(125, 183) : CGSizeMake(188, 188);
    layout.minimumInteritemSpacing = iPhoneDevice ? 2 : 11;
    layout.minimumLineSpacing = iPhoneDevice ? 2 : 11;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self generateData];
    self.collectionView.scrollsToTop = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[VTListViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    NSLog(@"viewWillAppear:%@",self);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.collectionView.scrollsToTop = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    NSLog(@"viewWillDisappear:%@",self);
    self.collectionView.scrollsToTop = NO;
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _infoList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VTListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSString *imageName = [NSString stringWithFormat:@"image_%ld", indexPath.row%13];
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
    cell.titleLabel.text = @"景点介绍，景点介绍。。";
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectItemAtIndexPath%@", indexPath);
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
