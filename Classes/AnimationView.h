//
//  AnimationView.h
//  Boyacai
//
//  Created by wangxr on 14-5-13.
//
//

#import <UIKit/UIKit.h>

@interface AnimationView : UIView
@property (nonatomic,retain)NSArray* subviewsArray;
@property (nonatomic,readonly)BOOL animation;
@property (nonatomic,assign)BOOL sound;
- (void)setNeedStop: (BOOL)stop;
- (void)starAnimation;
- (void)stopAnimationWithSubviewsLocation:(NSInteger)location completion:(void (^)(void))completion;
- (void)showCardWithTitle:(NSString*)title content:(NSString*)content Target:(id)target action:(SEL)action;
@end
