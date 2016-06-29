#Change Log
All notable changes to this project will be documented in this file.

--- 

## [1.2.2](https://github.com/tianzhuo112/VTMagic/releases/tag/1.2.2) (06/29/2016)
Released on Wednesday, June 29, 2016.

### changed
- Add new method reloadDataToPage:, support reload data and switch to specified page at the same time.
- Optimize appearance logic, fix bug that multiple calls appearance methods(viewWillAppear,etc), optimize multiple nesting.
- Modify protocol VTMagicViewDelegate, modify method viewDidAppeare: to viewDidAppear:, modify method viewDidDisappeare: to viewDidDisappear:.


## [1.2.1](https://github.com/tianzhuo112/VTMagic/releases/tag/1.2.1) (06/19/2016)
Released on Sunday, June 19, 2016.

### changed
- Add property `itemScale`, if you change it, menuItem will have zoom effect when switching.
- Optimize menu bar.

## [1.2.0](https://github.com/tianzhuo112/VTMagic/releases/tag/1.2.0) (06/13/2016)
Released on Monday, June 13, 2016.

### changed
- Add property `sliderExtension`.
- Optimize layout.


## [1.1.0](https://github.com/tianzhuo112/VTMagic/releases/tag/1.1.0) (06/04/2016)
Released on Sunday, June 4, 2016.

### changed
- Add property `sliderStyle`，you can show a bubble in menu bar by setting `sliderStyle` to `VTSliderStyleBubble`.
- Add **Center** in demo project.

## [1.0.2](https://github.com/tianzhuo112/VTMagic/releases/tag/1.0.2) (06/02/2016)
Released on Thursday, June 2, 2016.

### changed
- Add new layout style `VTLayoutStyleCenter`.
- Improved the demo project, add modules **Center**、**Divide** and **Data**.


## [1.0.1](https://github.com/tianzhuo112/VTMagic/releases/tag/1.0.1) (06/01/2016)
Released on Wednesday, June 1, 2016.

### changed
- Adjust the file directory.


## [1.0.0](https://github.com/tianzhuo112/VTMagic/releases/tag/1.0.0) (05/31/2016)
The initial version is released on Tuesday, May 31, 2016.

### Features
- You can custom every page controller by different identifier if you need, each one is independent.
- VTMagic will automatically calls the appearance methods when user switches the page, it is convenient for you to manage the data, or do some other things.
- Menu bar supports multiple layout style, you can change it by `layoutStyle`.
- You can also custom `menuItem` if you need, it can display text and image.
- You can get the nearest magicController in any child view controller which is conforms to `<VTMagicProtocol>`, after you import file `VTMagic.h`.
- You can embed webview in any page, if the page can't scroll, you should call method handlePanGesture: to fix it(please refer to **Data** module).
- The page is reusable and support auto rotate.
- For more information please read file `VTMagicView.h`.


