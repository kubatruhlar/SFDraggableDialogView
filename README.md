[![Version](https://img.shields.io/cocoapods/v/SFDraggableDialogView.svg)](http://cocoapods.org/pods/SFDraggableDialogView)
[![License](https://img.shields.io/cocoapods/l/SFDraggableDialogView.svg)](http://cocoapods.org/pods/SFDraggableDialogView)
[![Platform](https://img.shields.io/cocoapods/p/SFDraggableDialogView.svg)](http://cocoapods.org/pods/SFDraggableDialogView)

# SFDraggableDialogView
Display the beautiful dialog view with **realistic physics behavior** (thanks to UIkit Dynamics) with **drag to dismiss** feature.

<h3 align="center">
  <img src="https://github.com/kubatru/SFDraggableDialogView/blob/master/Screens/example.gif" alt="Example" height="400"/>
</h3>

## Installation
There are two ways to add the **SFDraggableDialogView** library to your project. Add it as a regular library or install it through **CocoaPods**.

`pod 'SFDraggableDialogView'`

You may also quick try the example project with

`pod try SFDraggableDialogView`

**Library requires target iOS 8 and above**

## Usage
```objective-c
    SFDraggableDialogView *dialogView = [[[NSBundle mainBundle] loadNibNamed:@"SFDraggableDialogView" owner:self options:nil] firstObject];
    dialogView.frame = self.view.bounds;
    dialogView.delegate = self;
    dialogView.photo = [UIImage imageNamed:@""];
    dialogView.titleText = [[AttributedString alloc] initWithString:@"Round is over"];
    dialogView.messageText = [[NSMutableAttributedString alloc] initWithString:@"You have won"];
    dialogView.firstBtnText = [@"See results" uppercaseString];
    dialogView.cancelViewPosition = SFCancelViewPositionBottom;
    dialogView.hideCloseButton = true;
    
    [self.view addSubview:dialogView];
```

### SFDraggableDialogViewDelegate
```objective-c
- (void)draggableDialogView:(SFDraggableDialogView *)dialogView didPressFirstButton:(UIButton *)firstButton;
- (void)draggableDialogView:(SFDraggableDialogView *)dialogView didPressSecondButton:(UIButton *)secondButton;
- (void)draggingDidBegin:(SFDraggableDialogView *)dialogView;
- (void)draggingDidEnd:(SFDraggableDialogView *)dialogView;
- (void)draggableDialogViewDismissed:(SFDraggableDialogView *)dialogView;
```

### Custom content view
There is `SFContentViewType` property that takes two values - Default and Custom. Default view has two labels and image from example. Use custom view for as a container for your subviews accessible through `customView` property.

There is also `showSecondBtn` property.

## Author
This library is open-sourced by [Jakub Truhlar](http://kubatruhlar.cz).
    
## License
The MIT License (MIT)
Copyright © 2015 Jakub Truhlar
