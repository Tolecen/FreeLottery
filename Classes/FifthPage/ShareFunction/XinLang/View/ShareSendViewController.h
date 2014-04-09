//
//  ShareSendViewController.h
//  RuYiCai
//
//  Created by  on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

typedef enum XinLang_shareType
{
    XL_SHARE_DOWN_LOAD = 0,
    XL_SHARE_HM_CASE,
    XL_SHARE_NEWS,
    XL_LOTTERY_OPEN,
}XinLang_shareType;

@class ActivityView;

@interface ShareSendViewController : UIViewController<UITextViewDelegate, SinaWeiboDelegate, SinaWeiboRequestDelegate>
{    
    NSString*      m_shareContent;
    UITextView*    m_contentView;
    
    UILabel*       m_ziNumLabel;
    
    SinaWeibo      *sinaweibo;
}
@property (assign) XinLang_shareType     XinLang_shareType;
@property (nonatomic, retain) NSString*      shareContent;

- (void)refreshZiLabelText;
- (void)SubmitButtonClick:(id)sender;
- (void)SinaHandleOpenURL:(NSNotification*)notification;
- (void)SinaBecomeActive:(NSNotification*)notification;

@end
