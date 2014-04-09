//
//  ChangePassViewController.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-12-11.
//
//

#import <UIKit/UIKit.h>

@interface BindPhoneViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    
    UITextField*  m_oldPswTextField;
    UITextField*  m_newPswTextField1;
    UITextField*  m_newPswTextField2;
}


@end
