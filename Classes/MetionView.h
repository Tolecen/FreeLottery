//
//  MetionView.h
//  Boyacai
//
//  Created by wangxr on 14-6-10.
//
//

#import <UIKit/UIKit.h>

@interface MetionView : UIView
- (id)initWithView:(UIViewController*)viewC;
-(void)showSharePlatformView;
- (void)showInfoText:(NSString*)infoString;
-(void)canclesharePlatformView;
@end
