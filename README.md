# VTMagic

VTMagic is a page container library, you can custom every page controller by different identifier if you need. It's so easy to use!（[中文手册传送门](http://www.jianshu.com/p/cb2edb21055f)）

## Usage

To run the example project, clone the repo, and run `pod install` from the project directory first.

### Installation

VTMagic is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "VTMagic"
```

### Integration

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    [_magicController didMoveToParentViewController:self];

    [_magicController.magicView reloadData];
}

- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = [UIColor redColor];
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.navigationHeight = 40.f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}
```
or like this
```objective-c
#import "VTMagicController.h"

@interface ViewController : VTMagicController

@end
```

```objective-c
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.sliderColor = [UIColor redColor];
    self.magicView.layoutStyle = VTLayoutStyleDefault;
    self.magicView.switchStyle = VTSwitchStyleDefault;
    self.magicView.navigationHeight = 40.f;
    self.magicView.dataSource = self;
    self.magicView.delegate = self;
    
    [self.magicView reloadData];
}
```

### Protocals

You must conform to `<VTMagicViewDataSource>`. `<VTMagicViewDelegate>` and `<VTMagicReuseProtocol>` are optional.

####  VTMagicViewDataSource

```objective-c
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return _menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    if (0 == pageIndex) {
        static NSString *recomId = @"recom.identifier";
        VTRecomViewController *recomViewController = [magicView dequeueReusablePageWithIdentifier:recomId];
        if (!recomViewController) {
            recomViewController = [[VTRecomViewController alloc] init];
        }
        return recomViewController;
    }

    static NSString *gridId = @"grid.identifier";
    VTGridViewController *gridViewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!gridViewController) {
        gridViewController = [[VTGridViewController alloc] init];
    }
    return gridViewController;
}
```

#### VTMagicViewDelegate

```objective-c
- (void)magicView:(VTMagicView *)magicView viewDidAppeare:(UIViewController *)viewController atPage:(NSUInteger)pageIndex
{
    NSLog(@"pageIndex:%ld viewDidAppeare:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappeare:(UIViewController *)viewController atPage:(NSUInteger)pageIndex
{
    NSLog(@"pageIndex:%ld viewDidDisappeare:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex
{
    NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}
```

#### VTMagicReuseProtocol

```objective-c
- (void)vtm_prepareForReuse
{
    NSLog(@"clear old data if needed:%@", self);
}
```

## Features

#### Appearance methods

VTMagic will automatically calls appearance methods when user switches the page, you should do something in here, e.g. refresh page info.

```objective-c
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // do something...
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // do something...
}

```

#### Obtain magicController

You can obtain the nearest magicController in any child view controller which is conforms to `<VTMagicProtocol>`, after you import file `VTMagic.h`.
```objective-c
NSInteger currentPage = [self.magicController currentPage];
UIViewController *viewController = self.magicController.currentViewController;
```

#### Switch to specified page

```objective-c
[self.magicView switchToPage:3 animated:YES];
```
or like this
```objective-c
[self.magicController switchToPage:3 animated:YES];
```
#### Obtain specified view controller

```objective-c
UIViewController *viewController = [self.magicView viewControllerAtPage:3];
```
or like this
```objective-c
UIViewController *viewController = [self.magicController viewControllerAtPage:3];
```

## License

VTMagic is released under the MIT license. See LICENSE for details.
