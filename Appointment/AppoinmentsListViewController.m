//
//  AppoinmentsListViewController.m
//  Appointment
//
//  Created by Alex Ushakov on 05/12/13.
//  Copyright (c) 2013 Alex Ushakov. All rights reserved.
//

#import "AppoinmentsListViewController.h"

#import "Appointment.h"
#import "AppointmentViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface AppoinmentsListViewController ()

@property (nonatomic, strong) NSArray* appoinments;

@property (readonly, nonatomic, weak) NSManagedObjectContext *managedObjectContext;

- (void)fetchAppointments;

@end

@implementation AppoinmentsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchAppointments];
    
    if([self.appoinments count] == 0)
    {
        Appointment* app1 = [Appointment appointmentWithContext:self.managedObjectContext];
        app1.subject = @"The Beatles";
        app1.meetingDate = [NSDate date];
        app1.duration = @(90 * 60.0);
        
        Appointment* app2 = [Appointment appointmentWithContext:self.managedObjectContext];
        app2.subject = @"The Clash";
        app2.meetingDate = [NSDate dateWithTimeIntervalSinceNow:[app1.duration doubleValue]];
        app2.duration = @(60 * 60.0);
        
        Appointment* app3 = [Appointment appointmentWithContext:self.managedObjectContext];
        app3.subject = @"Elton John";
        app3.meetingDate = [app2.meetingDate dateByAddingTimeInterval:[app2.duration doubleValue]];
        app3.duration = @(30 * 60.0);
        
        NSError* error = nil;
        if(![self.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error: %@", error);
            abort();
        }
        
        [self fetchAppointments];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.appoinments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AppointmentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Appointment* appointment = self.appoinments[indexPath.row];
    
    cell.textLabel.text = appointment.subject;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"hh:mm";
    
    NSDate *endDate = [appointment.meetingDate dateByAddingTimeInterval:[appointment.duration doubleValue]];
    
    NSString* startString = [formatter stringFromDate:appointment.meetingDate];
    NSString* endString = [formatter stringFromDate:endDate];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@", startString, endString];
    
    return cell;
}

- (void)fetchAppointments
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Appointments" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSSortDescriptor *sorting = [[NSSortDescriptor alloc] initWithKey:@"meetingDate" ascending:YES];
    [request setSortDescriptors:@[sorting]];
    
    NSError *error = nil;
    self.appoinments = [context executeFetchRequest:request error:&error];
    if(error)
    {
        NSLog(@"Failed to fetch appointments: %@", error);
    }
}

- (NSManagedObjectContext *)managedObjectContext
{
    __weak NSManagedObjectContext *context = nil;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    context = delegate.managedObjectContext;
    return context;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"PushAppointment"])
    {
        AppointmentViewController* vc = (AppointmentViewController *)[segue destinationViewController];
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        
        vc.appointment = self.appoinments[indexPath.row];
    }
    [super prepareForSegue:segue sender:sender];
}

@end
