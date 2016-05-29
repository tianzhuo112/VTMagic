//
//  RecomViewController.m
//  VTMagicView
//
//  Created by tianzhuo on 14-11-13.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import "RecomViewController.h"
#import "VTRecomCell.h"

@interface RecomViewController ()

@property (nonatomic, strong) NSMutableArray *newsList;

@end

@implementation RecomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.scrollsToTop = NO;
    self.view.backgroundColor = RGBCOLOR(239, 239, 239);
    self.tableView.rowHeight = 70.f;
    [self fetchNewsData];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.tableView.scrollsToTop = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.tableView.scrollsToTop = NO;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _newsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VTRecomCell *cell = nil;
    static NSString *cellID = @"cell.Identifier";
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[VTRecomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *imageName = [NSString stringWithFormat:@"image_%ld", indexPath.row%13];
    [cell.iconView setImage:[UIImage imageNamed:imageName]];
    cell.titleLabel.text = @"标题标题";
    cell.descLabel.text = @"景点描述景点描述景点描述景点描述景点描述";
    return cell;
}

#pragma mark - functional methods
- (void)fetchNewsData
{
    _newsList = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < 50; index++) {
        [_newsList addObject:[NSString stringWithFormat:@"新闻%ld", (long)index]];
    }
}

@end
