//
//  SLHelpOverlayViewController.m
//
//  Created by Scott Larson on 3/5/14.

#import "SLHelpOverlayViewController.h"

static CGFloat const kDefaultArrowLength            = 20.0f;
static CGFloat const kDefaultArrowWidth             = 15.0f;
static CGFloat const kDefaultArrowViewInset         = 8.0f;
static CGFloat const kDefaultArrowDistanceFromEdge  = 20.0f;

static CGFloat const kDefaultBubblePadding  = 8.0f;
static CGFloat const kDefaultBorderWidth    = 3.5f;
static CGFloat const kDefaultMaxLabelWidth  = 150.0f;

static CGFloat const kIpadAnimationFrameOffset      = 150.0f;
static CGFloat const kIphoneAnimationFrameOffset    = 75.0f;
static CGFloat const kAnimationSlideDelay           = 0.15f;
static CGFloat const kAnimationFadeDuration         = 0.5f;

static UIColor *kDefaultBorderColor;
static UIColor *kDefaultBubbleColor;
static UIColor *kDefaultLabelTextColor;
static UIFont *kDefaultLabelFont;

@interface SLHelpOverlayViewController()

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIButton *closeButton;
@property (weak, nonatomic) UIWindow *appWindow;

- (void)closeOverlayTapped;
- (void)applySettingsToItem:(SLHelpOverlayItem *)overlayItem;
- (void)setRectForCurrentOrientation;

@end

@implementation SLHelpOverlayViewController

+ (void)initialize
{
    kDefaultBorderColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:1.0f];
    kDefaultBubbleColor = [UIColor darkGrayColor];
    kDefaultLabelTextColor = [UIColor whiteColor];
    kDefaultLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

+ (SLHelpOverlayViewController *)overlayWithTitle:(NSString *)title
{
    return [[SLHelpOverlayViewController alloc] initWithTitle:title];
}

- (SLHelpOverlayViewController *)init
{
    return [self initWithTitle:nil];
}

