//
//  TengXunSendViewController.h
//  RuYiCai
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RuYiCaiAppDelegate.h"

typedef enum TengXun_shareType
{
    TX_SHARE_DOWN_LOAD = 0,
    TX_SHARE_HM_CASE,
    TX_SHARE_NEWS,
    TX_LOTTERY_OPEN,
}TengXun_shareType;

@class ActivityView;

@interface TengXunSendViewController : UIViewController<UITextViewDelegate>
{
    NSString*      m_shareContent;
    UITextView*    m_contentView;

    UILabel*       m_ziNumLabel;

    ActivityView         *activity_views;
    
    RuYiCaiAppDelegate   *m_delegate;
    
    NSURLConnection      *connection;
    NSMutableData        *responseData;
}
@property (assign) TengXun_shareType     TengXun_shareType;
@property(nonatomic, retain) NSString*      shareContent;

- (void)refreshZiLabelText;
- (void)SubmitButtonClick:(id)sender;

@end
