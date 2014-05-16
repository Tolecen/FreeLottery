//
//  AnimationView.m
//  Boyacai
//
//  Created by wangxr on 14-5-13.
//
//

#import "AnimationView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "iCarousel.h"
@interface AnimationView ()<iCarouselDataSource,iCarouselDelegate>
{
    BOOL needStop;
    int integer;
}
@property (nonatomic, copy) void (^completion)(void);
@property (nonatomic, retain)iCarousel *carousel;
@end
@implementation AnimationView
- (void)dealloc
{
    [_subviewsArray release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        needStop = NO;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 152)];
        imageV.image = [UIImage imageNamed:@"animationBG"];
        imageV.center = CGPointMake(160, frame.size.height/3+20);
        [self addSubview:imageV];
        [imageV release];
        self.carousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, 0, 320, 152)];
        _carousel.center =CGPointMake(160, frame.size.height/3+20);
        _carousel.delegate = self;
        _carousel.dataSource = self;
        _carousel.type = iCarouselTypeRotary;
        [self addSubview:_carousel];
        self.hidden = YES;
        _animation = NO;
    }
    return self;
}
- (void)starAnimation
{
    _animation = YES;
    self.hidden = NO;
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [_carousel reloadData];
    [self pickAutoScroll:0];
}
- (void)pickAutoScroll:(int)i
{
    if (i>_subviewsArray.count*2) {
        i = 0;
    }
    [_carousel scrollToItemAtIndex:i duration:0.07 completion:^{
        if (needStop&&i==integer) {
            _completion();
        }else{
            [self pickAutoScroll:i+1];
        }
    }];
}

- (void)stopAnimationWithSubviewsLocation:(NSInteger)location completion:(void (^)(void))completion
{
    needStop = YES;
    integer = location;
    self.completion = completion;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark -

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _subviewsArray.count*2;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    UIView *view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"card_%d",index%4]]] autorelease];
    
    view.frame = CGRectMake(0, 0, 93.5, 63);
    UILabel*label = [[[UILabel alloc]initWithFrame:view.frame] autorelease];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    label.text = _subviewsArray[index%_subviewsArray.count];
    return view;
}
- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 100;
}
- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return YES;
}
@end
