//
//  Passport.h
//  Appointment
//
//  Created by Alex Ushakov on 02/12/13.
//  Copyright (c) 2013 Alex Ushakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Passport : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *surname;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *jobTitle;

@end
