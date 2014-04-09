//
//  FeedBackViewController.h
//  RuYiCaiiPad
//
//  Created by  on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
{
    UITextView   *m_leaveMess;
    UITextField  *m_contactWay;
    UITextField  *m_qNumTextField;
    NSString     *m_userNamePhone;
    UILabel      *ploachodlLable;
    NSString     *proposalStr;
    NSString     *m_bindPhone;
    BOOL            *m_isPushHid;
}
@property (nonatomic, assign) BOOL            *isPushHid;

@property (nonatomic,retain) NSString   *bindPhone;
@property (nonatomic,retain) NSString   *proposalStr;
@property (nonatomic,retain) NSString   *userNamePhone;
- (void)setMainView;
- (void)okClick;
- (void)feedBackOK:(NSNotification *)notification;

@end
