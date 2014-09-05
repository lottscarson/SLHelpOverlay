//
//  SLHelpOverlayItem.h
//
//  Created by Scott Larson on 3/5/14.

#import <Foundation/Foundation.h>

typedef enum {
    HelpOverlayArrowDirectionUp = 0,
    HelpOverlayArrowDirectionDown,
    HelpOverlayArrowDirectionRight,
    HelpOverlayArrowDirectionLeft
} HelpOverlayArrowDirection;

typedef enum {
    HelpOverlayArrowOffsetDefault = 0,
    HelpOverlayArrowOffsetLeft,
    HelpOverlayArrowOffsetRight
} HelpOverlayArrowOffset;

typedef enum {
    HelpOverlayViewOffsetDefault = 0,
    HelpOverlayViewOffsetLeft,
    HelpOverlayViewOffsetRight,
    HelpOverlayViewOffsetTop,
    HelpOverlayViewOffsetBottom
} HelpOverlayViewOffset;

@interface SLHelpOverlayItem : NSObject

@property (strong, nonatomic) UIView *itemView;
@property (weak, nonatomic) UIView *rootView;

@property (copy, nonatomic) NSString *itemText;
@property (assign, nonatomic) HelpOverlayArrowDirection arrowDirection;
@property (assign, nonatomic) HelpOverlayArrowOffset arrowOffset;
@property (assign, nonatomic) HelpOverlayViewOffset viewOffset;
@property (weak, nonatomic) UIView *viewToPointAt;
@property (copy, nonatomic) NSString *accessibilityLabelForView;

@property (assign, nonatomic) CGFloat arrowLength;
@property (assign, nonatomic) CGFloat arrowWidth;
@property (assign, nonatomic) CGFloat arrowViewInset;
@property (assign, nonatomic) CGFloat arrowDistanceFromEdge;
@property (weak, nonatomic) UIColor *borderColor;
@property (weak, nonatomic) UIColor *bubbleColor;
@property (assign, nonatomic) CGFloat bubblePadding;
@property (assign, nonatomic) CGFloat borderWidth;
@property (assign, nonatomic) CGFloat maxLabelWidth;
@property (weak, nonatomic) UIFont *labelFont;
@property (weak, nonatomic) UIColor *labelTextColor;

+ (SLHelpOverlayItem *)helpOverlayItemWithItemText:(NSString *)itemText
                                    arrowDirection:(HelpOverlayArrowDirection)arrowDirection
                                     viewToPointAt:(UIView *)viewToPointAt;

- (SLHelpOverlayItem *)initWithItemText:(NSString *)itemText
                         arrowDirection:(HelpOverlayArrowDirection)arrowDirection
                          viewToPointAt:(UIView *)viewToPointAt;

- (void)setupItemView;


@end
