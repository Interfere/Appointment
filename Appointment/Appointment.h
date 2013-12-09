//
//  Appointment.h
//  Appointment
//
//  Created by Alex Ushakov on 05/12/13.
//  Copyright (c) 2013 Alex Ushakov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Appointment : NSManagedObject

@property (nonatomic, strong) NSString *subject;

@property (nonatomic, strong) NSDate *meetingDate;

@property (nonatomic, strong) NSNumber *duration;

+ (instancetype)appointmentWithContext:(NSManagedObjectContext *)ctx;

@end
