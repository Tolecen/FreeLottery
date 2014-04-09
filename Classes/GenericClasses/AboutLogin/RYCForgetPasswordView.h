//
//  RYCForgetPasswordView.h
//  RuYiCai
//
//  Created by  on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomColorButtonUtils;
@interface RYCForgetPasswordView : UINavigationController <UITextFieldDelegate>


@property (nonatomic, retain) UITextField  *userNameField;
@property (nonatomic, retain) UITextField  *phoneNumField;
@property (nonatomic, retain) CustomColorButtonUtils *findButton;

- (void)backButtonClick:(id)sender;
- (void)findButtonClick:(id)sender;
- (void)findPswOK:(NSNotification*)notification;

@end
