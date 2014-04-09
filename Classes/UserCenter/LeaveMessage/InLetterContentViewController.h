//
//  InLetterContentViewController.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-12-19.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface InLetterContentViewController : UIViewController<UIWebViewDelegate>
{
    NSString*  m_inTitle;
    NSString*  m_content;
}

@property(nonatomic, retain)NSString*  inTitle;
@property(nonatomic, retain)NSString*  content;
@end
