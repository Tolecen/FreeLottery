//
//  ActionCenterDetailViewController.h
//  RuYiCai
//
//  Created by  on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionCenterDetailViewController : UIViewController
{
    NSString *m_activityId;
    NSString *m_activityTime;
    NSString *m_pushType;
}
@property (nonatomic, retain) NSString *activityId;
@property (nonatomic, retain) NSString *activityTime;
@property (nonatomic, retain) NSString *pushType;

- (void)GetActivityContentOK:(NSNotification*)notification;

@end
