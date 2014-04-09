//
//  XinShouZhiNanViewController.h
//  RuYiCai
//
//  Created by  on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyledPageControl.h"
@interface XinShouZhiNanViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView                    *m_scrollView;
    StyledPageControl               *customPageControl;

}
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) StyledPageControl *customPageControl;

@end
