//
//  SFDraggableDialogView.m
//
//  Created by Jakub Truhlar on 10.12.15.
//  Copyright © 2015 Jakub Truhlar. All rights reserved.
//

#import "SFDraggableDialogView.h"

typedef NS_ENUM(NSInteger, SFPanDirection) {
    SFPanDirectionTop = 0,
    SFPanDirectionBottom,
    SFPanDirectionOthers
};

@interface SFDraggableDialogView()

@property (weak, nonatomic) IBOutlet UIView *dialogView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *cancelViewTop;
@property (weak, nonatomic) IBOutlet UIView *cancelViewBottom;
@property (weak, nonatomic) IBOutlet UIView *blurViewContainer;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView;

// Content
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *cancelArrowLblTop;
@property (weak, nonatomic) IBOutlet UILabel *cancelArrowLblBottom;
@property (weak, nonatomic) IBOutlet UIImageView *cancelArrowImageViewTop;
@property (weak, nonatomic) IBOutlet UIImageView *cancelArrowImageViewBottom;

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

// UIDynamics
@property (nonatomic, strong) UIGestureRecognizer *gestureRecognizer;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, assign) SFPanDirection *panDirection;

// Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dialogViewHeightCns;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dialogViewWidthCns;

// Default button highlight handle
- (IBAction)defaultBtnTouchDownEvent:(id)sender;

@end

@implementation SFDraggableDialogView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Gesture recognizer for dragging
    [self addGestureRecognizer];
    
    // Create engine
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    // Default initialization
    [self defaultSetup];
    
    // Pop animation
    [self pop];
    
    // Blur
    [self showBlurView:true];
    
    // Cancel arror
    [self showCancelArrow:true];
}

- (void)defaultSetup {
    self.cornerRadius = 5.0;
    self.dialogBackgroundColor = [UIColor whiteColor];
    self.draggable = true;
    self.backgroundShadow = true;
    self.hideCloseButton = false;
    self.cancelArrowText = [[NSMutableAttributedString alloc] initWithString:@"Cancel"];
    self.defaultBtnText = [@"Accept" uppercaseString];
    self.defaultBtnTextColor = [UIColor whiteColor];
    self.cancelViewPosition = SFCancelViewPositionBottom;
    self.size = CGSizeMake(270.0, 350.0);
}

- (void)dealloc {
    [self.dialogView removeGestureRecognizer:self.gestureRecognizer];
}

- (void)showCancelArrow:(bool)show {
    if (show) {
        [UIView animateWithDuration:0.2 animations:^{
            [self cancelViewAlpha:1.0];
        }];
        
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            [self cancelViewAlpha:0.0];
        }];
    }
}

- (void)cancelViewAlpha:(CGFloat)alpha {
    if (_cancelViewPosition == SFCancelViewPositionTop) {
        _cancelViewTop.alpha = alpha;
        
    } else {
        _cancelViewBottom.alpha = alpha;
    }
}

- (void)dismissWithFadeOut:(bool)fadeOut {
    if (fadeOut) {
        [UIView animateWithDuration:0.1 animations:^{
            self.shadowView.transform = CGAffineTransformMakeScale(0.9, 0.9);
            self.shadowView.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            [self dismiss];
            
            if ([self.delegate respondsToSelector:@selector(draggableDialogViewDismissed:)]) {
                [self.delegate draggableDialogViewDismissed:self];
            }
        }];
        
    } else {
        [self dismiss];
        
        if ([self.delegate respondsToSelector:@selector(draggableDialogViewDismissed:)]) {
            [self.delegate draggableDialogViewDismissed:self];
        }
    }
    
    [self showBlurView:false];
}

- (void)dismiss {
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showBlurView:(bool)show {
    if (show) {
        [UIView animateWithDuration:0.2 animations:^{
            self.blurViewContainer.alpha = 1.0;
        }];
        
    } else {
        [UIView animateWithDuration:0.4 animations:^{
        self.blurViewContainer.alpha = 0.0;
    }];
    }
}

- (void)highlightDefaultBtn:(bool)highlight {
    if (highlight) {
        [UIView animateWithDuration:0.1 animations:^{
            self.defaultBtn.alpha = 0.85;
        }];
        
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            self.defaultBtn.alpha = 1.0;
        }];
    }
}

