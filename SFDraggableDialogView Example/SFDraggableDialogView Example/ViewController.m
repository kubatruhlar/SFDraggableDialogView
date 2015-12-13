//
//  ViewController.m
//  SFDraggableDialogView Example
//
//  Created by Jakub Truhlar on 10.12.15.
//  Copyright © 2015 Jakub Truhlar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)showBtnPressed:(id)sender {
    SFDraggableDialogView *dialogView = [[[NSBundle mainBundle] loadNibNamed:@"SFDraggableDialogView" owner:self options:nil] firstObject];
    dialogView.frame = self.view.bounds;
    dialogView.photo = [UIImage imageNamed:@"face"];
    dialogView.delegate = self;
    dialogView.titleText = [[NSMutableAttributedString alloc] initWithString:@"Round is over"];
    dialogView.messageText = [self exampleAttributeString];
    dialogView.defaultBtnText = [@"See results" uppercaseString];
    dialogView.cancelViewPosition = SFCancelViewPositionBottom;
    dialogView.hideCloseButton = true;
    
    [self.view addSubview:dialogView];
}

- (NSMutableAttributedString *)exampleAttributeString {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"You have won"];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:21.0] range:NSMakeRange(9, 3)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.230 green:0.777 blue:0.316 alpha:1.000] range:NSMakeRange(9, 3)];
    return attributedString;
}

#pragma mark - SFDraggableDialogViewDelegate
- (void)draggableDialogView:(SFDraggableDialogView *)dialogView didPressDefaultButton:(UIButton *)defaultButton {
    NSLog(@"Default button pressed");
}

- (void)draggingDidBegin:(SFDraggableDialogView *)dialogView {
    NSLog(@"Dragging has begun");
}

- (void)draggingDidEnd:(SFDraggableDialogView *)dialogView {
    NSLog(@"Dragging did end");
}

- (void)draggableDialogViewDismissed:(SFDraggableDialogView *)dialogView {
    NSLog(@"Dismissed");
}

@end
