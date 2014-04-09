//
//  DatePickView.h
//  RuYiCai
//
//  Created by  on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickViewDelegate;

@interface DatePickView : UIView
{
    id<DatePickViewDelegate> delegate;
    UIDatePicker   *m_datePicker;
}

@property (nonatomic, assign) id<DatePickViewDelegate> delegate;

- (void)presentModalView:(NSInteger)PickerMode;
- (void)dismissModalView;
- (void)pressedCancel;
- (void)pressedOK;

@end

@protocol DatePickViewDelegate

- (void)randomPickerView:(DatePickView*)randomPickerView selectDate:(NSDate*)selectDate;
- (void)cancelPickView:(DatePickView*)randomPickerView;

@end