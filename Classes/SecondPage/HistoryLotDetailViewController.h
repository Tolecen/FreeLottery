//
//  HistoryLotDetailViewController.h
//  RuYiCai
//
//  Created by  on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface HistoryLotDetailViewController : UIViewController <MFMessageComposeViewControllerDelegate>
{
    NSString*         m_lotTitle;
    NSString*         m_lotNo;
    NSString*         m_batchCode;
    
    UIButton*        m_shareButton;
    NSString        *m_nsLastText;
}
@property (nonatomic, assign) id               delegate;
@property(nonatomic, retain)NSString*         lotTitle;
@property(nonatomic, retain)NSString*         nsLastText;
@property(nonatomic, retain)NSString*         lotNo;
@property(nonatomic, retain)NSString*         batchCode; 

- (void)GetLotteryDetailOK:(NSNotification*)notification;
- (void)setGoToLotteryView;
- (void)setShareButton;

- (void)displaySMS:(NSString*)message;
- (void)sendsms:(NSString*)message;

@end
