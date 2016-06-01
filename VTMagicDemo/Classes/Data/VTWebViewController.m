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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - UIPanGestureRecognizer
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    // 如果内嵌webView时无法响应滑动手势，可以这样处理
//    [self.magicController.magicView handlePanGesture:recognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - accessors
- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.frame];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_webView.scrollView addGestureRecognizer:self.panRecognizer];
        _webView.scrollView.alwaysBounceHorizontal = NO;
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.scrollsToTop = NO;
        _webView.layer.masksToBounds = YES;
        _webView.layer.cornerRadius = 5.f;
    }
    return _webView;
}

- (UIPanGestureRecognizer *)panRecognizer
{
    if (!_panRecognizer) {
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        _panRecognizer.cancelsTouchesInView = YES;
        _panRecognizer.delegate = self;
    }
    return _panRecognizer;
}

@end
