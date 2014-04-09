//
//  DaiLiChargeViewController.h
//  RuYiCai
//
//  Created by  on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaiLiChargeViewController : UIViewController<UITextFieldDelegate>
{
    UITextField*    m_accountField;
    UITextField*    m_amountField;
    UITextField*    m_passwordField;
    
    UILabel*        m_tiXianAmountLabel;
}

- (void)okClick;
- (void)querySampleNetOK:(NSNotification*)notification;
@end
