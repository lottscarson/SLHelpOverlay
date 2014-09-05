//
//  SLHelpOverlayBubbleView.h
//
//  Created by Scott Larson on 3/5/14.

#import <UIKit/UIKit.h>

@interface SLHelpOverlayBubbleView : UIView

@property (assign, nonatomic) CGPoint tailPoint;
@property (assign, nonatomic) CGPoint tipPoint;
@property (assign, nonatomic) CGFloat arrowWidth;
@property (assign, nonatomic) CGFloat arrowLength;
@property (assign, nonatomic) CGFloat borderWidth;
@property (weak, nonatomic) UIColor *bubbleColor;
@property (weak, nonatomic) UIColor *borderColor;
@property (assign, nonatomic) BOOL showShadow;

- (void)setupBubbleWithArrowTipPoint:(CGPoint)tipPoint
                      arrowTailPoint:(CGPoint)tailPoint
                          arrowWidth:(CGFloat)arrowWidth
                         arrowLength:(CGFloat)arrowLength
                      textBubbleRect:(CGRect)bubbleRect
                         borderColor:(UIColor *)borderColor
                         bubbleColor:(UIColor *)bubbleColor
                         borderWidth:(CGFloat)borderWidth;

@end

@interface UIBezierPath (Bubble)

+ (UIBezierPath *)bezierPathWithBubbleFromArrowTipPoint:(CGPoint)tipPoint
                                            toTailPoint:(CGPoint)tailPoint
                                            arrowLength:(CGFloat)arrowLength
                                             arrowWidth:(CGFloat)arrowWidth
                                             bubbleRect:(CGRect)bubbleRect;

@end
