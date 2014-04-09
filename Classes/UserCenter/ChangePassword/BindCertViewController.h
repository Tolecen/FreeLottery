//
//  BindCertViewController.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-12-11.
//
//

#import <UIKit/UIKit.h>

@interface BindCertViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    UITableView*  m_myTableView;
    
    UITextField     *m_bindCertidField;
    UITextField     *m_bindTrueNameField;
}
@property(nonatomic, retain)UITableView*  myTableView;

@end
