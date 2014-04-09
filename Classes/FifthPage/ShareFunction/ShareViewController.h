//
//  ShareViewController.h
//  RuYiCai
//
//  Created by  on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "WXApiObject.h"
#import "TextViewController.h"
#import "WXApi.h"

@protocol sendMsgToWeChatViewDelegate <NSObject>
- (void) sendTextContent:(NSString*)nsText;
- (void) sendAppContent;
- (void) sendImageContent;
- (void) sendNewsContent ;
- (void) sendMusicContent ;
- (void) sendVideoContent ;
- (void) sendNonGifContent;
- (void) sendGifContent;
- (void) doAuth;
- (void) changeScene:(NSInteger)scene;
@end

@interface ShareViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate,TextViewControllerDelegate,WXApiDelegate>
{
    UITableView*     m_myTableView;
    NSString* m_nsLastText;
    NSString    *m_shareContent;
    NSString    *m_txShareContent;
    NSString    *m_sinShareContent;
    NSString    *wxTitleStr;
    NSString    *m_pushType;
}
@property(nonatomic, retain)NSString    *pushType;
@property(nonatomic, retain)NSString    *txShareContent;
@property(nonatomic, retain)NSString    *sinShareContent;
@property(nonatomic, retain)NSString    *shareContent;
@property(nonatomic, retain)UITableView*     myTableView;
@property (nonatomic, assign) id<sendMsgToWeChatViewDelegate> delegate;
@property (nonatomic, retain) NSString* m_nsLastText;

- (void)displaySMS:(NSString*)message;
- (void)sendsms:(NSString*)message;

@end
