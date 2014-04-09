//
//  ZJJHViewController.h
//  RuYiCai
//
//  Created by  on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ZJJHViewController : UIViewController<UIAlertViewDelegate, MFMessageComposeViewControllerDelegate>
{
    UIButton                   *m_backButton;
    
    UISegmentedControl         *m_segmented;
    
    UIScrollView               *m_scrollViewOne;
    UIScrollView               *m_scrollViewTwo;
    UIScrollView               *m_scrollViewThere;
    UIScrollView               *m_scrollViewFour;
    
    NSInteger                  m_startY;
    NSInteger                  m_curIndex;
    NSMutableArray             *m_titleDataArrayOne;
    NSMutableArray             *m_titleDataArrayTwo;
    NSMutableArray             *m_titleDataArrayThere;
    NSMutableArray             *m_titleDataArrayFour;

    BOOL                       isScrollTwo;
    BOOL                       isScrollThere;
    BOOL                       isScrollFour;
    
    NSInteger                  clickButtonTag;
}
@property (nonatomic, retain) NSMutableArray      *titleDataArrayOne;
@property (nonatomic, retain) NSMutableArray      *titleDataArrayTwo;
@property (nonatomic, retain) NSMutableArray      *titleDataArrayThere;
@property (nonatomic, retain) NSMutableArray      *titleDataArrayFour;


@end
