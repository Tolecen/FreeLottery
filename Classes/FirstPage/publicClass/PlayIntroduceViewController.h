//
//  PlayIntroduceViewController.h
//  RuYiCai
//
//  Created by  on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayIntroduceViewController : UIViewController

@property(nonatomic, retain)NSString*    lotNo;

- (void)querySampleNetOK:(NSNotification*)notification;
- (void)setMainView;

@end