#pragma mark - Gesture recognizer and UIDynamics
- (void)addGestureRecognizer {
    self.gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.shadowView addGestureRecognizer:self.gestureRecognizer];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    if (!_draggable) {
        return;
    }
    
    [self highlightDefaultBtn:false];
    
    static UIAttachmentBehavior *attachment;
    static CGPoint startCenter;
    
    // Variables for calculating angular velocity
    static CFAbsoluteTime lastTime;
    static CGFloat lastAngle;
    static CGFloat angularVelocity;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        if ([self.delegate respondsToSelector:@selector(draggingDidBegin:)]) {
            [self.delegate draggingDidBegin:self];
        }
        
        [self showCancelArrow:false];
        
        // UIDynamics handle
        [self.animator removeAllBehaviors];
        
        startCenter = gesture.view.center;
        
        // Calculate the center offset and anchor point
        CGPoint pointWithinAnimatedView = [gesture locationInView:gesture.view];
        UIOffset offset = UIOffsetMake(pointWithinAnimatedView.x - gesture.view.bounds.size.width / 2.0, pointWithinAnimatedView.y - gesture.view.bounds.size.height / 2.0);
        CGPoint anchor = [gesture locationInView:gesture.view.superview];
        
        // Create attachment behavior
        attachment = [[UIAttachmentBehavior alloc] initWithItem:gesture.view offsetFromCenter:offset attachedToAnchor:anchor];
        
        // Code to calculate angular velocity
        lastTime = CFAbsoluteTimeGetCurrent();
        lastAngle = [self angleOfView:gesture.view];
        typeof(self) __weak weakSelf = self;
        
        attachment.action = ^{
            CFAbsoluteTime time = CFAbsoluteTimeGetCurrent();
            CGFloat angle = [weakSelf angleOfView:gesture.view];
            if (time > lastTime) {
                angularVelocity = (angle - lastAngle) / (time - lastTime);
                lastTime = time;
                lastAngle = angle;
            }
        };
        
        // Add attachment behavior
        [self.animator addBehavior:attachment];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        // As user makes gesture, update attachment behavior's anchor point, achieving drag and rotate
        CGPoint anchor = [gesture locationInView:gesture.view.superview];
        attachment.anchorPoint = anchor;
        
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        
        if ([self.delegate respondsToSelector:@selector(draggingDidEnd:)]) {
            [self.delegate draggingDidEnd:self];
        }
        
        // UIDynamics handle
        [self.animator removeAllBehaviors];
        
        CGPoint velocity = [gesture velocityInView:gesture.view.superview];
        
        // If we aren't dragging it allowed way, just snap it back and quit
        if (!_cancelArrowText || _cancelArrowText.length == 0) {
            [self showCancelArrow:true];
            UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:gesture.view snapToPoint:startCenter];
            [self.animator addBehavior:snap];
            return;
            
        }
        
        if (_cancelViewPosition == SFCancelViewPositionBottom) {
            if ([self calculateDirectionFromVelocity:velocity] != SFPanDirectionBottom) {
                [self showCancelArrow:true];
                UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:gesture.view snapToPoint:startCenter];
                [self.animator addBehavior:snap];
                return;
            }
            
        } else if (_cancelViewPosition == SFCancelViewPositionTop) {
            if ([self calculateDirectionFromVelocity:velocity] != SFPanDirectionTop) {
                [self showCancelArrow:true];
                UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:gesture.view snapToPoint:startCenter];
                [self.animator addBehavior:snap];
                return;
            }
        }
        
        // Start dismissing
        self.shadowView.userInteractionEnabled = false;
        [self dismissWithFadeOut:false];
        
        // Otherwise, create UIDynamicItemBehavior that carries on animation from where the gesture left off (notably linear and angular velocity)
        UIDynamicItemBehavior *dynamic = [[UIDynamicItemBehavior alloc] initWithItems:@[gesture.view]];
        [dynamic addLinearVelocity:velocity forItem:gesture.view];
        [dynamic addAngularVelocity:angularVelocity forItem:gesture.view];
        [dynamic setAngularResistance:1.25];
        
        // When the view no longer intersects with its superview, go ahead and remove it
        typeof(self) __weak weakSelf = self;
        
        dynamic.action = ^{
            if (!CGRectIntersectsRect(gesture.view.superview.bounds, gesture.view.frame)) {
                [weakSelf.animator removeAllBehaviors];
                [gesture.view removeFromSuperview];
            }
        };
        [self.animator addBehavior:dynamic];
        
        // Add a little gravity so it accelerates off the screen (in case user gesture was slow)
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[gesture.view]];
        gravity.magnitude = 1.0;
        [self.animator addBehavior:gravity];
    }
}

