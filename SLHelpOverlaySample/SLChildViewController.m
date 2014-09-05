//
//  SLChildViewController.m
//  SLHelpOverlaySample
//
//  Created by Scott Larson on 3/10/14.
//  Copyright (c) 2014 SL. All rights reserved.
//

#import "SLChildViewController.h"

static CGFloat const kChildVCLabelHeight = 50;

@interface SLChildViewController ()

@property (strong, nonatomic) UILabel *textLabel;

@end

@implementation SLChildViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height / 2) - kChildVCLabelHeight, self.view.bounds.size.width, kChildVCLabelHeight)];
    self.textLabel.text = @"This is a child view controller";
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.textLabel];
}


- (void)addItemsToHelpOverlay:(SLHelpOverlayViewController *)controller
{
    [controller addItemToOverlayWithText:@"This is a text field inside of a child view controller" arrowDirection:HelpOverlayArrowDirectionLeft viewToPointAt:self.textLabel];
}
@end
