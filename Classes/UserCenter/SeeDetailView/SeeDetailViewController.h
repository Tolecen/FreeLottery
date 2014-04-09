//
//  SeeDetailViewController.h
//  RuYiCai
//
//  Created by  on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


//typedef enum 
//{
//    DETAIL_LOT_WIN = 0,
//} DetailViewType;

@interface SeeDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
//    DetailViewType        m_detailType;
    
    UITableView           *m_myTableView;
    
    NSMutableArray        *m_contentArray;//进行了释放，因此使用copy传递
}

@property(nonatomic, retain) NSMutableArray        *contentArray;
@property(nonatomic, retain) UITableView           *myTableView;

- (void)setUpTopView;

@end
