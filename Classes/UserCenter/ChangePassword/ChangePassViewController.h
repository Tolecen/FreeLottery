//
//  ChangePassViewController.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-12-11.
//
//

#import <UIKit/UIKit.h>

@interface ChangePassViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    UITableView*  m_myTableView;
    
    UITextField*  m_oldPswTextField;
    UITextField*  m_newPswTextField1;
    UITextField*  m_newPswTextField2;
}

@property(nonatomic, retain)UITableView*  myTableView;

@end
