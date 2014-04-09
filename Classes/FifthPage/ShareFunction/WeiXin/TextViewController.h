//
//  TextViewController.h
//  MicroMessenger
//
//  Created by Tencent on 12-3-21.
//  Copyright 2012 Tecent. All rights reserved.
//

#import "WXApi.h"

@protocol TextViewControllerDelegate
-(void) onCancelText;
-(void) onCompleteText:(NSString*)nsText;
@end

@interface TextViewController : UIViewController<UITextViewDelegate,WXApiDelegate> {
	UITextView *m_textView;
	id<TextViewControllerDelegate> m_delegate;
	UILabel*    m_wordCountLabel;
    NSString*   m_nsLastText;
    NSString     *m_titleStr;
}

@property (nonatomic,assign) id<TextViewControllerDelegate> m_delegate;
@property (nonatomic,retain) NSString* m_nsLastText;
@property (nonatomic,retain) NSString  *titleStr;

@end
