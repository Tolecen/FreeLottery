//
//  HelpContentViewController.h
//  RuYiCai
//
//  Created by  on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpContentViewController : UIViewController
{
    UITextView*         m_contentView;
    
    NSString*           m_contentId;
    NSString*           m_contentTitle;
}

@property(nonatomic, assign) NSString*       contentId;
@property(nonatomic, retain)NSString *       contentTitle;
- (void)queryHelpContentOK:(NSNotification*)notification;

@end
