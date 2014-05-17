//
//  InterestSignInViewController.h
//  Boyacai
//
//  Created by wangxr on 14-5-12.
//
//

#import <UIKit/UIKit.h>
@class InterestSignInViewController;
@protocol  InterestSignInViewControllerDelegate<NSObject>
- (void)interestSignInViewControllerDidCancel:(InterestSignInViewController*)viewC;
@end
@interface InterestSignInViewController : UIViewController
@property (nonatomic,retain)NSString* ActID;
@property (nonatomic,assign)id<InterestSignInViewControllerDelegate> delegate;
@end
