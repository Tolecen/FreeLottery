//
//  AccountDetailView.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountDetailView : UIView {
    UILabel*   m_memoLabel;
    UILabel*   m_platTimeLabel;
    UILabel*   m_amountLabel;
    
    NSString*  m_amt;
    NSString*  m_drawAmt;
    NSString*  m_blsign;
    NSString*  m_ttransactionType;
    NSString*  m_memo;
    NSString*  m_balance;
    NSString*  m_drawamtBalance;
    NSString*  m_platTime;
}

@property (nonatomic, retain) NSString* amt;
@property (nonatomic, retain) NSString* drawAmt;
@property (nonatomic, retain) NSString* blsign;
@property (nonatomic, retain) NSString* ttransactionType;
@property (nonatomic, retain) NSString* memo;
@property (nonatomic, retain) NSString* balance;
@property (nonatomic, retain) NSString* drawamtBalance;
@property (nonatomic, retain) NSString* platTime;

- (void)refreshView;

@end
