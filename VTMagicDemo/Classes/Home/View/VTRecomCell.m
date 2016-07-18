//
//  VTRecomCell.m
//  VTMagicView
//
//  Created by tianzhuo on 5/27/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import "VTRecomCell.h"

@interface VTRecomCell()


@end

@implementation VTRecomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconView = [[UIImageView alloc] init];
        _iconView.translatesAutoresizingMaskIntoConstraints = NO;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.clipsToBounds = YES;
        [self.contentView addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        
        _descLabel = [[UILabel alloc] init];
        _descLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _descLabel.numberOfLines = 0;
        _descLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_descLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [self addContraints:@"H:|-15-[_iconView(100)]" forViews:NSDictionaryOfVariableBindings(_iconView)];
    [self addContraints:@"V:|-5-[_iconView]-5-|" forViews:NSDictionaryOfVariableBindings(_iconView)];
    
    [self addContraints:@"H:[_iconView]-10-[_titleLabel]-10-|" forViews:NSDictionaryOfVariableBindings(_iconView, _titleLabel)];
    NSString *titleContraints = [NSString stringWithFormat:@"V:|-5-[_titleLabel(%f)]", _titleLabel.font.lineHeight];
    [self addContraints:titleContraints forViews:NSDictionaryOfVariableBindings(_titleLabel)];
    
    [self addContraints:@"H:[_iconView]-10-[_descLabel]-10-|" forViews:NSDictionaryOfVariableBindings(_iconView, _descLabel)];
    [self addContraints:@"V:[_titleLabel]-5-[_descLabel]-5-|" forViews:NSDictionaryOfVariableBindings(_titleLabel, _descLabel)];
    
    [super updateConstraints];
}

- (void)addContraints:(NSString *)constraint forViews:(NSDictionary *)views {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:nil views:views]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
