//
//  bankChargeViewController.h
//  RuYiCai
//
//  Created by  on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RandomPickerViewController.h"
#import "RuYiCaiAppDelegate.h"
//#import "LTInterface.h"

//@interface bankChargeViewController : UIViewController<RandomPickerDelegate, LTInterfaceDelegate>
@interface bankChargeViewController : UIViewController<RandomPickerDelegate>
{
    RuYiCaiAppDelegate *m_delegate;
    NSInteger          bankNo;
    
    NSInteger          recodeButton;
}

@property(nonatomic, retain)IBOutlet UITextField* amountField;
@property(nonatomic, retain)IBOutlet UIButton*    bankButton;
@property(nonatomic, retain)IBOutlet UIButton*    bankTypeButton;
@property(nonatomic, retain) NSMutableArray*     allBankNameArr;
@property(nonatomic, retain) NSMutableArray*     allBankTypeArr;//存的是字典


- (IBAction)bankButtonClick:(id)sender;
- (IBAction)bankTypeButtonClick:(id)sender;

@end
