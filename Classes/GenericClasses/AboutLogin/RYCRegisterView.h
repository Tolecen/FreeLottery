//
//  RYCRegisterView.h
//  RuYiCai
//
//  Created by  on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYCRegisterView : UIViewController <UITextFieldDelegate>
{
    UIView           *protocolView;
    UINavigationBar  *m_navgationBarReg;
    UIButton         *_commiteRegisterButton;
    UIView           *_commitProtcolView;
}
@property(nonatomic, retain) IBOutlet  UILabel      *navgationTitleLable;
@property(nonatomic, retain) IBOutlet  UIView       *navgationView;
@property(nonatomic, retain) IBOutlet  UIButton*    goBackBtn;


@property(nonatomic, retain) IBOutlet  UINavigationBar *navgationBarReg;
@property(nonatomic, retain) IBOutlet  UIScrollView*   myScrollView;

@property(nonatomic, retain) IBOutlet  UITextField*    m_registerPhonenumTextField;
@property(nonatomic, retain) IBOutlet  UITextField*    m_registerPswTextField;
@property(nonatomic, retain) IBOutlet  UITextField*    m_registerCertidTextField;
@property(nonatomic, retain) IBOutlet  UITextField*    m_registerNameTextField;
@property(nonatomic, retain) IBOutlet  UITextField*    m_registerSurePswTextField;
@property(nonatomic, retain) IBOutlet  UITextField*    m_registerRecNameTextField;

@property(nonatomic, retain) IBOutlet  UISwitch*       bCertid;
@property(nonatomic, retain) IBOutlet  UISwitch*       recNameSwitch;
@property(nonatomic, retain) IBOutlet  UISwitch*       recommendNameSwitch;

@property(nonatomic, retain) IBOutlet  UIScrollView*   certIdView;
@property(nonatomic, retain) IBOutlet  UIScrollView*   recNameView;

- (IBAction)backButtonClick:(id)sender;

- (IBAction)bCertidButtonClick:(id)sender;
- (IBAction)recNameSwitchChange:(id)sender;

- (IBAction)sureButtonClick:(id)sender;
- (IBAction)protocolButtonClick:(id)sender;

@end
