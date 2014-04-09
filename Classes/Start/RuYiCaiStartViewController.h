//
//  RuYiCaiStartViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-8-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuYiCaiStartView.h"
#import "RuYiCaiAppDelegate.h"

@interface RuYiCaiStartViewController : UIViewController {
	RuYiCaiStartView *m_startView;
    RuYiCaiAppDelegate *m_delegate;
}

- (void)showLoading:(id)sender;

@end
