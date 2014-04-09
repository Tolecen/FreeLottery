//
//  GiftWordTableViewController.h
//  RuYiCai
//
//  Created by  on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftWordTableViewController : UIViewController< UITableViewDelegate,UITableViewDataSource>
{
    UITableView   *m_tableView;
	
	NSMutableArray       *m_giftMessage;
    
}

@property(nonatomic, retain) UITableView            *tableView;
@property(nonatomic, retain) NSMutableArray                *giftMessage;

@end
