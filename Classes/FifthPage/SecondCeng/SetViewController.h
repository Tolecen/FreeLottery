//
//  SetViewController.h
//  RuYiCai
//
//  Created by  on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView*    m_myTableView;
}

@property (nonatomic, retain)UITableView*    myTableView;

@end
