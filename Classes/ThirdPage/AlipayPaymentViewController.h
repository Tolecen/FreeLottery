//
//  AlipayPaymentViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuYiCaiAppDelegate.h"

@interface AlipayPaymentViewController : UIViewController {
    UITextField*        m_amountTextField;
    RuYiCaiAppDelegate *m_delegate;
}

@property (nonatomic, retain) IBOutlet UITextField* amountTextField;

- (IBAction)hideKeyboard;

@end
