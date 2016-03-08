[![Version](https://img.shields.io/cocoapods/v/SFDraggableDialogView.svg)](http://cocoapods.org/pods/SFDraggableDialogView)
[![License](https://img.shields.io/cocoapods/l/SFDraggableDialogView.svg)](http://cocoapods.org/pods/SFDraggableDialogView)
[![Platform](https://img.shields.io/cocoapods/p/SFDraggableDialogView.svg)](http://cocoapods.org/pods/SFDraggableDialogView)

# SFDraggableDialogView
Display the beautiful dialog view with **realistic physics behavior** (thanks to UIkit Dynamics) with **drag to dismiss** feature.

<h3 align="center">
  <img src="https://github.com/kubatru/SFDraggableDialogView/blob/master/Screens/example.gif" alt="Example" height="400"/>
</h3>

## Installation
**Since pod version 1.1.4 the pod is not broken anymore! Assets and xib are generated.**

There are two ways to add the **SFDraggableDialogView** library to your project. Add it as a regular library or install it through **CocoaPods**.

`pod 'SFDraggableDialogView'`

You may also quick try the example project with

`pod try SFDraggableDialogView`

**Library requires target iOS 8 and above**

## Usage *(Mind that some parts of the example code could be from my other libraries etc.)*
```objective-c
    SFDraggableDialogView *dialogView = [[[NSBundle mainBundle] loadNibNamed:@"SFDraggableDialogView" owner:self options:nil] firstObject];
    dialogView.frame = self.view.bounds;
    dialogView.photo = [UIImage imageNamed:@"face"];
    dialogView.delegate = self;
    dialogView.titleText = [[NSMutableAttributedString alloc] initWithString:@"Round is over"];
    dialogView.messageText = [self exampleAttributeString];
    dialogView.firstBtnText = [@"See results" uppercaseString];
    dialogView.dialogBackgroundColor = [UIColor whiteColor];
    dialogView.cornerRadius = 8.0;
    dialogView.backgroundShadowOpacity = 0.2;
    dialogView.hideCloseButton = true;
    dialogView.showSecondBtn = false;
    dialogView.contentViewType = SFContentViewTypeDefault;
    dialogView.firstBtnBackgroundColor = [UIColor colorWithRed:0.230 green:0.777 blue:0.316 alpha:1.000];
    [dialogView createBlurBackgroundWithImage:[self jt_imageWithView:self.view] tintColor:[[UIColor blackColor] colorWithAlphaComponent:0.35] blurRadius:60.0];
    
    [self.view addSubview:dialogView];
```

### SFDraggableDialogViewDelegate
```objective-c
- (void)draggableDialogView:(SFDraggableDialogView *)dialogView didPressFirstButton:(UIButton *)firstButton;
- (void)draggableDialogView:(SFDraggableDialogView *)dialogView didPressSecondButton:(UIButton *)secondButton;
- (void)draggingDidBegin:(SFDraggableDialogView *)dialogView;
- (void)draggingDidEnd:(SFDraggableDialogView *)dialogView;
- (void)draggableDialogViewWillDismiss:(SFDraggableDialogView *)dialogView;
- (void)draggableDialogViewDismissed:(SFDraggableDialogView *)dialogView;
```

### Custom content view
There is `SFContentViewType` property that takes two values - Default and Custom. Default view has two labels and image from example. Use custom view for as a container for your subviews accessible through `customView` property.

There is also `showSecondBtn` property.

Library uses Apple’s category for UIImage blur located in resources.

## Author
This library is open-sourced by [Jakub Truhlar](http://kubatruhlar.cz).
    
## License
The MIT License (MIT)
Copyright © 2015 Jakub Truhlar
