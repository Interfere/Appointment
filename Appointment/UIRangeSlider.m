//
//  UIRangeSlider.m
//  Appointment
//
//  Created by Alex Ushakov on 11/12/13.
//  Copyright (c) 2013 Alex Ushakov. All rights reserved.
//

#import "UIRangeSlider.h"

@interface UIRangeSlider ()

//- (void)updateTrackHighlight;

@end

@implementation UIRangeSlider
{
    BOOL _maxThumbOn;
    BOOL _minThumbOn;
    
    float _padding;
    
    UIImageView * _minThumb;
    UIImageView * _maxThumb;
    UIImageView * _track;
    UIImageView * _trackBackground;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /*
        _minThumbOn = NO;
        _maxThumbOn = NO;
        
        UIImage* _trackBackgroundImage = [UIImage imageNamed:@"bar-background.png"];
        _trackBackground = [[UIImageView alloc] initWithImage:_trackBackgroundImage];
        _padding = (frame.size.width - _trackBackgroundImage.size.width)/2;
        
        _trackBackground.frame = CGRectMake(
                _padding,
                (frame.size.height - _trackBackgroundImage.size.height)/2,
                _trackBackgroundImage.size.width,
                _trackBackgroundImage.size.height
        );
        [self addSubview:_trackBackground];
        
        UIImage* _trackImage = [UIImage imageNamed:@"bar-highlight.png"];
        _track = [[UIImageView alloc] initWithImage:_trackImage];
        _track.frame = CGRectMake(
                 _padding,
                 (frame.size.height - _trackImage.size.height)/2,
                 _trackImage.size.width,
                 _trackImage.size.height
        );
        [self addSubview:_track];
        
        UIImage* _thumbImage = [UIImage imageNamed:@"handle.png"];
        UIImage* _thumbHoverImage = [UIImage imageNamed:@"handle-hover.png"];
        
        _minThumb = [[UIImageView alloc] initWithImage:_thumbImage highlightedImage:_thumbHoverImage];
        _minThumb.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
        _minThumb.contentMode = UIViewContentModeCenter;
        [self addSubview:_minThumb];
        
        _maxThumb = [[UIImageView alloc] initWithImage:_thumbImage highlightedImage:_thumbHoverImage];
        _maxThumb.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
        _maxThumb.contentMode = UIViewContentModeCenter;
        [self addSubview:_maxThumb];
         */
    }
    return self;
}

/*
-(CGFloat)xForValue:(float)value
{
    return (self.frame.size.width-(_padding*2))*((value - _minimumValue) / (_maximumValue - _minimumValue))+_padding;
}
*/

/*
-(float)valueForX:(CGFloat)x
{
    return (_maximumValue - _minimumValue) * (x - _padding) / (self.bounds.size.width - 2 * _padding) + _minimumValue;
}
*/

/*
-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    if(CGRectContainsPoint(_minThumb.frame, touchPoint)){
        _minThumbOn = YES;
        [_minThumb setHighlighted:YES];
    }else if(CGRectContainsPoint(_maxThumb.frame, touchPoint)){
        _maxThumbOn = YES;
        [_maxThumb setHighlighted:YES];
    }
    return YES;
}
*/

/*
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    _minThumbOn = NO;
    _maxThumbOn = NO;
    [_minThumb setHighlighted:NO];
    [_maxThumb setHighlighted:NO];
}
*/

/*
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(!_minThumbOn && !_maxThumbOn){
        return YES;
    }
    
    CGPoint touchPoint = [touch locationInView:self];
    float value = [self valueForX:touchPoint.x];
    if(_minThumbOn){
        _selectedMinimumValue = MAX(MIN(value, _selectedMaximumValue - _minimumRange), _minimumValue);
    }
    if(_maxThumbOn){
        _selectedMaximumValue = MIN(MAX(value, _selectedMinimumValue + _minimumRange), _maximumValue);
    }
    [self setNeedsLayout];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}
*/

@end
