//
//  VTRelateViewController.m
//  VTMagic
//
//  Created by tianzhuo on 7/7/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import "VTRelateViewController.h"
#import "VTRecomCell.h"

@interface VTRelateViewController ()

@property (nonatomic, strong) NSMutableArray *newsList;

@end

@implementation VTRelateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.scrollsToTop = NO;
    self.view.backgroundColor = RGBCOLOR(239, 239, 239);
    self.tableView.rowHeight = 70.f;
    
    [self fetchNewsData];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    VTPRINT_METHOD
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.tableView.scrollsToTop = YES;
    VTPRINT_METHOD
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tableView.scrollsToTop = NO;
    VTPRINT_METHOD
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    VTPRINT_METHOD
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VTRecomCell *cell = nil;
    static NSString *cellID = @"cell.Identifier";
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[VTRecomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *imageName = _newsList[indexPath.row];
    [cell.iconView setImage:[UIImage imageNamed:imageName]];
    cell.titleLabel.text = @"标题标题";
    cell.descLabel.text = @"详情描述详情描述详情描述详情描述详情描述详情描述";
    return cell;
}

#pragma mark - VTMagicReuseProtocol
- (void)vtm_prepareForReuse {
    // reset content offset
    NSLog(@"clear old data if needed:%@", self);
    [self.tableView setContentOffset:CGPointZero];
}

#pragma mark - functional methods
- (void)fetchNewsData {
    _newsList = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < 50; index++) {
        [_newsList addObject:[NSString stringWithFormat:@"image_%d", arc4random_uniform(13)]];
    }
}

@end
