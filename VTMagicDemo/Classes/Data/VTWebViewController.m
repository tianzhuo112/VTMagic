//
//  VTWebViewController.m
//  VTMagic
//
//  Created by tianzhuo on 6/1/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import "VTWebViewController.h"
#import <VTMagic/VTMagic.h>
#import <WebKit/WebKit.h>

@interface VTWebViewController()<UIGestureRecognizerDelegate, UIWebViewDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@end

@implementation VTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.webView.scrollView.scrollsToTop = YES;
    VTPRINT_METHOD
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.webView.scrollView.scrollsToTop = NO;
    VTPRINT_METHOD
}

#pragma mark - VTMagicReuseProtocol
- (void)vtm_prepareForReuse {
    // reset content offset
    NSLog(@"clear old data if needed:%@", self);
    [self.webView.scrollView setContentOffset:CGPointZero];
}

#pragma mark - UIPanGestureRecognizer
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    // 如果内嵌webView时无法响应滑动手势，可以这样处理
//    [self.magicController.magicView handlePanGesture:recognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - accessors
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.frame];
        _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, VTTABBAR_HEIGHT, 0);
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_webView.scrollView addGestureRecognizer:self.panRecognizer];
        _webView.scrollView.alwaysBounceHorizontal = NO;
        _webView.scrollView.scrollsToTop = NO;
        _webView.layer.masksToBounds = YES;
    }
    return _webView;
}

- (UIPanGestureRecognizer *)panRecognizer {
    if (!_panRecognizer) {
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        _panRecognizer.cancelsTouchesInView = YES;
        _panRecognizer.delegate = self;
    }
    return _panRecognizer;
}

@end
