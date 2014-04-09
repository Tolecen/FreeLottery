//
//  MoreBetListViewController.h
//  RuYiCai
//
//  Created by  on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreBetListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView        *m_myTableView;
    
    UILabel            *m_inforBetLabel;
    
    NSInteger          m_zhuShu;
    NSInteger          m_allAmount;
    
    UIScrollView*      bottomView;
}

@property(nonatomic, retain) UITableView        *myTableView;
@property(nonatomic, assign) NSInteger          zhuShu;
@property(nonatomic, assign) NSInteger          allAmount;

@end
