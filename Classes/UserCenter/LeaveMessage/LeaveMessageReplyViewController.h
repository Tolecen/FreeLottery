//
//  LeaveMessageReplyViewController.h
//  RuYiCai
//
//  Created by  on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaveMessageReplyViewController : UIViewController
{
    UILabel      *m_timeLabel;
    UILabel      *m_contentLabel;
    UITextView   *m_replyView;
    NSInteger    rowIndex;
    
    NSArray*     m_contentArray;
}

@property (nonatomic, retain)UILabel     *timeLabel;
@property (nonatomic, retain)UILabel     *contentLabel;
@property (nonatomic, retain)UITextView  *replyView;
@property (nonatomic, assign)NSInteger   rowIndex;
@property (nonatomic, retain)NSArray     *contentArray;

- (void)setMainView;

@end
