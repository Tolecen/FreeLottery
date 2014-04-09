//
//  TopAnimationView.h
//  Boyacai
//
//  Created by qiushi on 13-8-13.
//
//

#import <UIKit/UIKit.h>

@class TopAnimationView;
@protocol TopAnimationViewDelegate <NSObject>

- (void)topAnimationView:(TopAnimationView *)topAnimationView didSelectItemAtIndex:(NSUInteger)index;

@end

@interface TopAnimationView : UIView

{
    id      _delegate;
}




@property (nonatomic, assign) id<TopAnimationViewDelegate> delegate;

//自定义 TopAnimationView 根据titile，创建动态的按钮个数
- (id)initWithFrame:(CGRect)frame andNormalTitles:(NSArray *)normalTitles;
- (void)thatButtonSelect:(int)index;

@end





