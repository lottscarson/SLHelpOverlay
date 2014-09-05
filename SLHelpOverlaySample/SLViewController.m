//
//  SLViewController.m
//  SLHelpOverlaySample
//
//  Created by Scott Larson on 3/5/14.
//  Copyright (c) 2014 SL. All rights reserved.
//

#import "SLViewController.h"
#import "SLChildViewController.h"

static CGFloat const kButtonCornerRadius    = 5.0f;
static CGFloat const kLongArrowValue        = 100.0f;
static CGFloat const kWideArrowValue        = 50.0f;

@interface SLViewController ()

@property (strong, nonatomic) SLHelpOverlayViewController *helpOverlay;

@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UITextField *basicTextField;
@property (weak, nonatomic) IBOutlet UISlider *valueSlider;
@property (weak, nonatomic) IBOutlet UISwitch *itemToggleSwitch;
@property (weak, nonatomic) IBOutlet UILabel *itemToggleLabel;

@property (strong, nonatomic) SLChildViewController *childVC;
@property (weak, nonatomic) IBOutlet UIView *childVCViewPlaceholder;
@property (weak, nonatomic) IBOutlet UISwitch *childVCItemsSwitch;
@property (weak, nonatomic) IBOutlet UILabel *childVCItemsLabel;

@property (weak, nonatomic) IBOutlet UISwitch *longArrowSwitch;
@property (weak, nonatomic) IBOutlet UILabel *longArrowLabel;
@property (weak, nonatomic) IBOutlet UISwitch *wideArrowSwitch;
@property (weak, nonatomic) IBOutlet UILabel *wideArrowLabel;
@property (weak, nonatomic) IBOutlet UISwitch *tealOverlaySwitch;
@property (weak, nonatomic) IBOutlet UILabel *tealOverlayLabel;
@property (weak, nonatomic) IBOutlet UISwitch *comicSansSwitch;
@property (weak, nonatomic) IBOutlet UILabel *comicSansLabel;

- (IBAction)displayHelpOverlay:(id)sender;

- (IBAction)switchToggled:(id)sender;

@end

@implementation SLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"SLHelpOverlay Sample";
    
    self.helpButton.layer.cornerRadius = kButtonCornerRadius;
    self.helpButton.layer.masksToBounds = YES;
    
    self.childVC = [[SLChildViewController alloc] init];
    self.childVC.view.frame = self.childVCViewPlaceholder.bounds;
    [self.childVCViewPlaceholder addSubview:self.childVC.view];
    [self addChildViewController:self.childVC];
}

#pragma mark - Action Handling

- (IBAction)displayHelpOverlay:(id)sender
{
    self.helpOverlay = [[SLHelpOverlayViewController alloc] init];
    
    self.helpOverlay.borderWidth = 0.0f;
    
    [(id<SLHelpOverlayItemSource>)self addItemsToHelpOverlay:self.helpOverlay];
    
    if (self.longArrowSwitch.on) {
        self.helpOverlay.arrowLength = kLongArrowValue;
    }
    
    if (self.wideArrowSwitch.on) {
        self.helpOverlay.arrowWidth = kWideArrowValue;
    }
    
    if (self.tealOverlaySwitch.on) {
        self.helpOverlay.bubbleColor = [UIColor colorWithRed:0 green:0.5f blue:0.5f alpha:1.0];
    }
    
    if (self.comicSansSwitch.on) {
        self.helpOverlay.labelFont = [UIFont fontWithName:@"Comic Sans MS" size:14.0f];
    }
    
    [self.helpOverlay displayOverlay];
}

- (IBAction)switchToggled:(id)sender
{
    if ([sender isKindOfClass:[UISwitch class]]) {
        UISwitch *toggledSwitch = (UISwitch *)sender;
        
        UILabel *labelToAdjust = nil;
        if (toggledSwitch == self.itemToggleSwitch) {
            labelToAdjust = self.itemToggleLabel;
        } else if (toggledSwitch == self.childVCItemsSwitch) {
            labelToAdjust = self.childVCItemsLabel;
        } else if (toggledSwitch == self.longArrowSwitch) {
            labelToAdjust = self.longArrowLabel;
        } else if (toggledSwitch == self.wideArrowSwitch) {
            labelToAdjust = self.wideArrowLabel;
        } else if (toggledSwitch == self.tealOverlaySwitch) {
            labelToAdjust = self.tealOverlayLabel;
        } else if (toggledSwitch == self.comicSansSwitch) {
            labelToAdjust = self.comicSansLabel;
        }

        if (labelToAdjust) {
            UIColor *labelTextColor = (toggledSwitch.on ? self.helpButton.backgroundColor : [UIColor blackColor]);
            labelToAdjust.textColor = labelTextColor;
        }
    }
}

#pragma maek - SLHelpOverlayDelegate
- (BOOL)shouldDisplayHelpOverlay:(SLHelpOverlayViewController *)helpOverlay
{
    return YES;
}

#pragma mark - SLHelpOverlayItemSource

- (void)addItemsToHelpOverlay:(SLHelpOverlayViewController *)controller
{
    [controller addItemToOverlayWithText:@"This is a text field"
                          arrowDirection:HelpOverlayArrowDirectionDown
                           viewToPointAt:self.basicTextField];
    
    NSString *valueSliderItemText = [NSString stringWithFormat:@"The current value of this slider is %f", self.valueSlider.value];
    [controller addItemToOverlayWithText:valueSliderItemText
                          arrowDirection:HelpOverlayArrowDirectionUp
                           viewToPointAt:self.valueSlider];
    
    if (self.itemToggleSwitch.on) {
        [controller addItemToOverlayWithText:@"This switch toggles this overlay"
                              arrowDirection:HelpOverlayArrowDirectionRight
                               viewToPointAt:self.itemToggleSwitch];
    }
    
    if (self.childVCItemsSwitch.on) {
        [self.childVC addItemsToHelpOverlay:controller];
    }
}

@end
