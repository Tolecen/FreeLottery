//
//  ActivityView.h
//  RuYiCai
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ActivityView : UIView
@property (nonatomic,retain)UILabel*  titleLabel;
- (void)activityViewShow;
- (void)disActivityView;

@end
