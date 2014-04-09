//
//  CustomeUserAlertView.h
//  Boyacai
//
//  Created by qiushi on 13-9-24.
//
//
#import <Foundation/Foundation.h>

#import "CustomizedAlertAnimation.h"

@protocol CustomeAlertViewDelegate ;



@interface CustomeUserAlertView : UIWindow  <CustomizedAlertAnimationDelegate>

@property(strong,nonatomic)UIView *myView;

@property(strong,nonatomic)UIActivityIndicatorView *activityIndicator;


@property(strong,nonatomic)CustomizedAlertAnimation *animation;

@property(assign,nonatomic)id<CustomeAlertViewDelegate> delegate;
-(void)show;
@end


@protocol CustomeAlertViewDelegate

-(void)CustomeAlertViewDismiss:(CustomeUserAlertView *) alertView;

@end