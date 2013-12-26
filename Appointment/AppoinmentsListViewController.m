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

@interface AppoinmentsListViewController () <UIAlertViewDelegate>

@property (weak, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) UIPopoverController *pc;

@property (strong, nonatomic, readonly) NSURLSession *session;

@property (strong, nonatomic) NSOperationQueue *queue;

@property (strong, nonatomic) NSIndexPath *indexToDelete;

- (void)fetchAppointments;

@end

@implementation AppoinmentsListViewController
@synthesize session = _session;

#pragma mark - View lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.splitViewController.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchAppointments];
    
    self.queue = [[NSOperationQueue alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAppointmentAdded:)
                                                 name:@"DID_ADD_APPOINTMENT"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onAppointmentAdded:(NSNotification *)notification
{
    [self fetchAppointments];
    [self.tableView reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex)
    {
        // Delete from CoreData
        // TODO: delete rom CoreData
        __weak Appointment* app = self.appoinments[self.indexToDelete.row];
        self.appoinments = [self.appoinments filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return ![app.subject isEqualToString:[evaluatedObject subject]];
        }]];
        [self.tableView deleteRowsAtIndexPaths:@[self.indexToDelete]
                              withRowAnimation:UITableViewRowAnimationLeft];
    }
    
    self.indexToDelete = nil;
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.indexToDelete = indexPath;
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Delete Cell"
                                                            message:@"Are you sure?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
        [alertView show];
    }
}

- (AppointmentViewController *)getDetail
{
    UISplitViewController* split = self.splitViewController;
    NSArray* controllers = split.viewControllers;
    UINavigationController* navigation = (UINavigationController *)controllers[1];
    AppointmentViewController* detail = (AppointmentViewController *)navigation.topViewController;
    return detail;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    indexPath.row - selected cell
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        AppointmentViewController *detail = [self getDetail];
        
        detail.appointment = self.appoinments[indexPath.row];
        [detail refresh];
        
        if(self.pc)
        {
            [self.pc dismissPopoverAnimated:YES];
        }
    }
}

#pragma mark - Split Controller Delegate

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    AppointmentViewController *detail = [self getDetail];
    
    barButtonItem.title = @"Master";
    barButtonItem.style = UIBarButtonItemStyleBordered;
    
    detail.navigationItem.leftBarButtonItem = barButtonItem;
    
    self.pc = pc;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    AppointmentViewController *detail = [self getDetail];
    
    detail.navigationItem.leftBarButtonItem = nil;
    
    self.pc = nil;
}

#pragma mark - Refresh Handling

- (NSURLSession *)session
{
    if(_session)
    {
        return _session;
    }
    
    /* Create Session Config */
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSString *tmpPath = NSTemporaryDirectory();
    NSString *cachePath = [tmpPath stringByAppendingPathComponent:@"sessiontemp.cache"];
    NSURLCache* sessionCache = [[NSURLCache alloc] initWithMemoryCapacity:16000
                                                             diskCapacity:1024*1024*20
                                                                 diskPath:cachePath];
    
    configuration.URLCache = sessionCache;
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    _session = [NSURLSession sessionWithConfiguration:configuration];
    
    return _session;
}

- (void)handleData:(NSData *)data
{
//    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSError* error = nil;
    NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:&error];
    
    if(!jsonDict)
    {
        NSLog(@"Error parsing: %@", error);
        return ;
    }
    
    NSArray* apoointments = jsonDict[@"appointments"];
    NSMutableArray* tmp = [[NSMutableArray alloc] initWithArray:self.appoinments];
    
    for (NSDictionary* appointment in apoointments) {
        Appointment* app = [Appointment appointmentWithContext:self.managedObjectContext];
        app.subject = appointment[@"subject"];
        app.meetingDate = [NSDate dateWithTimeIntervalSince1970:[appointment[@"meetingTime"] integerValue]];
        app.duration = appointment[@"duration"];
        
        [tmp addObject:app];
    }
    
    error = nil;
    if(![self.managedObjectContext save:&error])
    {
        NSLog(@"Unresolved error: %@", error);
        return ;
    }
    
    [tmp sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Appointment* app1 = obj1;
        Appointment* app2 = obj2;
        
        return [app1.meetingDate compare:app2.meetingDate];
    }];
    
    self.appoinments = tmp;
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                     withObject:nil waitUntilDone:NO];

    
//    [self.session finishTasksAndInvalidate];
}

- (void)fetchDataFromServer {
    NSURL *url = [[NSURL alloc] initWithString:@"http://ftp.quantron-systems.com/public/alexey/appointments.json"];
    
    NSURLSessionTask* task = [self.session dataTaskWithURL:url
                                         completionHandler:
                              ^(NSData *data, NSURLResponse *response, NSError *error) {
                                  if(!error)
                                  {
                                      [self handleData:data];
                                  }
                                  else
                                  {
                                      NSLog(@"%@: %d. %@", error.domain, error.code, error.localizedDescription);
                                      
                                      UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                                                                          message:@"Failed to load data"
                                                                                         delegate:nil
                                                                                cancelButtonTitle:@"OK"
                                                                                otherButtonTitles:nil];
                                      
                                      [alertView performSelectorOnMainThread:@selector(show)
                                                                  withObject:nil
                                                               waitUntilDone:NO];
                                  }
                              }];
    
    //    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    //    request.HTTPMethod = @"POST";
    //    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //    NSString* postBody = @"v=1&cid=a428-83&tid=event";
    //    NSData* postData = [postBody dataUsingEncoding:NSASCIIStringEncoding];
    //    [request setHTTPBody:postData];
    //    
    //    NSURLSessionTask* task = [self.session dataTaskWithRequest:request
    //                                             completionHandler:
    //                              ^(NSData *data, NSURLResponse *response, NSError *error) {
    //                                  <#code#>
    //                              }];
    
    [task resume];
    NSLog(@"Resume call");
}

- (IBAction)onRefreshPressed:(id)sender {
    NSInvocationOperation* op = [[NSInvocationOperation alloc] initWithTarget:self
                                                                     selector:@selector(fetchDataFromServer)
                                                                       object:nil];
    
    op.completionBlock = ^{
        NSLog(@"Refresh Done: %@", [NSThread isMainThread]?@"YES":@"NO");
    };
    
    [self.queue addOperation:op];
}

#pragma mark - Core Data routines

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
