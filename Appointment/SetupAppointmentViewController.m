//
//  SetupAppointmentViewController.m
//  Appointment
//
//  Created by Alex Ushakov on 02/12/13.
//  Copyright (c) 2013 Alex Ushakov. All rights reserved.
//

#import "SetupAppointmentViewController.h"
#import "UIRangeSlider.h"

@interface SetupAppointmentViewController ()

@end

@implementation SetupAppointmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIRangeSlider* slider = [[UIRangeSlider alloc] initWithFrame:CGRectMake(0,
                                                                            400.f,
                                                                            self.view.bounds.size.width,
                                                                            44.f)];
    
    slider.minimumValue = 8;
    slider.maximumValue = 18;
    slider.minimumRange = 0.5;
    slider.selectedMinimumValue = 10;
    slider.selectedMaximumValue = 16;
    
    [slider addTarget:self
               action:@selector(onSliderValueChanged:)
     forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:slider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSliderValueChanged:(UIRangeSlider *)sender
{
    NSLog(@"Slider Value Changed: %.2f %.2f",
          sender.selectedMinimumValue,
          sender.selectedMaximumValue);
}

- (IBAction)onCancelButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onDoneButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
