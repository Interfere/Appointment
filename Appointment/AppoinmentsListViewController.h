//
//  AppoinmentsListViewController.h
//  Appointment
//
//  Created by Alex Ushakov on 05/12/13.
//  Copyright (c) 2013 Alex Ushakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppoinmentsListViewController : UITableViewController <UISplitViewControllerDelegate>

@property (nonatomic, strong) NSArray* appoinments;

@end
