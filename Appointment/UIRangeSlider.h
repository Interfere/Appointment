//
//  UIRangeSlider.h
//  Appointment
//
//  Created by Alex Ushakov on 11/12/13.
//  Copyright (c) 2013 Alex Ushakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIRangeSlider : UIControl

@property(nonatomic) float minimumValue;
@property(nonatomic) float maximumValue;
@property(nonatomic) float minimumRange;
@property(nonatomic) float selectedMinimumValue;
@property(nonatomic) float selectedMaximumValue;

@end
