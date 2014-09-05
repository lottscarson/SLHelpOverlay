//
//  SLHelpOverlayItem.m
//
//  Created by Scott Larson on 3/5/14.

#import "SLHelpOverlayItem.h"
#import "SLHelpOverlayBubbleView.h"

@implementation SLHelpOverlayItem

+ (SLHelpOverlayItem *)helpOverlayItemWithItemText:(NSString *)itemText
                                    arrowDirection:(HelpOverlayArrowDirection)arrowDirection
                                     viewToPointAt:(UIView *)viewToPointAt
{
    return [[SLHelpOverlayItem alloc] initWithItemText:itemText
                                        arrowDirection:arrowDirection
                                         viewToPointAt:viewToPointAt];
}

- (SLHelpOverlayItem *)init
{
    return [self initWithItemText:@" "
                   arrowDirection:HelpOverlayArrowDirectionUp
                    viewToPointAt:[UIApplication sharedApplication].keyWindow];
}

- (SLHelpOverlayItem *)initWithItemText:(NSString *)itemText
                         arrowDirection:(HelpOverlayArrowDirection)arrowDirection
                          viewToPointAt:(UIView *)viewToPointAt
{
    if (self = [super init]) {
        self.itemText = itemText;
        self.arrowDirection = arrowDirection;
        self.viewToPointAt = viewToPointAt;
    }
    
    return self;
}