- (CGFloat)angleOfView:(UIView *)view {
    return atan2(view.transform.b, view.transform.a);
}

- (SFPanDirection)calculateDirectionFromVelocity:(CGPoint)velocity {
    CGFloat arctangent = atan2(velocity.y, velocity.x) - M_PI_2;
    CGFloat absoluteValue = fabs(arctangent);
    
    if (absoluteValue <= M_PI_4) {
        return SFPanDirectionBottom;
        
    } else if (absoluteValue <= (M_PI + M_PI_4) && absoluteValue > (M_PI_2 + M_PI_4)) {
        return SFPanDirectionTop;
        
    } else {
        return SFPanDirectionOthers;
    }
}

#pragma mark - Pop animation
- (void)popAnimationForView:(UIView *)view withDuration:(CGFloat)duration {
    [UIView animateWithDuration:duration * 0.5 animations:^{
        view.transform = CGAffineTransformMakeScale(1.05, 1.05);
    }];
    [UIView animateWithDuration:duration * 0.35 delay:duration * 0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        view.transform = CGAffineTransformMakeScale(0.98, 0.98);
    } completion:nil];
    [UIView animateWithDuration:duration * 0.15 delay:duration * 0.85 options:UIViewAnimationOptionCurveLinear animations:^{
        view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
    [UIView animateWithDuration:duration animations:^{
        view.alpha = 1.0;
    }];
}

- (void)pop {
    [UIView animateWithDuration:0.2 animations:^{
        [self popAnimationForView:self.shadowView withDuration:0.2];
    } completion:nil];
}

#pragma mark - Setters
- (void)setSize:(CGSize)size {
    _size = size;
    self.dialogViewWidthCns.constant = size.width;
    self.dialogViewHeightCns.constant = size.height;
}

- (void)setCloseBtnImage:(UIImage *)closeBtnImage {
    _closeBtnImage = closeBtnImage;
    [_closeBtn setImage:closeBtnImage forState:UIControlStateNormal];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.dialogView.layer.cornerRadius = _cornerRadius;
    self.dialogView.layer.masksToBounds = true;
}

- (void)setDialogBackgroundColor:(UIColor *)dialogBackgroundColor {
    _dialogBackgroundColor = dialogBackgroundColor;
    self.dialogView.backgroundColor = dialogBackgroundColor;
}

- (void)setPhoto:(UIImage *)photo {
    _photo = photo;
    self.photoImageView.image = photo;
    self.photoImageView.layer.cornerRadius = self.photoImageView.frame.size.width / 2.0;
    self.photoImageView.layer.masksToBounds = true;
}

- (void)setTitleText:(NSMutableAttributedString *)titleText {
    _titleText = titleText;
    _titleLbl.attributedText = titleText;
}

- (void)setMessageText:(NSMutableAttributedString *)messageText {
    _messageText = messageText;
    _messageLbl.attributedText = messageText;
}

- (void)setHideCloseButton:(bool)hideCloseButton {
    _hideCloseButton = hideCloseButton;
    self.closeBtn.hidden = hideCloseButton;
}

- (void)setBackgroundShadow:(bool)backgroundShadow {
    _backgroundShadow = backgroundShadow;
    
    self.shadowView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.shadowView.layer.shadowOpacity = 0.2;
    self.shadowView.layer.shadowRadius = 10.0;
    self.shadowView.layer.shadowOffset = CGSizeZero;
    self.shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.dialogView.bounds cornerRadius:_cornerRadius].CGPath;
    self.shadowView.layer.shouldRasterize = true;
    self.shadowView.layer.rasterizationScale = [UIScreen mainScreen].scale;

    if (!backgroundShadow) {
        self.shadowView.layer.shadowOpacity = 0.0;
    }
}

