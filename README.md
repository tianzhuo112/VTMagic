# VTMagic
VTMagic is page controller manager, it's easy to use.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Installation

VTMagic is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "VTMagic"
```

### Integrate

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
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.sliderColor = [UIColor redColor];
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.navigationHeight = 40.f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}
```

### Protocals

You must conforms to `<VTMagicViewDataSource>`, `<VTMagicViewDelegate>` and `<VTMagicReuseProtocal>` are optional.

####  VTMagicViewDataSource

```objective-c
-(NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
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
    static NSString *gridId = @"grid.identifier";
    GridViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[GridViewController alloc] init];
    }
    return viewController;
}
```

#### VTMagicViewDelegate

```objective-c
- (void)magicView:(VTMagicView *)magicView viewDidAppeare:(UIViewController *)viewController atPage:(NSUInteger)pageIndex
{
    NSLog(@"index:%ld viewDidAppeare:%@",pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappeare:(UIViewController *)viewController atPage:(NSUInteger)pageIndex
{
    NSLog(@"index:%ld viewDidDisappeare:%@",pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex
{
    NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}
```

#### VTMagicReuseProtocal

```objective-c
- (void)vtm_prepareForReuse
{
    NSLog(@"clear old data if needed:%@", self);
}
```

## Features

#### Switch to specified page

```objective-c
[self.magicController.magicView switchToPage:3 animated:YES];
```

#### Obtain specified view controller

```objective-c
UIViewController *viewController = [self.magicController.magicView viewControllerAtPage:3];
```

#### Obtain magicController

You can obtain magicController in any child view controller, after you import file `VTMagic.h`.
```objective-c
NSInteger currentPage = [self.magicController currentPage];
UIViewController *viewController = self.magicController.currentViewController;
```

## License

VTMagic is released under the MIT license. See LICENSE for details.
