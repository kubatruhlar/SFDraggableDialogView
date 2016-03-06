//
//  SFDraggableDialogView.h
//
//  Created by Jakub Truhlar on 10.12.15.
//  Copyright © 2015 Jakub Truhlar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFDraggableDialogView;

@protocol SFDraggableDialogViewDelegate <NSObject>

@optional

/**
 *  The bottom first button was pressed.
 *
 *  @param dialogView  Dialog view within the button was pressed.
 *  @param closeButton Reference of the pressed button.
 */
- (void)draggableDialogView:(SFDraggableDialogView *)dialogView didPressFirstButton:(UIButton *)firstButton;

/**
 *  The bottom second button was pressed.
 *
 *  @param dialogView  Dialog view within the button was pressed.
 *  @param closeButton Reference of the pressed button.
 */
- (void)draggableDialogView:(SFDraggableDialogView *)dialogView didPressSecondButton:(UIButton *)secondButton;

/**
 *  Dialog view interactive dragging did begin.
 *
 *  @param dialogView Dialog view within the dialog did begin moving.
 */
- (void)draggingDidBegin:(SFDraggableDialogView *)dialogView;

/**
 *  Dialog view interactive dragging did end.
 *
 *  @param dialogView Dialog view within the dialog did end moving.
 */
- (void)draggingDidEnd:(SFDraggableDialogView *)dialogView;

/**
 *  Dialog view was dismissed by dragging out of the screen or by pressed close button.
 *
 *  @param dialogView Dialog view within the dialog was dismissed.
 */
- (void)draggableDialogViewDismissed:(SFDraggableDialogView *)dialogView;

/**
 *  Dialog view will be dismissed by dragging out of the screen or by pressed close button.
 *
 *  @param dialogView Dialog view within the dialog will be dismissed.
 */
- (void)draggableDialogViewWillDismiss:(SFDraggableDialogView *)dialogView;

@end

typedef NS_ENUM(NSInteger, SFContentViewType) {
    SFContentViewTypeDefault = 0,
    SFContentViewTypeCustom
};

@interface SFDraggableDialogView : UIView

/**
 *  Dialog is centered within the background superview. DEFAULT is (270.0, 350.0).
 */
@property (nonatomic, assign) CGSize size;

/**
 *  Dialog's corner radius. DEFAULT is 5.0.
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 *  Opacity (between 0.0 and 1.0) of the dialog's shadow. DEFAULT is 0.3
 */
@property (nonatomic, assign) CGFloat backgroundShadowOpacity;

/**
 *  Background color of the dialog. DEFAULT is White.
 */
@property (nonatomic, strong) UIColor *dialogBackgroundColor;

/**
 *  Background color of the first button. DEFAULT is a kind of green.
 *  MUST BE set, otherwise the button's highlight WILL NOT be working.
 */
@property (nonatomic, strong) UIColor *firstBtnBackgroundColor;

/**
 *  The first button's text color. DEFAULT is white.
 */
@property (nonatomic, strong) UIColor *firstBtnTextColor;

/**
 *  The first button's font. DEFAULT is Helvetica Neue 15.0 Bold.
 */
@property (nonatomic, strong) UIFont *firstBtnFont;

/**
 *  Background color of the second button. DEFAULT is a kind of green.
 *  MUST BE set, otherwise the button's highlight WILL NOT be working.
 */
@property (nonatomic, strong) UIColor *secondBtnBackgroundColor;

/**
 *  Second button's text color. DEFAULT is white.
 */
@property (nonatomic, strong) UIColor *secondBtnTextColor;

/**
 *  Second button's font. DEFAULT is Helvetica Neue 15.0 Bold.
 */
@property (nonatomic, strong) UIFont *secondBtnFont;

/**
 *  Image for the dismissal button.
 */
@property (nonatomic, strong) UIImage *closeBtnImage;

/**
 *  Image for the circular image view.
 */
@property (nonatomic, strong) UIImage *photo;

/**
 *  Title text. Title label is suppose to have one line.
 */
@property (nonatomic, strong) NSMutableAttributedString *titleText;

/**
 *  Message text. Message label is suppose to have two lines.
 */
@property (nonatomic, strong) NSMutableAttributedString *messageText;

/**
 *  Default button's text. DEFAULT is Accept.
 */
@property (nonatomic, strong) NSString *firstBtnText;

/**
 *  Second button's text. DEFAULT is Cancel.
 */
@property (nonatomic, strong) NSString *secondBtnText;

/**
 *  Text of the cancel arrow. Empty value will make it hidden and draggable dismissing will be disabled. DEFAULT is @"Cancel".
 */
@property (nonatomic, strong) NSMutableAttributedString *cancelArrowText;

/**
 *  The image of the cancel view. Default is arrow
 */
@property (nonatomic, strong) UIImage *cancelArrowImage;

/**
 *  The visible content view. Custom is blank, default has image and two labels. DEFAULT is Default.
 */
@property (nonatomic, assign) SFContentViewType contentViewType;

/**
 *  Should hide close button. DEFAULT is NO.
 */
@property (nonatomic, assign) bool hideCloseButton;

/**
 *  Should show the second button. DEFAULT is NO.
 */
@property (nonatomic, assign) bool showSecondBtn;

/**
 *  Dialog view is draggable. DEFAULT is YES.
 */
@property (nonatomic, assign, getter=isDraggable) bool draggable;

/**
 *  The custom content view of the contentViewTypeCustom type. Add any subview here.
 */
@property (weak, nonatomic) IBOutlet UIView *customView;

@property (nonatomic, assign) id<SFDraggableDialogViewDelegate> delegate;

/**
 *  Background image button view reference. Should be use only for a subview adding.
 */
@property (weak, nonatomic) IBOutlet UIButton *backgroundImageBtn;

/**
 *  Dismiss the dialog view.
 *
 *  @param drop Drop down movement
 */
- (void)dismissWithDrop:(bool)drop;

/**
 *  Dismiss the dialog view.
 *
 *  @param drop Drop down movement
 *  @param completion Completion block.
 */
- (void)dismissWithDrop:(bool)drop completion:(void (^)())completion;

/**
 *  Create the background image view that will be placed behind the dialog view.
 *
 *  @param backgroundImage      Blurred image.
 *  @param tintColor  Tint color of the blurred image view.
 *  @param blurRadius Blur radius of the blurred image view.
 */
- (void)createBlurBackgroundWithImage:(UIImage *)backgroundImage tintColor:(UIColor *)tintColor blurRadius:(CGFloat)blurRadius;

@end