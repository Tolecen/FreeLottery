//
//  InterestSignInViewController.h
//  Boyacai
//
//  Created by wangxr on 14-5-12.
//
//

#import <UIKit/UIKit.h>
@protocol  InterestSignInViewControllerDelegate<NSObject>
- (void)interestSignInViewControllerDidCancel;
@end
@interface InterestSignInViewController : UIViewController
@property (nonatomic,retain)NSString* ActID;
@property (nonatomic,assign)id<InterestSignInViewControllerDelegate> delegate;
@end