- (SLHelpOverlayViewController *)initWithTitle:(NSString *)title
{
    if (self = [super init]) {
        if (title) {
            self.overlayTitle = title;
        }
        
        // Set these value to the default initially so that the value can be later set to 0
        self.arrowViewInset = kDefaultArrowViewInset;
        self.borderWidth = kDefaultBorderWidth;
        self.bubblePadding = kDefaultBubblePadding;
        
        self.appWindow = [[UIApplication sharedApplication] keyWindow];
        self.view = [[UIView alloc] initWithFrame:CGRectZero];
        [self setRectForCurrentOrientation];
        
        self.view.backgroundColor = [UIColor clearColor];
        self.slideAnimationEnabled = YES;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView.backgroundColor = [UIColor blackColor];
        self.backgroundView.alpha = 0.5f;
        [self.view addSubview:self.backgroundView];
        
        CGRect buttonFrame = self.view.bounds;
        UIButton *closeOverlayButton = [[UIButton alloc] initWithFrame:buttonFrame];
        [closeOverlayButton setImage:nil forState:UIControlStateNormal];
        [closeOverlayButton addTarget:self action:@selector(closeOverlayTapped) forControlEvents:UIControlEventTouchUpInside];
        self.closeButton = closeOverlayButton;
        
        self.view.accessibilityLabel = @"Help Overlay";
    }
    
    return self;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - Helper Methods

- (void)addItemToOverlayWithText:(NSString *)itemText
                  arrowDirection:(HelpOverlayArrowDirection)arrowDirection
                   viewToPointAt:(UIView *)viewToPointAt;
{
    SLHelpOverlayItem *overlayItem = [SLHelpOverlayItem helpOverlayItemWithItemText:itemText
                                                                     arrowDirection:arrowDirection
                                                                      viewToPointAt:viewToPointAt];
    
    // Apply global settings or defaults to the item
    [self applySettingsToItem:overlayItem];
    
    if (!self.items) {
        self.items = [NSMutableArray arrayWithObject:overlayItem];
    } else {
        [self.items addObject:overlayItem];
    }
}

- (void)displayOverlay
{
    if ((self.delegate && [self.delegate shouldDisplayHelpOverlay:self]) || !self.delegate) {
        [self.delegate willDisplayHelpOverlay:self];
        self.isDisplayed = YES;
        self.view.alpha = 0.0f;
        
        for (SLHelpOverlayItem *overlayItem in self.items) {
            [overlayItem setupItemView];
            [self.view addSubview:overlayItem.itemView];
            
            // Set the initial alpha to 0 for item views if slide animation is enabled
            if (self.slideAnimationEnabled) {
                overlayItem.itemView.alpha = 0.0f;
            }
        }
        
        [self.view addSubview:self.closeButton];
        [self.appWindow addSubview:self.view];
        
        
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.alpha = 1.0f;
        } completion:nil];
        
        // Fancy slide animation
        if (self.slideAnimationEnabled) {
            if (!self.animationOffset) {
                self.animationOffset = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kIpadAnimationFrameOffset : kIphoneAnimationFrameOffset);
            }
            
            for (SLHelpOverlayItem *overlayItem in self.items) {
                CGRect finalItemFrame = overlayItem.itemView.frame;
                HelpOverlayArrowDirection arrowDirection = overlayItem.arrowDirection;
                
                switch (arrowDirection) {
                    case HelpOverlayArrowDirectionUp:
                        overlayItem.itemView.frame = CGRectMake(finalItemFrame.origin.x,
                                                                finalItemFrame.origin.y + self.animationOffset,
                                                                finalItemFrame.size.width,
                                                                finalItemFrame.size.height);
                        break;
                    case HelpOverlayArrowDirectionDown:
                        overlayItem.itemView.frame = CGRectMake(finalItemFrame.origin.x,
                                                                finalItemFrame.origin.y - self.animationOffset,
                                                                finalItemFrame.size.width,
                                                                finalItemFrame.size.height);
                        break;
                    case HelpOverlayArrowDirectionRight:
                        overlayItem.itemView.frame = CGRectMake(finalItemFrame.origin.x - self.animationOffset,
                                                                finalItemFrame.origin.y,
                                                                finalItemFrame.size.width,
                                                                finalItemFrame.size.height);
                        break;
                    case HelpOverlayArrowDirectionLeft:
                        overlayItem.itemView.frame = CGRectMake(finalItemFrame.origin.x + self.animationOffset,
                                                                finalItemFrame.origin.y,
                                                                finalItemFrame.size.width,
                                                                finalItemFrame.size.height);
                        break;
                    default:
                        break;
                }
                
                // Slide in from the side if the arrow offset is non-default
                if (overlayItem.arrowOffset == HelpOverlayArrowOffsetLeft) {
                    overlayItem.itemView.frame = CGRectMake(finalItemFrame.origin.x + self.animationOffset,
                                                            finalItemFrame.origin.y,
                                                            finalItemFrame.size.width,
                                                            finalItemFrame.size.height);
                } else if (overlayItem.arrowOffset == HelpOverlayArrowOffsetRight) {
                    overlayItem.itemView.frame = CGRectMake(finalItemFrame.origin.x - self.animationOffset,
                                                            finalItemFrame.origin.y,
                                                            finalItemFrame.size.width,
                                                            finalItemFrame.size.height);
                }
                
                CFRunLoopRunInMode(kCFRunLoopDefaultMode, kAnimationSlideDelay, NO);
                [UIView animateWithDuration:kAnimationFadeDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                    overlayItem.itemView.alpha = 1.0f;
                    overlayItem.itemView.frame = finalItemFrame;
                } completion:nil];
            }
        }
        
        [self.delegate didDisplayHelpOverlay:self];
    }
}

- (void)closeOverlayTapped
{
    [self.delegate willDismissHelpOverlay:self];
    [self dismissOverlayAnimated:YES];
}

- (void)dismissOverlayAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:kAnimationFadeDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.view.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            self.isDisplayed = NO;
        }];
    } else {
        [self.view removeFromSuperview];
        self.isDisplayed = NO;
    }
    
    [self.delegate didDisplayHelpOverlay:self];
}

#pragma mark - Global Item Properties

- (void)setArrowLength:(CGFloat)arrowLength
{
    _arrowLength = arrowLength;
    for (SLHelpOverlayItem *overlayItem in self.items) {
        overlayItem.arrowLength = self.arrowLength;
    }
}

- (void)setArrowWidth:(CGFloat)arrowWidth
{
    _arrowWidth = arrowWidth;
    for (SLHelpOverlayItem *overlayItem in self.items) {
        overlayItem.arrowWidth = self.arrowWidth;
    }
}

- (void)setArrowViewInset:(CGFloat)arrowViewInset
{
    _arrowViewInset = arrowViewInset;
    for (SLHelpOverlayItem *overlayItem in self.items) {
        overlayItem.arrowViewInset = self.arrowViewInset;
    }
}

- (void)setArrowDistanceFromEdge:(CGFloat)arrowDistanceFromEdge
{
    _arrowDistanceFromEdge = arrowDistanceFromEdge;
    for (SLHelpOverlayItem *overlayItem in self.items) {
        overlayItem.arrowDistanceFromEdge = self.arrowDistanceFromEdge;
    }
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    for (SLHelpOverlayItem *overlayItem in self.items) {
        overlayItem.borderColor = self.borderColor;
    }
}

