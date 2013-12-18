//
//  AppointmentViewController.m
//  Appointment
//
//  Created by Alex Ushakov on 05/12/13.
//  Copyright (c) 2013 Alex Ushakov. All rights reserved.
//

#import "AppointmentViewController.h"

#import "AppoinmentsListViewController.h"

@interface AppointmentViewController ()

@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *durationProgress;

@end

@implementation AppointmentViewController

- (void)refresh
{
    self.subjectLabel.text = self.appointment.subject;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"hh:mm";
    
    self.timeLabel.text = [formatter stringFromDate:self.appointment.meetingDate];
    
    double minutes = [self.appointment.duration doubleValue] / 60.0;
    self.durationLabel.text = [NSString stringWithFormat:@"%.0f minutes", minutes];
    
    double passed = -1.0 * [self.appointment.meetingDate timeIntervalSinceNow];
    double progress = passed / [self.appointment.duration doubleValue];
    if(progress < 0)
    {
        self.durationProgress.progress = 0;
    }
    else if(progress > 1.0)
    {
        self.durationProgress.progress = 1.0;
    }
    else
    {
        self.durationProgress.progress = progress;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UISplitViewController* splitVC = self.splitViewController;
        NSArray* controllers = splitVC.viewControllers;
        UINavigationController* navigation = (UINavigationController *)controllers[0];
        AppoinmentsListViewController* master = (AppoinmentsListViewController *)navigation.topViewController;
        
        self.appointment = master.appoinments[0];
    }
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
