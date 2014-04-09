//
//  LuckListViewController.h
//  RuYiCai
//
//  Created by  on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LuckListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UIScrollView*       m_mainScrollView;

    NSInteger           m_randomNum;
    UITableView*        m_randomTableView;
    
    NSString*           m_lotTitle;
    NSString*           m_lotNo;
    NSMutableArray     *m_randomDataArray; 
    
    NSString*           m_batchCode;
    NSString*           m_batchEndTime;
    
}

@property(nonatomic, assign)NSInteger           m_randomNum;
@property(nonatomic, retain)UITableView*        randomTableView;
@property(nonatomic, retain)NSString*           lotTitle;
@property(nonatomic, retain)NSString*           lotNo;
@property(nonatomic, retain)NSMutableArray     *randomDataArray;
@property (nonatomic, retain) NSString* batchCode;
@property (nonatomic, retain) NSString* batchEndTime;

- (void)listTableView;
- (void)OKButttonClick;
- (void)updateInformation:(NSNotification*)notification;//期号
- (void)submitLotNotification:(NSNotification*)notification;
- (void)betNormal:(NSNotification*)notification;
- (void)deleteRandomBallCell:(NSNotification*)notification;

@end
