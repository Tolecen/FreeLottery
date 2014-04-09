//
//  PhoneCardPaymentViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RandomPickerViewController.h"
#import "RuYiCaiAppDelegate.h"

@interface PhoneCardPaymentViewController : UIViewController <RandomPickerDelegate, UITextFieldDelegate> {
    UIButton*           m_cardTypeButton;
    UIButton*           m_cardAmountButton;
    UITextField*        m_cardNoTextField;
    UITextField*        m_cardPasswordTextField;
    
    NSString*           m_cardType;
    NSString*           m_cardAmount;
    RuYiCaiAppDelegate *m_delegate;
}

@property (nonatomic, retain) IBOutlet UIButton* cardTypeButton;
@property (nonatomic, retain) IBOutlet UIButton* cardAmountButton;
@property (nonatomic, retain) IBOutlet UITextField* cardNoTextField;
@property (nonatomic, retain) IBOutlet UITextField* cardPasswordTextField;
@property (nonatomic, retain) NSString* cardType;
@property (nonatomic, retain) NSString* cardAmount;

- (IBAction)hideKeyboard;
- (IBAction)selectCardTypeAction;
- (IBAction)selectCardAmountAction;

@end
