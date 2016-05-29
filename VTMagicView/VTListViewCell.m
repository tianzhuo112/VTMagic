//
//  VTListViewCell.m
//  VTMagicView
//
//  Created by tianzhuo on 5/27/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import "VTListViewCell.h"

@interface VTListViewCell()



@end

@implementation VTListViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    [self addContraints:@"H:|-0-[_imageView]-0-|" forViews:NSDictionaryOfVariableBindings(_imageView)];
    [self addContraints:@"V:|-0-[_imageView(99)]" forViews:NSDictionaryOfVariableBindings(_imageView)];
    
    [self addContraints:@"H:|-0-[_titleLabel]-0-|" forViews:NSDictionaryOfVariableBindings(_titleLabel)];
    [self addContraints:@"V:[_imageView]-5-[_titleLabel(45)]" forViews:NSDictionaryOfVariableBindings(_imageView, _titleLabel)];
    
    [super updateConstraints];
}

- (void)addContraints:(NSString *)constraint forViews:(NSDictionary *)views
{
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:nil views:views]];
}

@end
