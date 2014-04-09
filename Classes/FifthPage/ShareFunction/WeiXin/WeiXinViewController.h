//
//  WeiXinViewController.h
//  Boyacai
//
//  Created by qiushi on 13-3-15.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RuYiCaiAppDelegate.h"

typedef enum WeiXin_shareType
{
    WX_SHARE_DOWN_LOAD = 0,
    WX_SHARE_HM_CASE,
    WX_SHARE_NEWS,
    WX_LOTTERY_OPEN,
}WeiXin_shareType;

@class ActivityView;


@protocol TextViewControllerDelegate
-(void) onCancelText;
-(void) onCompleteText:(NSString*)nsText;
@end

@interface WeiXinViewController : UIViewController<UITextViewDelegate>
{
    NSString*      m_shareContent;
    UITextView*    m_contentView;
    
    UILabel*       m_ziNumLabel;
    id<TextViewControllerDelegate> m_delegate;
    
    ActivityView         *activity_views;
    
//    RuYiCaiAppDelegate   *m_delegate;
    
    NSURLConnection      *connection;
    NSMutableData        *responseData;
}
@property (assign) WeiXin_shareType     WeiXin_shareType;
@property(nonatomic, retain) NSString*      shareContent;
@property(nonatomic, assign) id<TextViewControllerDelegate> m_delegate;

- (void)refreshZiLabelText;
- (void)SubmitButtonClick:(id)sender;

@end