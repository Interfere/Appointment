//
//  Appointment.h
//  Appointment
//
//  Created by Alex Ushakov on 05/12/13.
//  Copyright (c) 2013 Alex Ushakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Appointment : NSObject

@property (nonatomic, strong) NSString *subject;

@property (nonatomic, strong) NSDate *meetingDate;

@property (nonatomic, strong) NSNumber *duration;

+ (instancetype)appointment;

@end
