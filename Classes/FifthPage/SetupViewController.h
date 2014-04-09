//
//  SetupViewController.h
//  RuYiCai
//
//  Created by ruyicai on 12-6-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuYiCaiAppDelegate.h"

@interface SetupViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    UITableView        *m_myTableView;
 
    RuYiCaiAppDelegate *m_delegate;
}

@property (nonatomic, retain)UITableView        *myTableView;

@end