- (void)setDefaultBtnText:(NSString *)defaultBtnText {
    _defaultBtnText = defaultBtnText;
    [self.defaultBtn setTitle:_defaultBtnText forState:UIControlStateNormal];
}

- (void)setDefaultBtnTextColor:(UIColor *)defaultBtnTextColor {
    _defaultBtnTextColor = defaultBtnTextColor;
    [self.defaultBtn setTitleColor:_defaultBtnTextColor forState:UIControlStateNormal];
}

- (void)setDefaultBtnFont:(UIFont *)defaultBtnFont {
    _defaultBtnFont = defaultBtnFont;
    self.defaultBtn.titleLabel.font = _defaultBtnFont;
}

- (void)setDefaultBtnBackgroundColor:(UIColor *)defaultBtnBackgroundColor {
    _defaultBtnBackgroundColor = defaultBtnBackgroundColor;
    self.defaultBtn.backgroundColor = _defaultBtnBackgroundColor;
}

- (void)setCancelViewPosition:(SFCancelViewPosition)cancelViewPosition {
    _cancelViewPosition = cancelViewPosition;
    
    if (!_cancelArrowText) {
        _cancelViewBottom.hidden = true;
        _cancelViewTop.hidden = true;
        return;
    }
    
    if (_cancelViewPosition == SFCancelViewPositionTop) {
        _cancelViewBottom.hidden = true;
        _cancelViewTop.hidden = false;
        
    } else {
        _cancelViewTop.hidden = true;
        _cancelViewBottom.hidden = false;
    }
}

- (void)setCancelArrowText:(NSMutableAttributedString *)cancelArrowText {
    _cancelArrowText = cancelArrowText;
    
    if (!cancelArrowText || cancelArrowText.length == 0) {
        _cancelViewBottom.hidden = true;
        _cancelViewTop.hidden = true;
        
    } else {
        _cancelViewBottom.hidden = false;
        _cancelViewTop.hidden = false;
        [self cancelViewAlpha:1.0];
        _cancelArrowLblBottom.attributedText = cancelArrowText;
        _cancelArrowLblTop.attributedText = cancelArrowText;
    }
}

- (void)setCancelArrowImage:(UIImage *)cancelArrowImage {
    _cancelArrowImage = cancelArrowImage;
    _cancelArrowImageViewBottom.image = _cancelArrowImage;
    _cancelArrowImageViewTop.image = _cancelArrowImage;
}

- (void)setBlurViewTintColor:(UIColor *)blurViewTintColor {
    _blurViewTintColor = blurViewTintColor;
    _blurView.contentView.backgroundColor = [blurViewTintColor colorWithAlphaComponent:0.5];
}

#pragma mark - Actions
- (IBAction)defaultBtnPressed:(id)sender {
    [self highlightDefaultBtn:false];
    if ([self.delegate respondsToSelector:@selector(draggableDialogView:didPressDefaultButton:)]) {
        [self.delegate draggableDialogView:self didPressDefaultButton:self.defaultBtn];
    }
}

- (IBAction)closeBtnPressed:(id)sender {
    [self showCancelArrow:false];
    [self dismissWithFadeOut:true];
}

- (IBAction)defaultBtnTouchDownEvent:(id)sender {
    [self highlightDefaultBtn:true];
}

@end