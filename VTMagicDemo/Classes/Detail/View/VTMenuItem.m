//
//  VTMenuItem.m
//  VTMagic
//
//  Created by tianzhuo on 7/8/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import "VTMenuItem.h"
#import <VTMagic/VTMagic.h>

@interface VTMenuItem()

@property (nonatomic, strong) UIView *dotView;

@end

@implementation VTMenuItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dotHidden = YES;
        _dotView = [[UIView alloc] init];
        _dotView.translatesAutoresizingMaskIntoConstraints = NO;
        _dotView.backgroundColor = [UIColor redColor];
        _dotView.layer.masksToBounds = YES;
        _dotView.layer.cornerRadius = 4.f;
        _dotView.hidden = _dotHidden;
        [self addSubview:_dotView];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_dotView(8)]-20-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_dotView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_dotView(8)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_dotView)]];
    
    [super updateConstraints];
}

- (void)vtm_prepareForReuse {
    VTLog(@"menuItem will be reused: %@", self);
}

#pragma mark - accessor methods
- (void)setDotHidden:(BOOL)dotHidden {
    _dotHidden = dotHidden;
    _dotView.hidden = dotHidden;
}

@end
