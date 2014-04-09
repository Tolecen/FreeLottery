//
//  DirectPaymentViewController.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-11-8.
//
//

#import <UIKit/UIKit.h>

@interface DirectPaymentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    UITableView        *m_myTabelView;
}
@property (nonatomic, retain) UITableView*  myTabelView;


@end
