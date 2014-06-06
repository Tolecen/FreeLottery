//
//  sharePlatformView.h
//  PetGroup
//
//  Created by wangxr on 13-12-19.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class sharePlatformView;
@protocol sharePlatformViewDelegate <NSObject>
-(void)sharePlatformView:(sharePlatformView*)shareView PressButtonWithIntage:(NSInteger)integer;
@end
@interface sharePlatformView : UIView
@property (nonatomic,assign)id<sharePlatformViewDelegate>delegate;
- (id)initWithView:(UIViewController*)viewC;
-(void)showSharePlatformView;
-(void)canclesharePlatformView;
@end
