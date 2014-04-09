//
//  LaKaLaChargeViewController.h
//  RuYiCai
//
//  Created by ruyicai on 12-9-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaKaLaChargeViewController : UIViewController
{
    UITextField*       m_amountField;
}

@property (nonatomic ,retain)UITextField* amountField;
- (void)payButtonClick:(id)sender;
- (void)queryLaKaLaChargeOK:(NSNotification*)notifition;
//- (void)queryLaKaLaChargeWarnStrOK:(NSNotification*)notifition;
//- (void)backNotification:(NSNotification*)notification;
@end