- (void)setupItemView
{
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    
    CGSize labelSize = CGSizeMake(self.maxLabelWidth, 0);
    CGRect labelFrame = [self.itemText boundingRectWithSize:labelSize
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:nil
                                                    context:nil];
    
    // Set up the label
    UILabel *itemLabel = [[UILabel alloc] initWithFrame:labelFrame];
    itemLabel.lineBreakMode = NSLineBreakByWordWrapping;
    itemLabel.textAlignment = NSTextAlignmentCenter;
    itemLabel.numberOfLines = 0;
    itemLabel.text = self.itemText;
    itemLabel.font = self.labelFont;
    itemLabel.textColor = self.labelTextColor;
    itemLabel.backgroundColor = [UIColor clearColor];
    [itemLabel sizeToFit];
    
    // Add some padding to the side of the label
    CGFloat bubbleWidth = (int)(itemLabel.frame.size.width + (self.bubblePadding * 2));
    CGFloat bubbleHeight = (int)(itemLabel.frame.size.height + (self.bubblePadding * 2));
    
    CGRect targetBounds = self.viewToPointAt.bounds;
    CGPoint pointInTarget, tipPoint, tailPoint;
    CGRect arrowFrame;
    CGFloat widthFromArrowCenter = (self.arrowWidth / 2);
    CGFloat widthFromBubbleCenter = (bubbleWidth / 2);
    CGFloat heightFromBubbleCenter = (bubbleHeight / 2);
    
    // Set up the view according to the arrow direction and view offset
    switch (self.arrowDirection) {
        case HelpOverlayArrowDirectionUp:
            if (self.viewOffset == HelpOverlayViewOffsetLeft || self.viewOffset == HelpOverlayViewOffsetRight) {
                pointInTarget = (self.viewOffset == HelpOverlayViewOffsetLeft ?
                                 CGPointMake(CGRectGetMinX(targetBounds) + self.arrowViewInset, CGRectGetMaxY(targetBounds) - self.arrowViewInset) :
                                 CGPointMake(CGRectGetMaxX(targetBounds) - self.arrowViewInset, CGRectGetMaxY(targetBounds) - self.arrowViewInset));
            } else {
                pointInTarget = CGPointMake(CGRectGetMidX(targetBounds), CGRectGetMaxY(targetBounds) - self.arrowViewInset);
            }
            
            tipPoint = [self.viewToPointAt convertPoint:pointInTarget toView:mainWindow.rootViewController.view];
            tailPoint = CGPointMake(tipPoint.x, tipPoint.y + self.arrowLength);
            arrowFrame = CGRectMake(tipPoint.x - widthFromArrowCenter, tipPoint.y, self.arrowWidth, self.arrowLength);
            labelFrame = CGRectMake(tailPoint.x - widthFromBubbleCenter, arrowFrame.origin.y + arrowFrame.size.height, bubbleWidth, bubbleHeight);
            break;
            
        case HelpOverlayArrowDirectionDown:
            if (self.viewOffset == HelpOverlayViewOffsetLeft || self.viewOffset == HelpOverlayViewOffsetRight) {
                pointInTarget = (self.viewOffset == HelpOverlayViewOffsetLeft ?
                                 CGPointMake(CGRectGetMinX(targetBounds) + self.arrowViewInset, CGRectGetMinY(targetBounds) + self.arrowViewInset) :
                                 CGPointMake(CGRectGetMaxX(targetBounds) - self.arrowViewInset, CGRectGetMinY(targetBounds) + self.arrowViewInset));
            } else {
                pointInTarget = CGPointMake(CGRectGetMidX(targetBounds), CGRectGetMinY(targetBounds) + self.arrowViewInset);
            }
            
            tipPoint = [self.viewToPointAt convertPoint:pointInTarget toView:mainWindow.rootViewController.view];
            tailPoint = CGPointMake(tipPoint.x, tipPoint.y - self.arrowLength);
            arrowFrame = CGRectMake(tailPoint.x - widthFromArrowCenter, tailPoint.y, self.arrowWidth, self.arrowLength);
            labelFrame = CGRectMake(tailPoint.x - widthFromBubbleCenter, arrowFrame.origin.y - bubbleHeight, bubbleWidth, bubbleHeight);
            break;
            
        case HelpOverlayArrowDirectionRight:
            if (self.viewOffset == HelpOverlayViewOffsetTop || self.viewOffset == HelpOverlayViewOffsetBottom) {
                pointInTarget = (self.viewOffset == HelpOverlayViewOffsetTop ?
                                 CGPointMake(CGRectGetMinX(targetBounds) + self.arrowViewInset, CGRectGetMinY(targetBounds) + self.arrowViewInset) :
                                 CGPointMake(CGRectGetMinX(targetBounds) + self.arrowViewInset, CGRectGetMaxY(targetBounds) - self.arrowViewInset));
            } else {
                pointInTarget = CGPointMake(CGRectGetMinX(targetBounds) + self.arrowViewInset, CGRectGetMidY(targetBounds));
            }

            tipPoint = [self.viewToPointAt convertPoint:pointInTarget toView:mainWindow.rootViewController.view];
            tailPoint = CGPointMake(tipPoint.x - self.arrowLength, tipPoint.y);
            arrowFrame = CGRectMake(tailPoint.x, tailPoint.y - widthFromArrowCenter, self.arrowLength, self.arrowWidth);
            labelFrame = CGRectMake(tailPoint.x - bubbleWidth, tailPoint.y - heightFromBubbleCenter, bubbleWidth, bubbleHeight);
            break;
            
        case HelpOverlayArrowDirectionLeft:
            if (self.viewOffset == HelpOverlayViewOffsetTop || self.viewOffset == HelpOverlayViewOffsetBottom) {
                pointInTarget = (self.viewOffset == HelpOverlayViewOffsetTop ?
                                 CGPointMake(CGRectGetMaxX(targetBounds) - self.arrowViewInset, CGRectGetMinY(targetBounds) + self.arrowViewInset) :
                                 CGPointMake(CGRectGetMaxX(targetBounds) - self.arrowViewInset, CGRectGetMaxY(targetBounds) - self.arrowViewInset));
            } else {
                pointInTarget = CGPointMake(CGRectGetMaxX(targetBounds) - self.arrowViewInset, CGRectGetMidY(targetBounds));
            }
            
            tipPoint = [self.viewToPointAt convertPoint:pointInTarget toView:mainWindow.rootViewController.view];
            tailPoint = CGPointMake(tipPoint.x + self.arrowLength, tipPoint.y);
            arrowFrame = CGRectMake(tipPoint.x, tipPoint.y - widthFromArrowCenter, self.arrowLength, self.arrowWidth);
            labelFrame = CGRectMake(tailPoint.x, tailPoint.y - heightFromBubbleCenter, bubbleWidth, bubbleHeight);
            break;
            
        default:
            break;
    }
    
    // Offset the bubble from the arrow
    if (self.arrowOffset != HelpOverlayArrowOffsetDefault && (self.arrowDirection == HelpOverlayArrowDirectionDown || self.arrowDirection == HelpOverlayArrowDirectionUp)) {
        CGRect offsetLabelFrame;
        switch (self.arrowOffset) {
            case HelpOverlayArrowOffsetLeft:
                offsetLabelFrame = CGRectMake(tailPoint.x - self.arrowDistanceFromEdge, labelFrame.origin.y, labelFrame.size.width, labelFrame.size.height);
                labelFrame = offsetLabelFrame;
                break;
            case HelpOverlayArrowOffsetRight:
                offsetLabelFrame = CGRectMake(tailPoint.x + self.arrowDistanceFromEdge - labelFrame.size.width, labelFrame.origin.y, labelFrame.size.width, labelFrame.size.height);
                labelFrame = offsetLabelFrame;
                break;
            default:
                break;
        }
    }
    
    // Make sure the labels don't ever appear off the screen
    BOOL labelIsWithinScreen = CGRectContainsRect(mainWindow.rootViewController.view.bounds, labelFrame);
    if (!labelIsWithinScreen) {
        CGRect fixedFrame;
        // Left edge
        if (labelFrame.origin.x < 0) {
            fixedFrame = CGRectMake(self.bubblePadding, labelFrame.origin.y, labelFrame.size.width, labelFrame.size.height);
            labelFrame = fixedFrame;
        }
        // Right edge
        if (labelFrame.origin.x + labelFrame.size.width > mainWindow.rootViewController.view.bounds.size.width) {
            fixedFrame = CGRectMake(mainWindow.rootViewController.view.bounds.size.width - labelFrame.size.width - self.bubblePadding, labelFrame.origin.y, labelFrame.size.width, labelFrame.size.height);
            labelFrame = fixedFrame;
        }
        // Top edge
        if (labelFrame.origin.y < 0) {
            fixedFrame = CGRectMake(labelFrame.origin.x, 0, labelFrame.size.width, labelFrame.size.height);
            labelFrame = fixedFrame;
        }
        // Bottom edge
        if (labelFrame.origin.y + labelFrame.size.height > mainWindow.rootViewController.view.bounds.size.height) {
            fixedFrame = CGRectMake(labelFrame.origin.x, mainWindow.rootViewController.view.bounds.size.height - labelFrame.size.height, labelFrame.size.width, labelFrame.size.height);
            labelFrame = fixedFrame;
        }
    }
    
    // Create the item view
    CGRect itemViewFrame = CGRectUnion(arrowFrame, labelFrame);
    itemViewFrame = CGRectMake(floor(itemViewFrame.origin.x), floor(itemViewFrame.origin.y), itemViewFrame.size.width, itemViewFrame.size.height);
    UIView *itemView = [[UIView alloc] initWithFrame:itemViewFrame];
    
    SLHelpOverlayBubbleView *bubble = [[SLHelpOverlayBubbleView alloc] initWithFrame:itemViewFrame];
    
    CGPoint adjustedTipPoint = CGPointMake(tipPoint.x - itemViewFrame.origin.x, tipPoint.y - itemViewFrame.origin.y);
    CGPoint adjustedTailPoint = CGPointMake(tailPoint.x - itemViewFrame.origin.x, tailPoint.y - itemViewFrame.origin.y);
    CGPoint adjustedLabelOrigin;
    switch (self.arrowDirection) {
        case HelpOverlayArrowDirectionUp:
            adjustedLabelOrigin = CGPointMake(0, adjustedTailPoint.y);
            break;
        case HelpOverlayArrowDirectionLeft:
            adjustedLabelOrigin = CGPointMake(adjustedTailPoint.x, 0);
            break;
        default: // default value for right and down values
            adjustedLabelOrigin = CGPointMake(0, 0);
            break;
    }
    CGRect adjustedLabelFrame = CGRectMake(adjustedLabelOrigin.x, adjustedLabelOrigin.y, labelFrame.size.width, labelFrame.size.height);
    
    [bubble setupBubbleWithArrowTipPoint:adjustedTipPoint
                          arrowTailPoint:adjustedTailPoint
                              arrowWidth:self.arrowWidth
                             arrowLength:self.arrowLength
                          textBubbleRect:adjustedLabelFrame
                             borderColor:self.borderColor
                             bubbleColor:self.bubbleColor
                             borderWidth:self.borderWidth];
    
    bubble.frame = CGRectMake(0, 0, bubble.frame.size.width, bubble.frame.size.height);
    itemLabel.frame = CGRectMake(floor(adjustedLabelOrigin.x + self.bubblePadding), floor(adjustedLabelOrigin.y + self.bubblePadding), itemLabel.frame.size.width, itemLabel.frame.size.height);
    
    [itemView addSubview:bubble];
    [itemView addSubview:itemLabel];
    
    itemView.isAccessibilityElement = YES;
    if (self.accessibilityLabelForView) {
        itemView.accessibilityLabel = self.accessibilityLabelForView;
    }
    self.itemView = itemView;
    [self.itemView setNeedsDisplay];
}

@end
