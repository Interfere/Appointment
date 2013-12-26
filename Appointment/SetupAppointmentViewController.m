//
//  SetupAppointmentViewController.m
//  Appointment
//
//  Created by Alex Ushakov on 02/12/13.
//  Copyright (c) 2013 Alex Ushakov. All rights reserved.
//

#import "SetupAppointmentViewController.h"
#import "UIRangeSlider.h"
#import "AppDelegate.h"

@interface SetupAppointmentViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *meetingDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) UIRangeSlider *durationSlider;

@end

@implementation SetupAppointmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.durationSlider = [[UIRangeSlider alloc] initWithFrame:CGRectMake(0,
                                                                          400.f,
                                                                          self.view.bounds.size.width,
                                                                          44.f)];
    
    self.durationSlider.minimumValue = 8;
    self.durationSlider.maximumValue = 18;
    self.durationSlider.minimumRange = 0.5;
    self.durationSlider.selectedMinimumValue = 10;
    self.durationSlider.selectedMaximumValue = 16;
    
    [self.durationSlider addTarget:self
                            action:@selector(onSliderValueChanged:)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.durationSlider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSliderValueChanged:(UIRangeSlider *)slider
{
    int startTime = slider.selectedMinimumValue * 60;
    int endTime = slider.selectedMaximumValue * 60;
    
    int startHours = startTime / 60;
    int startMinutes = startTime % 60;
    
    int endHours = endTime / 60;
    int endMinutes = endTime % 60;
    
    NSString* labelString = [NSString stringWithFormat:@"%02d:%02d-%02d:%02d",
                             startHours, startMinutes, endHours, endMinutes];
    
    self.durationLabel.text = labelString;
}

- (IBAction)onCancelButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onDoneButtonPressed:(id)sender {
    if(!self.appointment)
    {
        // Form is opened to create new appointment
        self.appointment = [Appointment appointmentWithContext:[self managedObjectContext]];
    }
    
    self.appointment.subject = self.subjectTextField.text;
    NSDate* dateFromPicker = self.meetingDatePicker.date;
    NSLog(@"Picker Date: %@", dateFromPicker);
    NSDate* startMeetingDate = [dateFromPicker dateByAddingTimeInterval:self.durationSlider.selectedMinimumValue * 3600.f];
    NSLog(@"Start Date: %@", startMeetingDate);
    
    self.appointment.meetingDate = startMeetingDate;
    
    self.appointment.duration = @((self.durationSlider.selectedMaximumValue - self.durationSlider.selectedMinimumValue) * 3600.f);
    
    NSError* error = nil;
    if(![[self managedObjectContext] save:&error])
    {
        NSLog(@"Error saving context: %@", error);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DID_ADD_APPOINTMENT" object:nil];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (NSManagedObjectContext *)managedObjectContext
{
    __weak NSManagedObjectContext *context = nil;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    context = delegate.managedObjectContext;
    return context;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end
