//
//  SetupAppointmentViewController.m
//  Appointment
//
//  Created by Alex Ushakov on 02/12/13.
//  Copyright (c) 2013 Alex Ushakov. All rights reserved.
//

#import "SetupAppointmentViewController.h"

@interface SetupAppointmentViewController ()

@end

@implementation SetupAppointmentViewController

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

- (IBAction)onCancelButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onDoneButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
