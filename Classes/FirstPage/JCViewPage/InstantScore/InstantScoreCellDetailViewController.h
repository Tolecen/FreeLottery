//
//  InstantScoreCellDetailViewController.h
//  RuYiCai
//
//  Created by ruyicai on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstantScoreCellDetailViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView                                *m_scollView;

    NSString*                                   m_event;
    int                                         m_lotType;//区别竞彩和北单  0  竞彩；1   北单
}
@property (nonatomic, retain) NSString *event;
@property (nonatomic, retain) UIScrollView *scollView;
@property (nonatomic, assign) int lotType;

@end
