//
//  AgainTrackViewController.h
//  RuYiCai
//
//  Created by  on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgainTrackViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UITableView           *m_myTableView;
    UITextField           *m_againTrackBatchField;
    UITextField           *m_againTrackBeiField;
    
    NSString*             m_startBatch;
    
    NSString*             m_lotNo;
    NSString*             m_lotName;
    NSString*             m_oneAmount;
    NSString*             m_zhuShu;
}

@property(nonatomic, retain) UITableView           *myTableView;
@property(nonatomic, retain) NSString*             lotNo;
@property(nonatomic, retain) NSString*             lotName;
@property(nonatomic, retain) NSString*             oneAmount;
@property(nonatomic, retain) NSString*             startBatch;
@property(nonatomic, retain) NSString*             zhuShu;

- (void)updateInformation:(NSNotification*)notification;
- (void)okClick:(id)sender;
- (void)betCompleteOK:(NSNotification*)notification;

@end
