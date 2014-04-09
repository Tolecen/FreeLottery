//
//  InstantScoreCellDetail_JCLQViewController.h
//  RuYiCai
//
//  Created by ruyicai on 12-12-13.
//
//

#import <UIKit/UIKit.h>
 

@interface InstantScoreCellDetail_JCLQViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView                                *m_scollView;
    
    NSString*                                   m_event;
}
@property (nonatomic, retain) NSString *event;
@property (nonatomic, retain) UIScrollView *scollView;

@end