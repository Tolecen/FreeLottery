//
//  SelecterView.h
//  RuYiCai
//
//  Created by ruyicai on 12-9-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface SelecterView : UIViewController <UITableViewDelegate,UITableViewDataSource> {

    UITableView                *m_tableView;
    UIBarButtonItem            *m_rightTitleBarItem;
 
    int                         m_selectCount;
    int                         m_selectedTag;
    
    NSMutableArray              *m_selectArrayTag;
    NSMutableArray              *m_selectArrayTitle;
    
}
@property (nonatomic, assign) BOOL         isUserEvent;
@property (nonatomic, retain) UITableView *tableView;
 
-(void) appendSelectArray:(NSString*)tag TITLE:(NSString*)title;

@end
