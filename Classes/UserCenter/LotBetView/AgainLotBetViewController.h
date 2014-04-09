//
//  AgainLotBetViewController.h
//  RuYiCai
//
//  Created by  on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgainLotBetViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UITableView           *m_myTableView;
    UITextField           *m_againBetBeiField;
    
    NSString*             m_startBatch;
    
    NSString*             m_lotNo;
    NSString*             m_lotName;
    NSString*             m_amount;
    NSString*             m_contentStr;
}
@property(nonatomic, retain) UITableView           *myTableView;
@property(nonatomic, retain) NSString*             startBatch;
@property(nonatomic, retain) NSString*             lotNo;
@property(nonatomic, retain) NSString*             lotName;
@property(nonatomic, retain) NSString*             amount;
@property(nonatomic, retain) NSString*             contentStr;

- (void)updateInformation:(NSNotification*)notification;
- (void)okClick:(id)sender;
- (void)betCompleteOK:(NSNotification*)notification;
- (BOOL)beiShuFieldCheck;

@end
