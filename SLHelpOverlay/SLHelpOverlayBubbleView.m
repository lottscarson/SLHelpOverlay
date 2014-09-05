//
//  SLHelpOverlayBubbleView.m
//
//  Created by Scott Larson on 3/5/14.

#import "SLHelpOverlayBubbleView.h"
#import <QuartzCore/QuartzCore.h>

static NSInteger const kBubblePointCount = 7;

@interface SLHelpOverlayBubbleView()
@property (assign, nonatomic) CGRect bubbleRect;
@end

@implementation SLHelpOverlayBubbleView

- (SLHelpOverlayBubbleView *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setupBubbleWithArrowTipPoint:(CGPoint)tipPoint
                      arrowTailPoint:(CGPoint)tailPoint
                          arrowWidth:(CGFloat)arrowWidth
                         arrowLength:(CGFloat)arrowLength
                      textBubbleRect:(CGRect)bubbleRect
                         borderColor:(UIColor *)borderColor
                         bubbleColor:(UIColor *)bubbleColor
                         borderWidth:(CGFloat)borderWidth
{
    self.tipPoint = tipPoint;
    self.tailPoint = tailPoint;
    self.arrowWidth = arrowWidth;
    self.arrowLength = arrowLength;
    self.bubbleRect = bubbleRect;
    self.borderColor = borderColor;
    self.bubbleColor = bubbleColor;
    self.borderWidth = borderWidth;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *bubblePath = [UIBezierPath bezierPathWithBubbleFromArrowTipPoint:self.tipPoint
                                                                       toTailPoint:self.tailPoint
                                                                       arrowLength:self.arrowLength
                                                                        arrowWidth:self.arrowWidth
                                                                        bubbleRect:self.bubbleRect];
    if (bubblePath) {
        
        [self.bubbleColor setFill];
        if (self.borderWidth > 0) {
            [self.borderColor setStroke];
        }
        
        [bubblePath addClip];
        bubblePath.lineWidth = self.borderWidth;
        bubblePath.usesEvenOddFillRule = YES;
        
        [bubblePath fill];
        if (self.borderWidth > 0) {
            [bubblePath stroke];
        }
    }
}

@end

@implementation UIBezierPath (Bubble)

+ (UIBezierPath *)bezierPathWithBubbleFromArrowTipPoint:(CGPoint)tipPoint
                                            toTailPoint:(CGPoint)tailPoint
                                            arrowLength:(CGFloat)arrowLength
                                             arrowWidth:(CGFloat)arrowWidth
                                             bubbleRect:(CGRect)bubbleRect
{
    CGPoint points[kBubblePointCount];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    CGFloat topRightAngle = ((3 * M_PI) / 2);
    CGFloat topLeftAngle = topRightAngle;
    CGFloat bottomRightAngle = (M_PI / 2);
    CGFloat bottomLeftAngle = bottomRightAngle;
    CGFloat flat = 0;
    CGFloat radius = 5.0f;
    
    points[0] = CGPointMake(tipPoint.x, tipPoint.y);
    
    // Right-facing arrow
    if (tipPoint.x > bubbleRect.size.width) {
        points[1] = CGPointMake(tailPoint.x, tipPoint.y + (arrowWidth / 2));
        points[2] = CGPointMake(tailPoint.x, bubbleRect.size.height);
        points[3] = CGPointMake(0, bubbleRect.size.height);
        points[4] = CGPointMake(0, 0);
        points[5] = CGPointMake(tailPoint.x, 0);
        points[6] = CGPointMake(tailPoint.x, tipPoint.y - (arrowWidth / 2));
        
        [path moveToPoint:points[0]];
        [path addLineToPoint:points[1]];
        [path addLineToPoint:CGPointMake(points[2].x, points[2].y - radius)];
        [path addArcWithCenter:CGPointMake(points[2].x - radius, points[2].y - radius) radius:radius startAngle:flat endAngle:bottomRightAngle clockwise:YES];
        [path addLineToPoint:CGPointMake(points[3].x + radius, points[3].y)];
        [path addArcWithCenter:CGPointMake(points[3].x + radius, points[3].y - radius) radius:radius startAngle:bottomLeftAngle endAngle:M_PI clockwise:YES];
        [path addLineToPoint:CGPointMake(points[4].x, points[4].y + radius)];
        [path addArcWithCenter:CGPointMake(points[4].x + radius, points[4].y + radius) radius:radius startAngle:M_PI endAngle:topLeftAngle clockwise:YES];
        [path addLineToPoint:CGPointMake(points[5].x - radius, points[5].y)];
        [path addArcWithCenter:CGPointMake(points[5].x - radius, points[5].y + radius) radius:radius startAngle:topRightAngle endAngle:flat clockwise:YES];
        [path addLineToPoint:points[6]];
    }
    // Left-facing arrow
    else if (tipPoint.x < bubbleRect.origin.x) {
        points[1] = CGPointMake(bubbleRect.origin.x, tipPoint.y - (arrowWidth / 2));
        points[2] = CGPointMake(bubbleRect.origin.x, 0);
        points[3] = CGPointMake(bubbleRect.origin.x + bubbleRect.size.width, 0);
        points[4] = CGPointMake(bubbleRect.origin.x + bubbleRect.size.width, bubbleRect.size.height);
        points[5] = CGPointMake(bubbleRect.origin.x, bubbleRect.size.height);
        points[6] = CGPointMake(bubbleRect.origin.x, tipPoint.y + (arrowWidth / 2));
        
        [path moveToPoint:points[0]];
        [path addLineToPoint:points[1]];
        [path addLineToPoint:CGPointMake(points[2].x, points[2].y + radius)];
        [path addArcWithCenter:CGPointMake(points[2].x + radius, points[2].y + radius) radius:radius startAngle:M_PI endAngle:topLeftAngle clockwise:YES];
        [path addLineToPoint:CGPointMake(points[3].x - radius, points[3].y)];
        [path addArcWithCenter:CGPointMake(points[3].x - radius, points[3].y + radius) radius:radius startAngle:topRightAngle endAngle:flat clockwise:YES];
        [path addLineToPoint:CGPointMake(points[4].x, points[4].y - radius)];
        [path addArcWithCenter:CGPointMake(points[4].x - radius, points[4].y - radius) radius:radius startAngle:flat endAngle:bottomRightAngle clockwise:YES];
        [path addLineToPoint:CGPointMake(points[5].x + radius, points[5].y)];
        [path addArcWithCenter:CGPointMake(points[5].x + radius, points[5].y - radius) radius:radius startAngle:bottomLeftAngle endAngle:M_PI clockwise:YES];
        [path addLineToPoint:points[6]];
    }
    // Down-facing arrow
    else if (bubbleRect.origin.y < tipPoint.y) {
        points[1] = CGPointMake(tipPoint.x - (arrowWidth / 2), bubbleRect.size.height);
        points[2] = CGPointMake(0, bubbleRect.size.height);
        points[3] = CGPointMake(0, 0);
        points[4] = CGPointMake(bubbleRect.size.width, 0);
        points[5] = CGPointMake(bubbleRect.size.width, bubbleRect.size.height);
        points[6] = CGPointMake(tipPoint.x + (arrowWidth / 2), bubbleRect.size.height);
        
        [path moveToPoint:points[0]];
        [path addLineToPoint:points[1]];
        [path addLineToPoint:CGPointMake(points[2].x + radius, points[2].y)];
        [path addArcWithCenter:CGPointMake(points[2].x + radius, points[2].y - radius) radius:radius startAngle:bottomLeftAngle endAngle:M_PI clockwise:YES];
        [path addLineToPoint:CGPointMake(points[3].x, points[3].y + radius)];
        [path addArcWithCenter:CGPointMake(points[3].x + radius, points[3].y + radius) radius:radius startAngle:M_PI endAngle:topLeftAngle clockwise:YES];
        [path addLineToPoint:CGPointMake(points[4].x - radius, points[4].y)];
        [path addArcWithCenter:CGPointMake(points[4].x - radius, points[4].y + radius) radius:radius startAngle:topRightAngle endAngle:flat clockwise:YES];
        [path addLineToPoint:CGPointMake(points[5].x, points[5].y - radius)];
        [path addArcWithCenter:CGPointMake(points[5].x - radius, points[5].y - radius) radius:radius startAngle:flat endAngle:bottomRightAngle clockwise:YES];
        [path addLineToPoint:points[6]];
    }
    // Up-facing arrow
    else if (bubbleRect.origin.y > tipPoint.y) {
        points[1] = CGPointMake(tipPoint.x + (arrowWidth / 2), arrowLength);
        points[2] = CGPointMake(bubbleRect.size.width, arrowLength);
        points[3] = CGPointMake(bubbleRect.size.width, bubbleRect.size.height + arrowLength);
        points[4] = CGPointMake(0, bubbleRect.size.height + arrowLength);
        points[5] = CGPointMake(0, arrowLength);
        points[6] = CGPointMake(tipPoint.x - (arrowWidth / 2), arrowLength);
        
        [path moveToPoint:points[0]];
        [path addLineToPoint:points[1]];
        [path addLineToPoint:CGPointMake(points[2].x - radius, points[2].y)];
        [path addArcWithCenter:CGPointMake(points[2].x - radius, points[2].y + radius) radius:radius startAngle:topRightAngle endAngle:flat clockwise:YES];
        [path addLineToPoint:CGPointMake(points[3].x, points[3].y - radius)];
        [path addArcWithCenter:CGPointMake(points[3].x - radius, points[3].y - radius) radius:radius startAngle:flat endAngle:bottomRightAngle clockwise:YES];
        [path addLineToPoint:CGPointMake(points[4].x + radius, points[4].y)];
        [path addArcWithCenter:CGPointMake(points[4].x + radius, points[4].y - radius) radius:radius startAngle:bottomLeftAngle endAngle:M_PI clockwise:YES];
        [path addLineToPoint:CGPointMake(points[5].x, points[5].y + radius)];
        [path addArcWithCenter:CGPointMake(points[5].x + radius, points[5].y + radius) radius:radius startAngle:M_PI endAngle:topLeftAngle clockwise:YES];
        [path addLineToPoint:points[6]];
    }
    
    [path closePath];
    
    return path;
}

@end

