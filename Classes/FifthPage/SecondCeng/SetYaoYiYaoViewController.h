//
//  SetYaoYiYaoViewController.h
//  RuYiCai
//
//  Created by ruyicai on 12-12-5.
//
//
 
#import <UIKit/UIKit.h>
#import "RuYiCaiAppDelegate.h"

@interface SetYaoYiYaoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    UITableView        *m_myTableView;
    
    RuYiCaiAppDelegate *m_delegate;
}

@property (nonatomic, retain)UITableView        *myTableView;

@end