- (void)setBubbleColor:(UIColor *)bubbleColor
{
    _bubbleColor = bubbleColor;
    for (SLHelpOverlayItem *overlayItem in self.items) {
        overlayItem.bubbleColor = self.bubbleColor;
    }
}

- (void)setBubblePadding:(CGFloat)bubblePadding
{
    _bubblePadding = bubblePadding;
    for (SLHelpOverlayItem *overlayItem in self.items) {
        overlayItem.bubblePadding = self.bubblePadding;
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    for (SLHelpOverlayItem *overlayItem in self.items) {
        overlayItem.borderWidth = self.borderWidth;
    }
}

- (void)setMaxLabelWidth:(CGFloat)maxLabelWidth
{
    _maxLabelWidth = maxLabelWidth;
    for (SLHelpOverlayItem *overlayItem in self.items) {
        overlayItem.maxLabelWidth = self.maxLabelWidth;
    }
}

- (void)setLabelFont:(UIFont *)labelFont
{
    _labelFont = labelFont;
    for (SLHelpOverlayItem *overlayItem in self.items) {
        overlayItem.labelFont = self.labelFont;
    }
}

- (void)setLabelTextColor:(UIColor *)labelTextColor
{
    _labelTextColor = labelTextColor;
    for (SLHelpOverlayItem *overlayItem in self.items) {
        overlayItem.labelTextColor = self.labelTextColor;
    }
}

- (void)applySettingsToItem:(SLHelpOverlayItem *)overlayItem
{
    // Apply default or user-defiend global settings to the item
    overlayItem.arrowLength = (self.arrowLength ?: kDefaultArrowLength);
    overlayItem.arrowWidth = (self.arrowWidth ?: kDefaultArrowWidth);
    overlayItem.arrowViewInset = (self.arrowViewInset != kDefaultArrowViewInset ? self.arrowViewInset : kDefaultArrowViewInset);
    overlayItem.arrowDistanceFromEdge = (self.arrowDistanceFromEdge ?: kDefaultArrowDistanceFromEdge);
    overlayItem.borderColor = (self.borderColor ?: kDefaultBorderColor);
    overlayItem.bubbleColor = (self.bubbleColor ?: kDefaultBubbleColor);
    overlayItem.bubblePadding = (self.bubblePadding != kDefaultBubblePadding ? self.bubblePadding : kDefaultBubblePadding);
    overlayItem.borderWidth = (self.borderWidth != kDefaultBorderWidth ? self.borderWidth : kDefaultBorderWidth);
    overlayItem.maxLabelWidth = (self.maxLabelWidth ?: kDefaultMaxLabelWidth);
    overlayItem.labelFont = (self.labelFont ?: kDefaultLabelFont);
    overlayItem.labelTextColor = (self.labelTextColor ?: kDefaultLabelTextColor);
    overlayItem.arrowOffset = HelpOverlayArrowOffsetDefault;
    overlayItem.viewOffset = HelpOverlayViewOffsetDefault;
}

- (SLHelpOverlayItem *)lastAddedItem
{
    return (SLHelpOverlayItem *)[self.items lastObject];
}


# pragma mark - Orientation

- (void)setRectForCurrentOrientation
{
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    // Figure out the angle for the transform rotation based on the current orientation
    CGFloat angle;
    switch (statusBarOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = -M_PI_2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = M_PI_2;
            break;
        default:
            angle = 0.0;
            break;
    }
    
    CGFloat statusBarHeight;
    if ([self isIOS7orLater]) {
        statusBarHeight = 0;
    } else {
        statusBarHeight = (UIInterfaceOrientationIsLandscape(statusBarOrientation) ?
                           [UIApplication sharedApplication].statusBarFrame.size.width :
                           [UIApplication sharedApplication].statusBarFrame.size.height);
    }
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    
    // Figure out the final frame's origin and dimensions
    CGRect frame = self.appWindow.bounds;
    frame.origin.x += (statusBarOrientation == UIInterfaceOrientationLandscapeLeft ? statusBarHeight : 0);
    frame.origin.y += (statusBarOrientation == UIInterfaceOrientationPortrait ? statusBarHeight : 0);
    frame.size.width -= (UIInterfaceOrientationIsLandscape(statusBarOrientation) ? statusBarHeight : 0);
    frame.size.height -= (UIInterfaceOrientationIsPortrait(statusBarOrientation) ? statusBarHeight : 0);
    
    self.view.transform = transform;
    self.view.frame = frame;
}

#pragma mark - Helper Methods

- (BOOL)isIOS7orLater
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        return YES;
    }
    
    return NO;
}

@end
