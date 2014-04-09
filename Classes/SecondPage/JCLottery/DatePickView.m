//
//  DatePickView.m
//  RuYiCai
//
//  Created by  on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DatePickView.h"

@implementation DatePickView

@synthesize delegate;

- (void)dealloc 
{
    
    [m_datePicker release];
    
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//        [imageView setBackgroundColor:[UIColor blackColor]];
//        imageView.alpha = 0.7f;
//        [self addSubview:imageView];
//        [imageView release];
        
//        self.backgroundColor = [UIColor yellowColor];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:self
                                                                        action:@selector(pressedCancel)];
        UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:self
                                                                        action:@selector(pressedOK)];
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 324, 320, 44)];
        [toolbar setItems:[NSArray arrayWithObjects:cancelButton, submitButton, nil] animated:YES];
        [self addSubview:toolbar];
        [toolbar release];
        [cancelButton release];
        [submitButton release];
        
        m_datePicker = [[UIDatePicker alloc] init];
        [m_datePicker setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
        m_datePicker.backgroundColor = [UIColor whiteColor];
        m_datePicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 280, 320, 236);
//        m_datePicker.timeZone = [NSTimeZone defaultTimeZone];
        m_datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
//        m_datePicker.datePickerMode = UIDatePickerModeDate;
        [self addSubview:m_datePicker];
    }
    return self;
}

- (void)presentModalView:(NSInteger)PickerMode
{
    m_datePicker.datePickerMode = PickerMode;
    
	[UIView beginAnimations:@"movement" context:nil]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationRepeatCount:1];
	[UIView setAnimationRepeatAutoreverses:NO];
	CGPoint center = self.center;
	center.y -= [UIScreen mainScreen].bounds.size.height;
	self.center = center;
	[UIView commitAnimations];
}

- (void)dismissModalView
{		
	[UIView beginAnimations:@"movement" context:nil]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationRepeatCount:1];
	[UIView setAnimationRepeatAutoreverses:NO];
	CGPoint center = self.center;
	center.y += [UIScreen mainScreen].bounds.size.height;
	self.center = center;
	[UIView commitAnimations];
}

- (void)pressedCancel 
{
    [delegate cancelPickView:self];
	[self dismissModalView];
}

- (void)pressedOK
{	
	[delegate randomPickerView:self selectDate:m_datePicker.date];
	[self dismissModalView];	
}

@end

