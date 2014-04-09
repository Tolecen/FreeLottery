//
//  NewsViewController.h
//  RuYiCai
//
//  Created by  on 12-2-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextViewController.h"
#import <MessageUI/MessageUI.h>

@interface NewsViewController : UIViewController <TextViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    UIButton*        m_shareButton;
    NSString         *m_nsLastText;
    NSString         *m_newsTitle;
}
@property(nonatomic, retain)NSString         *newsTitle;
@property(nonatomic, retain)NSString*        shareURL;
@property (nonatomic, assign) id             delegate;
//- (void)refreshView;
- (void)setMainView;

- (void)setShareButton;
- (void)shareButtonClick:(id)sender;
- (void)sinaButtonClick:(id)sender;
- (void)tengXunButtonClick:(id)sender;

@end
