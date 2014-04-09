//
//  UserBindDetileVC.h
//  Boyacai
//
//  Created by qiushi on 13-9-26.
//
//
#import <UIKit/UIKit.h>

@interface SettingNicknameVC : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    
    UITextField*  m_oldPswTextField;
    UITextField*  m_newPswTextField1;
    UITextField*  m_newPswTextField2;
}


@end
