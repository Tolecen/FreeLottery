//
//  AppDelegate.m
//  UIAnimation
//
//  Created by Ibokan on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#import <UIKit/UIKit.h>

typedef CGRect NSRect;
typedef CGSize NSSize;
typedef CGPoint NSPoint;
#else
#import <Cocoa/Cocoa.h>
typedef NSView UIView;
#endif


typedef enum
{
    iCarouselTypeLinear = 0,
    iCarouselTypeRotary,
    iCarouselTypeInvertedRotary,
    iCarouselTypeCylinder,
    iCarouselTypeInvertedCylinder,
    iCarouselTypeCoverFlow,
    iCarouselTypeCoverFlow2,
    iCarouselTypeCustom
}
iCarouselType;


@protocol iCarouselDataSource, iCarouselDelegate;

@interface iCarousel : UIView
#ifdef __i386__
{
    id<iCarouselDelegate> delegate;
    id<iCarouselDataSource> dataSource;
    iCarouselType type;
    CGFloat perspective;
    NSInteger numberOfItems;
    NSInteger numberOfPlaceholders;
	NSInteger numberOfPlaceholdersToShow;
    NSInteger numberOfVisibleItems;
    UIView *contentView;
    NSDictionary *itemViews;
    NSInteger previousItemIndex;
    CGFloat itemWidth;
    CGFloat scrollOffset;
    CGFloat offsetMultiplier;
    CGFloat startVelocity;
    id timer;
    BOOL decelerating;
    BOOL scrollEnabled;
    CGFloat decelerationRate;
    BOOL bounces;
    CGSize contentOffset;
    CGSize viewpointOffset;
    CGFloat startOffset;
    CGFloat endOffset;
    NSTimeInterval scrollDuration;
    NSTimeInterval startTime;
    BOOL scrolling;
    CGFloat previousTranslation;
	BOOL centerItemWhenSelected;
	BOOL shouldWrap;
	BOOL dragging;
    BOOL didDrag;
    CGFloat scrollSpeed;
    CGFloat bounceDistance;
    NSTimeInterval toggleTime;
    CGFloat toggle;
    BOOL stopAtItemBoundary;
    BOOL scrollToItemBoundary;
}
#endif

@property (nonatomic, assign) IBOutlet id<iCarouselDataSource> dataSource;
@property (nonatomic, assign) IBOutlet id<iCarouselDelegate> delegate;
@property (nonatomic, assign) iCarouselType type;
@property (nonatomic, assign) CGFloat perspective;
@property (nonatomic, assign) CGFloat decelerationRate;
@property (nonatomic, assign) CGFloat scrollSpeed;
@property (nonatomic, assign) CGFloat bounceDistance;
@property (nonatomic, assign) BOOL scrollEnabled;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, readonly) CGFloat scrollOffset;
@property (nonatomic, readonly) CGFloat offsetMultiplier;
@property (nonatomic, assign) CGSize contentOffset;
@property (nonatomic, assign) CGSize viewpointOffset;
@property (nonatomic, readonly) NSInteger numberOfItems;
@property (nonatomic, readonly) NSInteger numberOfPlaceholders;
@property (nonatomic, readonly) NSInteger currentItemIndex;
@property (nonatomic, retain, readonly) UIView *currentItemView;
@property (nonatomic, retain, readonly) NSArray *indexesForVisibleItems;
@property (nonatomic, readonly) NSInteger numberOfVisibleItems;
@property (nonatomic, retain, readonly) NSSet *visibleViews __deprecated; // use visibleItemViews instead
@property (nonatomic, retain, readonly) NSArray *visibleItemViews;
@property (nonatomic, readonly) CGFloat itemWidth;
@property (nonatomic, retain, readonly) UIView *contentView;
@property (nonatomic, readonly) CGFloat toggle;
@property (nonatomic, assign) BOOL stopAtItemBoundary;
@property (nonatomic, assign) BOOL scrollToItemBoundary;

- (void)scrollByNumberOfItems:(NSInteger)itemCount duration:(NSTimeInterval)duration;
- (void)scrollToItemAtIndex:(NSInteger)index duration:(NSTimeInterval)duration;
- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)reloadItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (UIView *)itemViewAtIndex:(NSInteger)index;
- (NSInteger)indexOfItemView:(UIView *)view;
- (void)reloadData;
//扩展一个方法
- (void)scrollToItemAtIndex:(NSInteger)index duration:(NSTimeInterval)duration completion:(void (^)(void))completion;

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

@property (nonatomic, assign) BOOL centerItemWhenSelected;

#endif

@end


@protocol iCarouselDataSource <NSObject>

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel;
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index;

@optional

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel;
- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel;

NSInteger compareViewDepth(id obj1, id obj2, void *context);

@end


@protocol iCarouselDelegate <NSObject>

@optional

- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel;
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel;
- (void)carouselDidScroll:(iCarousel *)carousel;
- (void)carouselCurrentItemIndexUpdated:(iCarousel *)carousel;
- (void)carouselWillBeginDragging:(iCarousel *)carousel;
- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate;
- (void)carouselWillBeginDecelerating:(iCarousel *)carousel;
- (void)carouselDidEndDecelerating:(iCarousel *)carousel;
- (CGFloat)carouselItemWidth:(iCarousel *)carousel;
- (CGFloat)carouselOffsetMultiplier:(iCarousel *)carousel;
- (BOOL)carouselShouldWrap:(iCarousel *)carousel;
- (CATransform3D)carousel:(iCarousel *)carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset;

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index;
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index;

#endif

@end