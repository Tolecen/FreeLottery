//
//  QueryUserBalanceViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryUserBalanceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSString* m_balance;
    NSString* m_drawBalance;
    NSString* m_freezeBalance;
    NSString* m_betBalance;
    
    UITableView*      m_myTableView;
}

@property (nonatomic, retain) NSString* balance;
@property (nonatomic, retain) NSString* drawBalance;
@property (nonatomic, retain) NSString* betBalance;
@property (nonatomic, retain) NSString* freezeBalance;

@property (nonatomic, retain) UITableView* myTableView;

@end
