//
//  Appointment.m
//  Appointment
//
//  Created by Alex Ushakov on 05/12/13.
//  Copyright (c) 2013 Alex Ushakov. All rights reserved.
//

#import "Appointment.h"

@implementation Appointment

@dynamic subject;
@dynamic meetingDate;
@dynamic duration;

+ (instancetype)appointmentWithContext:(NSManagedObjectContext *)ctx
{
    return [NSEntityDescription insertNewObjectForEntityForName:@"Appointments" inManagedObjectContext:ctx];
}

@end
