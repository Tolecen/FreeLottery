//
//  ChangeViewController.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-11-8.
//
//

#import <UIKit/UIKit.h>

@interface ChangeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView        *m_myTabelView;
    
    int                 m_didSelectRow;
}
@property (nonatomic, retain) UITableView*  myTabelView;

@end
