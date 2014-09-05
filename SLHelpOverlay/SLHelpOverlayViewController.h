//
//  SLHelpOverlayViewController.h
//
//  Created by Scott Larson on 3/5/14.

#import <UIKit/UIKit.h>
#import "SLHelpOverlayItem.h"

@class SLHelpOverlayViewController;

#pragma mark - Protocols

@protocol SLHelpOverlayItemSource <NSObject>
@required
- (void)addItemsToHelpOverlay:(SLHelpOverlayViewController *)controller;
@end

@protocol SLHelpOverlayDelegate <NSObject>
@required
- (BOOL)shouldDisplayHelpOverlay:(SLHelpOverlayViewController *)helpOverlay;
@optional
- (void)willDisplayHelpOverlay:(SLHelpOverlayViewController *)helpOverlay;
- (void)didDisplayHelpOverlay:(SLHelpOverlayViewController *)helpOverlay;
- (void)willDismissHelpOverlay:(SLHelpOverlayViewController *)helpOverlay;
- (void)didDismissHelpOverlay:(SLHelpOverlayViewController *)helpOverlay;
@end

@interface SLHelpOverlayViewController : UIViewController

@property (assign, nonatomic) BOOL slideAnimationEnabled;
@property (assign, nonatomic) BOOL isDisplayed;

@property (assign, nonatomic) CGFloat animationOffset;

// Global item properties, applied to all items
// Setting these properties will wipe out any previously set values!
@property (assign, nonatomic) CGFloat arrowLength;
@property (assign, nonatomic) CGFloat arrowWidth;
@property (assign, nonatomic) CGFloat arrowViewInset;
@property (assign, nonatomic) CGFloat arrowDistanceFromEdge;
@property (strong, nonatomic) UIColor *borderColor;
@property (strong, nonatomic) UIColor *bubbleColor;
@property (assign, nonatomic) CGFloat bubblePadding;
@property (assign, nonatomic) CGFloat borderWidth;
@property (assign, nonatomic) CGFloat maxLabelWidth;
@property (strong, nonatomic) UIFont *labelFont;
@property (strong, nonatomic) UIColor *labelTextColor;

// The lastAddedItem property returns the most recently added help overlay item
// It's useful for setting additional properties on an item during setup
@property (weak, nonatomic) SLHelpOverlayItem *lastAddedItem;

@property (weak, nonatomic) id<SLHelpOverlayDelegate> delegate;

+ (SLHelpOverlayViewController *)overlay;

- (void)addItemToOverlayWithText:(NSString *)itemText
                  arrowDirection:(HelpOverlayArrowDirection)arrowDirection
                   viewToPointAt:(UIView *)viewToPointAt;

- (void)displayOverlay;
- (void)dismissOverlayAnimated:(BOOL)animated;

@end